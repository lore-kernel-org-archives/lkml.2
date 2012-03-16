Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032532Ab2CPAmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 20:42:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34936 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161859Ab2CPAl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 20:41:56 -0400
Date: Fri, 16 Mar 2012 08:41:42 +0800
From: Wang YanQing <udknight@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Michal Januszewski <spock@gentoo.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: export 'pcibios_enabled'
Message-ID: <20120316004142.GA3897@udknight>
Mail-Followup-To: Wang YanQing <Udknight@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Michal Januszewski <spock@gentoo.org>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	linux-fbdev@vger.kernel.org, x86@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20120313204114.e160849af7dbe5a4b4e5c0ad@canb.auug.org.au>
 <4F5FAE63.3090908@xenotime.net>
 <4F5FE9AD.7000204@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5FE9AD.7000204@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 05:43:25PM -0700, H. Peter Anvin wrote:
> On 03/13/2012 01:30 PM, Randy Dunlap wrote:
> > From: Randy Dunlap <rdunlap@xenotime.net>
> > 
> > Export 'pcibios_enabled' so that when uvesafb is built as a
> > loadable module (on X86_32), the build will succeed.
> > 
> > ERROR: "pcibios_enabled" [drivers/video/uvesafb.ko] undefined!
> > 
> > Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> > Cc:	Michal Januszewski <spock@gentoo.org>
> > Cc:	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> > Cc:	linux-fbdev@vger.kernel.org
> > Cc:	x86@kernel.org
> > ---
> > Applies to mainline; found in linux-next.
> > 
> >  arch/x86/pci/pcbios.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > --- linux-next-20120313.orig/arch/x86/pci/pcbios.c
> > +++ linux-next-20120313/arch/x86/pci/pcbios.c
> > @@ -27,6 +27,7 @@
> >  #define PCIBIOS_HW_TYPE2_SPEC		0x20
> >  
> >  int pcibios_enabled;
> > +EXPORT_SYMBOL(pcibios_enabled);
> >  
> >  /* According to the BIOS specification at:
> >   * http://members.datafast.net.au/dft0802/specs/bios21.pdf, we could
> 
> I would think this should be EXPORT_SYMBOL_GPL()... this seems like a
> symbol with a very high likelihood to be abused in strange ways.
> 
> 	-hpa
> 
Yes, I think EXPORT_SYMBOL_GPL is better. Indeed, there is another issue I 
meet about the pcibios NX protection code.
If I set "pcibios_enable = 1" forcely no matter whether set_bios_x had been executed, then
the BIOS code is not NX. The problem is,  if set_bios_x had not been executed, of course set_memory_x 
for the bios code page has no chance to execute, then why the BIOS code is not NX? Any comment?
Or because the default set for the BIOS range is X, if so we should set_memory_nx if pcibios_enable == 0.

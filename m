Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab2CUJ2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 05:28:19 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41466 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757137Ab2CUJ2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 05:28:15 -0400
Date: Wed, 21 Mar 2012 09:29:50 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Wang YanQing <udknight@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Michal Januszewski <spock@gentoo.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v2] x86: export 'pcibios_enabled' as GPL
Message-ID: <20120321092950.7fc07d84@pyramind.ukuu.org.uk>
In-Reply-To: <20120321043721.GA927@udknight>
References: <20120313204114.e160849af7dbe5a4b4e5c0ad@canb.auug.org.au>
	<4F5FAE63.3090908@xenotime.net>
	<20120319003044.GA3744@udknight>
	<4F6685ED.7040000@xenotime.net>
	<20120321043721.GA927@udknight>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2012 12:37:21 +0800
Wang YanQing <udknight@gmail.com> wrote:

> On Sun, Mar 18, 2012 at 06:03:41PM -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <rdunlap@xenotime.net>
> > 
> > Export 'pcibios_enabled' so that when uvesafb is built as a
> > loadable module (on X86_32), the build will succeed.
> > 
> > ERROR: "pcibios_enabled" [drivers/video/uvesafb.ko] undefined!
> > 
> > Patch v2 uses EXPORT_SYMBOL_GPL() as requested.
> > 
> > Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> > Cc:	Michal Januszewski <spock@gentoo.org>
> > Cc:	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> > Cc:	linux-fbdev@vger.kernel.org
> > Cc:	x86@kernel.org
> > ---
> >  arch/x86/pci/pcbios.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > --- linux-next-20120313.orig/arch/x86/pci/pcbios.c
> > +++ linux-next-20120313/arch/x86/pci/pcbios.c
> > @@ -27,6 +27,7 @@
> >  #define PCIBIOS_HW_TYPE2_SPEC		0x20
> >  
> >  int pcibios_enabled;
> > +EXPORT_SYMBOL_GPL(pcibios_enabled);
> >  
> >  /* According to the BIOS specification at:
> >   * http://members.datafast.net.au/dft0802/specs/bios21.pdf, we could
> Acked-by: Wang YanQing <udknight@gmail.com>

NAKked again by Alan Cox <alan@linux.intel.com>

The fb code shouldn't be playing guessing games with thsi variable.
I've pointed out both how to check if NX is enabled and how to set pages
NX/non-NX.

Even if you wanted to check the pci bios state we should export a helper
method.

So NAK.

Alan

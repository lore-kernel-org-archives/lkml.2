Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab0LHVY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 16:24:29 -0500
Received: from relay3.sgi.com ([192.48.152.1]:35679 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750951Ab0LHVY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 16:24:27 -0500
Date: Wed, 8 Dec 2010 15:22:44 -0600
From: Jack Steiner <steiner@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>, lenb@kernel.org
Cc: hmh@hmh.eng.br, mingo@elte.hu, tglx@linutronix.de, tony.luck@gmail.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        gbeshers@sgi.com
Subject: Re: [RFC  - V2] - Mapping ACPI tables as CACHED
Message-ID: <20101208212244.GA24280@sgi.com>
References: <20100722152220.GA18290@sgi.com> <20100724001449.GA9618@khazad-dum.debian.net> <4C743C0F.2010101@zytor.com> <20100826171704.GA21584@sgi.com> <4C76AD82.2030105@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C76AD82.2030105@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 11:08:02AM -0700, H. Peter Anvin wrote:
> On 08/26/2010 10:17 AM, Jack Steiner wrote:
> > Map ACPI tables as WB on x86_64. No substantive changes to IA64.
> > 
> > 
> > Signed-off-by: Jack Steiner <steiner@sgi.com>
> > 
> > ---
> > V2 - Change the patch to unconditionally map ACPI tables as WB on x86_64.
> >      I'm still some paranoid about this because of the potential imapct on
> >      some platforms with weird BIOSs. However, note that on EFI-enabled
> >      systems (like UV), the ACPI tables are already mapped as WB memory.
> >      This is done in the EFI function efi_enter_virtual_mode().
> >      The ACPI code in acpi_os_map_memory() is not currently aware of the
> >      EFI mapping & currently maps the memory as UC. This seems like a bug.
> > 
> 
> I really think that it's all a consequence of the fact that ioremap()
> became implicitly UC when we added PAT support (being the more
> conservative choice.)
> 
> Len, want to take this one or should I?
> 
> 	-hpa

What is the upstream status of this patch? See the LKML discussion at:

	http://marc.info/?l=linux-kernel&m=128206079905826&w=2
	http://marc.info/?l=linux-acpi&m=128284304032481&w=2

We would like to get this patch into the distros but need upstream acceptance first.

This patch substantially reduces the time to run ACPIDUMP on a large system:
 	527 seconds without the patch
 	  8 seconds with the patch

Is there something I should be doing? I can resend the patch if needed.


--- jack

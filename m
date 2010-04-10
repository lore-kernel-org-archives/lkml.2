Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab0DJB5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 21:57:16 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:36490 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab0DJB5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 21:57:12 -0400
Date: Fri, 9 Apr 2010 18:57:11 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: guenter.roeck@ericsson.com, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well
	as x86_32
Message-ID: <20100410015711.GH11130@hexapodia.org>
References: <1270839357.1477.758.camel@groeck-laptop> <4BBF863B.1060806@oracle.com> <20100409222103.GA11130@hexapodia.org> <4BBFA9BF.60608@oracle.com> <20100409223532.GC11130@hexapodia.org> <4BBFB1D8.6090802@oracle.com> <20100410000030.GE11130@hexapodia.org> <4BBFD019.9040405@oracle.com> <20100410014308.GG11130@hexapodia.org> <4BBFD8EF.6020108@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBFD8EF.6020108@oracle.com>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 06:48:31PM -0700, Yinghai wrote:
> On 04/09/2010 06:43 PM, Andy Isaacson wrote:
> > On Fri, Apr 09, 2010 at 06:10:49PM -0700, Yinghai wrote:
> >> in addition to -v2 patch
> >>
> >> please apply this patch too
> >>
> >> also please boot with "debug" in boot command line.
> >>
> >> Thanks
> >>
> >> Yinghai
> >>
> >> [PATCH] x86,acpi: use request_resource instead of instead of insert_resource
> >>
> >> So make pci root resouce from _CRS honor the one We reserve in e820 below 1M
> >>
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >>
> >> ---
> >>  arch/x86/pci/acpi.c |    2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> Index: linux-2.6/arch/x86/pci/acpi.c
> >> ===================================================================
> >> --- linux-2.6.orig/arch/x86/pci/acpi.c
> >> +++ linux-2.6/arch/x86/pci/acpi.c
> >> @@ -168,7 +168,7 @@ setup_resource(struct acpi_resource *acp
> >>  		return AE_OK;
> >>  	}
> >>  
> >> -	conflict = insert_resource_conflict(root, res);
> >> +	conflict = request_resource_conflict(root, res);
> >>  	if (conflict) {
> >>  		dev_err(&info->bridge->dev,
> >>  			"address space collision: host bridge window %pR "
> > 
> > That works.  dmesg.gz attached (I'm pretty sure I'm skating close to
> > vger's size limit without gz).  "debug" didn't seem to make much
> > difference?
> 
> [    0.636805] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [    0.654025] pci_root PNP0A03:00: address space collision: host bridge window [io  0x0000-0x0cf7] conflicts with dma1 [io  0x0000-0x001f]
> [    0.654370] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
> [    0.654586] pci_root PNP0A03:00: address space collision: host bridge window [mem 0x000a0000-0x000bffff] conflicts with reserved [mem 0x000a0000-0x000fffff]
> [    0.654933] pci_root PNP0A03:00: address space collision: host bridge window [mem 0x000c0000-0x000effff] conflicts with reserved [mem 0x000a0000-0x000fffff]
> [    0.655002] pci_root PNP0A03:00: address space collision: host bridge window [mem 0x000f0000-0x000fffff] conflicts with reserved [mem 0x000a0000-0x000fffff]
> [    0.655367] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff]
> [    0.655706] pci_root PNP0A03:00: host bridge window [mem 0xbff00000-0xdfffffff]
> [    0.656003] pci_root PNP0A03:00: host bridge window [mem 0xff980800-0xff980bff]
> [    0.656360] pci_root PNP0A03:00: host bridge window [mem 0xff97c000-0xff97ffff]
> [    0.657002] pci_root PNP0A03:00: host bridge window [mem 0xfed20000-0xfed9ffff]
> 
> still not optimal.

Well, thanks for looking at it; if there are any more patches I can try,
let me know (but I may not get to it until Monday morning, since I can't
reliably reboot this machine remotely).

Is this a BIOS error?  I am currently running A04; there's an A10
available, but I didn't want to perturb the situation during the
debugging cycle without guidance.

-andy

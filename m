Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857Ab1AMDYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 22:24:13 -0500
Received: from vms173013pub.verizon.net ([206.46.173.13]:44785 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932602Ab1AMDYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 22:24:11 -0500
Date: Wed, 12 Jan 2011 22:23:55 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Narendra_K@Dell.com, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au, Matt_Domsch@Dell.com,
        Charles_Rose@Dell.com, Surya_Prabhakar@Dell.com
Subject: Re: CONFIG_NLS=m resulting in undefined reference to utf16s_to_utf8s
 causing build failure
In-reply-to: <20110112160229.7b8d82c1@jbarnes-desktop>
Message-id: <alpine.LFD.2.02.1101122217370.19754@x980>
References: <20110112203414.GA5657@fedora14-r610.oslab.blr.amer.dell.com>
 <20110112160229.7b8d82c1@jbarnes-desktop>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > drivers/built-in.o: In function `dsm_label_utf16s_to_utf8s':
> > /usr/src/Linux-Next/linux-next/drivers/pci/pci-label.c:195: undefined reference to `utf16s_to_utf8s'
> > make: *** [.tmp_vmlinux1] Error 1
> > 
> > The drivers/pci/pci-label.c is compiled as part of vmlinux as defined by
> > the makefile drivers/pci/Makefile. 
> > 
> > #
> > # ACPI Related PCI FW Functions
> > # ACPI _DSM provided firmware instance and string name
> > #
> > obj-$(CONFIG_ACPI)    += pci-acpi.o pci-label.o
> > 
> > # SMBIOS provided firmware instance and labels
> > obj-$(CONFIG_DMI)    += pci-label.o
> > 
> > This could be prevented by one of the following methods -
> > 
> > * forcing CONFIG_NLS=y if CONFIG_PCI=y 
> > * move `utf16s_to_utf8s' out of nls_base.c to a new file to be always
> > built into vmlinux
> > 
> > Please correct me if i missed something here and let me know what would be the right
> > way to fix this build failure.
> 
> So there's no other ACPI code that depends on this function?  I'd hate
> to make PCI depend on NLS, so assuming ACPI doesn't need it (in which
> case the select or depend should be there), I guess it should be pulled
> into a common file that will always be included.

No, nothing in the ACPI code uses utf16s_to_utf8s.

I don't know anything about NLS, but it appears to be
something that file systems (befs, cifs, fat, hfs, isofs, jfs, etc)
use to to support native languages.

BTW. I don't understand why pci-label.o appears twice above.
It used to be just the 2nd one, that depends on CONFIG_DMI.

cheers,
Len Brown, Intel Open Source Technology Center



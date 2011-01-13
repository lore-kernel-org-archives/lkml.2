Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab1AMQrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 11:47:35 -0500
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:32755 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934Ab1AMQrc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 11:47:32 -0500
X-Loopcount0: from 10.170.28.39
From: <Narendra_K@Dell.com>
To: <lenb@kernel.org>
CC: <jbarnes@virtuousgeek.org>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <sfr@canb.auug.org.au>,
        <Matt_Domsch@Dell.com>, <Charles_Rose@Dell.com>,
        <Surya_Prabhakar@Dell.com>
Date: Thu, 13 Jan 2011 22:16:03 +0530
Subject: Re: CONFIG_NLS=m resulting in undefined reference to
 utf16s_to_utf8s causing build failure
Thread-Topic: CONFIG_NLS=m resulting in undefined reference to
 utf16s_to_utf8s causing build failure
Thread-Index: AcuzQV2gBidLaRbzRVuJI1D846wE/A==
Message-ID: <20110113170952.GA6598@fedora14-r610.oslab.blr.amer.dell.com>
References: <20110112203414.GA5657@fedora14-r610.oslab.blr.amer.dell.com>
 <20110112160229.7b8d82c1@jbarnes-desktop>
 <alpine.LFD.2.02.1101122217370.19754@x980>
In-Reply-To: <alpine.LFD.2.02.1101122217370.19754@x980>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.5.21 (2010-09-15)
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 08:53:55AM +0530, Len Brown wrote:
> 
> > > drivers/built-in.o: In function `dsm_label_utf16s_to_utf8s':
> > > /usr/src/Linux-Next/linux-next/drivers/pci/pci-label.c:195: undefined reference to `utf16s_to_utf8s'
> > > make: *** [.tmp_vmlinux1] Error 1
> > > 
> > > The drivers/pci/pci-label.c is compiled as part of vmlinux as defined by
> > > the makefile drivers/pci/Makefile. 
> > > 
> > > #
> > > # ACPI Related PCI FW Functions
> > > # ACPI _DSM provided firmware instance and string name
> > > #
> > > obj-$(CONFIG_ACPI)    += pci-acpi.o pci-label.o
> > > 
> > > # SMBIOS provided firmware instance and labels
> > > obj-$(CONFIG_DMI)    += pci-label.o
> > > 
> > > This could be prevented by one of the following methods -
> > > 
> > > * forcing CONFIG_NLS=y if CONFIG_PCI=y 
> > > * move `utf16s_to_utf8s' out of nls_base.c to a new file to be always
> > > built into vmlinux
> > > 
> > > Please correct me if i missed something here and let me know what would be the right
> > > way to fix this build failure.
> > 
> > So there's no other ACPI code that depends on this function?  I'd hate
> > to make PCI depend on NLS, so assuming ACPI doesn't need it (in which
> > case the select or depend should be there), I guess it should be pulled
> > into a common file that will always be included.
> 
> No, nothing in the ACPI code uses utf16s_to_utf8s.

Len,

Thanks for the information.

> 
> I don't know anything about NLS, but it appears to be
> something that file systems (befs, cifs, fat, hfs, isofs, jfs, etc)
> use to to support native languages.
> 
> BTW. I don't understand why pci-label.o appears twice above.
> It used to be just the 2nd one, that depends on CONFIG_DMI.
> 

Support has been added to export ACPI _DSM provided firmware instance
number and string, defined in 'PCI Firmware Specification Revision 3.1' 
section 4.6.7.( DSM for Naming a PCI or PCI Express Device Under
Operating Systems) to sysfs. So we need to compile pci-labe.c if either
of CONFIG_DMI or CONFIG_ACPI is set. When ACPI _DSM is available it
takes priority.

With regards,
Narendra K 
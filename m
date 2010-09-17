Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab0IQUEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 16:04:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023Ab0IQUEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 16:04:44 -0400
Date: Fri, 17 Sep 2010 13:04:28 -0700
From: Chris Wright <chrisw@redhat.com>
To: Cam Macdonell <cam@cs.ualberta.ca>
Cc: "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Chris Wright <chrisw@redhat.com>
Subject: Re: ACPI error when mapping a 2GB BAR w/ 4GB of RAM
Message-ID: <20100917200428.GD19949@x200.localdomain>
References: <AANLkTinORYZOYk9xsST+J=zxgeZPr2BNw3S=dvPPTcdn@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinORYZOYk9xsST+J=zxgeZPr2BNw3S=dvPPTcdn@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Cam Macdonell (cam@cs.ualberta.ca) wrote:
> After fixing the resource_size_t return value with
> pci_resource_alignment, I see one other strange behaviour only when
> using 4GB of RAM and a 2GB BAR.  I haven't found any other combination
> of RAM/BAR size that triggers this bug.  I am using 2.6.36-rc3.
> 
> ACPI Error: The DSDT has been corrupted or replaced - old, new headers
> below (20100702/tbutils-372)
> ACPI: DSDT (null) 01F15 (v01   BXPC   BXDSDT 00000001 INTL 20090123)
> ACPI:      (null) 00000 (v00                 00000000      00000000)
> ACPI Error: Please send DMI info to linux-acpi@vger.kernel.org
> If system does not work as expected, please boot with acpi=copy_dsdt
> (20100702/tbutils-378)
> ACPI: PCI Interrupt Link [LNKC] disabled and referenced, BIOS bug
> ACPI Exception: AE_AML_INVALID_RESOURCE_TYPE, Evaluating _CRS
> (20100702/pci_link-283)
> ACPI: Unable to set IRQ for PCI Interrupt Link [LNKC]. Try pci=noacpi
> or acpi=off
> virtio-pci 0000:00:03.0: PCI INT A: no GSI - using ISA IRQ 11
> Non-volatile memory driver v1.3
> Linux agpgart interface v0.103
> Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled

IIRC,  the pci hole is only 1.5G in the BIOS, can you verify that
seabios is doing the right thing?

thanks,
-chris

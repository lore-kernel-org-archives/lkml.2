Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab2K2WWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 17:22:55 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:41046 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab2K2WWx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 17:22:53 -0500
From: "Ortiz, Lance E" <lance.oritz@hp.com>
To: Joe Perches <joe@perches.com>
CC: "bhelgaas@google.com" <bhelgaas@google.com>,
        "lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3] aerdrv: Enhanced AER logging
Thread-Topic: [PATCH 2/3] aerdrv: Enhanced AER logging
Thread-Index: AQHNzn6Ehpc/JEiO50SjpobGZn2yJpgBYqeg
Date: Thu, 29 Nov 2012 22:21:37 +0000
Message-ID: <A961433CDFF2F640A2866803152E61F9516EABDE@G4W3219.americas.hpqcorp.net>
References: <20121129215443.5483.43364.stgit@grignak.americas.hpqcorp.net>
	 <20121129215450.5483.26562.stgit@grignak.americas.hpqcorp.net>
 <1354227105.1700.15.camel@joe-AO722>
In-Reply-To: <1354227105.1700.15.camel@joe-AO722>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yup.  You are right.  I thought I had it enabled, I will send out the new patch soon.

Lance

> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Thursday, November 29, 2012 3:12 PM
> To: Ortiz, Lance E
> Cc: bhelgaas@google.com; lance_ortiz@hotmail.com; jiang.liu@huawei.com;
> tony.luck@intel.com; bp@alien8.de; rostedt@goodmis.org;
> mchehab@redhat.com; linux-acpi@vger.kernel.org; linux-
> pci@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 2/3] aerdrv: Enhanced AER logging
> 
> On Thu, 2012-11-29 at 14:54 -0700, Lance Ortiz wrote:
> > This patch will provide a more reliable and easy way for user-space
> > applications to have access to AER logs rather than reading them from
> the
> > message buffer. It also provides a way to notify user-space when an
> AER
> > event occurs.
> []
> > diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
> > index e6defd8..ef1e1c0 100644
> > --- a/drivers/acpi/apei/cper.c
> > +++ b/drivers/acpi/apei/cper.c
> > @@ -281,9 +281,16 @@ static void cper_print_pcie(const char *pfx,
> const struct cper_sec_pcie *pcie,
> >  	"%s""bridge: secondary_status: 0x%04x, control: 0x%04x\n",
> >  	pfx, pcie->bridge.secondary_status, pcie->bridge.control);
> >  #ifdef CONFIG_ACPI_APEI_PCIEAER
> > -	if (pcie->validation_bits & CPER_PCIE_VALID_AER_INFO) {
> > +	dev = pci_get_domain_bus_and_slot(pcie->device_id.segment,
> > +			pcie->device_id.bus, pcie->device_id.function);
> > +	if (!dev)
> > +		pr_info(KERN_INFO, "PCI AER Cannot get PCI device
> %04x:%02x:%02x.%d\n",
> > +			domain, bus, slot, func);
> 
> You've not tried this with CONFIG_ACPI_APEI_PCIEAER enabled.
> 
> 		pr_info("PCI AER Cannot get PCI device
> %04x:%02x:%02x.%d\n",
> 			domain, bus, slot, func);
> 


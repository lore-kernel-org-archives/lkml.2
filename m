Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab2K1Xdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 18:33:55 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.31]:3870
	"EHLO NA01-BY2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931Ab2K1Xdx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 18:33:53 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -8
X-BigFish: PS-8(zz98dI9371I542M1432Izz1de0h1202h1d1ah1d2ahzz8275dhz31h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1155h)
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: drivres/hv
Thread-Topic: drivres/hv
Thread-Index: AQHNzbnkuR7QxMXjLE2jWFnID1DlIJf/3c9w
Date: Wed, 28 Nov 2012 23:32:52 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930E5E514@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1354133850-17540-1-git-send-email-kys@microsoft.com>
 <20121128224313.GA14402@kroah.com>
In-Reply-To: <20121128224313.GA14402@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.144]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT003.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC102.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(51704002)(377454001)(24454001)(13464001)(6806001)(53806001)(16676001)(54316002)(74502001)(50466001)(44976002)(47736001)(23726001)(76482001)(56816002)(4396001)(51856001)(31966008)(74662001)(5343655001)(56776001)(50986001)(47446002)(46102001)(47976001)(54356001)(47776002)(49866001)(46406002)(55846006)(33656001);DIR:OUT;SFP:;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 06793E740F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Wednesday, November 28, 2012 5:43 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org
> Subject: Re: drivres/hv
> 
> On Wed, Nov 28, 2012 at 12:17:30PM -0800, K. Y. Srinivasan wrote:
> >
> > Greg,
> 
> You are writing the most unhelpful Subject: lines lately, please be more
> descriptive in the future.

Sorry about that; I will be more descriptive.

> 
> > I recently discovered that the Hyper-V host allocates mmio
> > memory for some synthetic devices like the virtual framebuffer.
> > We are currently in the process of implementing this virtual
> > framebuffer device. As part of the offer message from the host
> > we are given the mmio region size that needs to be allocatted to
> > the device. I am told in the current implementation of the firmware,
> > this mmio resource shows up in the PCI space. What is the best way to
> > allocate this mmio space for this driver.
> 
> I don't understand, does the guest os think this really is mmio memory
> and the host just set up up?  Or is the memory being used to pass data
> back and forth?  Or something else?

>From what I understand, the host is allocating this memory and presenting
this to the guest. This memory is to be used for framebuffer. The guest is
expected to setup appropriate mappings to this region and use that as the 
framebuffer.

> 
> And what do you mean "firmware"?  That usually means UEFI/BIOS to me,
> not a hyperv host.

Hyper-V host presents the firmware to the guest (Hyper-V like KVM supports
full virtualization with selective para-virtualization - PV drivers). As part of the
BIOS presented to the guest this mmio region is allocated.

> 
> And finally, what does the guest os see as far as the PCI resource space
> shows it?  Shouldn't it just think it is a normal PCI device and access
> it properly that way?

This is the crux of the problem. Vmbus and other vmbus based devices are not
PCI  devices. I have implemented vmbus as an ACPI driver since vmbus is an ACPI
enumerated device. I have the size information of the mmio region that is to be 
allocated to the framebuffer device. I am looking at a way to allocate this mmio
region.

> 
> thanks,
> 
> greg k-h
> 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890Ab2K2Ag2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 19:36:28 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.23]:28944
	"EHLO NA01-BY2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932789Ab2K2Ag1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 19:36:27 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -9
X-BigFish: PS-9(zz98dI9371I542M1432I4015Izz1de0h1202h1d1ah1d2ahzz8275dhz31h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1155h)
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: drivres/hv
Thread-Topic: drivres/hv
Thread-Index: AQHNzbnkuR7QxMXjLE2jWFnID1DlIJf/3c9wgAAQ9gCAAAIZIA==
Date: Thu, 29 Nov 2012 00:35:00 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930E5E599@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1354133850-17540-1-git-send-email-kys@microsoft.com>
 <20121128224313.GA14402@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF930E5E514@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20121129000434.GA17233@kroah.com>
In-Reply-To: <20121129000434.GA17233@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.144]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT004.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC101.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC101.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454001)(24454001)(51704002)(164054002)(13464001)(56776001)(47736001)(33656001)(31966008)(51856001)(47976001)(49866001)(54356001)(50986001)(55846006)(50466001)(5343655001)(74662001)(54316002)(6806001)(74502001)(53806001)(56816002)(47776002)(4396001)(16676001)(76482001)(46406002)(23726001)(44976002)(47446002)(46102001);DIR:OUT;SFP:;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0680FADD48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Wednesday, November 28, 2012 7:05 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org
> Subject: Re: drivres/hv
> 
> On Wed, Nov 28, 2012 at 11:32:52PM +0000, KY Srinivasan wrote:
> > > > I recently discovered that the Hyper-V host allocates mmio
> > > > memory for some synthetic devices like the virtual framebuffer.
> > > > We are currently in the process of implementing this virtual
> > > > framebuffer device. As part of the offer message from the host
> > > > we are given the mmio region size that needs to be allocatted to
> > > > the device. I am told in the current implementation of the firmware,
> > > > this mmio resource shows up in the PCI space. What is the best way to
> > > > allocate this mmio space for this driver.
> > >
> > > I don't understand, does the guest os think this really is mmio memory
> > > and the host just set up up?  Or is the memory being used to pass data
> > > back and forth?  Or something else?
> >
> > From what I understand, the host is allocating this memory and presenting
> > this to the guest. This memory is to be used for framebuffer. The guest is
> > expected to setup appropriate mappings to this region and use that as the
> > framebuffer.
> 
> What type of framebuffer?  Linux supports a ton of different ones, have
> you looked at drivers/video/ to see if one of the ones there will "just
> work" with what hyperv is passing to the guest?

We are writing a diver for this device. The existing Linux drivers can (and do)
work for the emulated VGA device. What we are implementing is a synthetic
framebuffer driver that will communicate over the vmbus to the host.
 
> 
> If not, you'll have to write a new driver for this, look at the examples
> of other framebuffer drivers in that directory for examples.  Also, I
> bet the code there will answer your memory questions.
> 
> > > And what do you mean "firmware"?  That usually means UEFI/BIOS to me,
> > > not a hyperv host.
> >
> > Hyper-V host presents the firmware to the guest (Hyper-V like KVM supports
> > full virtualization with selective para-virtualization - PV drivers). As part of the
> > BIOS presented to the guest this mmio region is allocated.
> >
> > >
> > > And finally, what does the guest os see as far as the PCI resource space
> > > shows it?  Shouldn't it just think it is a normal PCI device and access
> > > it properly that way?
> >
> > This is the crux of the problem. Vmbus and other vmbus based devices are not
> > PCI  devices. I have implemented vmbus as an ACPI driver since vmbus is an
> ACPI
> > enumerated device. I have the size information of the mmio region that is to be
> > allocated to the framebuffer device. I am looking at a way to allocate this mmio
> > region.
> 
> Do you have any "hints" as to where it is, if it even is present, or
> anything else?  If so, use them and create a new framebuffer device with
> that information.

All I know is that it is present and its size is known. If I have a way of knowing
what range of mmio memory is unclaimed; I could grab that perhaps using
the request_mem_region() call, I know the size that is reserved for this device.
So, is there a way to query the system for the first unclaimed address in the mmio
range.

Thanks,

K. Y
> 



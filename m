Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591Ab1IOMqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:46:49 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:7253 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933533Ab1IOMqr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:46:47 -0400
X-SpamScore: -17
X-BigFish: VS-17(zz9371K542M1432N98dKzz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Sethi Varun-B16395 <B16395@freescale.com>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Joerg Roedel <joro@8bytes.org>, Greg KH <gregkh@suse.de>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 02/10] Driver core: Add iommu_ops to bus_type
Thread-Topic: [PATCH 02/10] Driver core: Add iommu_ops to bus_type
Thread-Index: AQHMbX1KEHbH2ksOTkK6XUaJZsZynZVCliAAgAAIzICABw2cQIAAXVGAgARjHbA=
Date: Thu, 15 Sep 2011 12:45:35 +0000
Message-ID: <F1FD01C1EFCE15408DBF59462450B3BD1CF87C@039-SN1MPN1-006.039d.mgd.msft.net>
References: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com>
 <1315410113-26608-3-git-send-email-joerg.roedel@amd.com>
 <20110907184750.GA920@suse.de> <20110907191919.GA31674@8bytes.org>
 <F1FD01C1EFCE15408DBF59462450B3BD1C4658@039-SN1MPN1-006.039d.mgd.msft.net>
 <20110912123551.GA11701@amd.com>
In-Reply-To: <20110912123551.GA11701@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [122.163.200.245]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Roedel, Joerg [mailto:Joerg.Roedel@amd.com]
> Sent: Monday, September 12, 2011 6:06 PM
> To: Sethi Varun-B16395
> Cc: Joerg Roedel; Greg KH; iommu@lists.linux-foundation.org; Alex
> Williamson; Ohad Ben-Cohen; David Woodhouse; David Brown;
> kvm@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 02/10] Driver core: Add iommu_ops to bus_type
> 
> On Mon, Sep 12, 2011 at 08:08:41AM -0400, Sethi Varun-B16395 wrote:
> > > The IOMMUs are usually devices on the bus itself, so they are
> > > initialized after the bus is set up and the devices on it are
> > > populated.  So the function can not be called on bus initialization
> > > because the IOMMU is not ready at this point.
> > Well, at what point would the add_device_group (referring to patch set
> posted by Alex) call back be invoked?
> 
> The details are up to Alex Williamson. One option is to register a
> notifier for the bus in the iommu_bus_init() function and react to its
> notifications.
> I think in the end we will have a number of additional call-backs in the
> iommu_ops which are called by the notifier (or from the driver-core
> directly) to handle actions like added or removed devices. All the
> infrastructure for that which is implemented in the iommu-drivers today
> will then be in the iommu-core code.
I am not sure If I understand this, but as per your earlier statement iommu is a device on the bus
and its initialization would happen when bus is set up and devices are populated. So, when would device
notifier call an iommu call back?

-Varun
 


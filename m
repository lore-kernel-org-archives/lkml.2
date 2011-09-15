Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933721Ab1IONQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 09:16:06 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:43017
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933338Ab1IONQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 09:16:04 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432N98dKzz1202hzz15d4Rz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LRKFEX-02-DCF-02
X-M-MSG: 
Date: Thu, 15 Sep 2011 15:13:47 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Sethi Varun-B16395 <B16395@freescale.com>
CC: Joerg Roedel <joro@8bytes.org>, Greg KH <gregkh@suse.de>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/10] Driver core: Add iommu_ops to bus_type
Message-ID: <20110915131347.GB11701@amd.com>
References: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com>
 <1315410113-26608-3-git-send-email-joerg.roedel@amd.com>
 <20110907184750.GA920@suse.de>
 <20110907191919.GA31674@8bytes.org>
 <F1FD01C1EFCE15408DBF59462450B3BD1C4658@039-SN1MPN1-006.039d.mgd.msft.net>
 <20110912123551.GA11701@amd.com>
 <F1FD01C1EFCE15408DBF59462450B3BD1CF87C@039-SN1MPN1-006.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <F1FD01C1EFCE15408DBF59462450B3BD1CF87C@039-SN1MPN1-006.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 08:45:35AM -0400, Sethi Varun-B16395 wrote:
> > From: Roedel, Joerg [mailto:Joerg.Roedel@amd.com]
> > The details are up to Alex Williamson. One option is to register a
> > notifier for the bus in the iommu_bus_init() function and react to its
> > notifications.
> > I think in the end we will have a number of additional call-backs in the
> > iommu_ops which are called by the notifier (or from the driver-core
> > directly) to handle actions like added or removed devices. All the
> > infrastructure for that which is implemented in the iommu-drivers today
> > will then be in the iommu-core code.

> I am not sure If I understand this, but as per your earlier statement
> iommu is a device on the bus and its initialization would happen when
> bus is set up and devices are populated. So, when would device
> notifier call an iommu call back?

This is done in the iommu_bus_init() function. It will iterate over all
devices that are already on the bus and do the iommu specific
initialization on them. The devices added or removed later the notifier
will do the job.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632


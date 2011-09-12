Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab1ILMgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 08:36:37 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:44749
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755466Ab1ILMgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 08:36:35 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432N98dKzz1202hzz15d4Rz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LRETNP-02-B8D-02
X-M-MSG: 
Date: Mon, 12 Sep 2011 14:35:51 +0200
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
Message-ID: <20110912123551.GA11701@amd.com>
References: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com>
 <1315410113-26608-3-git-send-email-joerg.roedel@amd.com>
 <20110907184750.GA920@suse.de>
 <20110907191919.GA31674@8bytes.org>
 <F1FD01C1EFCE15408DBF59462450B3BD1C4658@039-SN1MPN1-006.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <F1FD01C1EFCE15408DBF59462450B3BD1C4658@039-SN1MPN1-006.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 08:08:41AM -0400, Sethi Varun-B16395 wrote:
> > The IOMMUs are usually devices on the bus itself, so they are initialized
> > after the bus is set up and the devices on it are populated.  So the
> > function can not be called on bus initialization because the IOMMU is not
> > ready at this point.
> Well, at what point would the add_device_group (referring to patch set posted by Alex) call back be invoked?

The details are up to Alex Williamson. One option is to register a
notifier for the bus in the iommu_bus_init() function and react to its
notifications.
I think in the end we will have a number of additional call-backs in the
iommu_ops which are called by the notifier (or from the driver-core
directly) to handle actions like added or removed devices. All the
infrastructure for that which is implemented in the iommu-drivers today
will then be in the iommu-core code.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632


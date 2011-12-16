Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514Ab1LPOyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 09:54:09 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:35051
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754119Ab1LPOyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 09:54:04 -0500
X-SpamScore: -17
X-BigFish: VPS-17(zz98dK4015Lzz1202hzz15d4Rz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LWAXDU-02-0B0-02
X-M-MSG: 
Date: Fri, 16 Dec 2011 15:53:53 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: David Gibson <david@gibson.dropbear.id.au>, <aik@ozlabs.ru>,
        <benh@kernel.crashing.org>, <dwmw2@infradead.org>, <chrisw@redhat.com>,
        <agraf@suse.de>, <scottwood@freescale.com>, <B08248@freescale.com>,
        <rusty@rustcorp.com.au>, <iommu@lists.linux-foundation.org>,
        <qemu-devel@nongnu.org>, <linux-kernel@vger.kernel.org>,
        <joro@8bytes.org>
Subject: Re: [RFC] Device isolation infrastructure v2
Message-ID: <20111216145353.GA29877@amd.com>
References: <1323930340-24055-1-git-send-email-david@gibson.dropbear.id.au>
 <1323972307.2437.19.camel@x201.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1323972307.2437.19.camel@x201.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 11:05:07AM -0700, Alex Williamson wrote:
> Starting with it in the core and hand waving some future use that we
> don't plan to implement right now seems like the wrong direction.

I agree with Alex. First of all, I havn't seen any real vfio problem
that can't be solved with the current approach, and it has the great
advantage of simplicity. It doesn't require a re-implementation of the
driver-core based on groups. I agree that we need some improvements to
Alex' code for the dma-api layer to solve the problem with broken devices
using the wrong requestor-id. But that can be done incrementally with
the current (current == in the iommu-tree) approach implemented by Alex.

I also think that all this does not belong into the driver core for two
reasons:

	1) The information for building the device groups is provided
	   by the iommu-layer
	2) The group information is provided to vfio by the iommu-api

This makes the iommu-layer the logical point to place the grouping code.
There are some sources outside of the iommu-layer that may influence
grouping (like pci-quirks), but most of the job is done by the
iommu-drivers.

Thanks,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632


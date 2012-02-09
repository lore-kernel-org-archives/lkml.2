Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab2BIL2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 06:28:15 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:56533
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751144Ab2BIL2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 06:28:13 -0500
X-SpamScore: -22
X-BigFish: VPS-22(zz936eK1432N98dKzz1202hzz15d4Rz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZ4IIW-01-2N5-02
X-M-MSG: 
Date: Thu, 9 Feb 2012 12:28:05 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: David Gibson <david@gibson.dropbear.id.au>, <dwmw2@infradead.org>,
        <iommu@lists.linux-foundation.org>, <aik@ozlabs.ru>,
        <qemu-devel@nongnu.org>, <alex.williamson@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Device isolation group infrastructure (v3)
Message-ID: <20120209112805.GN22598@amd.com>
References: <1328071614-8320-1-git-send-email-david@gibson.dropbear.id.au>
 <1328071614-8320-2-git-send-email-david@gibson.dropbear.id.au>
 <20120208152748.GD22598@amd.com>
 <1328737168.2903.35.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1328737168.2903.35.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 08:39:28AM +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2012-02-08 at 16:27 +0100, Joerg Roedel wrote:
> > Again, device grouping is done by the IOMMU drivers, so this all
> > belongs
> > into the generic iommu-code rather than the driver core.
> 
> Except that there isn't really a "generic iommu code"... discovery,
> initialization & matching of iommu vs. devices etc... that's all
> implemented in the arch specific iommu code.

The whole point of moving the iommu drivers to drivers/iommu was to
factor out common code. We are not where we want to be yet but the goal
is to move more code to the generic part.

For the group-code this means that the generic code should iterate over
all devices on a bus and build up group structures based on isolation
information provided by the arch specific code.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632


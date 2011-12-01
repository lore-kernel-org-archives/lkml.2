Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab1LAVdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 16:33:09 -0500
Received: from gate.crashing.org ([63.228.1.57]:56702 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab1LAVdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 16:33:06 -0500
Message-ID: <1322775151.3729.25.camel@pasglop>
Subject: Re: [PATCH 1/4] iommu: Add iommu_device_group callback and
 iommu_group sysfs entry
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: David Gibson <dwg@au1.ibm.com>, joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        chrisw@redhat.com, agraf@suse.de, scottwood@freescale.com,
        B08248@freescale.com
Date: Fri, 02 Dec 2011 08:32:31 +1100
In-Reply-To: <1322722110.26545.68.camel@bling.home>
References: <20111021195412.8438.9951.stgit@s20.home>
	 <20111021195605.8438.81609.stgit@s20.home>
	 <20111130024205.GF5435@truffala.fritz.box>
	 <1322628672.21641.39.camel@pasglop> <1322630751.19120.222.camel@bling.home>
	 <20111201000337.GA5427@truffala.fritz.box>
	 <1322722110.26545.68.camel@bling.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-30 at 23:48 -0700, Alex Williamson wrote:

> See bus_set_iommu(struct bus_type *bus, struct iommu_ops *ops).  It
> wasn't long ago that we had a global iommu_ops.

Right now, the dma_ops are per-device but the iommu populate/depopulate
hooks are system global, installed by the platform code at boot time, on
powerpc. We could try to "fit in" an iommu "driver" at that point.

In theory, you can connect separate IO chips on POWER server and in fact
it happens on high end boxes, tho they tend to have a similar "PE#"
mechanism, but with different constraints and resources capacities.
However we aren't concerned with that initially for KVM as we are
targetting only lower end machines with only one p7ioc for now.

But I can see more heterogenous setup showing up in embedded space..
 
> Are heterogeneous
> iommus using different drivers on the same bus_type really a possibility
> on your system, or are we dealing with hypothetical situations?  You'd
> currently need to multiplex iommu_ops callbacks between the drivers
> yourself.

We could.

Ben.



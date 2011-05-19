Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935176Ab1ESWPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 18:15:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730Ab1ESWPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 18:15:52 -0400
Subject: Re: [PATCH] pci, dmar: Update dmar units devices list during
 hotplug
From: Alex Williamson <alex.williamson@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <4DC6E569.1060808@kernel.org>
References: <4DC6E569.1060808@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 May 2011 16:15:08 -0600
Message-ID: <1305843308.3100.10.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-05-08 at 11:48 -0700, Yinghai Lu wrote:
> When do pci remove/rescan on system that have more iommus, got
> 
> [  894.089745] Set context mapping for c4:00.0
> [  894.110890] mpt2sas3: Allocated physical memory: size(4293 kB)
> [  894.112556] mpt2sas3: Current Controller Queue Depth(1883), Max Controller Queue Depth(2144)
> [  894.127278] mpt2sas3: Scatter Gather Elements per IO(128)
> [  894.361295] DRHD: handling fault status reg 2
> [  894.364053] DMAR:[DMA Read] Request device [c4:00.0] fault addr fffbe000
> [  894.364056] DMAR:[fault reason 02] Present bit in context entry is cl
> 
> it turns out when remove/rescan, pci dev will be freed and will get another new dev.
> but drhd units still keep old one... so dmar_find_matched_drhd_unit will
> return wrong drhd and iommu for the device that is not on first iommu.
> 
> So need to update devices in drhd_units during pci remove/rescan.
> 
> Could save domain/bus/device/function aside in the list and according that info
> restore new dev to drhd_units later.
> Then dmar_find_matched_drdh_unit and device_to_iommu could return right drhd and iommu.

I think I'd vote for saving some kind of representation of the bus
hierarchy, we probably don't need to list every possible individual
device.  Leaving a broken pointer around to be matched up and restored
later just seems like a continuation of an idea that was bad to begin
with.  Thanks,

Alex


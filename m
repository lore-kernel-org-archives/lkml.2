Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab1IVNsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 09:48:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52575 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab1IVNs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 09:48:29 -0400
MIME-Version: 1.0
In-Reply-To: <201109201254.39542.laurent.pinchart@ideasonboard.com>
References: <1316009259-18052-1-git-send-email-joerg.roedel@amd.com>
	<201109180202.23123.laurent.pinchart@ideasonboard.com>
	<20110920100146.GA2078@amd.com>
	<201109201254.39542.laurent.pinchart@ideasonboard.com>
Date: Thu, 22 Sep 2011 16:48:27 +0300
Message-ID: <CAMP44s2-sBUGsOYzOxTMamOfw+Od4jOWriRinG=qkpt68WvQ9Q@mail.gmail.com>
Subject: Re: [PATCH] iommu/omap: Fix build error with !IOMMU_SUPPORT
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 1:54 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Tuesday 20 September 2011 12:01:46 Roedel, Joerg wrote:
>> On Sat, Sep 17, 2011 at 08:02:22PM -0400, Laurent Pinchart wrote:
>> > On Wednesday 14 September 2011 16:07:39 Joerg Roedel wrote:
>> > > Without this patch it is possible to select the VIDEO_OMAP3
>> > > driver which then selects OMAP_IOVMM. But the omap iommu
>> > > driver is not compiled without IOMMU_SUPPORT enabled. Fix
>> > > that by forcing OMAP_IOMMU and OMAP_IOVMM are enabled before
>> > > VIDEO_OMAP3 can be selected.
>> >
>> > What about making VIDEO_OMAP3 select IOMMU_SUPPORT instead then ? Your
>> > patch would make the OMAP3 ISP driver disappear from the menu until
>> > IOMMU_SUPPORT gets turned on, which can confuse users.
>>
>> Using 'depends on' rather then 'selects' is common standard in Kconfig.
>> You can't select PCI drivers without selecting PCI first, for example.
>
> You wouldn't expect a PCI driver to work without PCI support. My concern is
> that most OMAP3 ISP users won't know that IOMMU supports is required. Feel
> free to ignore it though :-)

I agree with Laurent. As a user, why should I care about IOMMU? I just
want this thing.

That's why DRM_RADEON_KMS selects BACKLIGHT_CLASS_DEVICE; it's an
implementation detail that the user should not need to care about. Why
should I need to go see the dependencies of DRM_RADEON_KMS and
manually select all of them? I shouldn't, that's the reason 'select'
exists in the first place.

Cheers.

-- 
Felipe Contreras

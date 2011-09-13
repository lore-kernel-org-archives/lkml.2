Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab1IMKer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 06:34:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32773 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab1IMKeo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 06:34:44 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.113.217]
In-Reply-To: <20110913101011.GK11701@amd.com>
References: <1315421604-12286-1-git-send-email-ohad@wizery.com>
 <1315421604-12286-3-git-send-email-ohad@wizery.com> <20110913101011.GK11701@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 13 Sep 2011 13:34:23 +0300
Message-ID: <CAK=WgbbhdFpAHTt=Bku-v1ZOCf48+u+XB-f4yO=5EDojv1kCJg@mail.gmail.com>
Subject: Re: [PATCH 3/3] iommu/core: split mapping to page sizes as supported
 by the hardware
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Brown <davidb@codeaurora.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

On Tue, Sep 13, 2011 at 1:10 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> Please split this patch into the core-change and patches for the
> individual iommu-drivers and post this as a seperate patch-set.

But we'll be breaking bisectibility this way, no ?

> Intel IOMMU does not support arbitrary page-sizes, afaik.

It does; besides the usual 4K it has "super page sizes" support of
2MB, 1GB, 512GB and 1TB.

>> +       pr_debug("map: iova 0x%lx pa 0x%lx size 0x%lx\n", iova,
>> +                                       (unsigned long)paddr, size);
>
> Please keep the debug-code in a seperate patch in your dev-tree. No need
> for it to be merged upstream.

It's actually useful sometimes to have those around - it's off by
default, and can be enabled only when needed (CONFIG_DYNAMIC_DEBUG).

But I don't mind removing them.

Thanks,
Ohad.

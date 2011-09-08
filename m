Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab1IHMwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 08:52:01 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46553 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932642Ab1IHMv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 08:51:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAK=WgbbFhmiC=PJfmyPOhbHGtiPFOcmqBx7nSpkuDX36hPYgbA@mail.gmail.com>
References: <1314984756-4400-1-git-send-email-ohad@wizery.com>
	<1314984756-4400-8-git-send-email-ohad@wizery.com>
	<CAHQjnOMT3UOFMi=JbSXf4-s_BbZ+fSGbOEjxwT7t7N-zd+9-zg@mail.gmail.com>
	<CAK=WgbZPFryzCFLa5AhAYDmH1S8c3x-OsSTyxYeq0WLAe8VyTg@mail.gmail.com>
	<CAHQjnOMnOjAJ6QuuLmLa1UKvTRHfyyjiUYrfvzLx8FSsCixxng@mail.gmail.com>
	<CAK=WgbbFhmiC=PJfmyPOhbHGtiPFOcmqBx7nSpkuDX36hPYgbA@mail.gmail.com>
Date: Thu, 8 Sep 2011 21:51:57 +0900
X-Google-Sender-Auth: _0pE-QkYBa4ZuivtJgOwCg1xPJ4
Message-ID: <CAHQjnONUvBtKSMxiDf5Mk+DLqfrTr09Us11rWoaR1mVZeiAmnA@mail.gmail.com>
Subject: Re: [RFC 7/7] iommu/core: split mapping to page sizes as supported by
 the hardware
From: KyongHo Cho <pullip.cho@samsung.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Joerg Roedel <Joerg.Roedel@amd.com>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Brown <davidb@codeaurora.org>, linux-omap@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On Wed, Sep 7, 2011 at 6:16 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> Hmm this sounds a bit like a red herring to me; optimization of the
:) I agree. sorry.

> map function is not the main subject here. Especially not when we're
> discussing mapping of large physically contiguous memory regions which
> do not happen too often.
>
I've got your point but I thought that it is really needed.

> Another advantage for migrating s5p_iommu_map() over to the subject
> patch, is that s5p_iommu_map() doesn't support super sections yet. To
> support it, you'd need to add more code (duplicate another while
> loop). But if you migrated to the subject patch, then you would only
> need to flip the 16MB bit when you advertise page size capabilities
> and then that's it; you're done.

I did not implement that.
16MB page is less practical in Linux because Linux kernel is unable
to allocated larger physically contiguous memory than 4MB by default.
But I also think that it is needed to support 16MB mapping for IO
virtualization someday
and it is just trivial job.

And you pointed correctly that s5p_iommu_map() has duplicate similar codes.

Actually, I think your idea is good and does not cause performance degradation.
But I wondered if it is really useful.

>
> The caller of iommu_map() doesn't say anything about alignments. It
> just gives it a memory region to map, and expect things to just work.
>
The caller of iommu_map() gives gfp_order that is the size of the physical
memory to map.
I thought that it also means alignment of the physical memory.
Isn't it?

Regards,
KyongHo

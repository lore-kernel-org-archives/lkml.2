Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab2HIJje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 05:39:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37292 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab2HIJjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 05:39:31 -0400
Message-ID: <50238552.6030404@canonical.com>
Date: Thu, 09 Aug 2012 11:39:30 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Sumit Semwal <sumit.semwal@linaro.org>
CC: rob.clark@linaro.org, linaro-mm-sig@lists.linaro.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, patches@linaro.org
Subject: Re: [PATCH 1/3] dma-fence: dma-buf synchronization (v7)
References: <20120807175330.18745.81293.stgit@patser.local> <502162D7.9090809@canonical.com> <CAO_48GGmo65yT9UeJk69f-ASir3E+SWMsOJXgN4M_-UyO3XqUA@mail.gmail.com>
In-Reply-To: <CAO_48GGmo65yT9UeJk69f-ASir3E+SWMsOJXgN4M_-UyO3XqUA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Sumit,

Op 08-08-12 08:35, Sumit Semwal schreef:
> Hi Maarten,
>
> On 8 August 2012 00:17, Maarten Lankhorst
> <maarten.lankhorst@canonical.com> wrote:
>> Op 07-08-12 19:53, Maarten Lankhorst schreef:
>>> A dma-fence can be attached to a buffer which is being filled or consumed
>>> by hw, to allow userspace to pass the buffer without waiting to another
>>> device.  For example, userspace can call page_flip ioctl to display the
>>> next frame of graphics after kicking the GPU but while the GPU is still
>>> rendering.  The display device sharing the buffer with the GPU would
>>> attach a callback to get notified when the GPU's rendering-complete IRQ
>>> fires, to update the scan-out address of the display, without having to
>>> wake up userspace.
> Thanks for this patchset; Could you please also fill up
> Documentation/dma-buf-sharing.txt, to include the relevant bits?
>
> We've tried to make sure the Documentation corresponding is kept
> up-to-date as the framework has grown, and new features are added to
> it - and I think features as important as dma-fence and dmabufmgr do
> warrant a healthy update.

Ok I'll clean it up and add the documentation, one other question. If code
that requires dmabuf needs to select CONFIG_DMA_SHARED_BUFFER,
why does dma-buf.h have fallbacks for !CONFIG_DMA_SHARED_BUFFER?
This seems weird, would you have any objection if I removed those?

~Maarten


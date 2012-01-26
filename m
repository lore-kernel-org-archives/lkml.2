Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab2AZJ6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 04:58:19 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:44501 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab2AZJ6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 04:58:18 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Semwal, Sumit" <sumit.semwal@ti.com>
Subject: Re: [Linaro-mm-sig] [PATCH 1/3] dma-buf: Introduce dma buffer sharing mechanism
Date: Thu, 26 Jan 2012 10:58:25 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.10-gentoo-r1; KDE/4.7.4; x86_64; ; )
Cc: linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        arnd@arndb.de, airlied@redhat.com, linux@arm.linux.org.uk,
        patches@linaro.org, jesse.barker@linaro.org, daniel@ffwll.ch
References: <1324891397-10877-1-git-send-email-sumit.semwal@ti.com> <201201201423.46858.laurent.pinchart@ideasonboard.com> <CAB2ybb98BT8L569G_728x1ZXdFNaQCDZzW2+kB0ZNeFak5_g+Q@mail.gmail.com>
In-Reply-To: <CAB2ybb98BT8L569G_728x1ZXdFNaQCDZzW2+kB0ZNeFak5_g+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201261058.27098.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sumit,

On Wednesday 25 January 2012 14:56:52 Semwal, Sumit wrote:
> On Fri, Jan 20, 2012 at 6:53 PM, Laurent Pinchart wrote:
> > Hi Summit,
> > 
> > Sorry for the late review. I know that this code is now in mainline, but
> > I still have a couple of comments. I'll send patches if you agree with
> > them.
> 
> Hi Laurent,
> 
> Thanks for your review; apologies for being late in replying - I was
> OoO for last couple of days.

No worries.

[snip]

> Let me know if you'd send patches for these, or should I just go ahead and
> correct.

I'll send patches.

Another small comment. The map_dma_buf operation is defined as

        struct sg_table * (*map_dma_buf)(struct dma_buf_attachment *,
                                                enum dma_data_direction);

If we want to let exporters cache the sg_table we should return a const struct 
sg_table *. unmap_dma_buf will then take a const pointer as well, which would 
need to be cast to a non-const pointer internally. What's your opinion on that 
?

-- 
Regards,

Laurent Pinchart

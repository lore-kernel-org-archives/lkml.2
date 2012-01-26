Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751166Ab2AZFfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 00:35:52 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:51132 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750809Ab2AZFfv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 00:35:51 -0500
MIME-Version: 1.0
In-Reply-To: <20120125200701.GH3896@phenom.ffwll.local>
References: <1324891397-10877-1-git-send-email-sumit.semwal@ti.com>
 <1324891397-10877-2-git-send-email-sumit.semwal@ti.com> <4F2035B1.4020204@samsung.com>
 <20120125200701.GH3896@phenom.ffwll.local>
From: "Semwal, Sumit" <sumit.semwal@ti.com>
Date: Thu, 26 Jan 2012 11:05:30 +0530
Message-ID: <CAB2ybb_5Co38kpahe5PmO5b_uevr0=_3ODnwD1Xy9V0HQ7mPwg@mail.gmail.com>
Subject: Re: [PATCH 1/3] dma-buf: Introduce dma buffer sharing mechanism
To: Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Sumit Semwal <sumit.semwal@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, arnd@arndb.de, airlied@redhat.com,
        linux@arm.linux.org.uk, jesse.barker@linaro.org,
        m.szyprowski@samsung.com, rob@ti.com, patches@linaro.org,
        Sumit Semwal <sumit.semwal@linaro.org>
Cc: daniel@ffwll.ch
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 1:37 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Wed, Jan 25, 2012 at 06:02:41PM +0100, Tomasz Stanislawski wrote:
>> Hi Sumit,
>>
>> On 12/26/2011 10:23 AM, Sumit Semwal wrote:
>> >This is the first step in defining a dma buffer sharing mechanism.
>> >
>> [snip]
>>
>> >+struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *,
>> >+                                    enum dma_data_direction);
>> >+void dma_buf_unmap_attachment(struct dma_buf_attachment *, struct sg_table *);
>>
>> I think that you should add enum dma_data_direction as an argument
>> unmap function. It was mentioned that the dma_buf_attachment should keep
>> cached and mapped sg_table for performance reasons. The field
>> dma_buf_attachment::priv seams to be a natural place to keep this sg_table.
>> To map a buffer the exporter calls dma_map_sg. It needs dma direction
>> as an argument. The problem is that dma_unmap_sg also needs this
>> argument but dma direction is not available neither in
>> dma_buf_unmap_attachment nor in unmap callback. Therefore the exporter
>> is forced to embed returned sg_table into a bigger structure where
>> dma direction is remembered. Refer to function vb2_dc_dmabuf_ops_map
>> at
>
> Oops, makes sense. I've totally overlooked that we need to pass in the dma
> direction also for the unmap call to the dma subsystem. Sumit, can you
> stitch together that small patch?

Right, of course. I will do that by tomorrow; it is a bank holiday
today here in India, so.

regards,
~Sumit.
> -Daniel
> --
> Daniel Vetter
> Mail: daniel@ffwll.ch
> Mobile: +41 (0)79 365 57 48

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab1KYQPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 11:15:13 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45542 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab1KYQPM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 11:15:12 -0500
MIME-Version: 1.0
In-Reply-To: <1318325033-32688-2-git-send-email-sumit.semwal@ti.com>
References: <1318325033-32688-1-git-send-email-sumit.semwal@ti.com>
	<1318325033-32688-2-git-send-email-sumit.semwal@ti.com>
Date: Fri, 25 Nov 2011 16:15:11 +0000
Message-ID: <CAPM=9tzjO7poyz_uYFFgONxzuTB86kKej8f2XBDHLGdUPZHvjg@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFC 1/2] dma-buf: Introduce dma buffer sharing mechanism
From: Dave Airlie <airlied@gmail.com>
To: Sumit Semwal <sumit.semwal@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux@arm.linux.org.uk, arnd@arndb.de, jesse.barker@linaro.org,
        daniel@ffwll.ch
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
> +                                               struct device *dev)
> +{
> +       struct dma_buf_attachment *attach;
> +       int ret;
> +
> +       BUG_ON(!dmabuf || !dev);
> +
> +       mutex_lock(&dmabuf->lock);
> +
> +       attach = kzalloc(sizeof(struct dma_buf_attachment), GFP_KERNEL);
> +       if (attach == NULL)
> +               goto err_alloc;
> +
> +       attach->dev = dev;
> +       if (dmabuf->ops->attach) {
> +               ret = dmabuf->ops->attach(dmabuf, dev, attach);
> +               if (!ret)
> +                       goto err_attach;
> +       }
> +       list_add(&attach->node, &dmabuf->attachments);
> +

I would assume at some point this needed at
attach->dmabuf = dmabuf;
added.

Dave.

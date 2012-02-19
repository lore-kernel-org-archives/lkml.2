Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab2BSVUQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 16:20:16 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:64374 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927Ab2BSVUP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 16:20:15 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of rob.clark@linaro.org designates 10.229.105.141 as permitted sender) smtp.mail=rob.clark@linaro.org
MIME-Version: 1.0
In-Reply-To: <1326845297-6233-2-git-send-email-rmorell@nvidia.com>
References: <alpine.DEB.2.00.1201061458020.18430@skynet.skynet.ie>
	<1326845297-6233-1-git-send-email-rmorell@nvidia.com>
	<1326845297-6233-2-git-send-email-rmorell@nvidia.com>
Date: Sun, 19 Feb 2012 15:20:14 -0600
Message-ID: <CAN_cFWPv1X+tb998ejstf9svENhZweG9zWwtFbaCNrFi482qEQ@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: Use EXPORT_SYMBOL
From: Rob Clark <rob.clark@linaro.org>
To: Robert Morell <rmorell@nvidia.com>
Cc: linux-kernel@vger.kernel.org, sumit.semwal@linaro.org, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 6:08 PM, Robert Morell <rmorell@nvidia.com> wrote:
> EXPORT_SYMBOL_GPL is intended to be used for "an internal implementation
> issue, and not really an interface".  The dma-buf infrastructure is
> explicitly intended as an interface between modules/drivers, so it
> should use EXPORT_SYMBOL instead.


We discussed this topic at the kernel-gfx mini-summit at ELC.
Following the discussion, I agree that dma-buf infrastructure is
intended as an interface between driver subsystems.  And because (for
now) all the other arm SoC gl(es) stacks unfortunately involve a
closed src userspace, and since I consider userspace and kernel as
tightly coupled in the realm of graphics stacks, I don't think we can
really claim the moral high-ground here.  So I can't object to use of
EXPORT_SYMBOL() instead of EXPORT_SYMBOL_GPL().

That said, I expect the dma-buf infrastructure to still be evolving
and it is the responsibility for out-of-tree users of the API (GPL or
otherwise) to adapt as the dma-buf API changes.  And there isn't much
the in-tree drivers can do when it comes to debugging of buffer
sharing issues with out-of-tree drivers (binary or otherwise), leaving
the debugging responsibility to the owners of different out-of-tree
drivers.

BR,
-R

> Signed-off-by: Robert Morell <rmorell@nvidia.com>
> ---
>  drivers/base/dma-buf.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
> index e38ad24..4ed5a5d 100644
> --- a/drivers/base/dma-buf.c
> +++ b/drivers/base/dma-buf.c
> @@ -101,7 +101,7 @@ struct dma_buf *dma_buf_export(void *priv, struct dma_buf_ops *ops,
>
>        return dmabuf;
>  }
> -EXPORT_SYMBOL_GPL(dma_buf_export);
> +EXPORT_SYMBOL(dma_buf_export);
>
>
>  /**
> @@ -126,7 +126,7 @@ int dma_buf_fd(struct dma_buf *dmabuf)
>
>        return fd;
>  }
> -EXPORT_SYMBOL_GPL(dma_buf_fd);
> +EXPORT_SYMBOL(dma_buf_fd);
>
>  /**
>  * dma_buf_get - returns the dma_buf structure related to an fd
> @@ -152,7 +152,7 @@ struct dma_buf *dma_buf_get(int fd)
>
>        return file->private_data;
>  }
> -EXPORT_SYMBOL_GPL(dma_buf_get);
> +EXPORT_SYMBOL(dma_buf_get);
>
>  /**
>  * dma_buf_put - decreases refcount of the buffer
> @@ -167,7 +167,7 @@ void dma_buf_put(struct dma_buf *dmabuf)
>
>        fput(dmabuf->file);
>  }
> -EXPORT_SYMBOL_GPL(dma_buf_put);
> +EXPORT_SYMBOL(dma_buf_put);
>
>  /**
>  * dma_buf_attach - Add the device to dma_buf's attachments list; optionally,
> @@ -213,7 +213,7 @@ err_attach:
>        mutex_unlock(&dmabuf->lock);
>        return ERR_PTR(ret);
>  }
> -EXPORT_SYMBOL_GPL(dma_buf_attach);
> +EXPORT_SYMBOL(dma_buf_attach);
>
>  /**
>  * dma_buf_detach - Remove the given attachment from dmabuf's attachments list;
> @@ -235,7 +235,7 @@ void dma_buf_detach(struct dma_buf *dmabuf, struct dma_buf_attachment *attach)
>        mutex_unlock(&dmabuf->lock);
>        kfree(attach);
>  }
> -EXPORT_SYMBOL_GPL(dma_buf_detach);
> +EXPORT_SYMBOL(dma_buf_detach);
>
>  /**
>  * dma_buf_map_attachment - Returns the scatterlist table of the attachment;
> @@ -265,7 +265,7 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
>
>        return sg_table;
>  }
> -EXPORT_SYMBOL_GPL(dma_buf_map_attachment);
> +EXPORT_SYMBOL(dma_buf_map_attachment);
>
>  /**
>  * dma_buf_unmap_attachment - unmaps and decreases usecount of the buffer;might
> @@ -288,4 +288,4 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
>        mutex_unlock(&attach->dmabuf->lock);
>
>  }
> -EXPORT_SYMBOL_GPL(dma_buf_unmap_attachment);
> +EXPORT_SYMBOL(dma_buf_unmap_attachment);
> --
> 1.7.3.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

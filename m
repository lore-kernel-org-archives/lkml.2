Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab2I1NUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:20:49 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33241 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756255Ab2I1NUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:20:47 -0400
Date: Fri, 28 Sep 2012 15:20:40 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: jakob@vmware.com, thellstrom@vmware.com, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] dma-buf: remove fallback for
 !CONFIG_DMA_SHARED_BUFFER
Message-ID: <20120928132040.GK2098@bremse>
Mail-Followup-To: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	jakob@vmware.com, thellstrom@vmware.com,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	sumit.semwal@linaro.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20120928124148.14366.21063.stgit@patser.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120928124148.14366.21063.stgit@patser.local>
X-Operating-System: Linux bremse 3.5.4-1.fc17.x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 02:41:48PM +0200, Maarten Lankhorst wrote:
> Documentation says that code requiring dma-buf should add it to
> select, so inline fallbacks are not going to be used. A link error
> will make it obvious what went wrong, instead of silently doing
> nothing at runtime.
> 
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

I think it'd be good if we could merge this for 3.7 ...
-Daniel

> ---
>  include/linux/dma-buf.h |   99 -----------------------------------------------
>  1 file changed, 99 deletions(-)
> 
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index eb48f38..bd2e52c 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -156,7 +156,6 @@ static inline void get_dma_buf(struct dma_buf *dmabuf)
>  	get_file(dmabuf->file);
>  }
>  
> -#ifdef CONFIG_DMA_SHARED_BUFFER
>  struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
>  							struct device *dev);
>  void dma_buf_detach(struct dma_buf *dmabuf,
> @@ -184,103 +183,5 @@ int dma_buf_mmap(struct dma_buf *, struct vm_area_struct *,
>  		 unsigned long);
>  void *dma_buf_vmap(struct dma_buf *);
>  void dma_buf_vunmap(struct dma_buf *, void *vaddr);
> -#else
> -
> -static inline struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
> -							struct device *dev)
> -{
> -	return ERR_PTR(-ENODEV);
> -}
> -
> -static inline void dma_buf_detach(struct dma_buf *dmabuf,
> -				  struct dma_buf_attachment *dmabuf_attach)
> -{
> -	return;
> -}
> -
> -static inline struct dma_buf *dma_buf_export(void *priv,
> -					     const struct dma_buf_ops *ops,
> -					     size_t size, int flags)
> -{
> -	return ERR_PTR(-ENODEV);
> -}
> -
> -static inline int dma_buf_fd(struct dma_buf *dmabuf, int flags)
> -{
> -	return -ENODEV;
> -}
> -
> -static inline struct dma_buf *dma_buf_get(int fd)
> -{
> -	return ERR_PTR(-ENODEV);
> -}
> -
> -static inline void dma_buf_put(struct dma_buf *dmabuf)
> -{
> -	return;
> -}
> -
> -static inline struct sg_table *dma_buf_map_attachment(
> -	struct dma_buf_attachment *attach, enum dma_data_direction write)
> -{
> -	return ERR_PTR(-ENODEV);
> -}
> -
> -static inline void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
> -			struct sg_table *sg, enum dma_data_direction dir)
> -{
> -	return;
> -}
> -
> -static inline int dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
> -					   size_t start, size_t len,
> -					   enum dma_data_direction dir)
> -{
> -	return -ENODEV;
> -}
> -
> -static inline void dma_buf_end_cpu_access(struct dma_buf *dmabuf,
> -					  size_t start, size_t len,
> -					  enum dma_data_direction dir)
> -{
> -}
> -
> -static inline void *dma_buf_kmap_atomic(struct dma_buf *dmabuf,
> -					unsigned long pnum)
> -{
> -	return NULL;
> -}
> -
> -static inline void dma_buf_kunmap_atomic(struct dma_buf *dmabuf,
> -					 unsigned long pnum, void *vaddr)
> -{
> -}
> -
> -static inline void *dma_buf_kmap(struct dma_buf *dmabuf, unsigned long pnum)
> -{
> -	return NULL;
> -}
> -
> -static inline void dma_buf_kunmap(struct dma_buf *dmabuf,
> -				  unsigned long pnum, void *vaddr)
> -{
> -}
> -
> -static inline int dma_buf_mmap(struct dma_buf *dmabuf,
> -			       struct vm_area_struct *vma,
> -			       unsigned long pgoff)
> -{
> -	return -ENODEV;
> -}
> -
> -static inline void *dma_buf_vmap(struct dma_buf *dmabuf)
> -{
> -	return NULL;
> -}
> -
> -static inline void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
> -{
> -}
> -#endif /* CONFIG_DMA_SHARED_BUFFER */
>  
>  #endif /* __DMA_BUF_H__ */
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch

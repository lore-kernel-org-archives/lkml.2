Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab1JLMl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:41:59 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55884 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab1JLMl6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:41:58 -0400
MIME-Version: 1.0
In-Reply-To: <1318325033-32688-2-git-send-email-sumit.semwal@ti.com>
References: <1318325033-32688-1-git-send-email-sumit.semwal@ti.com>
	<1318325033-32688-2-git-send-email-sumit.semwal@ti.com>
Date: Wed, 12 Oct 2011 13:41:57 +0100
Message-ID: <CAPM=9tzHOa5Dbe=SQz+AURMMbio4L7qoS8kUT3Ek0+HdtkrH4g@mail.gmail.com>
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

On Tue, Oct 11, 2011 at 10:23 AM, Sumit Semwal <sumit.semwal@ti.com> wrote:
> This is the first step in defining a dma buffer sharing mechanism.
>
> A new buffer object dma_buf is added, with operations and API to allow easy
> sharing of this buffer object across devices.
>
> The framework allows:
> - a new buffer-object to be created with fixed size.
> - different devices to 'attach' themselves to this buffer, to facilitate
>  backing storage negotiation, using dma_buf_attach() API.
> - association of a file pointer with each user-buffer and associated
>   allocator-defined operations on that buffer. This operation is called the
>   'export' operation.
> - this exported buffer-object to be shared with the other entity by asking for
>   its 'file-descriptor (fd)', and sharing the fd across.
> - a received fd to get the buffer object back, where it can be accessed using
>   the associated exporter-defined operations.
> - the exporter and user to share the scatterlist using get_scatterlist and
>   put_scatterlist operations.
>
> Atleast one 'attach()' call is required to be made prior to calling the
> get_scatterlist() operation.
>
> Couple of building blocks in get_scatterlist() are added to ease introduction
> of sync'ing across exporter and users, and late allocation by the exporter.
>
> mmap() file operation is provided for the associated 'fd', as wrapper over the
> optional allocator defined mmap(), to be used by devices that might need one.

Why is this needed? it really doesn't make sense to be mmaping objects
independent of some front-end like drm or v4l.

how will you know what contents are in them, how will you synchronise
access. Unless someone has a hard use-case for this I'd say we drop it
until someone does.

Dave.

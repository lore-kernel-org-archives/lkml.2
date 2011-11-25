Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab1KYONY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 09:13:24 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42988 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab1KYONX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 09:13:23 -0500
MIME-Version: 1.0
In-Reply-To: <1318325033-32688-2-git-send-email-sumit.semwal@ti.com>
References: <1318325033-32688-1-git-send-email-sumit.semwal@ti.com>
	<1318325033-32688-2-git-send-email-sumit.semwal@ti.com>
Date: Fri, 25 Nov 2011 14:13:22 +0000
Message-ID: <CAPM=9tzAgCSDgdvi=9QZa-gEVXwKp_gpCPTtQ10XS=Z9K4805w@mail.gmail.com>
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
>
> More details are there in the documentation patch.
>

Some questions, I've started playing around with using this framework
to do buffer sharing between DRM devices,

Why struct scatterlist and not struct sg_table? it seems like I really
want to use an sg_table,

I'm not convinced fd's are really useful over just some idr allocated
handle, so far I'm just returning the "fd" to userspace as a handle,
and passing it back in the other side, so I'm not really sure what an
fd wins us here, apart from the mmap thing which I think shouldn't be
here anyways.
(if fd's do win us more we should probably record that in the docs patch).

Dave.

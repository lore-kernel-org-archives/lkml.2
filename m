Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab1LTT3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:29:43 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:65484 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab1LTT3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:29:36 -0500
Date: Tue, 20 Dec 2011 20:31:17 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Sumit Semwal <sumit.semwal@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux@arm.linux.org.uk, arnd@arndb.de, jesse.barker@linaro.org,
        m.szyprowski@samsung.com, rob@ti.com, daniel@ffwll.ch,
        t.stanislaws@samsung.com, patches@linaro.org
Subject: Re: [RFC v3 0/2] Introduce DMA buffer sharing mechanism
Message-ID: <20111220193117.GD3883@phenom.ffwll.local>
Mail-Followup-To: Sumit Semwal <sumit.semwal@ti.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linux@arm.linux.org.uk, arnd@arndb.de, jesse.barker@linaro.org,
	m.szyprowski@samsung.com, rob@ti.com, t.stanislaws@samsung.com,
	patches@linaro.org
References: <1324283611-18344-1-git-send-email-sumit.semwal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324283611-18344-1-git-send-email-sumit.semwal@ti.com>
X-Operating-System: Linux phenom 3.1.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 02:03:28PM +0530, Sumit Semwal wrote:
> Hello Everyone,
> 
> This is RFC v3 for DMA buffer sharing mechanism - changes from v2 are in the
> changelog below.
> 
> Various subsystems - V4L2, GPU-accessors, DRI to name a few - have felt the 
> need to have a common mechanism to share memory buffers across different
> devices - ARM, video hardware, GPU.
> 
> This need comes forth from a variety of use cases including cameras, image 
> processing, video recorders, sound processing, DMA engines, GPU and display
> buffers, and others.
> 
> This RFC is an attempt to define such a buffer sharing mechanism- it is the
> result of discussions from a couple of memory-management mini-summits held by
> Linaro to understand and address common needs around memory management. [1]
> 
> A new dma_buf buffer object is added, with operations and API to allow easy
> sharing of this buffer object across devices.
> 
> The framework allows:
> - a new buffer-object to be created with fixed size.
> - different devices to 'attach' themselves to this buffer, to facilitate
>   backing storage negotiation, using dma_buf_attach() API.
> - association of a file pointer with each user-buffer and associated
>    allocator-defined operations on that buffer. This operation is called the
>    'export' operation.
> - this exported buffer-object to be shared with the other entity by asking for
>    its 'file-descriptor (fd)', and sharing the fd across.
> - a received fd to get the buffer object back, where it can be accessed using
>    the associated exporter-defined operations.
> - the exporter and user to share the scatterlist using map_dma_buf and
>    unmap_dma_buf operations.
> 
> Documentation present in the patch-set gives more details.
> 
> This is based on design suggestions from many people at the mini-summits,
> most notably from Arnd Bergmann <arnd@arndb.de>, Rob Clark <rob@ti.com> and
> Daniel Vetter <daniel@ffwll.ch>.
> 
> The implementation is inspired from proof-of-concept patch-set from
> Tomasz Stanislawski <t.stanislaws@samsung.com>, who demonstrated buffer sharing
> between two v4l2 devices. [2]
> 
> References:
> [1]: https://wiki.linaro.org/OfficeofCTO/MemoryManagement
> [2]: http://lwn.net/Articles/454389
> 
> Patchset based on top of 3.2-rc3, the current version can be found at
> 
> http://git.linaro.org/gitweb?p=people/sumitsemwal/linux-3.x.git
> Branch: dma-buf-upstr-v2
> 
> Earlier versions:
> v2 at: https://lkml.org/lkml/2011/12/2/53
> v1 at: https://lkml.org/lkml/2011/10/11/92
> 
> Best regards,
> ~Sumit Semwal

I think this is a really good v1 version of dma_buf. It contains all the
required bits (with well-specified semantics in the doc patch) to
implement some basic use-cases and start fleshing out the integration with
various subsystem (like drm and v4l). All the things still under
discussion like
- userspace mmap support
- more advanced (and more strictly specified) coherency models
- and shared infrastructure for implementing exporters
are imo much clearer once we have a few example drivers at hand and a
better understanding of some of the insane corner cases we need to be able
to handle.

And I think any risk that the resulting clarifications will break a basic
use-case is really minimal, so I think it'd be great if this could go into
3.3 (maybe as some kind of staging/experimental infrastructure).

Hence for both patches:
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab1LTQl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 11:41:56 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46350 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab1LTQlq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 11:41:46 -0500
MIME-Version: 1.0
In-Reply-To: <201112201541.17904.arnd@arndb.de>
References: <1322816252-19955-1-git-send-email-sumit.semwal@ti.com>
	<201112121648.52126.arnd@arndb.de>
	<CAB2ybb_dU7BzJmPo6vA92pe1YCNerCLc+bv7Qi_EfkfGaik6bQ@mail.gmail.com>
	<201112201541.17904.arnd@arndb.de>
Date: Tue, 20 Dec 2011 10:41:45 -0600
Message-ID: <CAF6AEGtOjO6Z6yfHz-ZGz3+NuEMH2M-8=20U6+-xt-gv9XtzaQ@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFC v2 1/2] dma-buf: Introduce dma buffer
 sharing mechanism
From: Rob Clark <robdclark@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Semwal, Sumit" <sumit.semwal@ti.com>, Daniel Vetter <daniel@ffwll.ch>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 9:41 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 19 December 2011, Semwal, Sumit wrote:
>> I didn't see a consensus on whether dma_buf should enforce some form
>> of serialization within the API - so atleast for v1 of dma-buf, I
>> propose to 'not' impose a restriction, and we can tackle it (add new
>> ops or enforce as design?) whenever we see the first need of it - will
>> that be ok? [I am bending towards the thought that it is a problem to
>> solve at a bigger platform than dma_buf.]
>
> The problem is generally understood for streaming mappings with a
> single device using it: if you have a long-running mapping, you have
> to use dma_sync_*. This obviously falls apart if you have multiple
> devices and no serialization between the accesses.
>
> If you don't want serialization, that implies that we cannot have
> use the  dma_sync_* API on the buffer, which in turn implies that
> we cannot have streaming mappings. I think that's ok, but then
> you have to bring back the mmap API on the buffer if you want to
> allow any driver to provide an mmap function for a shared buffer.

I'm thinking for a first version, we can get enough mileage out of it by saying:
1) only exporter can mmap to userspace
2) only importers that do not need CPU access to buffer..

This way we can get dmabuf into the kernel, maybe even for 3.3.  I
know there are a lot of interesting potential uses where this stripped
down version is good enough.  It probably isn't the final version,
maybe more features are added over time to deal with importers that
need CPU access to buffer, sync object, etc.  But we have to start
somewhere.

BR,
-R

>        Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab1LUR1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 12:27:43 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:54407 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab1LUR1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 12:27:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [Linaro-mm-sig] [RFC v2 1/2] dma-buf: Introduce dma buffer sharing mechanism
Date: Wed, 21 Dec 2011 17:27:16 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Rob Clark <robdclark@gmail.com>, "Semwal, Sumit" <sumit.semwal@ti.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1322816252-19955-1-git-send-email-sumit.semwal@ti.com> <CAF6AEGtOjO6Z6yfHz-ZGz3+NuEMH2M-8=20U6+-xt-gv9XtzaQ@mail.gmail.com> <20111220171437.GC3883@phenom.ffwll.local>
In-Reply-To: <20111220171437.GC3883@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112211727.17104.arnd@arndb.de>
X-Provags-ID: V02:K0:qbDf4igyg0b/TXywmVGD1MpYCUf2n1oLIZLCweXwnvJ
 BL4wlia4prdUTjWVM37uSfZGGkTY8SftCLWr3bUiNcdMlfYvMN
 MSs02F3d/z1reOHnXRn/52AfHU/e0jpnzSR30qp1XZBiGKhokf
 QKE21OxR3K4CWg9B2RYcj9j8VSX/iYE294eW+jodoEcOg0SYlg
 3DPFQ3Omx5lOUEuLrwYkeg84C+lQxShKy+GuCp38wXdKK+7Ijg
 0Hk6k+j6RQsdVZIguethCCBjOVvVWl1/z+KlQz4qo3x8Ce3kHH
 lLlbSrnkyWUmR4ktyLqBtgo1r94OjPX0PwVFi8NaDvZhXtjF+x
 f3Hbkx0RSQOq9A4B0pUM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 December 2011, Daniel Vetter wrote:
> > I'm thinking for a first version, we can get enough mileage out of it by saying:
> > 1) only exporter can mmap to userspace
> > 2) only importers that do not need CPU access to buffer..

Ok, that sounds possible. The alternative to this would be:

1) The exporter has to use dma_alloc_coherent() or dma_alloc_writecombine()
to allocate the buffer
2. Every user space mapping has to go through dma_mmap_coherent()
or dma_mmap_writecombine()

We can extend the rules later to allow either one after we have gained
some experience using it.

> > This way we can get dmabuf into the kernel, maybe even for 3.3.  I
> > know there are a lot of interesting potential uses where this stripped
> > down version is good enough.  It probably isn't the final version,
> > maybe more features are added over time to deal with importers that
> > need CPU access to buffer, sync object, etc.  But we have to start
> > somewhere.
> 
> I agree with Rob here - I think especially for the coherency discussion
> some actual users of dma_buf on a bunch of insane platforms (i915
> qualifies here too, because we do some cacheline flushing behind everyones
> back) would massively help in clarifying things.

Yes, agreed.

> It also sounds like that at least for proper userspace mmap support we'd
> need some dma api extensions on at least arm, and that might take a while
> ...

I think it's actually the opposite -- you'd need dma api extensions on
everything else other than arm, which already has dma_mmap_coherent()
and dma_mmap_writecombine() for this purpose.

	Arnd

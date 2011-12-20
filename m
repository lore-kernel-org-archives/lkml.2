Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab1LTPlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 10:41:39 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64835 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab1LTPlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 10:41:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Semwal, Sumit" <sumit.semwal@ti.com>
Subject: Re: [Linaro-mm-sig] [RFC v2 1/2] dma-buf: Introduce dma buffer sharing mechanism
Date: Tue, 20 Dec 2011 15:41:17 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Daniel Vetter <daniel@ffwll.ch>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <1322816252-19955-1-git-send-email-sumit.semwal@ti.com> <201112121648.52126.arnd@arndb.de> <CAB2ybb_dU7BzJmPo6vA92pe1YCNerCLc+bv7Qi_EfkfGaik6bQ@mail.gmail.com>
In-Reply-To: <CAB2ybb_dU7BzJmPo6vA92pe1YCNerCLc+bv7Qi_EfkfGaik6bQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112201541.17904.arnd@arndb.de>
X-Provags-ID: V02:K0:DTsJ1hihYpVmXaK0ytOYJQdHd0D/e4Ju8oQQ9NhAE/E
 68qNgnldlhwXnINw71sT5Hfy4MXy96Ms+xz3xV5BRJi44Reb7a
 oUeXS80S3YVId1rg++oeUCTObynv+/gUvKTdTfaJ8tPtkEGchi
 cXs0e121u4iBrKQXTP+Mhwx6j/mOtJiXTDNlLIUv3YmZP5wCTG
 XK/fCCZVrB3GKTQoY8yNrzR2WtbO1He521YixGj5RuWkWxjZdg
 ne+MuzjCoStoCHLj5062ruxt+XwDc04PKs8Cc5q/fAXeRSHykJ
 t4e+ZRWzdVTOu3Xr1Cwh+7OvhAl185qvok6Fo2zsa1CYMfSTke
 ajGcfFNltOEg0xM8IuBg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 December 2011, Semwal, Sumit wrote:
> I didn't see a consensus on whether dma_buf should enforce some form
> of serialization within the API - so atleast for v1 of dma-buf, I
> propose to 'not' impose a restriction, and we can tackle it (add new
> ops or enforce as design?) whenever we see the first need of it - will
> that be ok? [I am bending towards the thought that it is a problem to
> solve at a bigger platform than dma_buf.]

The problem is generally understood for streaming mappings with a 
single device using it: if you have a long-running mapping, you have
to use dma_sync_*. This obviously falls apart if you have multiple
devices and no serialization between the accesses.

If you don't want serialization, that implies that we cannot have
use the  dma_sync_* API on the buffer, which in turn implies that
we cannot have streaming mappings. I think that's ok, but then
you have to bring back the mmap API on the buffer if you want to
allow any driver to provide an mmap function for a shared buffer.

	Arnd

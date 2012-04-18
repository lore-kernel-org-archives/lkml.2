Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab2DROGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 10:06:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58695 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab2DROGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 10:06:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH] dma-buf: mmap support
Date: Wed, 18 Apr 2012 14:06:13 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linaro-mm-sig@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org, Rob Clark <rob.clark@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>
References: <1334757146-28335-1-git-send-email-daniel.vetter@ffwll.ch>
In-Reply-To: <1334757146-28335-1-git-send-email-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204181406.14159.arnd@arndb.de>
X-Provags-ID: V02:K0:OSHKAVuLW7GDSH9LGrlaLbCLktoObrfSwGdbsU9mBu9
 wHmFSWr6HfPLf/mst93cCF4qdSLVyXNqpUpC1QWb0jGbtboKfb
 yKB0fWUrOHR/v3C8YxBo16bqNEqa8VedxjP5MGCE2OPF/zwiQx
 Hfetep8GAjUY59+ziolrh2OWdeFqX6RP4cJHB8FL4/hL62hgjP
 czBg8KjeULry182wYOX+Hjm4iPWwHa8/D9IUJ9xri2ORxAqA3v
 732KF5f/CyMw7Hi0TTM42mmDI12Cfl1fTIFgufRFKK/ASXRfg7
 KN9daWk+VkcGktfqSGMszf6+1d9o3zQNtiPBBcmdsp1+EnZakL
 Muho3077HNnYGbNU5TgY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 April 2012, Daniel Vetter wrote:
> +   Because existing importing subsystems might presume coherent mappings for
> +   userspace, the exporter needs to set up a coherent mapping. If that's not
> +   possible, it needs to fake coherency by manually shooting down ptes when
> +   leaving the cpu domain and flushing caches at fault time. Note that all the
> +   dma_buf files share the same anon inode, hence the exporter needs to replace
> +   the dma_buf file stored in vma->vm_file with it's own if pte shootdown is
> +   requred. This is because the kernel uses the underlying inode's address_space
> +   for vma tracking (and hence pte tracking at shootdown time with
> +   unmap_mapping_range).
> +
> +   If the above shootdown dance turns out to be too expensive in certain
> +   scenarios, we can extend dma-buf with a more explicit cache tracking scheme
> +   for userspace mappings. But the current assumption is that using mmap is
> +   always a slower path, so some inefficiencies should be acceptable.
> +
> +   Exporters that shoot down mappings (for any reasons) shall not do any
> +   synchronization at fault time with outstanding device operations.
> +   Synchronization is an orthogonal issue to sharing the backing storage of a
> +   buffer and hence should not be handled by dma-buf itself. This is explictly
> +   mentioned here because many people seem to want something like this, but if
> +   different exporters handle this differently, buffer sharing can fail in
> +   interesting ways depending upong the exporter (if userspace starts depending
> +   upon this implicit synchronization).

How do you ensure that no device can do DMA on the buffer while it's mapped
into user space in a noncoherent manner?

	Arnd

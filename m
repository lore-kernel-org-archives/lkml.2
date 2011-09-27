Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab1I0RHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 13:07:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37132 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab1I0RHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 13:07:32 -0400
MIME-Version: 1.0
In-Reply-To: <4E81BDEE.2080601@enea.com>
References: <4E81BDEE.2080601@enea.com>
Date: Tue, 27 Sep 2011 09:55:02 -0700
Message-ID: <CAF8ieYUPcer2ZwaOi6YbiZQPeDBFukT2_dPStH10G_15Rh1fpw@mail.gmail.com>
Subject: Re: dma_unmap_single() lacking cache sync on some archs?
From: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
To: Arvid Brodin <arvid.brodin@enea.com>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>, arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 27, 2011 at 5:13 AM, Arvid Brodin <arvid.brodin@enea.com> wrote:
> [Resending with CC to affected parties]
>
> Hi,
>
> I would expect cache synchronization for DMA_TO_DEVICE and DMA_BIDIRECTIONAL
> when dma_map_single() is called, and for DMA_FROM_DEVICE and DMA_BIDIRECTIONAL
> when dma_unmap_single() is called.
>
> However, on some architechtures (at least avr32, blackfin, ...), cache
> synchronization only happens when dma_map_single() is called (and then
> irrespective of DMA direction). dma_unmap_single() is a no-op for these archs.
>
> See e.g. http://lxr.linux.no/#linux+v3.0.4/arch/avr32/include/asm/dma-mapping.h#L117
>
> Isn't this a bug?

I don't think so. What do other architectures do?

We always need to sync before the transfer because if there is dirty
data in the cache, it might get written to RAM during the transfer,
which would be bad. Then, since the relevant cache lines are already
clean and invalid, and the CPU is not allowed to access the buffer
during the transfer, there's no need to sync again when the transfer
is complete.

Havard

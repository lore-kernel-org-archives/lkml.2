Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab1JVFJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:09:27 -0400
Received: from sh.osrg.net ([192.16.179.4]:59946 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878Ab1JVFJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:09:25 -0400
Date: Sat, 22 Oct 2011 14:08:49 +0900
To: clemens@ladisch.de
Cc: arnd@arndb.de, akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
        konrad.wilk@oracle.com, stefanr@s5r6.in-berlin.de,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma-mapping: fix sync_single_range_* DMA debugging
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4E99F69F.1080701@ladisch.de>
References: <20111015171523.434f47c8@stein>
	<4E99E92B.6020408@ladisch.de>
	<4E99F69F.1080701@ladisch.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20111022140751W.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 22 Oct 2011 14:08:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Oct 2011 23:09:51 +0200
Clemens Ladisch <clemens@ladisch.de> wrote:

> Commit 5fd75a7850b5 (dma-mapping: remove unnecessary sync_single_range_*
> in dma_map_ops) unified not only the dma_map_ops but also the
> corresponding debug_dma_sync_* calls.  This led to spurious WARN()ings
> like the following because the DMA debug code was no longer able to
> detect the DMA buffer base address without the separate offset parameter:
> 
> WARNING: at lib/dma-debug.c:911 check_sync+0xce/0x446()
> firewire_ohci 0000:04:00.0: DMA-API: device driver tries to sync DMA memory it has not allocated [device address=0x00000000cedaa400] [size=1024 bytes]
> Call Trace: ...
>  [<ffffffff811326a5>] check_sync+0xce/0x446
>  [<ffffffff81132ad9>] debug_dma_sync_single_for_device+0x39/0x3b
>  [<ffffffffa01d6e6a>] ohci_queue_iso+0x4f3/0x77d [firewire_ohci]
>  ...
> 
> To fix this, unshare the sync_single_* and sync_single_range_*
> implementations so that we are able to call the correct debug_dma_sync_*
> functions.
> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
> ---
>  include/asm-generic/dma-mapping-common.h |   14 ++++++++++++--
>  1 files changed, 12 insertions(+), 2 deletions(-)

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>


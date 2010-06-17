Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab0FQMNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 08:13:51 -0400
Received: from sh.osrg.net ([192.16.179.4]:33747 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759832Ab0FQMNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 08:13:48 -0400
Date: Thu, 17 Jun 2010 21:13:42 +0900
To: JBottomley@Novell.com
Cc: netdev@vger.kernel.org, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       mchan@broadcom.com
Subject: Re: bnx2 fails to compile on parisc because of missing
 get_dma_ops()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1276737229.2847.853.camel@mulgrave.site>
References: <1276737229.2847.853.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100617210358A.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 17 Jun 2010 21:13:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jun 2010 20:13:49 -0500
James Bottomley <JBottomley@Novell.com> wrote:

> I'm not quite sure whose fault this one is.
> 
> However, this code in bnx2.c:
> 
> 		if (!get_dma_ops(&pdev->dev)->sync_single_for_cpu) {
> 			next_rx_buf =
> 				&rxr->rx_buf_ring[
> 					RX_RING_IDX(NEXT_RX_BD(sw_cons))];
> 			prefetch(next_rx_buf->desc);
> 		}
> 
> Looks remarkably fragile: what exactly is it trying to do?
> 
> The commit that causes the problem:
> 
> commit a33fa66bcf365ffe5b79d1ae1d3582cc261ae56e
> Author: Michael Chan <mchan@broadcom.com>
> Date:   Thu May 6 08:58:13 2010 +0000
> 
>     bnx2: Add prefetches to rx path.
> 
> Looks fairly innocuous by the description.
> 
> Should parisc have a get_dma_ops()?  We don't need one because our dma
> ops are per platform not per bus.

Shouldn't. Only the architectures that use
include/dma-generic/dma-mapping.common.h need to have get_dma_ops().

Using include/dma-generic/dma-mapping.common.h for parisc is not a bad
idea though.

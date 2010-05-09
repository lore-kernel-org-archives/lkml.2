Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab0EIOAj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 10:00:39 -0400
Received: from sh.osrg.net ([192.16.179.4]:55276 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839Ab0EIOAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 10:00:37 -0400
Date: Sun, 9 May 2010 22:41:26 +0900
To: konrad.wilk@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es,
       linux@eikelenboom.it, chrisw@sous-sol.org, Ian.Campbell@eu.citrix.com,
       jeremy@goop.org, dwmw2@infradead.org, alex.williamson@hp.com
Subject: Re: [PATCH 5/6] swiotlb: Make swiotlb bookkeeping functions
 visible in the header file.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1270672170-31833-6-git-send-email-konrad.wilk@oracle.com>
References: <1270672170-31833-4-git-send-email-konrad.wilk@oracle.com>
	<1270672170-31833-5-git-send-email-konrad.wilk@oracle.com>
	<1270672170-31833-6-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100509224534X.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 09 May 2010 22:41:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  7 Apr 2010 16:29:29 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> We put the init, free, and functions dealing with the operations on
> the SWIOTLB buffer at the top of the header. Also we export some of the
> variables that are used by the dma_ops functions.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  include/linux/swiotlb.h |   33 +++++++++++++++++++++++++++++++++
>  lib/swiotlb.c           |   42 ++++++++++++++++++++----------------------
>  2 files changed, 53 insertions(+), 22 deletions(-)


> +extern void swiotlb_full(struct device *dev, size_t size,
> +			 enum dma_data_direction dir, int do_panic);
> +

Please don't. You create a new IOMMU implementation with the helper
function. We don't want another IOMMU implementation that has broken
'overflow buffer' concept.

swiotlb-xen should handle DMA mapping errors properly instead of
calling swiotlb_full().

btw, if you try to push xen swiotlb stuff to mainline, please don't
put xen swiotlb stuff to include/linux/swiotlb.h.

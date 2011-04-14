Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab1DNWa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 18:30:58 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58693 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab1DNWaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 18:30:55 -0400
Date: Thu, 14 Apr 2011 23:30:36 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Fernando Guzman Lugo <fernando.lugo@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, tony@atomide.com,
        Ramesh Gupta <grgupta@ti.com>, Hari Kanigeri <h-kanigeri2@ti.com>
Subject: Re: [PATCH] OMAP: iommu flush page table entries from L1 and L2
	cache
Message-ID: <20110414223036.GA7335@n2100.arm.linux.org.uk>
References: <1302817968-28516-1-git-send-email-fernando.lugo@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302817968-28516-1-git-send-email-fernando.lugo@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 04:52:48PM -0500, Fernando Guzman Lugo wrote:
> From: Ramesh Gupta <grgupta@ti.com>
> 
> This patch is to flush the iommu page table entries from L1 and L2
> caches using dma_map_single. This also simplifies the implementation
> by removing the functions  flush_iopgd_range/flush_iopte_range.

No.  This usage is just wrong.  If you're going to use the DMA API then
unmap it, otherwise the DMA API debugging will go awol.

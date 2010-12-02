Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab0LBWTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 17:19:40 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33918 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002Ab0LBWTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 17:19:39 -0500
Date: Thu, 2 Dec 2010 22:19:09 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jeff Ohlstein <johlstei@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dwalker@codeaurora.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Nicolas Pitre <nico@marvell.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] arm: dma-mapping: move consistent_init to
	early_initcall
Message-ID: <20101202221909.GK29347@n2100.arm.linux.org.uk>
References: <1291327879-28073-1-git-send-email-johlstei@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291327879-28073-1-git-send-email-johlstei@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 02:11:18PM -0800, Jeff Ohlstein wrote:
> Some machines require the use of coherent memory to bring up auxillary
> cpus, and thus want to use dma_alloc_coherent prior to smp_init
> completing.

I'd like to see the rest of the code to indicate why you need DMA
coherent memory for SMP boot.  It seems to me quite unnecessary.
DMA coherent memory is meant for talking to devices, not to other
CPUs which will be part of the symmetric part of the system.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab1BOOaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 09:30:07 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43513 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab1BOOaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 09:30:05 -0500
Date: Tue, 15 Feb 2011 14:27:30 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v4 16/19] ARM: LPAE: Use generic dma_addr_t type
	definition
Message-ID: <20110215142730.GM4152@n2100.arm.linux.org.uk>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com> <1295891761-18366-17-git-send-email-catalin.marinas@arm.com> <20110212103413.GD15616@n2100.arm.linux.org.uk> <1297688490.31111.38.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297688490.31111.38.camel@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 01:01:30PM +0000, Catalin Marinas wrote:
> Maybe we could make the dma_addr_t size configurable (and disabled by
> default) since I expect there'll be platforms capable of >32-bit DMA.

It would be far better to fix the dma_addr_t abuses.  I've already fixed
those in the pl08x driver:

struct lli {
        dma_addr_t src;
        dma_addr_t dst;
        dma_addr_t next;
        u32 cctl;
};

became:

struct pl08x_lli {
        u32 src;
        u32 dst;
        u32 lli;
        u32 cctl;
};

and similar needs to be done elsewhere in ARM specific drivers.
dma_addr_t has no business being in structures that describe data which
hardware accesses.

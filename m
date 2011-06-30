Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542Ab1F3HnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 03:43:23 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49102 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab1F3HnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 03:43:17 -0400
Date: Thu, 30 Jun 2011 08:43:01 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Qin Dehua <qindehua@gmail.com>
Cc: linux-kernel@vger.kernel.org, santosh.shilimkar@ti.com,
        dan.j.williams@intel.com, neilb@suse.de
Subject: Re: PROBLEM: ARM-dma-mapping-fix-for-speculative-prefetching cause
	OOPS
Message-ID: <20110630074301.GC27959@flint.arm.linux.org.uk>
References: <BANLkTimfF3_R5VS4xOriGp+-3j-r7V0W0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimfF3_R5VS4xOriGp+-3j-r7V0W0w@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 12:09:15PM +0800, Qin Dehua wrote:
> The 2.6.38.8 Kernel make our IOP 341 XScale processor based RAID6 crashes.
> 
> After doing a bisection, We found commit
> 2ffe2da3e71652d4f4cae19539b5c78c2a239136 cause the problem.
> 
> That commit is only for ARMv6 and ARMv7 CPUs, so we revert it on
> 2.6.38.8 Kernel, and then our raid box runs OK.
> 
> Following are some kernel messages when the system crashes:
> 
> 	* The kernel config has CONFIG_ASYNC_PQ=y CONFIG_RAID6_PQ=y

These traces are from 2.6.32... And I assume have CONFIG_BUG unset
because you have no verbose bug reporting (it's not reporting the
file/line which is necessary to identify which BUG has been hit in
the raid code.)

Could you reproduce with CONFIG_BUG=y please?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

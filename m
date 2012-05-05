Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab2EEQuB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 12:50:01 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38125 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab2EEQuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 12:50:00 -0400
Date: Sat, 5 May 2012 17:49:33 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Colin Cross <ccross@android.com>
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will.deacon@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: SMP: prevent use of the console when using
	idmap_pgd
Message-ID: <20120505164933.GQ897@n2100.arm.linux.org.uk>
References: <1336180444-26563-1-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336180444-26563-1-git-send-email-ccross@android.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 06:14:02PM -0700, Colin Cross wrote:
> Commit 4e8ee7de227e3ab9a72040b448ad728c5428a042 (ARM: SMP: use
> idmap_pgd for mapping MMU enable during secondary booting)
> switched secondary boot to use idmap_pgd, which is initialized
> during early_initcall, instead of a page table initialized during
> __cpu_up.  This causes idmap_pgd to contain the static mappings
> but be missing all dynamic mappings.
> 
> If a console is registered that creates a dynamic mapping, the
> printk in secondary_start_kernel will trigger a data abort on
> the missing mapping before the exception handlers have been
> initialized, leading to a hang.  Initial boot is not affected
> because no consoles have been registered, and resume is usually
> not affected because the offending console is suspended.
> Onlining a cpu with hotplug triggers the problem.
> 
> A workaround is to the printk in secondary_start_kernel until
> after the page tables have been switched back to init_mm.

I think this is fine.  Please put it in the patch system, thanks.

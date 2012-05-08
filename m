Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab2EHJV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 05:21:29 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40881 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149Ab2EHJV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 05:21:28 -0400
Date: Tue, 8 May 2012 10:21:09 +0100
From: Will Deacon <will.deacon@arm.com>
To: Colin Cross <ccross@android.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: SMP: prevent use of the console when using idmap_pgd
Message-ID: <20120508092109.GB2263@mudshark.cambridge.arm.com>
References: <1336180444-26563-1-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336180444-26563-1-git-send-email-ccross@android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Colin,

Sorry for the delayed response.

On Sat, May 05, 2012 at 02:14:02AM +0100, Colin Cross wrote:
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

You missed a word out here (`delay'?) but it looks like Russell has taken
this now so I'm sure we'll cope.

Acked-by: Will Deacon <will.deacon@arm.com>

Will

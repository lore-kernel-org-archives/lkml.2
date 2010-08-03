Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab0HCX7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 19:59:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757554Ab0HCX7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 19:59:43 -0400
Date: Tue, 3 Aug 2010 16:59:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: Kevin Cernekee <cernekee@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: Additional fix : (was [v2]printk: fix delayed messages from CPU
 hotplug events)
Message-Id: <20100803165926.2e37d355.akpm@linux-foundation.org>
In-Reply-To: <EAF47CD23C76F840A9E7FCE10091EFAB02C641D8EC@dbde02.ent.ti.com>
References: <EAF47CD23C76F840A9E7FCE10091EFAB02C5DB6D1F@dbde02.ent.ti.com>
	<20100802154434.5615bcf9.akpm@linux-foundation.org>
	<EAF47CD23C76F840A9E7FCE10091EFAB02C641D8EC@dbde02.ent.ti.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Aug 2010 13:03:25 +0530
"Shilimkar, Santosh" <santosh.shilimkar@ti.com> wrote:

> > thought that those events simply aren't occurring, and that the patch
> > has no effect.  Confused - please explain further.
> These events can come during the CPU hotplug(offline). Below is the
> complete patch. Also attaching it in case some email format screw
> up.
> 
> -----------------------------------------------
> >From b99271ce43cc82cda28447444004933d0f218ee3 Mon Sep 17 00:00:00 2001
> From: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Date: Tue, 3 Aug 2010 12:58:22 +0530
> Subject: [PATCH] console: flush delayed log messages from cpu-hotplug events
> 
> When a secondary CPU is being brought up, it is not uncommon for
> printk() to be invoked when cpu_online(smp_processor_id()) == 0.  The
> case that I witnessed personally was on MIPS:
> 
> http://lkml.org/lkml/2010/5/30/4
> 
> If (can_use_console() == 0), printk() will spool its output to log_buf
> and it will be visible in "dmesg", but that output will NOT be echoed to
> the console until somebody calls release_console_sem() from a CPU that
> is online.  Therefore, the boot time messages from the new CPU can get
> stuck in "limbo" for a long time, and might suddenly appear on the
> screen when a completely unrelated event (e.g. "eth0: link is down")
> occurs.
> 
> This patch modifies the console code so that any pending messages are
> automatically flushed out to the console whenever a CPU hotplug
> operation completes successfully or aborts.
> This is true even when CPU is getting hot-plugged out(offline) so
> need to add additional hotplug events.
> 
> The issue was seen on 2.6.34.
> 
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>

An older version of this patch is present in linux-next, committed by
Paul Mundt, who wasn't cc'ed here(!).

Paul, please update.  Be aware that the version of the patch to which I
replied is also not the latest.


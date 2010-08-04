Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab0HDDbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 23:31:07 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:60211 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520Ab0HDDbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 23:31:04 -0400
Date: Wed, 4 Aug 2010 12:30:34 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Kevin Cernekee <cernekee@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: Additional fix : (was [v2]printk: fix delayed messages from CPU hotplug events)
Message-ID: <20100804033034.GA15098@linux-sh.org>
References: <EAF47CD23C76F840A9E7FCE10091EFAB02C5DB6D1F@dbde02.ent.ti.com> <20100802154434.5615bcf9.akpm@linux-foundation.org> <EAF47CD23C76F840A9E7FCE10091EFAB02C641D8EC@dbde02.ent.ti.com> <20100803165926.2e37d355.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100803165926.2e37d355.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 04:59:26PM -0700, Andrew Morton wrote:
> On Tue, 3 Aug 2010 13:03:25 +0530
> "Shilimkar, Santosh" <santosh.shilimkar@ti.com> wrote:
> 
> > > thought that those events simply aren't occurring, and that the patch
> > > has no effect.  Confused - please explain further.
> > These events can come during the CPU hotplug(offline). Below is the
> > complete patch. Also attaching it in case some email format screw
> > up.
> > 
> > -----------------------------------------------
> > >From b99271ce43cc82cda28447444004933d0f218ee3 Mon Sep 17 00:00:00 2001
> > From: Santosh Shilimkar <santosh.shilimkar@ti.com>
> > Date: Tue, 3 Aug 2010 12:58:22 +0530
> > Subject: [PATCH] console: flush delayed log messages from cpu-hotplug events
> > 
> > When a secondary CPU is being brought up, it is not uncommon for
> > printk() to be invoked when cpu_online(smp_processor_id()) == 0.  The
> > case that I witnessed personally was on MIPS:
> > 
> > http://lkml.org/lkml/2010/5/30/4
> > 
> > If (can_use_console() == 0), printk() will spool its output to log_buf
> > and it will be visible in "dmesg", but that output will NOT be echoed to
> > the console until somebody calls release_console_sem() from a CPU that
> > is online.  Therefore, the boot time messages from the new CPU can get
> > stuck in "limbo" for a long time, and might suddenly appear on the
> > screen when a completely unrelated event (e.g. "eth0: link is down")
> > occurs.
> > 
> > This patch modifies the console code so that any pending messages are
> > automatically flushed out to the console whenever a CPU hotplug
> > operation completes successfully or aborts.
> > This is true even when CPU is getting hot-plugged out(offline) so
> > need to add additional hotplug events.
> > 
> > The issue was seen on 2.6.34.
> > 
> > Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> > Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> 
> An older version of this patch is present in linux-next, committed by
> Paul Mundt, who wasn't cc'ed here(!).
> 
> Paul, please update.  Be aware that the version of the patch to which I
> replied is also not the latest.
> 
I just reviewed it, it went in through the MIPS tree if memory serves
correctly, so Ralf (added to Cc) would have been the one that checked it
in. I'll take a look at the thread though.

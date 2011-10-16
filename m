Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab1JPK46 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 06:56:58 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:64860 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab1JPK44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 06:56:56 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-rt-users@vger.kernel.org, tglx@linutronix.de
Subject: [RFC] [PATCH -rt 0/5] patchset focusing on cpu hotplug
Date: Sun, 16 Oct 2011 18:56:42 +0800
Message-Id: <1318762607-2261-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When tring cpu hotplug, I get some warning. And these patches
are tring to fix them up.

BTW, I have marked some of them as RFC:
  patch#3: printk: don't call printk_tick in printk_needs_cpu()
    I don't think we need to call printk_tick() even in mainline
    kernel, fix me if I'm wrong.
  patch#5: cpufreq: get rid of get_online_cpus()/put_online_cpus
    IMHO, it's about lockdep false positive, but it's a little
    annoying. Maybe there is other way to fix it up.
    And the side effect is we introduce more latency than before
    though it's rare path.

More details in eatch patch :)

Thanks,
Yong

---
Yong Zhang (5):
  hotplug: sync_unplug: No '\n' in task name
  hotplug: Call cpu_unplug_begin() a little early
  printk: don't call printk_tick in printk_needs_cpu()
  workqueue: hotplug fix
  cpufreq: get rid of get_online_cpus()/put_online_cpus

 drivers/cpufreq/cpufreq.c |   20 +++++++-------------
 kernel/cpu.c              |   18 ++++++++----------
 kernel/printk.c           |    4 ++--
 kernel/workqueue.c        |   12 ++++++++----
 4 files changed, 25 insertions(+), 29 deletions(-)


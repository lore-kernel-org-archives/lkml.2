Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab0JUBI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 21:08:59 -0400
Received: from home.kolivas.org ([59.167.196.135]:34080 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab0JUBI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 21:08:58 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.36-ck1
Date: Thu, 21 Oct 2010 12:08:54 +1100
User-Agent: KMail/1.13.5 (Linux/2.6.36-ck1; KDE/4.4.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010211208.54401.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are patches designed to improve system responsiveness and interactivity 
with specific emphasis on the desktop, but suitable to any workload.


Apply to 2.6.36:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.36/2.6.36-ck1/patch-2.6.36-ck1.bz2

Broken out tarball:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.36/2.6.36-ck1/2.6.36-ck1-broken-out.tar.bz2

Discrete patches:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.36/2.6.36-ck1/patches/

All -ck patches:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/


Web:
http://kernel.kolivas.org

Code blog when I feel like it:
http://ck-hack.blogspot.com/

Each discrete patch contains a brief description of what it does at the top of 
the patch itself.


The most significant change is an updated BFS cpu scheduler to BFS 357 (Magnum).
It should pretty much behave like the older one, but is tighter with respect
to keeping to its deadlines, and will continue to behave fairly when load is
more than 8 * number of CPUs.

The other addition is to decrease the default dirty_ratio.

The rest is a resync only since 2.6.35-ck1.


Patch series:
2.6.36-sched-bfs-357.patch
sched-add-above-background-load-function.patch
mm-make_swappiness_really_mean_it.patch
mm-zero_swappiness.patch
mm-enable_swaptoken_only_when_swap_full.patch
mm-drop_swap_cache_aggressively.patch
mm-kswapd_inherit_prio-1.patch
mm-background_scan.patch
mm-idleprio_prio-1.patch
mm-lru_cache_add_lru_tail.patch
mm-decrease_default_dirty_ratio.patch
kconfig-expose_vmsplit_option.patch
hz-default_1000.patch
hz-no_default_250.patch
hz-raise_max.patch
preempt-desktop-tune.patch
cpufreq-bfs_tweaks.patch
ck1-version.patch


Those following the development of the patches for interactivity at massive
load, I have COMPLETELY DROPPED them as they introduce regressions at normal
workloads, and I cannot under any circumstances approve changes to improve
behaviour at ridiculous workloads which affect regular ones. I still see
precisely zero point at optimising for absurd workloads. Proving how many
un-niced jobs you can throw at your kernel compiles is not a measure of one's
prowess. It is just a mindless test. 


Enjoy!
-- 
-ck

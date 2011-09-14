Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137Ab1INUFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 16:05:40 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:5375 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932920Ab1INUFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 16:05:39 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: xemul@parallels.com, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, mingo@elte.hu, a.p.zijlstra@chello.nl,
        jbottomley@parallels.com
Subject: [PATCH 0/9] Per-cgroup /proc/stat
Date: Wed, 14 Sep 2011 17:04:46 -0300
Message-Id: <1316030695-19826-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[[ For those getting this twice: I sent it previously to containers
   ml, but I guess it was out. Sending now to a broader audience anyway ]]

Hi,

This patchset is a simple initial proposal for a per-cgroup/container
display of /proc/stat. The display method is based on Daniel's idea of
exposing a file that can be bind mounted (Daniel, is that more or less
what you had in mind?)

To grab the stats themselves, I am (ab)using cpuacct cgroup. percpu counters
are dropped in favor of normal percpu pointers, so we can easily track
per-cpu quantities.

In case you guys like this idea, my TODO list would include the removal
of the show stat code in fs/proc/stat.c altogether, and the displaying
of some fields I haven't touched yet.

Also, to demonstrate one of the potential ideas for such method, I
implemented a feature comonly found in hypervisors - steal time - on top
of it. I arguee that containers can/should also display steal time when
available. Turns out that due to the fact that we run on the same kernel,
steal time is quite easy to implement once we have per-container tick
accounting in place.

Please let me know what you guys think

Glauber Costa (9):
  Remove parent field in cpuacct cgroup
  Make cpuacct fields per cpu variables
  Include nice values in cpuacct
  Include irq and softirq fields in cpuacct
  Include guest fields in cpuacct
  Include idle and iowait fields in cpuacct
  Create cpuacct.proc.stat file
  per-cgroup boot time
  Report steal time for cgroup

 kernel/sched.c |  265 +++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 234 insertions(+), 31 deletions(-)

-- 
1.7.6


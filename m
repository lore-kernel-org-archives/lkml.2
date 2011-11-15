Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab1KOQAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 11:00:42 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:36862 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756720Ab1KOQAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 11:00:40 -0500
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com, pjt@google.com,
        cgroups@vger.kernel.org
Subject: [PATCH 0/4] Provide cpuacct functionality in cpu cgroup
Date: Tue, 15 Nov 2011 13:59:13 -0200
Message-Id: <1321372757-1581-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is an excerpt of the last patches I sent regarding cpu cgroup.
It is mostly focused on cleaning up what we have now, so it can
be considered largely preparation. As a user of the new organization
of things, I am including cpuacct stats functionality in the end of
the series. The files related to cpuusage are left to be sent in
an upcoming series after this one is included.

Let me know if there is anything you'd like me to address.

Glauber Costa (4):
  Change cpustat fields to an array.
  split kernel stat in two
  Keep scheduler statistics per cgroup
  provide a version of cpuacct statistics inside cpu cgroup

 arch/s390/appldata/appldata_os.c       |   18 ++-
 arch/x86/include/asm/i387.h            |    2 +-
 drivers/cpufreq/cpufreq_conservative.c |   33 +++--
 drivers/cpufreq/cpufreq_ondemand.c     |   33 +++--
 drivers/macintosh/rack-meter.c         |    8 +-
 fs/proc/stat.c                         |   67 +++++-----
 fs/proc/uptime.c                       |    9 +-
 include/linux/kernel_stat.h            |   54 ++++++--
 kernel/sched.c                         |  228 +++++++++++++++++++++++++-------
 9 files changed, 315 insertions(+), 137 deletions(-)

-- 
1.7.6.4


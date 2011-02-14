Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab1BNNGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 08:06:34 -0500
Received: from shutemov.name ([188.40.19.243]:55988 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631Ab1BNNGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 08:06:31 -0500
From: "Kirill A. Shutsemov" <kirill@shutemov.name>
To: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH, v6 0/3] Introduce timer slack controller
Date: Mon, 14 Feb 2011 15:06:24 +0200
Message-Id: <1297688787-3592-1-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill A. Shutemov <kirill@shutemov.name>


Changelog:

v6:
 - add documentation
 - use notifier_call_chain() instead of check hook
 - fix validate_change()
 - cleanup
v5:
 - -EBUSY on writing to timer_slack.min_slack_ns/max_slack_ns if a child has
   wider min-max range
v4:
 - hierarchy support
 - drop dummy_timer_slack_check()
 - workaround lockdep false (?) positive
 - allow 0 as timer slack value
v3:
 - rework interface
 - s/EXPORT_SYMBOL/EXPORT_SYMBOL_GPL/
v2:
 - fixed with CONFIG_CGROUP_TIMER_SLACK=y
v1:
 - initial revision

Kirill A. Shutemov (3):
  cgroups: export cgroup_iter_{start,next,end}
  Implement timer slack notifier chain
  cgroups: introduce timer slack controller

 Documentation/cgroups/timer_slack.txt |   93 +++++++++++
 include/linux/cgroup_subsys.h         |    6 +
 include/linux/sched.h                 |    5 +
 init/Kconfig                          |   10 ++
 kernel/Makefile                       |    3 +-
 kernel/cgroup.c                       |    3 +
 kernel/cgroup_timer_slack.c           |  285 +++++++++++++++++++++++++++++++++
 kernel/sys.c                          |    9 +-
 kernel/timer_slack.c                  |   57 +++++++
 9 files changed, 463 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/cgroups/timer_slack.txt
 create mode 100644 kernel/cgroup_timer_slack.c
 create mode 100644 kernel/timer_slack.c

-- 
1.7.4


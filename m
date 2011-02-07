Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab1BGJqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 04:46:09 -0500
Received: from shutemov.name ([188.40.19.243]:38377 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab1BGJqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 04:46:06 -0500
From: "Kirill A. Shutsemov" <kirill@shutemov.name>
To: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH, v5 0/2] Timer slack cgroup subsystem
Date: Mon,  7 Feb 2011 11:46:00 +0200
Message-Id: <1297071962-11654-1-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill A. Shutemov <kirill@shutemov.name>

Changelog:
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

Kirill A. Shutemov (2):
  cgroups: export cgroup_iter_{start,next,end}
  cgroups: introduce timer slack subsystem

 include/linux/cgroup_subsys.h |    6 +
 include/linux/init_task.h     |    4 +-
 init/Kconfig                  |   10 ++
 kernel/Makefile               |    1 +
 kernel/cgroup.c               |    3 +
 kernel/cgroup_timer_slack.c   |  281 +++++++++++++++++++++++++++++++++++++++++
 kernel/sys.c                  |   19 ++-
 7 files changed, 317 insertions(+), 7 deletions(-)
 create mode 100644 kernel/cgroup_timer_slack.c

-- 
1.7.4


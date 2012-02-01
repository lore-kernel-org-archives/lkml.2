Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab2BADiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 22:38:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60762 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab2BADh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 22:37:58 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Paul Menage <paul@paulmenage.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Tim Hockin <thockin@hockin.org>,
        Containers <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@gmail.com>, Cgroups <cgroups@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Max Kellermann <mk@cm4all.com>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: [PATCH 00/10] cgroups: Task counter subsystem v8
Date: Wed,  1 Feb 2012 04:37:40 +0100
Message-Id: <1328067470-5980-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Changes In this version:

- Split 32/64 bits version of res_counter_write_u64() [1/10]
  Courtesy of Kirill A. Shutemov

- Added Kirill's ack [8/10]

- Added selftests [9/10], [10/10]

Please consider for merging. At least two users want this feature:
https://lkml.org/lkml/2011/12/13/309
https://lkml.org/lkml/2011/12/13/364

More general details provided in the last version posting:
https://lkml.org/lkml/2012/1/13/230

Thanks!


Frederic Weisbecker (9):
  cgroups: add res_counter_write_u64() API
  cgroups: new resource counter inheritance API
  cgroups: ability to stop res charge propagation on bounded ancestor
  res_counter: allow charge failure pointer to be null
  cgroups: pull up res counter charge failure interpretation to caller
  cgroups: allow subsystems to cancel a fork
  cgroups: Add a task counter subsystem
  selftests: Enter each directories before executing selftests
  selftests: Add a new task counter selftest

Kirill A. Shutemov (1):
  cgroups: add res counter common ancestor searching

 Documentation/cgroups/resource_counter.txt         |   20 ++-
 Documentation/cgroups/task_counter.txt             |  153 +++++++++++
 include/linux/cgroup.h                             |   20 +-
 include/linux/cgroup_subsys.h                      |    5 +
 include/linux/res_counter.h                        |   27 ++-
 init/Kconfig                                       |    9 +
 kernel/Makefile                                    |    1 +
 kernel/cgroup.c                                    |   23 ++-
 kernel/cgroup_freezer.c                            |    6 +-
 kernel/cgroup_task_counter.c                       |  272 ++++++++++++++++++++
 kernel/exit.c                                      |    2 +-
 kernel/fork.c                                      |    7 +-
 kernel/res_counter.c                               |  103 +++++++-
 tools/testing/selftests/Makefile                   |    2 +-
 tools/testing/selftests/run_tests                  |    6 +-
 tools/testing/selftests/task_counter/Makefile      |    8 +
 tools/testing/selftests/task_counter/fork.c        |   40 +++
 tools/testing/selftests/task_counter/forkbomb.c    |   40 +++
 tools/testing/selftests/task_counter/multithread.c |   68 +++++
 tools/testing/selftests/task_counter/run_test      |  198 ++++++++++++++
 .../selftests/task_counter/spread_thread_group.c   |   82 ++++++
 21 files changed, 1056 insertions(+), 36 deletions(-)
 create mode 100644 Documentation/cgroups/task_counter.txt
 create mode 100644 kernel/cgroup_task_counter.c
 create mode 100644 tools/testing/selftests/task_counter/Makefile
 create mode 100644 tools/testing/selftests/task_counter/fork.c
 create mode 100644 tools/testing/selftests/task_counter/forkbomb.c
 create mode 100644 tools/testing/selftests/task_counter/multithread.c
 create mode 100755 tools/testing/selftests/task_counter/run_test
 create mode 100644 tools/testing/selftests/task_counter/spread_thread_group.c

-- 
1.7.5.4


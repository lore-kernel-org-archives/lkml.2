Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab1FSXvY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 19:51:24 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55794 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab1FSXvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 19:51:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=d3v8v9MAZrURWCNE2VuDaWKKtufbf+4dLEyl08+74T5HpKM6WoanFAqrX9RZWzm8rX
         XwVXGUuVc+p85blOgm0U+hwGp1hv9eHsiu+bKk44LUEJe7uRqFBv9tttf78wTviMPERc
         TUVfQRm6Lqyhl/MDYNaL/4DT6vf6y9rKosbY4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH 0/4] cgroups: Start a basic rlimit subsystem
Date: Mon, 20 Jun 2011 01:51:10 +0200
Message-Id: <1308527474-20704-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This starts a basic rlimit cgroup subsystem with only the
equivalent of RLIMIT_NPROC yet. This can be useful to limit
the global effects of a local fork bomb for example (local
in term of a cgroup).

The thing is further expandable to host more general resource
limitations in the scope of a cgroup.

Frederic Weisbecker (4):
  cgroups: Allow a cgroup subsys to reject a fork
  cgroups: Add res_counter_write_u64() API
  cgroups: New resource counter inheritance API
  cgroups: Add an rlimit subsystem

 include/linux/cgroup.h        |    9 ++-
 include/linux/cgroup_subsys.h |    8 ++
 include/linux/res_counter.h   |    4 +
 init/Kconfig                  |    6 ++
 kernel/Makefile               |    1 +
 kernel/cgroup.c               |   13 +++-
 kernel/cgroup_freezer.c       |    6 +-
 kernel/cgroup_rlim.c          |  142 +++++++++++++++++++++++++++++++++++++++++
 kernel/fork.c                 |    5 +-
 kernel/res_counter.c          |   46 ++++++++++++--
 10 files changed, 225 insertions(+), 15 deletions(-)
 create mode 100644 kernel/cgroup_rlim.c

-- 
1.7.5.4


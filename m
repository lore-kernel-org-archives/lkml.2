Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab1FVGgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 02:36:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab1FVGgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 02:36:08 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
        WANG Cong <amwang@redhat.com>
Subject: [PATCH 0/5] notifiers: split notifier.h into subsystem headers
Date: Wed, 22 Jun 2011 14:35:17 +0800
Message-Id: <1308724522-32461-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we define all kinds of notifiers in notifier.h, this is not
necessary at all, since different subsystems use different
notifiers, they are almost non-related with each other.

This can also save much build time. Suppose I add a new netdevice
event, really I don't have to recompile all the source, just network
related. Without this patch, all the source will be recompiled.

I move the notify events near to their subsystem notifier registers,
so that they can be found more easily.

In case of conflicts, I hope Andrew Morton would take the whole
patchset, rather than different subsystem maintainers take their own.

Signed-off-by: WANG Cong <amwang@redhat.com>

---
 drivers/mmc/core/core.c   |    3 ++
 include/linux/cpu.h       |   33 ++++++++++++++++++
 include/linux/netdevice.h |   36 ++++++++++++++++++--
 include/linux/notifier.h  |   82 +++-----------------------------------------
 include/linux/reboot.h    |    5 +++
 include/linux/suspend.h   |    8 ++++
 include/linux/vt.h        |    7 ++++
 kernel/notifier.c         |   31 -----------------
 kernel/sys.c              |   32 +++++++++++++++++-
 net/rds/page.c            |    1 +
 10 files changed, 127 insertions(+), 111 deletions(-)

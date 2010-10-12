Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935Ab0JLPxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:53:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:40359 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932776Ab0JLPxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 11:53:02 -0400
Date: Tue, 12 Oct 2010 15:52:44 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        benh@kernel.crashing.org, peterz@infradead.org, tglx@linutronix.de,
        hch@infradead.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, peterz@infradead.org, tglx@linutronix.de,
        hch@infradead.org
In-Reply-To: <20100907125057.086367802@linutronix.de>
References: <20100907125057.086367802@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] drivers/macintosh/adb: Do not claim that the semaphore is a mutex
Message-ID: <tip-8192b1f6b1a46b33213b993471356495a93ffc70@git.kernel.org>
Git-Commit-ID: 8192b1f6b1a46b33213b993471356495a93ffc70
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Oct 2010 15:52:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8192b1f6b1a46b33213b993471356495a93ffc70
Gitweb:     http://git.kernel.org/tip/8192b1f6b1a46b33213b993471356495a93ffc70
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 7 Sep 2010 14:33:40 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 12 Oct 2010 17:36:10 +0200

drivers/macintosh/adb: Do not claim that the semaphore is a mutex

User DEFINE_SEMAPHORE() instead of DECLARE_MUTEX()

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
LKML-Reference: <20100907125057.086367802@linutronix.de>

---
 drivers/macintosh/adb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/macintosh/adb.c b/drivers/macintosh/adb.c
index 1c4ee6e..bf64e49 100644
--- a/drivers/macintosh/adb.c
+++ b/drivers/macintosh/adb.c
@@ -83,7 +83,7 @@ static struct adb_driver *adb_controller;
 BLOCKING_NOTIFIER_HEAD(adb_client_list);
 static int adb_got_sleep;
 static int adb_inited;
-static DECLARE_MUTEX(adb_probe_mutex);
+static DEFINE_SEMAPHORE(adb_probe_mutex);
 static int sleepy_trackpad;
 static int autopoll_devs;
 int __adb_probe_sync;

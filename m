Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab2DPHCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 03:02:07 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41775 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab2DPHCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 03:02:04 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de
Subject: [PATCH 0/2 -rt] make locckdep selftest work on -rt
Date: Mon, 16 Apr 2012 15:01:54 +0800
Message-Id: <1334559716-18447-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On -rt,
1) There is no softirq context any more;
2) rwlock can not be used in harirq context;

Wrt that, convert spinlock to raw spinlock to make spinlock+hardirq
work, and discard the test for rwlock+hardirq and softirq.

BTW, I think patch#1 can go to upstream.

Thanks,
Yong

---
Yong Zhang (2):
  lockdep: selftest: convert spinlock to raw spinlock
  lockdep: selftest: Only do hardirq context test for raw spinlock

 lib/locking-selftest.c |   57 +++++++++++++++++++++++++++++++++--------------
 1 files changed, 40 insertions(+), 17 deletions(-)

-- 
1.7.5.4


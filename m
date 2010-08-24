Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab0HXHAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 03:00:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:42915 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab0HXHAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 03:00:05 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, akpm@linux-foundation.org, mingo@elte.hu,
        peterz@infradead.org, oleg@redhat.com
Subject: [RFC PATCH 0/3] timer: patchset focus on del_timer_sync()
Date: Tue, 24 Aug 2010 14:58:46 +0800
Message-Id: <1282633129-9187-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 24 Aug 2010 06:58:52.0573 (UTC) FILETIME=[CFAF8CD0:01CB4359]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

This is inspired by http://lkml.org/lkml/2010/8/16/291
which catch a lockdep false positive on fake_timer_lock.
When I go into del_timer_sync(), but don't find anything
which prevent del_timer_sync() from using in softirq context,
and indeed it's been used in softirq for some timer(such as
__dst_free()).

Thus, tell others it can't be used in softirq context, and
teach lockdep about that. It's realized by patch-0002.

Your comments are very appreciated.

Thanks,
Yong

---
Yong Zhang (3):
      timer: fix comments of try_to_del_timer_sync()
      timer: del_timer_sync() can be used in softirq context
      timer: warn when del_timer_sync() used in hardirq context

 kernel/timer.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)


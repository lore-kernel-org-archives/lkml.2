Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab0HYNqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 09:46:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35554 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab0HYNqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 09:46:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=kys4ARVvH2br3aVWyT0lj/rE51PVoXPRMgW1wGGkHedxwqapdHN/GI7XXT4gH9gBlt
         3DRusopp7eY5wGrrJHon+kETG+Fmzjt8z9Cpp+57YT7K9ZGqO0od2yPDqvPxxg/0he3C
         v/hHtj7YbltHWJf8Lwh/EEPiK00mdq9A3jvJM=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, akpm@linux-foundation.org, mingo@elte.hu,
        oleg@redhat.com, peterz@infradead.org
Subject: [RFC V2 PATCH 0/3] timer: patchset focus on del_timer_sync()
Date: Wed, 25 Aug 2010 21:45:56 +0800
Message-Id: <1282743959-5427-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.0.4
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

V2 <- V1
  Update patch 0001, the new version make try_to_del_timer_sync()
  safe on both hardirq context and UP. Thanks Oleg.

---
Yong Zhang (3):
      timer: make try_to_del_timer_sync() safe on both hardirq context and UP
      timer: del_timer_sync() can be used in softirq context
      timer: warn when del_timer_sync() used in hardirq context

 include/linux/timer.h |    4 ++--
 kernel/timer.c        |   20 +++++++++-----------
 2 files changed, 11 insertions(+), 13 deletions(-)

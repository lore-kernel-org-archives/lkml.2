Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab1FINOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 09:14:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:39542 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757364Ab1FINOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:14:42 -0400
Message-Id: <20110609130647.937204592@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 09 Jun 2011 15:06:47 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, efault@gmx.de,
        Arne Jansen <lists@die-jansens.de>
Subject: [PATCH 0/3] printk: Remove lockdep_off() and wakeups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These three patches rework printk() to remove the lockdep_off() hackery and
remove the need for printk() to do wakeups, which should make it much more
reliable in various contexts.

The first patch is already in -tip, the others are not. Ingo reported some
problems with #2, but I've been unable to reproduce so far.

The third patch has the semaphore trickery in and keeps it private to printk.c
as per Thomas' request.

A kernel with all three applied and lockdep enabled seems to have no problem
booting.



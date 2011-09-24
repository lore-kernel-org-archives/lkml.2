Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab1IXRaa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 13:30:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48729 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab1IXRa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 13:30:29 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 0/3] ipc/sem.c: multiple fixes
Date: Sat, 24 Sep 2011 19:36:46 +0200
Message-Id: <1316885806-11934-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The wakeup scheme used by semtimedop() does not work as intended on -rt.
The following series:
- fixes one bug that I noticed while thinking about a -rt compatible
  implementation
- prevents the code from returning to user space due to spurious wakeups.
  (noticed by Peter Zijlstra)
- contains a proposal how to support -rt.

Especially the last patch is for discussion - I don't like the overhead
introduced by using a completion.

What do you think?

--
	Manfred

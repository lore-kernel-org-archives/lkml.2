Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab1FXW1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 18:27:35 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45888 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab1FXW1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 18:27:32 -0400
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, padovan@profusion.mobi, marcel@holtmann.org,
        a.p.zijlstra@chello.nl, akpm@linux-foundation.org
Subject: [RFC] Add mod_delayed_work()
Date: Fri, 24 Jun 2011 19:27:36 -0300
Message-Id: <1308954457-21487-1-git-send-email-padovan@profusion.mobi>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In the work to move Bluetooth RX processing to workqueues I faced some
issues when trying to move our timers to workqueue, including deadlocks.
We use mod_timer() a lot to reset timer's delay, but the alternative with
workqueues is

	cancel_delayed_work_sync(work);
	queue_delayed_work(wq, work, delay);

This is too much for a simple change in the delay, so I did some research on
this and found that other pieces[0] in the kernel may have the same needs and
cooked a patch to create mod_delayed_work(). I used this name because we
basically call mod_timer there (or queue the work if it is not pending).

Then I propose replace the two lines above with:
	mod_delayed_work(wq, work, delay);

Please comment.

	Gustavo

[0] https://lkml.org/lkml/2011/2/3/175	

Gustavo F. Padovan (1):
  workqueue: Add mod_delayed_work()

 include/linux/workqueue.h |    2 ++
 kernel/workqueue.c        |   26 ++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

-- 
1.7.5.1


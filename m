Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1K2DEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 22:04:11 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48835 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab1K2DEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 22:04:10 -0500
From: Shan Hai <haishan.bai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, tglx@linutronix.de
Subject: [PATCH 0/1] sched/rt: code cleanup, remove a redundant function call
Date: Tue, 29 Nov 2011 11:03:55 +0800
Message-Id: <1322535836-13590-1-git-send-email-haishan.bai@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Calls the sched_rt_runtime twice in the sched_rt_runtime_exceeded, and the
second time call is not necessary, because the value of the rt_runtime was
alreay read and rt_runtimer itself was protected by the rt_runtime_lock.

---
 kernel/sched_rt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


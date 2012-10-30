Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909Ab2J3PfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:35:09 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:53506 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab2J3PfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:35:07 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 0/2] irq_work: A couple fixes
Date: Tue, 30 Oct 2012 16:34:59 +0100
Message-Id: <1351611301-3520-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The first patch is extracted from my printk patches, with changelog
reworked. The second patch is an addition.

And I still wonder if cpu_relax() is enough to prevent the compiler
from correctly reloading work->flags in irq_work_sync() loop.
Do we need ACCESS_ONCE()?

Thanks.

Frederic Weisbecker (2):
  irq_work: Fix racy check on work pending flag
  irq_work: Fix racy IRQ_WORK_BUSY flag setting

 kernel/irq_work.c |   29 ++++++++++++++++++++++-------
 1 files changed, 22 insertions(+), 7 deletions(-)

-- 
1.7.5.4


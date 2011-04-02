Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab1DBTbJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 15:31:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:55773 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756426Ab1DBTbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 15:31:07 -0400
Date: Sat, 2 Apr 2011 19:30:56 GMT
From: tip-bot for Xiaotian Feng <dfeng@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, dfeng@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, dfeng@redhat.com
In-Reply-To: <1301744375-6812-1-git-send-email-dfeng@redhat.com>
References: <1301744375-6812-1-git-send-email-dfeng@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] genirq: Fix cpumask leak in __setup_irq()
Message-ID: <tip-4f5058c3b71ed5930bb2b478c4d5dbc799dd9ad1@git.kernel.org>
Git-Commit-ID: 4f5058c3b71ed5930bb2b478c4d5dbc799dd9ad1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 02 Apr 2011 19:30:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4f5058c3b71ed5930bb2b478c4d5dbc799dd9ad1
Gitweb:     http://git.kernel.org/tip/4f5058c3b71ed5930bb2b478c4d5dbc799dd9ad1
Author:     Xiaotian Feng <dfeng@redhat.com>
AuthorDate: Sat, 2 Apr 2011 19:39:35 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 2 Apr 2011 21:26:20 +0200

genirq: Fix cpumask leak in __setup_irq()

The allocated cpumask should be freed in __setup_irq().

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
LKML-Reference: <1301744375-6812-1-git-send-email-dfeng@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 12a80fd..07c1611 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1051,6 +1051,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	register_irq_proc(irq, desc);
 	new->dir = NULL;
 	register_handler_proc(irq, new);
+	free_cpumask_var(mask);
 
 	return 0;
 

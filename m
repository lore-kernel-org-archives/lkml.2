Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab1EZLTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 07:19:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:49138 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755670Ab1EZLTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 07:19:05 -0400
Date: Thu, 26 May 2011 11:18:57 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-def945eeb920b94e710574454043f080831aefe5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, travis@sgi.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, travis@sgi.com, tglx@linutronix.de
In-Reply-To: <4DDDE094.6050505@kernel.org>
References: <4DDDE094.6050505@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] irq: Remove smp_affinity_list when unregister irq proc
Git-Commit-ID: def945eeb920b94e710574454043f080831aefe5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 26 May 2011 11:18:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  def945eeb920b94e710574454043f080831aefe5
Gitweb:     http://git.kernel.org/tip/def945eeb920b94e710574454043f080831aefe5
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 25 May 2011 22:09:40 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 26 May 2011 13:15:28 +0200

irq: Remove smp_affinity_list when unregister irq proc

commit 4b06042(bitmap, irq: add smp_affinity_list interface to
/proc/irq) causes the following warning:

[  274.239500] WARNING: at fs/proc/generic.c:850 remove_proc_entry+0x24c/0x27a()
[  274.251761] remove_proc_entry: removing non-empty directory 'irq/184',
    	       leaking at least 'smp_affinity_list'

Remove the new file in the exit path.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Mike Travis <travis@sgi.com>
Link: http://lkml.kernel.org/r/4DDDE094.6050505@kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/proc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 64e3df6..4bd4faa 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -352,6 +352,7 @@ void unregister_irq_proc(unsigned int irq, struct irq_desc *desc)
 #ifdef CONFIG_SMP
 	remove_proc_entry("smp_affinity", desc->dir);
 	remove_proc_entry("affinity_hint", desc->dir);
+	remove_proc_entry("smp_affinity_list", desc->dir);
 	remove_proc_entry("node", desc->dir);
 #endif
 	remove_proc_entry("spurious", desc->dir);

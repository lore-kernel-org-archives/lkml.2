Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab1LULqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:46:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34044 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab1LULqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:46:52 -0500
Date: Wed, 21 Dec 2011 03:46:33 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-dcpi7164djsexmx6ya7lilrc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        asharma@fb.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, asharma@fb.com, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/fast] perf: Update the mmap control page on mmap()
Git-Commit-ID: 9a0f05cb36888550d1509d60aa55788615abea44
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 21 Dec 2011 03:46:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9a0f05cb36888550d1509d60aa55788615abea44
Gitweb:     http://git.kernel.org/tip/9a0f05cb36888550d1509d60aa55788615abea44
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 21 Nov 2011 15:13:29 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 21 Dec 2011 11:01:05 +0100

perf: Update the mmap control page on mmap()

Apparently we didn't update the mmap control page right after mmap(),
which leads to surprises when userspace wants to use it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Arun Sharma <asharma@fb.com>
Link: http://lkml.kernel.org/n/tip-dcpi7164djsexmx6ya7lilrc@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2f8f3f1..0ca1f64 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3534,6 +3534,8 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	event->mmap_user = get_current_user();
 	vma->vm_mm->pinned_vm += event->mmap_locked;
 
+	perf_event_update_userpage(event);
+
 unlock:
 	if (!ret)
 		atomic_inc(&event->mmap_count);

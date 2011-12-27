Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324Ab1L0Fqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 00:46:34 -0500
Received: from shutemov.name ([188.40.19.243]:37422 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab1L0Fq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 00:46:28 -0500
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: cgroups@vger.kernel.org
Cc: containers@lists.linux-foundation.org, Li Zefan <lizf@cn.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Paul Menage <paul@paulmenage.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH 2/2] cgroup: add sparse annotation to cgroup_iter_start() and cgroup_iter_end()
Date: Tue, 27 Dec 2011 07:46:26 +0200
Message-Id: <1324964786-19052-2-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.4.5
In-Reply-To: <1324964786-19052-1-git-send-email-kirill@shutemov.name>
References: <1324964786-19052-1-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill@shutemov.name>

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 kernel/cgroup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 98990dd..cbbc61d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2854,6 +2854,7 @@ static void cgroup_enable_task_cg_lists(void)
 }
 
 void cgroup_iter_start(struct cgroup *cgrp, struct cgroup_iter *it)
+	__acquires(css_set_lock)
 {
 	/*
 	 * The first time anyone tries to iterate across a cgroup,
@@ -2893,6 +2894,7 @@ struct task_struct *cgroup_iter_next(struct cgroup *cgrp,
 }
 
 void cgroup_iter_end(struct cgroup *cgrp, struct cgroup_iter *it)
+	__releases(css_set_lock)
 {
 	read_unlock(&css_set_lock);
 }
-- 
1.7.7.3


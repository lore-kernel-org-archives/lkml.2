Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab1LXFrB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 00:47:01 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53881 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab1LXFq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 00:46:58 -0500
From: hamo.by@gmail.com
To: avi@redhat.com, mtosatti@redhat.com
Cc: hamo.by@gmail.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: fix undeclared MAY_{READ,WRITE,ACCESS}
Date: Sat, 24 Dec 2011 13:46:35 +0800
Message-Id: <1324705595-4035-1-git-send-email-hamo.by@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yang Bai <hamo.by@gmail.com>

commit 08a95a511af91a2a6c42f2a8f13b99402a39e84b checks
device assignment permission but forgot to include the
definition of MAY_{READ,WRITE,ACCESS} in linux/fs.h
Include it and this fix the build error here:
http://buildbot.b1-systems.de/kvm/builders/i386/builds/401

Signed-off-by: Yang Bai <hamo.by@gmail.com>
---
 virt/kvm/assigned-dev.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index da9690e..1d9dad0 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/slab.h>
 #include <linux/namei.h>
+#include <linux/fs.h>
 #include "irq.h"
 
 static struct kvm_assigned_dev_kernel *kvm_find_assigned_dev(struct list_head *head,
-- 
1.7.7.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964793Ab2KHUYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 15:24:51 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45290 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab2KHUYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 15:24:48 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Russell King <linux@arm.linux.org.uk>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Medhurst <tixy@yxit.co.uk>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: kprobes: use BUG_ON where possible
Date: Thu,  8 Nov 2012 15:23:06 -0500
Message-Id: <1352406191-14303-4-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352406191-14303-1-git-send-email-sasha.levin@oracle.com>
References: <1352406191-14303-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just use BUG_ON() instead of constructions such as:

	if (...)
		BUG()

A simplified version of the semantic patch that makes this transformation
is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
@@
- if (e) BUG();
+ BUG_ON(e);
// </smpl>

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 arch/arm/kernel/kprobes-test.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/kernel/kprobes-test.c b/arch/arm/kernel/kprobes-test.c
index 1862d8f..0fb370d 100644
--- a/arch/arm/kernel/kprobes-test.c
+++ b/arch/arm/kernel/kprobes-test.c
@@ -1212,8 +1212,7 @@ static int register_test_probe(struct test_probe *probe)
 {
 	int ret;
 
-	if (probe->registered)
-		BUG();
+	BUG_ON(probe->registered);
 
 	ret = register_kprobe(&probe->kprobe);
 	if (ret >= 0) {
-- 
1.7.10.4


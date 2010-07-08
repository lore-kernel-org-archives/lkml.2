Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207Ab0GHAJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 20:09:37 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38698 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776Ab0GHAJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 20:09:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iDBwtEa1+MuTxl58CN1GyqjuVuqCh87ir9V/dk/D5wao4LKavYMPkikUD2icVlACd5
         PIImExybqvNP17TwM4X34hrAsxZUTpd4HKan+5RK5wjq5Ack0Q5etR1uRAu7ng/+mVmX
         Z9dcTeWXE+LwKcBtbuycpAmDpQTYDv055bSj0=
From: Kevin Winchester <kjwinchester@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Mark do_one_initcall* as __init_or_module
Date: Wed,  7 Jul 2010 21:09:11 -0300
Message-Id: <1278547751-2237-2-git-send-email-kjwinchester@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100707152640.586442f3.akpm@linux-foundation.org>
References: <20100707152640.586442f3.akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton suggested that the do_one_initcall and
do_one_initcall_debug functions can be marked __init_or_module
such that they can be discarded for the CONFIG_MODULES=N case.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
---
 init/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index 828ffac..f466d04 100644
--- a/init/main.c
+++ b/init/main.c
@@ -724,7 +724,7 @@ core_param(initcall_debug, initcall_debug, bool, 0644);
 
 static char msgbuf[64];
 
-static int do_one_initcall_debug(initcall_t fn)
+static int __init_or_module do_one_initcall_debug(initcall_t fn)
 {
 	ktime_t calltime, delta, rettime;
 	unsigned long long duration;
@@ -742,7 +742,7 @@ static int do_one_initcall_debug(initcall_t fn)
 	return ret;
 }
 
-int do_one_initcall(initcall_t fn)
+int __init_or_module do_one_initcall(initcall_t fn)
 {
 	int count = preempt_count();
 	int ret;
-- 
1.7.1


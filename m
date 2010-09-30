Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab0I3J3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 05:29:19 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:55969 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793Ab0I3J3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 05:29:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QbQuvxzZ7BCuNM/dzQu+LXQiXb4ka70M94q+tDxl5E1zN1hmgQBFoZaHotVVdHE5cr
         +0iP4Hf+gEmGkn98fyAx1EhDZRa2is9Fk+ulNtefL/gAT2yDZevszhdHX5TeWqht08sT
         mNepJf5eKKLjw8xHd96Az/3yNwni4lxim933M=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
        Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>
Subject: [PATCH RESEND v3 17/24] ptrace: cleanup arch_ptrace() on parisc
Date: Thu, 30 Sep 2010 18:27:52 +0900
Message-Id: <1285838880-4977-18-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
References: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing __user markup on the argument of put_user().

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
---
 arch/parisc/kernel/ptrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/parisc/kernel/ptrace.c b/arch/parisc/kernel/ptrace.c
index 03920db..2905b1f 100644
--- a/arch/parisc/kernel/ptrace.c
+++ b/arch/parisc/kernel/ptrace.c
@@ -125,7 +125,7 @@ long arch_ptrace(struct task_struct *child, long request,
 		     addr >= sizeof(struct pt_regs))
 			break;
 		tmp = *(unsigned long *) ((char *) task_regs(child) + addr);
-		ret = put_user(tmp, (unsigned long *) data);
+		ret = put_user(tmp, (unsigned long __user *) data);
 		break;
 
 	/* Write the word at location addr in the USER area.  This will need
-- 
1.7.2.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab1CROkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 10:40:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43896 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab1CROkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 10:40:13 -0400
From: Bill Gatliff <bgat@billgatliff.com>
To: linux-kernel@vger.kernel.org, hunold@linuxtv.org
Cc: Bill Gatliff <bgat@billgatliff.com>
Subject: [PATCH] kobject: export kobject_set_name_vargs
Date: Fri, 18 Mar 2011 09:39:49 -0500
Message-Id: <1300459189-32573-1-git-send-email-bgat@billgatliff.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applies EXPORT_SYMBOL to kobject_set_name_vargs().  As the function
itself is not marked static, it appears as though the function was
intended to be exported.

Among possibly others, the upcoming Generic PWM API code uses
kobject_set_name_vargs().  This function must be exported if users
wish to call it from kernel modules.

Signed-off-by: Bill Gatliff <bgat@billgatliff.com>
---
 lib/kobject.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 82dc34c..43f5b09 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -232,6 +232,7 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
 	kfree(old_name);
 	return 0;
 }
+EXPORT_SYMBOL(kobject_set_name_vargs);
 
 /**
  * kobject_set_name - Set the name of a kobject
-- 
1.7.2.3


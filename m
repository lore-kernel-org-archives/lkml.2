Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760358Ab2CNXCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:02:42 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:34736 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964793Ab2CNXCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:02:36 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 05/11] params: add param-name to parse_one's pr_debug()
Date: Wed, 14 Mar 2012 17:02:00 -0600
Message-Id: <1331766126-11674-6-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.8.1
In-Reply-To: <1331766126-11674-1-git-send-email-jim.cromie@gmail.com>
References: <1331766126-11674-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Current message doesnt identify the param being handled, add it.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 kernel/params.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index f37d826..10eb451 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -104,8 +104,8 @@ static int parse_one(char *param,
 			if (!val && params[i].ops->set != param_set_bool
 			    && params[i].ops->set != param_set_bint)
 				return -EINVAL;
-			pr_debug("They are equal!  Calling %p\n",
-			       params[i].ops->set);
+			pr_debug("handling %s with %p\n", param,
+				params[i].ops->set);
 			mutex_lock(&param_lock);
 			err = params[i].ops->set(val, &params[i]);
 			mutex_unlock(&param_lock);
-- 
1.7.7.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab2BACah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 21:30:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755696Ab2BACag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 21:30:36 -0500
Date: Wed, 1 Feb 2012 10:33:11 +0800
From: Dave Young <dyoung@redhat.com>
To: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] make module param bint handle nul value
Message-ID: <20120201023311.GA9716@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow bint param accept nul values, just do same as bool param.

Signed-off-by: Dave Young <dyoung@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/params.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.orig/kernel/params.c	2012-01-28 16:54:57.000000000 +0800
+++ linux-2.6/kernel/params.c	2012-01-31 16:16:18.723368198 +0800
@@ -97,7 +97,8 @@ static int parse_one(char *param,
 	for (i = 0; i < num_params; i++) {
 		if (parameq(param, params[i].name)) {
 			/* No one handled NULL, so do it here. */
-			if (!val && params[i].ops->set != param_set_bool)
+			if (!val && params[i].ops->set != param_set_bool
+			    && params[i].ops->set != param_set_bint)
 				return -EINVAL;
 			pr_debug("They are equal!  Calling %p\n",
 			       params[i].ops->set);

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550Ab1JFNjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 09:39:07 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34188 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758362Ab1JFNiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 09:38:10 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 11/15] drbd: Convert boolean flags on netlink from NLA_FLAG to NLA_U8
Date: Thu,  6 Oct 2011 15:37:56 +0200
Message-Id: <1317908280-28951-12-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317908280-28951-1-git-send-email-philipp.reisner@linbit.com>
References: <1317908280-28951-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Flags of type NLA_FLAG are either present or absent, but do not have a
value by themselves.  Use type NLA_U8 for our boolean flags instead, and
use the value to determine if the flag should be on or off.

On the drbdsetup command line, all those flags have an optional yes/no
argument which defaults to yes.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 include/linux/genl_magic_struct.h |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/include/linux/genl_magic_struct.h b/include/linux/genl_magic_struct.h
index ddbdd0a..b1ddbb5 100644
--- a/include/linux/genl_magic_struct.h
+++ b/include/linux/genl_magic_struct.h
@@ -86,8 +86,8 @@ enum {
 
 /* possible field types */
 #define __flg_field(attr_nr, attr_flag, name) \
-	__field(attr_nr, attr_flag, name, NLA_FLAG, char, \
-			nla_get_flag, __nla_put_flag)
+	__field(attr_nr, attr_flag, name, NLA_U8, char, \
+			nla_get_u8, NLA_PUT_U8)
 #define __u8_field(attr_nr, attr_flag, name)	\
 	__field(attr_nr, attr_flag, name, NLA_U8, unsigned char, \
 			nla_get_u8, NLA_PUT_U8)
@@ -118,12 +118,6 @@ enum {
 #define __str_field_def(attr_nr, attr_flag, name, maxlen) \
 	__str_field(attr_nr, attr_flag, name, maxlen)
 
-#define __nla_put_flag(skb, attrtype, value)		\
-	do {						\
-		if (value)				\
-			NLA_PUT_FLAG(skb, attrtype);	\
-	} while (0)
-
 #define GENL_op_init(args...)	args
 #define GENL_doit(handler)		\
 	.doit = handler,		\
-- 
1.7.4.1


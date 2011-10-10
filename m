Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab1JJLzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 07:55:55 -0400
Received: from mail09.linbit.com ([212.69.161.110]:45064 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab1JJLzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 07:55:15 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 11/13] drbd: drbd_nla_check_mandatory(): Need to remove the DRBD_GENLA_F_MANDATORY flag first
Date: Mon, 10 Oct 2011 13:55:04 +0200
Message-Id: <1318247706-7732-12-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318247706-7732-1-git-send-email-philipp.reisner@linbit.com>
References: <1318247706-7732-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

We need to remove the flag before checking for valid types.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 include/linux/genl_magic_func.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/genl_magic_func.h b/include/linux/genl_magic_func.h
index 99f4e95..2d38695 100644
--- a/include/linux/genl_magic_func.h
+++ b/include/linux/genl_magic_func.h
@@ -158,9 +158,9 @@ static inline int drbd_nla_check_mandatory(int maxtype, struct nlattr *nla)
 
 	nla_for_each_attr(nla, head, len, rem) {
 		if (nla->nla_type & DRBD_GENLA_F_MANDATORY) {
+			nla->nla_type &= ~DRBD_GENLA_F_MANDATORY;
 			if (nla_type(nla) > maxtype)
 				return -EOPNOTSUPP;
-			nla->nla_type &= ~DRBD_GENLA_F_MANDATORY;
 		}
 	}
 	return 0;
-- 
1.7.4.1


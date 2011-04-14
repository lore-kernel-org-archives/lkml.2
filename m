Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964858Ab1DNSRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:17:47 -0400
Received: from mail.windriver.com ([147.11.1.11]:41786 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964865Ab1DNR6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:07 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 116/209] can-bcm: fix minor heap overflow
Date: Thu, 14 Apr 2011 13:54:34 -0400
Message-Id: <1302803767-9715-3-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 0597d1b99fcfc2c0eada09a698f85ed413d4ba84 upstream.

On 64-bit platforms the ASCII representation of a pointer may be up to 17
bytes long. This patch increases the length of the buffer accordingly.

http://marc.info/?l=linux-netdev&m=128872251418192&w=2

Reported-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/can/bcm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index e10ee05..b8f7a2f 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -125,7 +125,7 @@ struct bcm_sock {
 	struct list_head tx_ops;
 	unsigned long dropped_usr_msgs;
 	struct proc_dir_entry *bcm_proc_read;
-	char procname [9]; /* pointer printed in ASCII with \0 */
+	char procname [20]; /* pointer printed in ASCII with \0 */
 };
 
 static inline struct bcm_sock *bcm_sk(const struct sock *sk)
-- 
1.7.4.4


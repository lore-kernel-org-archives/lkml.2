Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447Ab1DNR6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:58:23 -0400
Received: from mail.windriver.com ([147.11.1.11]:41848 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964890Ab1DNR6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:10 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Nelson Elhage <nelhage@ksplice.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 148/209] econet: Do the correct cleanup after an unprivileged SIOCSIFADDR.
Date: Thu, 14 Apr 2011 13:55:06 -0400
Message-Id: <1302803767-9715-35-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nelson Elhage <nelhage@ksplice.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 0c62fc6dd02c8d793c75ae76a9b6881fc36388ad upstream

We need to drop the mutex and do a dev_put, so set an error code and break like
the other paths, instead of returning directly.

Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/econet/af_econet.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/econet/af_econet.c b/net/econet/af_econet.c
index 2e41c76..e40e6b0 100644
--- a/net/econet/af_econet.c
+++ b/net/econet/af_econet.c
@@ -661,8 +661,10 @@ static int ec_dev_ioctl(struct socket *sock, unsigned int cmd, void __user *arg)
 	err = 0;
 	switch (cmd) {
 	case SIOCSIFADDR:
-		if (!capable(CAP_NET_ADMIN))
-			return -EPERM;
+		if (!capable(CAP_NET_ADMIN)) {
+			err = -EPERM;
+			break;
+		}
 
 		edev = dev->ec_ptr;
 		if (edev == NULL) {
-- 
1.7.4.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933871Ab1DNSUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:20:31 -0400
Received: from mail.windriver.com ([147.11.1.11]:41453 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933579Ab1DNR5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:57:45 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Phil Blundell <philb@gnu.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 124/209] econet: fix CVE-2010-3850
Date: Thu, 14 Apr 2011 13:54:42 -0400
Message-Id: <1302803767-9715-11-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Phil Blundell <philb@gnu.org>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 16c41745c7b92a243d0874f534c1655196c64b74 upstream.

Add missing check for capable(CAP_NET_ADMIN) in SIOCSIFADDR operation.

Signed-off-by: Phil Blundell <philb@gnu.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/econet/af_econet.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/econet/af_econet.c b/net/econet/af_econet.c
index 8170acb..cd62e27 100644
--- a/net/econet/af_econet.c
+++ b/net/econet/af_econet.c
@@ -661,6 +661,9 @@ static int ec_dev_ioctl(struct socket *sock, unsigned int cmd, void __user *arg)
 	err = 0;
 	switch (cmd) {
 	case SIOCSIFADDR:
+		if (!capable(CAP_NET_ADMIN))
+			return -EPERM;
+
 		edev = dev->ec_ptr;
 		if (edev == NULL) {
 			/* Magic up a new one. */
-- 
1.7.4.4


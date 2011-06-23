Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933985Ab1FWRlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:41:11 -0400
Received: from mail.windriver.com ([147.11.1.11]:35834 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933923Ab1FWRjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:39:09 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Vasiliy Kulikov <segoon@openwall.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 239/247] Bluetooth: sco: fix information leak to userspace
Date: Thu, 23 Jun 2011 13:35:07 -0400
Message-Id: <1308850515-15242-180-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segoon@openwall.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit c4c896e1471aec3b004a693c689f60be3b17ac86 upstream.

struct sco_conninfo has one padding byte in the end.  Local variable
cinfo of type sco_conninfo is copied to userspace with this uninizialized
one byte, leading to old stack contents leak.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/bluetooth/sco.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index ca6b2ad..5fa81fa 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -704,6 +704,7 @@ static int sco_sock_getsockopt_old(struct socket *sock, int optname, char __user
 			break;
 		}
 
+		memset(&cinfo, 0, sizeof(cinfo));
 		cinfo.hci_handle = sco_pi(sk)->conn->hcon->handle;
 		memcpy(cinfo.dev_class, sco_pi(sk)->conn->hcon->dev_class, 3);
 
-- 
1.7.4.4


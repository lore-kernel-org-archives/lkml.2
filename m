Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab2HOUOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:14:31 -0400
Received: from mail.windriver.com ([147.11.1.11]:36949 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804Ab2HOTv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:51:26 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Filip Palian <s3810@pjwstk.edu.pl>,
        Filip Palian <filip.palian@pjwstk.edu.pl>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 102/165] Bluetooth: l2cap and rfcomm: fix 1 byte infoleak to userspace.
Date: Wed, 15 Aug 2012 15:47:26 -0400
Message-ID: <1345060109-9187-103-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Filip Palian <s3810@pjwstk.edu.pl>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 8d03e971cf403305217b8e62db3a2e5ad2d6263f upstream.

Structures "l2cap_conninfo" and "rfcomm_conninfo" have one padding
byte each. This byte in "cinfo" is copied to userspace uninitialized.

Signed-off-by: Filip Palian <filip.palian@pjwstk.edu.pl>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
[PG: l2cap_sock.c chunk is in l2cap.c in a 2.6.34 context/baseline]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/bluetooth/l2cap.c       | 1 +
 net/bluetooth/rfcomm/sock.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
index b21e319..0b6cf87 100644
--- a/net/bluetooth/l2cap.c
+++ b/net/bluetooth/l2cap.c
@@ -1898,6 +1898,7 @@ static int l2cap_sock_getsockopt_old(struct socket *sock, int optname, char __us
 			break;
 		}
 
+		memset(&cinfo, 0, sizeof(cinfo));
 		cinfo.hci_handle = l2cap_pi(sk)->conn->hcon->handle;
 		memcpy(cinfo.dev_class, l2cap_pi(sk)->conn->hcon->dev_class, 3);
 
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 8ed3c37..b045bbb 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -882,6 +882,7 @@ static int rfcomm_sock_getsockopt_old(struct socket *sock, int optname, char __u
 
 		l2cap_sk = rfcomm_pi(sk)->dlc->session->sock->sk;
 
+		memset(&cinfo, 0, sizeof(cinfo));
 		cinfo.hci_handle = l2cap_pi(l2cap_sk)->conn->hcon->handle;
 		memcpy(cinfo.dev_class, l2cap_pi(l2cap_sk)->conn->hcon->dev_class, 3);
 
-- 
1.7.12.rc2


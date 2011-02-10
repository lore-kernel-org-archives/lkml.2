Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab1BJR7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:59:52 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57478 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab1BJR7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:59:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=c/hmpqhy+vkFuWxb1HLjDm25GT233RrdpRUI0+6fPhCfavmrBFGLThprv+KRifWDBZ
         W4oCw+QrHlIqK+atVdKXgRCVfhvp9YbSjqJfmxzYYxyRmtSimOCS/Xa2xz2eOIEGS1vY
         oQ4seFm2lvVAl4I4E2g3YcCVXXO/XSS+pFfkM=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] bluetooth: l2cap: fix 1 byte infoleak to userspace
Date: Thu, 10 Feb 2011 20:59:42 +0300
Message-Id: <1297360783-21452-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure l2cap_options has one padding byte between max_tx and
txwin_size fields.  This byte in "opts" is copied to userspace
uninitialized.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 net/bluetooth/l2cap_sock.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index adf4169..21f5385 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -392,6 +392,7 @@ static int l2cap_sock_getsockopt_old(struct socket *sock, int optname, char __us
 
 	switch (optname) {
 	case L2CAP_OPTIONS:
+		memset(&opts, 0, sizeof(opts));
 		opts.imtu     = l2cap_pi(sk)->imtu;
 		opts.omtu     = l2cap_pi(sk)->omtu;
 		opts.flush_to = l2cap_pi(sk)->flush_to;
-- 
1.7.0.4


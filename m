Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab2BTC1H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 21:27:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58118 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab2BTC1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 21:27:04 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, davem@davemloft.net, hjl.tools@gmail.com,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: [PATCH 5/7] compat: Use COMPAT_USE_64BIT_TIME in the Bluetooth subsystem
Date: Sun, 19 Feb 2012 18:22:48 -0800
Message-Id: <1329704570-3792-6-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329704570-3792-1-git-send-email-hpa@zytor.com>
References: <CA+55aFwiV3N-9-pB6ofN-5GBS0mnPTBGAdPH1M70wK8qr-=PQg@mail.gmail.com>
 <1329704570-3792-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 18:26:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. J. Lu" <hjl.tools@gmail.com>

Enable the Bluetooth subsystem to be used with a compat ABI with
64-bit time.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo F. Padovan <padovan@profusion.mobi>
Cc: David S. Miller <davem@davemloft.net>
---
 net/bluetooth/hci_sock.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 0dcc962..b2eb2b9 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -418,7 +418,8 @@ static inline void hci_sock_cmsg(struct sock *sk, struct msghdr *msg, struct sk_
 		data = &tv;
 		len = sizeof(tv);
 #ifdef CONFIG_COMPAT
-		if (msg->msg_flags & MSG_CMSG_COMPAT) {
+		if (!COMPAT_USE_64BIT_TIME &&
+		    (msg->msg_flags & MSG_CMSG_COMPAT)) {
 			ctv.tv_sec = tv.tv_sec;
 			ctv.tv_usec = tv.tv_usec;
 			data = &ctv;
-- 
1.7.6.5


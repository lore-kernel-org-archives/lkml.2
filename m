Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033386Ab2I1V6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:58:42 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52836 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031636Ab2I1UWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:22:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mathias Krause <minipli@googlemail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 014/218] Bluetooth: RFCOMM - Fix info leak in getsockopt(BT_SECURITY)
Date: Fri, 28 Sep 2012 13:13:51 -0700
Message-Id: <20120928201502.934031099@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 9ad2de43f1aee7e7274a4e0d41465489299e344b ]

The RFCOMM code fails to initialize the key_size member of struct
bt_security before copying it to userland -- that for leaking one
byte kernel stack. Initialize key_size with 0 to avoid the info
leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/rfcomm/sock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -836,6 +836,7 @@ static int rfcomm_sock_getsockopt(struct
 		}
 
 		sec.level = rfcomm_pi(sk)->sec_level;
+		sec.key_size = 0;
 
 		len = min_t(unsigned int, len, sizeof(sec));
 		if (copy_to_user(optval, (char *) &sec, len))



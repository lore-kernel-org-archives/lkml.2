Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab1DYUeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:34:10 -0400
Received: from 1wt.eu ([62.212.114.60]:34559 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932430Ab1DYUZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:21 -0400
Message-Id: <20110425200238.815072368@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:46 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Vasiliy Kulikov <segoon@openwall.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 134/173] Bluetooth: bnep: fix buffer overflow
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segoon@openwall.com>

commit 43629f8f5ea32a998d06d1bb41eefa0e821ff573 upstream.

Struct ca is copied from userspace.  It is not checked whether the "device"
field is NULL terminated.  This potentially leads to BUG() inside of
alloc_netdev_mqs() and/or information leak by creating a device with a name
made of contents of kernel stack.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/bluetooth/bnep/sock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/bluetooth/bnep/sock.c
+++ b/net/bluetooth/bnep/sock.c
@@ -88,6 +88,7 @@ static int bnep_sock_ioctl(struct socket
 			sockfd_put(nsock);
 			return -EBADFD;
 		}
+		ca.device[sizeof(ca.device)-1] = 0;
 
 		err = bnep_add_connection(&ca, nsock);
 		if (!err) {



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab1DLOpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:45:46 -0400
Received: from kroah.org ([198.145.64.141]:57717 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932352Ab1DLOig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:36 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:56 2011
Message-Id: <20110412143555.968540899@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:35:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segoon@openwall.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: [075/105] Bluetooth: bnep: fix buffer overflow
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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



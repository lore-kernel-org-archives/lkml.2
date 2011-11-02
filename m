Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830Ab1KCBhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:37:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50858 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933766Ab1KCBhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:37:38 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:59 2011
Message-Id: <20111102221459.470825385@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:15:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Filip Palian <filip.palian@pjwstk.edu.pl>,
        Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: [102/107] Bluetooth: l2cap and rfcomm: fix 1 byte infoleak to userspace.
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Filip Palian <s3810@pjwstk.edu.pl>

commit 8d03e971cf403305217b8e62db3a2e5ad2d6263f upstream.

Structures "l2cap_conninfo" and "rfcomm_conninfo" have one padding
byte each. This byte in "cinfo" is copied to userspace uninitialized.

Signed-off-by: Filip Palian <filip.palian@pjwstk.edu.pl>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/bluetooth/l2cap.c       |    1 +
 net/bluetooth/rfcomm/sock.c |    1 +
 2 files changed, 2 insertions(+)

--- a/net/bluetooth/l2cap.c
+++ b/net/bluetooth/l2cap.c
@@ -1886,6 +1886,7 @@ static int l2cap_sock_getsockopt_old(str
 			break;
 		}
 
+		memset(&cinfo, 0, sizeof(cinfo));
 		cinfo.hci_handle = l2cap_pi(sk)->conn->hcon->handle;
 		memcpy(cinfo.dev_class, l2cap_pi(sk)->conn->hcon->dev_class, 3);
 
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -878,6 +878,7 @@ static int rfcomm_sock_getsockopt_old(st
 
 		l2cap_sk = rfcomm_pi(sk)->dlc->session->sock->sk;
 
+		memset(&cinfo, 0, sizeof(cinfo));
 		cinfo.hci_handle = l2cap_pi(l2cap_sk)->conn->hcon->handle;
 		memcpy(cinfo.dev_class, l2cap_pi(l2cap_sk)->conn->hcon->dev_class, 3);
 



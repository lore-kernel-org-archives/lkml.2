Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab1DLOqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:46:32 -0400
Received: from kroah.org ([198.145.64.141]:57677 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932343Ab1DLOie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:34 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:55 2011
Message-Id: <20110412143555.759650773@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:35:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segoon@openwall.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: [073/105] Bluetooth: sco: fix information leak to userspace
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segoon@openwall.com>

commit c4c896e1471aec3b004a693c689f60be3b17ac86 upstream.

struct sco_conninfo has one padding byte in the end.  Local variable
cinfo of type sco_conninfo is copied to userspace with this uninizialized
one byte, leading to old stack contents leak.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/bluetooth/sco.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -703,6 +703,7 @@ static int sco_sock_getsockopt_old(struc
 			break;
 		}
 
+		memset(&cinfo, 0, sizeof(cinfo));
 		cinfo.hci_handle = sco_pi(sk)->conn->hcon->handle;
 		memcpy(cinfo.dev_class, sco_pi(sk)->conn->hcon->dev_class, 3);
 



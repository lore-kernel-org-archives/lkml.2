Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760734Ab2J2UMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:12:42 -0400
Received: from mail.kernel.org ([198.145.19.201]:42798 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760698Ab2J2UJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:09:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Michael S. Tsirkin" <mst@redhat.com>, Alexander Graf <agraf@suse.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 26/34] vhost: fix mergeable bufs on BE hosts
Date: Mon, 29 Oct 2012 13:07:57 -0700
Message-Id: <20121029200423.461884979@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029200420.550338074@linuxfoundation.org>
References: <20121029200420.550338074@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

commit 910a578f7e9400a78a3b13aba0b4d2df16a2cb05 upstream.

We copy head count to a 16 bit field, this works by chance on LE but on
BE guest gets 0. Fix it up.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Alexander Graf <agraf@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vhost/net.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -305,7 +305,8 @@ static void handle_rx(struct vhost_net *
 		.hdr.gso_type = VIRTIO_NET_HDR_GSO_NONE
 	};
 	size_t total_len = 0;
-	int err, headcount, mergeable;
+	int err, mergeable;
+	s16 headcount;
 	size_t vhost_hlen, sock_hlen;
 	size_t vhost_len, sock_len;
 	/* TODO: check that we are running from vhost_worker? */



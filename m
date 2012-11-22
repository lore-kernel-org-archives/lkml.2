Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759Ab2KVVwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:52:31 -0500
Received: from mail.kernel.org ([198.145.19.201]:49621 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957Ab2KVSkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@dreamhost.com>
Subject: [ 061/171] ceph: osd_client: fix endianness bug in osd_req_encode_op()
Date: Wed, 21 Nov 2012 16:40:07 -0800
Message-Id: <20121122004039.498690039@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@dreawmhost.com>

(cherry picked from commit 065a68f9167e20f321a62d044cb2c3024393d455)

>From Al Viro <viro@zeniv.linux.org.uk>

Al Viro noticed that we were using a non-cpu-encoded value in
a switch statement in osd_req_encode_op().  The result would
clearly not work correctly on a big-endian machine.

Signed-off-by: Alex Elder <elder@dreamhost.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osd_client.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -278,7 +278,7 @@ static void osd_req_encode_op(struct cep
 {
 	dst->op = cpu_to_le16(src->op);
 
-	switch (dst->op) {
+	switch (src->op) {
 	case CEPH_OSD_OP_READ:
 	case CEPH_OSD_OP_WRITE:
 		dst->extent.offset =



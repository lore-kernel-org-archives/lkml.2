Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab2KVSkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:40:24 -0500
Received: from mail.kernel.org ([198.145.19.201]:49620 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862Ab2KVSkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 065/171] libceph: dont reset kvec in prepare_write_banner()
Date: Wed, 21 Nov 2012 16:40:11 -0800
Message-Id: <20121122004039.894277276@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

(cherry picked from commit d329156f16306449c273002486c28de3ddddfd89)

Move the kvec reset for a connection out of prepare_write_banner and
into its only caller.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -686,7 +686,6 @@ static int prepare_connect_authorizer(st
 static void prepare_write_banner(struct ceph_messenger *msgr,
 				 struct ceph_connection *con)
 {
-	ceph_con_out_kvec_reset(con);
 	ceph_con_out_kvec_add(con, strlen(CEPH_BANNER), CEPH_BANNER);
 	ceph_con_out_kvec_add(con, sizeof (msgr->my_enc_addr),
 					&msgr->my_enc_addr);
@@ -726,10 +725,9 @@ static int prepare_write_connect(struct
 	con->out_connect.protocol_version = cpu_to_le32(proto);
 	con->out_connect.flags = 0;
 
+	ceph_con_out_kvec_reset(con);
 	if (include_banner)
 		prepare_write_banner(msgr, con);
-	else
-		ceph_con_out_kvec_reset(con);
 	ceph_con_out_kvec_add(con, sizeof (con->out_connect), &con->out_connect);
 
 	con->out_more = 0;



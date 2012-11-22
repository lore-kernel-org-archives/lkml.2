Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818Ab2KVVcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:32:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:49646 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179Ab2KVSkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>
Subject: [ 154/171] libceph: clear all flags on con_close
Date: Wed, 21 Nov 2012 16:41:40 -0800
Message-Id: <20121122004048.805129442@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

Signed-off-by: Sage Weil <sage@inktank.com>
(cherry picked from commit 43c7427d100769451601b8a36988ac0528ce0124)
---
 net/ceph/messenger.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -528,6 +528,8 @@ void ceph_con_close(struct ceph_connecti
 	clear_bit(CON_FLAG_LOSSYTX, &con->flags); /* so we retry next connect */
 	clear_bit(CON_FLAG_KEEPALIVE_PENDING, &con->flags);
 	clear_bit(CON_FLAG_WRITE_PENDING, &con->flags);
+	clear_bit(CON_FLAG_KEEPALIVE_PENDING, &con->flags);
+	clear_bit(CON_FLAG_BACKOFF, &con->flags);
 
 	reset_connection(con);
 	con->peer_global_seq = 0;



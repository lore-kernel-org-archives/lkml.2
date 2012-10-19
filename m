Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965002Ab2JSDdE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:33:04 -0400
Received: from mail.kernel.org ([198.145.19.201]:51100 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755720Ab2JSCrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:47:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Christoph Hellwig <hch@lst.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 13/62] iscsit: remove incorrect unlock in iscsit_build_sendtargets_resp
Date: Thu, 18 Oct 2012 19:44:41 -0700
Message-Id: <20121019024258.089558529@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024255.944999470@linuxfoundation.org>
References: <20121019024255.944999470@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@infradead.org>

commit 904753da183566c71211d23c169a80184648c121 upstream.

Fix a potential multiple spin-unlock -> deadlock scenario during the
overflow check within iscsit_build_sendtargets_resp() as found by
sparse static checking.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3196,7 +3196,6 @@ static int iscsit_build_sendtargets_resp
 		len += 1;
 
 		if ((len + payload_len) > buffer_len) {
-			spin_unlock(&tiqn->tiqn_tpg_lock);
 			end_of_buf = 1;
 			goto eob;
 		}



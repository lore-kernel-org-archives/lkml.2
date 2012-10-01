Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933553Ab2JAX3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:29:30 -0400
Received: from 1wt.eu ([62.212.114.60]:35230 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932733Ab2JAXAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:46 -0400
Message-Id: <20121001225200.069443764@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:55 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Jeff Garzik <jgarzik@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 058/180] block, sx8: fix pointer math issue getting fw version
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit ea5f4db8ece896c2ab9eafa0924148a2596c52e4 upstream.

"mem" is type u8.  We need parenthesis here or it screws up the pointer
math probably leading to an oops.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/block/sx8.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
index a7c4184..bcbfc20 100644
--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -1116,7 +1116,7 @@ static inline void carm_handle_resp(struct carm_host *host,
 			break;
 		case MISC_GET_FW_VER: {
 			struct carm_fw_ver *ver = (struct carm_fw_ver *)
-				mem + sizeof(struct carm_msg_get_fw_ver);
+				(mem + sizeof(struct carm_msg_get_fw_ver));
 			if (!error) {
 				host->fw_ver = le32_to_cpu(ver->version);
 				host->flags |= (ver->features & FL_FW_VER_MASK);
-- 
1.7.2.1.45.g54fbc




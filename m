Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab2CBTA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 14:00:58 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:32465 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab2CBTA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 14:00:56 -0500
Date: Fri, 2 Mar 2012 22:00:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] block, sx8: fix pointer math issue getting fw version
Message-ID: <20120302190042.GB3951@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4F5118E2.0080,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"mem" is type u8.  We need parenthesis here or it screws up the pointer
math probably leading to an oops.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
index e7472f5..3fb6ab4 100644
--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -1120,7 +1120,7 @@ static inline void carm_handle_resp(struct carm_host *host,
 			break;
 		case MISC_GET_FW_VER: {
 			struct carm_fw_ver *ver = (struct carm_fw_ver *)
-				mem + sizeof(struct carm_msg_get_fw_ver);
+				(mem + sizeof(struct carm_msg_get_fw_ver));
 			if (!error) {
 				host->fw_ver = le32_to_cpu(ver->version);
 				host->flags |= (ver->features & FL_FW_VER_MASK);

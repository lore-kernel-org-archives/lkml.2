Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965567Ab2CPXjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:39:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48094 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965530Ab2CPXjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:39:32 -0400
Message-Id: <20120316233449.949069275@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:35:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Carpenter <dan.carpenter@oracle.com>,
        Jeff Garzik <jgarzik@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [ 30/38] block, sx8: fix pointer math issue getting fw version
In-Reply-To: <20120316233422.GA5461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit ea5f4db8ece896c2ab9eafa0924148a2596c52e4 upstream.

"mem" is type u8.  We need parenthesis here or it screws up the pointer
math probably leading to an oops.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/sx8.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -1116,7 +1116,7 @@ static inline void carm_handle_resp(stru
 			break;
 		case MISC_GET_FW_VER: {
 			struct carm_fw_ver *ver = (struct carm_fw_ver *)
-				mem + sizeof(struct carm_msg_get_fw_ver);
+				(mem + sizeof(struct carm_msg_get_fw_ver));
 			if (!error) {
 				host->fw_ver = le32_to_cpu(ver->version);
 				host->flags |= (ver->features & FL_FW_VER_MASK);



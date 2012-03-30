Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935851Ab2C3VNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:13:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54199 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935831Ab2C3VNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:13:06 -0400
Message-Id: <20120330194851.198752647@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joern Engel <joern@logfs.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 078/149] target: fix use after free in target_report_luns
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?J=C3=B6rn=20Engel?= <joern@logfs.org>

commit 382436f8804fe1cb20b9a2a811a10eb2d8554721 upstream.

Fix possible NULL pointer dereference in target_report_luns failure path.

Signed-off-by: Joern Engel <joern@logfs.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -696,12 +696,12 @@ int target_report_luns(struct se_task *s
 	 * See SPC3 r07, page 159.
 	 */
 done:
-	transport_kunmap_data_sg(se_cmd);
 	lun_count *= 8;
 	buf[0] = ((lun_count >> 24) & 0xff);
 	buf[1] = ((lun_count >> 16) & 0xff);
 	buf[2] = ((lun_count >> 8) & 0xff);
 	buf[3] = (lun_count & 0xff);
+	transport_kunmap_data_sg(se_cmd);
 
 	se_task->task_scsi_status = GOOD;
 	transport_complete_task(se_task, 1);



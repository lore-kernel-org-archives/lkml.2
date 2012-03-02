Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030622Ab2CBUnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 15:43:15 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:47989
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1030593Ab2CBUnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 15:43:11 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com, jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command to the host
Date: Fri,  2 Mar 2012 12:49:07 -0800
Message-Id: <1330721347-26781-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Windows hosts don't handle the ATA_16 command; don't pass it to the host.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 44c7a48..1404c9b 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1221,8 +1221,10 @@ static bool storvsc_scsi_cmd_ok(struct scsi_cmnd *scmnd)
 	/*
 	 * smartd sends this command and the host does not handle
 	 * this. So, don't send it.
+	 * Host also does not support ATA_16 command.
 	 */
 	case SET_WINDOW:
+	case ATA_16:
 		scmnd->result = ILLEGAL_REQUEST << 16;
 		allowed = false;
 		break;
-- 
1.7.4.1


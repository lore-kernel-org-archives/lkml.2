Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933531Ab1I1WuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:50:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55023 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933520Ab1I1WuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:50:14 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:50 2011
Message-Id: <20110928220150.151799558@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:03:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Randy Dunlap <rdunlap@xenotime.net>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [235/244] [SCSI] scsi: qla4xxx needs libiscsi.o
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Randy Dunlap <rdunlap@xenotime.net>

commit 3538a001ea7db13fa1be2966b71f69d808acff01 upstream.

qla4xxx driver needs to be linked with libiscsi.o to fix
build errors.  This happens when no other drivers that use
libiscsi.o are enabled.

ERROR: "iscsi_conn_stop" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_conn_get_addr_param" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_session_teardown" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_host_alloc" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_conn_start" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_conn_send_pdu" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_session_get_param" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_conn_get_param" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_set_param" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_session_failure" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_complete_pdu" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_session_setup" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_conn_bind" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_conn_setup" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_itt_to_task" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -88,7 +88,7 @@ obj-$(CONFIG_SCSI_QLOGIC_FAS)	+= qlogicf
 obj-$(CONFIG_PCMCIA_QLOGIC)	+= qlogicfas408.o
 obj-$(CONFIG_SCSI_QLOGIC_1280)	+= qla1280.o 
 obj-$(CONFIG_SCSI_QLA_FC)	+= qla2xxx/
-obj-$(CONFIG_SCSI_QLA_ISCSI)	+= qla4xxx/
+obj-$(CONFIG_SCSI_QLA_ISCSI)	+= libiscsi.o qla4xxx/
 obj-$(CONFIG_SCSI_LPFC)		+= lpfc/
 obj-$(CONFIG_SCSI_BFA_FC)	+= bfa/
 obj-$(CONFIG_SCSI_PAS16)	+= pas16.o



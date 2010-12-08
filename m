Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab0LHBGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:06:32 -0500
Received: from kroah.org ([198.145.64.141]:33923 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932918Ab0LHBEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:04:12 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:49 2010
Message-Id: <20101208005749.451786145@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chad Dupuis <chad.dupuis@qlogic.com>,
        Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [280/289] [SCSI] qla2xxx: Add module parameter to enable/disable GFF_ID device type check.
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chad Dupuis <chad.dupuis@qlogic.com>

commit 4da26e162b69d89c3186a35a052c05e61a555637 upstream.

Add the module parameter ql2xgffidenable to disable/enable the use of the
GFF_ID name server command to prevent non FCP SCSI devices from being added to
the driver's internal fc_port database.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/qla2xxx/qla_gbl.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |    5 +++--
 drivers/scsi/qla2xxx/qla_os.c   |    5 +++++
 3 files changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -92,6 +92,7 @@ extern int ql2xshiftctondsd;
 extern int ql2xdbwr;
 extern int ql2xdontresethba;
 extern int ql2xasynctmfenable;
+extern int ql2xgffidenable;
 extern int ql2xenabledif;
 extern int ql2xenablehba_err_chk;
 extern int ql2xtargetreset;
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3258,8 +3258,9 @@ qla2x00_find_all_fabric_devs(scsi_qla_ho
 			continue;
 
 		/* Bypass ports whose FCP-4 type is not FCP_SCSI */
-		if (new_fcport->fc4_type != FC4_TYPE_FCP_SCSI &&
-		    new_fcport->fc4_type != FC4_TYPE_UNKNOWN)
+		if (ql2xgffidenable &&
+		    (new_fcport->fc4_type != FC4_TYPE_FCP_SCSI &&
+		    new_fcport->fc4_type != FC4_TYPE_UNKNOWN))
 			continue;
 
 		/* Locate matching device in database. */
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -160,6 +160,11 @@ MODULE_PARM_DESC(ql2xtargetreset,
 		 "Enable target reset."
 		 "Default is 1 - use hw defaults.");
 
+int ql2xgffidenable;
+module_param(ql2xgffidenable, int, S_IRUGO|S_IRUSR);
+MODULE_PARM_DESC(ql2xgffidenable,
+		"Enables GFF_ID checks of port type. "
+		"Default is 0 - Do not use GFF_ID information.");
 
 int ql2xasynctmfenable;
 module_param(ql2xasynctmfenable, int, S_IRUGO|S_IRUSR);



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab1BKPig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 10:38:36 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49599 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab1BKPie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 10:38:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=l3tg/ueWBa3+BnYusp3A8j+1KUSp2Ef8GaMhfrbw5czpbTnp1RMdNqQW4EejMYGiUQ
         2eIBQdzlScpTCkTLEceVqLTR6xxcrNW0IVQa8QIqAv04gzsJKu5axt0VxnWacTqAypxr
         mFvQfsTmk2TvxZ3O1aRwizrLv0qjRIr+D5IlM=
From: ycwang <yenchengwang@gmail.com>
To: dbrownell@users.sourceforge.net, gregkh@suse.de,
        linux-kernel@vger.kernel.org
Cc: ycwang <yenchengwang@gmail.com>
Subject: [PATCH] usb: gadget: f_mass_storage: fixed a macro coding style issue
Date: Fri, 11 Feb 2011 23:36:32 +0800
Message-Id: <1297438592-8566-1-git-send-email-yenchengwang@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a macro coding style issue.

Signed-off-by: YenCheng Wang <yenchengwang@gmail.com>
---
 drivers/usb/gadget/f_mass_storage.c |   44 +++++++++++++++++++---------------
 1 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index b5dbb23..eccdf10 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -3122,31 +3122,37 @@ struct fsg_module_parameters {
 };
 
 #define _FSG_MODULE_PARAM_ARRAY(prefix, params, name, type, desc)	\
-	module_param_array_named(prefix ## name, params.name, type,	\
-				 &prefix ## params.name ## _count,	\
-				 S_IRUGO);				\
-	MODULE_PARM_DESC(prefix ## name, desc)
+	do {								\
+		module_param_array_named(prefix ## name, params.name, type,\
+					 &prefix ## params.name ## _count,\
+					 S_IRUGO);			\
+		MODULE_PARM_DESC(prefix ## name, desc)			\
+	} while (0)
 
 #define _FSG_MODULE_PARAM(prefix, params, name, type, desc)		\
-	module_param_named(prefix ## name, params.name, type,		\
-			   S_IRUGO);					\
-	MODULE_PARM_DESC(prefix ## name, desc)
+	do {								\
+		module_param_named(prefix ## name, params.name, type,	\
+				   S_IRUGO);				\
+		MODULE_PARM_DESC(prefix ## name, desc)			\
+	} while (0)
 
 #define FSG_MODULE_PARAMETERS(prefix, params)				\
-	_FSG_MODULE_PARAM_ARRAY(prefix, params, file, charp,		\
-				"names of backing files or devices");	\
-	_FSG_MODULE_PARAM_ARRAY(prefix, params, ro, bool,		\
-				"true to force read-only");		\
-	_FSG_MODULE_PARAM_ARRAY(prefix, params, removable, bool,	\
-				"true to simulate removable media");	\
-	_FSG_MODULE_PARAM_ARRAY(prefix, params, cdrom, bool,		\
+	do {								\
+		_FSG_MODULE_PARAM_ARRAY(prefix, params, file, charp,	\
+					"names of backing files or devices");\
+		_FSG_MODULE_PARAM_ARRAY(prefix, params, ro, bool,	\
+					"true to force read-only");	\
+		_FSG_MODULE_PARAM_ARRAY(prefix, params, removable, bool,\
+					"true to simulate removable media");\
+		_FSG_MODULE_PARAM_ARRAY(prefix, params, cdrom, bool,	\
 				"true to simulate CD-ROM instead of disk"); \
-	_FSG_MODULE_PARAM_ARRAY(prefix, params, nofua, bool,		\
+		_FSG_MODULE_PARAM_ARRAY(prefix, params, nofua, bool,	\
 				"true to ignore SCSI WRITE(10,12) FUA bit"); \
-	_FSG_MODULE_PARAM(prefix, params, luns, uint,			\
-			  "number of LUNs");				\
-	_FSG_MODULE_PARAM(prefix, params, stall, bool,			\
-			  "false to prevent bulk stalls")
+		_FSG_MODULE_PARAM(prefix, params, luns, uint,		\
+				  "number of LUNs");			\
+		_FSG_MODULE_PARAM(prefix, params, stall, bool,		\
+				  "false to prevent bulk stalls")	\
+	} while (0)
 
 static void
 fsg_config_from_params(struct fsg_config *cfg,
-- 
1.7.0.4


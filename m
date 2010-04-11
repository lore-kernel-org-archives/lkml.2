Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751100Ab0DKEkR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 00:40:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52756
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813Ab0DKEkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 00:40:15 -0400
Date: Sat, 10 Apr 2010 21:40:17 -0700 (PDT)
Message-Id: <20100410.214017.165974351.davem@davemloft.net>
To: ebiederm@xmission.com
CC: gregkh@suse.de, James.Bottomley@suse.de, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] scsi: Add lockdep annotations to SAS sysfs attributes.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


They are allocated dynamically, and thus need sysfs_attr_init()
treatment.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 927e99c..f9c61b9 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1679,15 +1679,17 @@ static int sas_user_scan(struct Scsi_Host *shost, uint channel,
  */
 
 #define SETUP_TEMPLATE(attrb, field, perm, test)			\
-	i->private_##attrb[count] = dev_attr_##field;		\
+	i->private_##attrb[count] = dev_attr_##field;			\
 	i->private_##attrb[count].attr.mode = perm;			\
+	sysfs_attr_init(&i->private_##attrb[count].attr);		\
 	i->attrb[count] = &i->private_##attrb[count];			\
 	if (test)							\
 		count++
 
 #define SETUP_TEMPLATE_RW(attrb, field, perm, test, ro_test, ro_perm)	\
-	i->private_##attrb[count] = dev_attr_##field;		\
+	i->private_##attrb[count] = dev_attr_##field;			\
 	i->private_##attrb[count].attr.mode = perm;			\
+	sysfs_attr_init(&i->private_##attrb[count].attr);		\
 	if (ro_test) {							\
 		i->private_##attrb[count].attr.mode = ro_perm;		\
 		i->private_##attrb[count].store = NULL;			\

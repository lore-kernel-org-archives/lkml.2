Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1EDC33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 22:29:29 -0400
Received: from mail.perches.com ([173.55.12.10]:1224 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714Ab1EDC3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 22:29:04 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Linux PCMCIA team <linux-pcmcia@lists.infradead.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH 1/3] pcmcia: Make declaration and uses of struct pcmcia_device_id const
Date: Tue,  3 May 2011 19:29:00 -0700
Message-Id: <e97be9cadd4e6f60bf230e6447bf68ae146f74e7.1304475548.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
In-Reply-To: <cover.1304475547.git.joe@perches.com>
References: <cover.1304475547.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Const allows tables to be moved into text sections.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/pcmcia/ds.c |    6 +++---
 include/pcmcia/ds.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pcmcia/ds.c b/drivers/pcmcia/ds.c
index 100c441..749c2a1 100644
--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -45,7 +45,7 @@ MODULE_LICENSE("GPL");
 
 static void pcmcia_check_driver(struct pcmcia_driver *p_drv)
 {
-	struct pcmcia_device_id *did = p_drv->id_table;
+	const struct pcmcia_device_id *did = p_drv->id_table;
 	unsigned int i;
 	u32 hash;
 
@@ -784,7 +784,7 @@ static inline int pcmcia_load_firmware(struct pcmcia_device *dev, char * filenam
 
 
 static inline int pcmcia_devmatch(struct pcmcia_device *dev,
-				  struct pcmcia_device_id *did)
+				  const struct pcmcia_device_id *did)
 {
 	if (did->match_flags & PCMCIA_DEV_ID_MATCH_MANF_ID) {
 		if ((!dev->has_manf_id) || (dev->manf_id != did->manf_id))
@@ -890,7 +890,7 @@ static int pcmcia_bus_match(struct device *dev, struct device_driver *drv)
 {
 	struct pcmcia_device *p_dev = to_pcmcia_dev(dev);
 	struct pcmcia_driver *p_drv = to_pcmcia_drv(drv);
-	struct pcmcia_device_id *did = p_drv->id_table;
+	const struct pcmcia_device_id *did = p_drv->id_table;
 	struct pcmcia_dynid *dynid;
 
 	/* match dynamic devices first */
diff --git a/include/pcmcia/ds.h b/include/pcmcia/ds.h
index 3fd5064..7b82080 100644
--- a/include/pcmcia/ds.h
+++ b/include/pcmcia/ds.h
@@ -56,7 +56,7 @@ struct pcmcia_driver {
 	int (*resume)		(struct pcmcia_device *dev);
 
 	struct module		*owner;
-	struct pcmcia_device_id	*id_table;
+	const struct pcmcia_device_id	*id_table;
 	struct device_driver	drv;
 	struct pcmcia_dynids	dynids;
 };
-- 
1.7.5.rc3.dirty


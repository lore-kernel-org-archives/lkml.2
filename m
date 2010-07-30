Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634Ab0G3Rev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:34:51 -0400
Received: from kroah.org ([198.145.64.141]:35508 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759214Ab0G3ReD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:34:03 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:04 2010
Message-Id: <20100730173104.234436806@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:29:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jean Delvare <khali@linux-fr.org>, Huaxu Wan <huaxu.wan@intel.com>
Subject: [016/140] hwmon: (coretemp) Properly label the sensors
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit 3f4f09b4be35d38d6e2bf22c989443e65e70fc4c upstream.

Don't assume that CPU entry number and core ID always match. It
worked in the simple cases (single CPU, no HT) but fails on
multi-CPU systems.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Huaxu Wan <huaxu.wan@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/coretemp.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -53,6 +53,7 @@ struct coretemp_data {
 	struct mutex update_lock;
 	const char *name;
 	u32 id;
+	u16 core_id;
 	char valid;		/* zero until following fields are valid */
 	unsigned long last_updated;	/* in jiffies */
 	int temp;
@@ -75,7 +76,7 @@ static ssize_t show_name(struct device *
 	if (attr->index == SHOW_NAME)
 		ret = sprintf(buf, "%s\n", data->name);
 	else	/* show label */
-		ret = sprintf(buf, "Core %d\n", data->id);
+		ret = sprintf(buf, "Core %d\n", data->core_id);
 	return ret;
 }
 
@@ -255,6 +256,9 @@ static int __devinit coretemp_probe(stru
 	}
 
 	data->id = pdev->id;
+#ifdef CONFIG_SMP
+	data->core_id = c->cpu_core_id;
+#endif
 	data->name = "coretemp";
 	mutex_init(&data->update_lock);
 



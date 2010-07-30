Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab0G3RDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:03:30 -0400
Received: from kroah.org ([198.145.64.141]:35482 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979Ab0G3RD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:03:29 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 09:59:54 2010
Message-Id: <20100730165953.954949437@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 09:57:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jean Delvare <khali@linux-fr.org>, Huaxu Wan <huaxu.wan@intel.com>
Subject: [01/17] hwmon: (coretemp) Properly label the sensors
In-Reply-To: <20100730170054.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

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
@@ -52,6 +52,7 @@ struct coretemp_data {
 	struct mutex update_lock;
 	const char *name;
 	u32 id;
+	u16 core_id;
 	char valid;		/* zero until following fields are valid */
 	unsigned long last_updated;	/* in jiffies */
 	int temp;
@@ -74,7 +75,7 @@ static ssize_t show_name(struct device *
 	if (attr->index == SHOW_NAME)
 		ret = sprintf(buf, "%s\n", data->name);
 	else	/* show label */
-		ret = sprintf(buf, "Core %d\n", data->id);
+		ret = sprintf(buf, "Core %d\n", data->core_id);
 	return ret;
 }
 
@@ -216,6 +217,9 @@ static int __devinit coretemp_probe(stru
 	}
 
 	data->id = pdev->id;
+#ifdef CONFIG_SMP
+	data->core_id = c->cpu_core_id;
+#endif
 	data->name = "coretemp";
 	mutex_init(&data->update_lock);
 



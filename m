Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab1GHFBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:01:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41654 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496Ab1GHFBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:01:23 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:54 2011
Message-Id: <20110708001654.918057107@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:15:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [022/107] hwmon: (ibmpex) Initialize sysfs attributes
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Guenter Roeck <guenter.roeck@ericsson.com>

commit fb794e0f7153918c33f2300986d995524ab711cf upstream.

Initialize dynamically allocated sysfs attributes before device_create_file()
call to suppress lockdep_init_map() warning if lockdep debugging is enabled.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/ibmpex.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwmon/ibmpex.c
+++ b/drivers/hwmon/ibmpex.c
@@ -358,6 +358,7 @@ static int create_sensor(struct ibmpex_b
 	else if (type == POWER_SENSOR)
 		sprintf(n, power_sensor_name_templates[func], "power", counter);
 
+	sysfs_attr_init(&data->sensors[sensor].attr[func].dev_attr.attr);
 	data->sensors[sensor].attr[func].dev_attr.attr.name = n;
 	data->sensors[sensor].attr[func].dev_attr.attr.mode = S_IRUGO;
 	data->sensors[sensor].attr[func].dev_attr.show = ibmpex_show_sensor;



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab1GHFT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:19:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41643 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684Ab1GHFBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:01:18 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:54 2011
Message-Id: <20110708001654.827611668@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:15:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [021/107] hwmon: (s3c) Initialize sysfs attributes
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Guenter Roeck <guenter.roeck@ericsson.com>

commit b1e698db0939b04602ded2a2196ff69c92b49378 upstream.

Initialize dynamically allocated sysfs attributes before device_create_file()
call to suppress lockdep_init_map() warning if lockdep debugging is enabled.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/s3c-hwmon.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/hwmon/s3c-hwmon.c
+++ b/drivers/hwmon/s3c-hwmon.c
@@ -232,6 +232,7 @@ static int s3c_hwmon_create_attr(struct
 
 	attr = &attrs->in;
 	attr->index = channel;
+	sysfs_attr_init(&attr->dev_attr.attr);
 	attr->dev_attr.attr.name  = attrs->in_name;
 	attr->dev_attr.attr.mode  = S_IRUGO;
 	attr->dev_attr.show = s3c_hwmon_ch_show;
@@ -249,6 +250,7 @@ static int s3c_hwmon_create_attr(struct
 
 		attr = &attrs->label;
 		attr->index = channel;
+		sysfs_attr_init(&attr->dev_attr.attr);
 		attr->dev_attr.attr.name  = attrs->label_name;
 		attr->dev_attr.attr.mode  = S_IRUGO;
 		attr->dev_attr.show = s3c_hwmon_label_show;



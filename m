Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163103Ab1FAI10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:27:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:45126 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163090Ab1FAI1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:27:18 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:12:13 2011
Message-Id: <20110601081212.779414879@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:11:47 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [137/165] hwmon: (pmbus) Initialize sysfs attributes
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 931
Lines: 28

From: Guenter Roeck <guenter.roeck@ericsson.com>

commit eec752b2b99c794766926a9bac59b0d7df5b09c2 upstream.

Initialize sysfs attrs before device_create_file() call to suppress
lockdep_init_map() warning:

WARNING: at kernel/lockdep.c:2701 lockdep_init_map+0x12d/0x140()

Reviewed-by: Robert Coulson <robert.coulson@ericsson.com>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/pmbus_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwmon/pmbus_core.c
+++ b/drivers/hwmon/pmbus_core.c
@@ -700,6 +700,7 @@ do {									\
 	struct sensor_device_attribute *a				\
 	    = &data->_type##s[data->num_##_type##s].attribute;		\
 	BUG_ON(data->num_attributes >= data->max_attributes);		\
+	sysfs_attr_init(&a->dev_attr.attr);				\
 	a->dev_attr.attr.name = _name;					\
 	a->dev_attr.attr.mode = _mode;					\
 	a->dev_attr.show = _show;					\



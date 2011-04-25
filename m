Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923Ab1DYUut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:50:49 -0400
Received: from 1wt.eu ([62.212.114.60]:34102 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932198Ab1DYUYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:30 -0400
Message-Id: <20110425200235.429104924@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:28 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Vasiliy Kulikov <segoon@openwall.com>, Matthew Garrett <mjg@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 056/173] platform: x86: tc1100-wmi: world-writable sysfs wireless and jogdial files
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segoon@openwall.com>

commit 8a6a142c1286797978e4db266d22875a5f424897 upstream.

Don't allow everybody to change WMI settings.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/tc1100-wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/tc1100-wmi.c
+++ b/drivers/misc/tc1100-wmi.c
@@ -177,7 +177,7 @@ set_bool_##value(struct device *dev, str
 			return -EINVAL; \
 	return count; \
 } \
-static DEVICE_ATTR(value, S_IWUGO | S_IRUGO | S_IWUSR, \
+static DEVICE_ATTR(value, S_IRUGO | S_IWUSR, \
 	show_bool_##value, set_bool_##value);
 
 show_set_bool(wireless, TC1100_INSTANCE_WIRELESS);



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965352Ab1C3Vme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:42:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:61735 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933516Ab1C3VIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621237495"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: segoon@openwall.com, mjg@redhat.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [138/275] platform: x86: tc1100-wmi: world-writable sysfs wireless and jogdial files
Message-Id: <20110330210619.0573B3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Vasiliy Kulikov <segoon@openwall.com>

commit 8a6a142c1286797978e4db266d22875a5f424897 upstream.

Don't allow everybody to change WMI settings.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/platform/x86/tc1100-wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/platform/x86/tc1100-wmi.c
===================================================================
--- linux-2.6.35.y.orig/drivers/platform/x86/tc1100-wmi.c	2011-03-29 22:51:12.162411964 -0700
+++ linux-2.6.35.y/drivers/platform/x86/tc1100-wmi.c	2011-03-29 23:03:01.135271122 -0700
@@ -162,7 +162,7 @@
 			return -EINVAL; \
 	return count; \
 } \
-static DEVICE_ATTR(value, S_IWUGO | S_IRUGO | S_IWUSR, \
+static DEVICE_ATTR(value, S_IRUGO | S_IWUSR, \
 	show_bool_##value, set_bool_##value);
 
 show_set_bool(wireless, TC1100_INSTANCE_WIRELESS);

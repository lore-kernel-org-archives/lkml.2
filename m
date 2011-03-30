Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602Ab1C3VIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:08:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:41245 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933542Ab1C3VH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903735349"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: segoon@openwall.com, mjg@redhat.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [136/275] platform: x86: acer-wmi: world-writable sysfs threeg file
Message-Id: <20110330210616.E1FC03E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Vasiliy Kulikov <segoon@openwall.com>

commit b80b168f918bba4b847e884492415546b340e19d upstream.

Don't allow everybody to write to hardware registers.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/platform/x86/acer-wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/platform/x86/acer-wmi.c
===================================================================
--- linux-2.6.35.y.orig/drivers/platform/x86/acer-wmi.c	2011-03-29 23:03:01.062272989 -0700
+++ linux-2.6.35.y/drivers/platform/x86/acer-wmi.c	2011-03-29 23:03:01.099272042 -0700
@@ -1066,7 +1066,7 @@
 			return -EINVAL;
 	return count;
 }
-static DEVICE_ATTR(threeg, S_IWUGO | S_IRUGO | S_IWUSR, show_bool_threeg,
+static DEVICE_ATTR(threeg, S_IRUGO | S_IWUSR, show_bool_threeg,
 	set_bool_threeg);
 
 static ssize_t show_interface(struct device *dev, struct device_attribute *attr,

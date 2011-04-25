Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733Ab1DYUwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:52:22 -0400
Received: from 1wt.eu ([62.212.114.60]:34092 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932190Ab1DYUY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:28 -0400
Message-Id: <20110425200235.385744103@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:27 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Vasiliy Kulikov <segoon@openwall.com>, Matthew Garrett <mjg@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 055/173] platform: x86: acer-wmi: world-writable sysfs threeg file
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segoon@openwall.com>

commit b80b168f918bba4b847e884492415546b340e19d upstream.

Don't allow everybody to write to hardware registers.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
[wt: also fixed permission on interface]

---
 drivers/platform/x86/acer-wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: longterm-2.6.27/drivers/misc/acer-wmi.c
===================================================================
--- longterm-2.6.27.orig/drivers/misc/acer-wmi.c	2011-04-25 14:48:12.000000000 +0200
+++ longterm-2.6.27/drivers/misc/acer-wmi.c	2011-04-25 14:57:17.405278940 +0200
@@ -957,7 +957,7 @@
 			return -EINVAL; \
 	return count; \
 } \
-static DEVICE_ATTR(value, S_IWUGO | S_IRUGO | S_IWUSR, \
+static DEVICE_ATTR(value, S_IRUGO | S_IWUSR, \
 	show_bool_##value, set_bool_##value);
 
 show_set_bool(wireless, ACER_CAP_WIRELESS);
@@ -982,7 +982,7 @@
 	}
 }
 
-static DEVICE_ATTR(interface, S_IWUGO | S_IRUGO | S_IWUSR,
+static DEVICE_ATTR(interface, S_IRUGO | S_IWUSR,
 	show_interface, NULL);
 
 /*



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601Ab0LCO0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 09:26:30 -0500
Received: from coyote.quickmin.net ([217.14.112.24]:55847 "EHLO
	coyote.quickmin.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758456Ab0LCO02 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 09:26:28 -0500
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=telemotive.de;
  b=lMdDwXzZ82JFvN0G9jmoiUJlXdMBwsCqBukxXV9qY/LahsOdP4dyLI1it4CwbmPVd+rD3xtB71XaqLmmTyMsstkr0Npg3cP7gudxJ9Zhw0E2rSX9S6D+nftQCUHDylNXKH3lDQU2+qTEHIpEd9TFjlcYZS5yM1YOCh1JNu5WcEc=  ;
From: Roman Fietze <roman.fietze@telemotive.de>
Organization: Telemotive AG
To: Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH] Proposal to add dynamic debug feature for print_hex_dump [1/2]
User-Agent: KMail/1.13.5 (Linux/2.6.31.14-0.4-default; KDE/4.5.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201012031517.35062.roman.fietze@telemotive.de>
In-Reply-To: <201012031517.35062.roman.fietze@telemotive.de>
MIME-Version: 1.0
Message-ID: <201012031519.45827.roman.fietze@telemotive.de>
Date: Fri, 3 Dec 2010 15:19:45 +0100
X-MIMETrack: Itemize by SMTP Server on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 03.12.2010 15:19:45,
	Serialize by Router on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 03.12.2010 15:19:46,
	Serialize complete at 03.12.2010 15:19:46
Content-Transfer-Encoding: 8BIT
Content-Type: Text/Plain;
  charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 9990f3b651adad147a40bd4ce6289182e3b7da74 Mon Sep 17 00:00:00 2001
From: Roman Fietze <roman.fietze@telemotive.de>
Date: Fri, 3 Dec 2010 14:06:56 +0100
Subject: [PATCH 1/2] kernel.h: add pr_<level>_hex_dump macros

Add macros e.g. named pr_<level>_hex_dump calling print_hex_dump with
the approriate level, with level beeing emerg, alert, ..., debug. This
is similiar to the functions starting with "pr_".

The parameters for those macros are the same as for print_hex_dump
excluding the level.

Signed-off-by: Roman Fietze <roman.fietze@telemotive.de>
---
 include/linux/printk.h |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index b772ca5..77903f1 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -179,6 +179,44 @@ extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 #define pr_cont(fmt, ...) \
 	printk(KERN_CONT fmt, ##__VA_ARGS__)
 
+#define pr_emerg_hex_dump(prfx_str, prfx_type, rowsz,  grpsz,		\
+			  buf, len, ascii)				\
+	print_hex_dump(KERN_EMERG, prfx_str, prfx_type, rowsz, grpsz,	\
+		       buf, len, ascii)
+#define pr_alert_hex_dump(prfx_str, prfx_type, rowsz,  grpsz,		\
+			  buf, len, ascii)				\
+	print_hex_dump(KERN_ALERT, prfx_str, prfx_type, rowsz, grpsz,	\
+		       buf, len, ascii)
+#define pr_crit_hex_dump(prfx_str, prfx_type, rowsz,  grpsz,		\
+			 buf, len, ascii)				\
+	print_hex_dump(KERN_CRIT, prfx_str, prfx_type, rowsz, grpsz,	\
+		       buf, len, ascii)
+#define pr_err_hex_dump(prfx_str, prfx_type, rowsz,  grpsz,		\
+			buf, len, ascii)				\
+	print_hex_dump(KERN_ERR, prfx_str, prfx_type, rowsz, grpsz,	\
+		       buf, len, ascii)
+#define pr_warning_hex_dump(prfx_str, prfx_type, rowsz,  grpsz,		\
+			    buf, len, ascii)				\
+	print_hex_dump(KERN_WARNING, prfx_str, prfx_type, rowsz, grpsz,	\
+		       buf, len, ascii)
+#define pr_warn_hex_dump pr_warning_hex_dump
+#define pr_notice_hex_dump(prfx_str, prfx_type, rowsz,  grpsz,		\
+			   buf, len, ascii)				\
+	print_hex_dump(KERN_NOTICE, prfx_str, prfx_type, rowsz, grpsz,	\
+		       buf, len, ascii)
+#define pr_info_hex_dump(prfx_str, prfx_type, rowsz,  grpsz,		\
+			 buf, len, ascii)				\
+	print_hex_dump(KERN_INFO, prfx_str, prfx_type, rowsz, grpsz,	\
+		       buf, len, ascii)
+#define pr_cont_hex_dump(prfx_str, prfx_type, rowsz,  grpsz,		\
+			 buf, len, ascii)				\
+	print_hex_dump(KERN_CONT, prfx_str, prfx_type, rowsz, grpsz,	\
+		       buf, len, ascii)
+#define pr_debug_hex_dump(prfx_str, prfx_type, rowsz,  grpsz,		\
+			  buf, len, ascii)				\
+	print_hex_dump(KERN_DEBUG, prfx_str, prfx_type, rowsz, grpsz,	\
+		       buf, len, ascii)
+
 /* pr_devel() should produce zero code unless DEBUG is defined */
 #ifdef DEBUG
 #define pr_devel(fmt, ...) \
-- 
1.7.3.2



-- 
Roman Fietze              Telemotive AG Buero Muehlhausen
Breitwiesen                             73347 Muehlhausen
Tel.: +49(0)7335/18493-45        http://www.telemotive.de

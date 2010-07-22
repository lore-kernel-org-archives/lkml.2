Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765Ab0GVQ6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 12:58:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55840 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab0GVQ54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 12:57:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mExI6bEbNjDbBbd0meMER8+e4Xc3QNlmx7uJ1+JRRzgoTmr/igITRvVTD6BPDxk2ni
         r21tmqc81DN9Uoq72DllH/pNeqRPEWsV7qLPPKqwUK6Fd76vWVqnIP2kyqIEmn5Hrb0M
         pZpHFfmzyv2a1qLLZtVpYvlISMxzPJQ3ZUEn8=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 5/5] staging: wlan-ng: remove own bin2hex converter
Date: Thu, 22 Jul 2010 19:57:11 +0300
Message-Id: <b1b31effdd7ec5692844760f35142d6199b80662.1279817399.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <20100722151545.GA6696@suse.de>
References: <20100722151545.GA6696@suse.de>
In-Reply-To: <cover.1279817399.git.andy.shevchenko@gmail.com>
References: <cover.1279817399.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kernel we have hex_asc_hi and hex_asc_lo macroses to do the job.

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/wlan-ng/prism2sta.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2sta.c b/drivers/staging/wlan-ng/prism2sta.c
index 5ec5741..1a502bc 100644
--- a/drivers/staging/wlan-ng/prism2sta.c
+++ b/drivers/staging/wlan-ng/prism2sta.c
@@ -83,8 +83,6 @@
 #include "hfa384x.h"
 #include "prism2mgmt.h"
 
-#define wlan_hexchar(x) (((x) < 0x0a) ? ('0' + (x)) : ('a' + ((x) - 0x0a)))
-
 /* Create a string of printable chars from something that might not be */
 /* It's recommended that the str be 4*len + 1 bytes long */
 #define wlan_mkprintstr(buf, buflen, str, strlen) \
@@ -99,8 +97,8 @@
 		} else { \
 			(str)[j] = '\\'; \
 			(str)[j+1] = 'x'; \
-			(str)[j+2] = wlan_hexchar(((buf)[i] & 0xf0) >> 4); \
-			(str)[j+3] = wlan_hexchar(((buf)[i] & 0x0f)); \
+			(str)[j+2] = hex_asc_hi((buf)[i]); \
+			(str)[j+3] = hex_asc_lo((buf)[i]); \
 			j += 4; \
 		} \
 	} \
-- 
1.7.1.1


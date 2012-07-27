Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab2G0Bjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 21:39:46 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51603 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab2G0Bjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 21:39:44 -0400
Message-ID: <5011F15A.3060007@kernel.org>
Date: Thu, 26 Jul 2012 21:39:38 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Pavel Vasilyev <pavel@pavlinux.ru>, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>
Subject: [PATCH] ACPI: replace strlen("string") with sizeof("string") -1
References: <Pine.LNX.4.44L0.1206301023540.29029-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1206301023540.29029-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...both give the number of chars in the string
without the '\0', as strncmp() wants,
but sizeof() is compile-time.

Reported-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Pavel Vasilyev <pavel@pavlinux.ru>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c
index 240a244..7c3f98b 100644
--- a/drivers/acpi/sysfs.c
+++ b/drivers/acpi/sysfs.c
@@ -173,7 +173,7 @@ static int param_set_trace_state(const char *val,
struct kernel_param *kp)
 {
 	int result = 0;

-	if (!strncmp(val, "enable", strlen("enable"))) {
+	if (!strncmp(val, "enable", sizeof("enable") - 1)) {
 		result = acpi_debug_trace(trace_method_name, trace_debug_level,
 					  trace_debug_layer, 0);
 		if (result)
@@ -181,7 +181,7 @@ static int param_set_trace_state(const char *val,
struct kernel_param *kp)
 		goto exit;
 	}

-	if (!strncmp(val, "disable", strlen("disable"))) {
+	if (!strncmp(val, "disable", sizeof("disable") - 1)) {
 		int name = 0;
 		result = acpi_debug_trace((char *)&name, trace_debug_level,
 					  trace_debug_layer, 0);
-- 
1.7.12.rc0


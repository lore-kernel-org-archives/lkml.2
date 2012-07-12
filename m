Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161804Ab2GLWkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:40:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60450 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161755Ab2GLWkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:40:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Len Brown <len.brown@intel.com>
Subject: [ 082/187] ACPI sysfs.c strlen fix
Date: Thu, 12 Jul 2012 15:33:58 -0700
Message-Id: <20120712191530.011800520@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Vasilyev <pavel@pavlinux.ru>

commit 9f132652d94c96476b0b0a8caf0c10e96ab10fa8 upstream.

Current code is ignoring the last character of "enable" and "disable"
in comparisons.

https://bugzilla.kernel.org/show_bug.cgi?id=33732

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/sysfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/acpi/sysfs.c
+++ b/drivers/acpi/sysfs.c
@@ -173,7 +173,7 @@ static int param_set_trace_state(const c
 {
 	int result = 0;
 
-	if (!strncmp(val, "enable", strlen("enable") - 1)) {
+	if (!strncmp(val, "enable", strlen("enable"))) {
 		result = acpi_debug_trace(trace_method_name, trace_debug_level,
 					  trace_debug_layer, 0);
 		if (result)
@@ -181,7 +181,7 @@ static int param_set_trace_state(const c
 		goto exit;
 	}
 
-	if (!strncmp(val, "disable", strlen("disable") - 1)) {
+	if (!strncmp(val, "disable", strlen("disable"))) {
 		int name = 0;
 		result = acpi_debug_trace((char *)&name, trace_debug_level,
 					  trace_debug_layer, 0);



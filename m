Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab1GJSrB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 14:47:01 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43810 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454Ab1GJSq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 14:46:57 -0400
Subject: [PATCH] [RESENDING] dell-laptop - using buffer without mutex_lock
From: Jose Alonso <joalonsof@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Greg Dietsche <greg@gregd.org>, linux-kernel@vger.kernel.org
Date: Sun, 10 Jul 2011 15:46:51 -0300
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1310323613.2923.7.camel@laptop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resending patch with tabs and signed-off-by)

Using buffer->output[1] without mutex_lock()

Signed-off-by: Jose Alonso <joalonsof@gmail.com>
version linux-3.0-rc6
--
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -560,11 +560,11 @@
 	else
 		dell_send_request(buffer, 0, 1);
 
+	ret = buffer->output[1];
+
 out:
 	release_buffer();
-	if (ret)
-		return ret;
-	return buffer->output[1];
+	return ret;
 }
 
 static const struct backlight_ops dell_ops = {



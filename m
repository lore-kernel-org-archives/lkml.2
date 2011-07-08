Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab1GHWBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 18:01:33 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60767 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab1GHWBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 18:01:32 -0400
Subject: [PATCH] dell-laptop - using buffer without mutex_lock
From: Jose Alonso <joalonsof@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 08 Jul 2011 19:01:27 -0300
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1310162490.9760.5.camel@laptop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using buffer->output[1] without mutex_lock()

--- linux-3.0-rc6/drivers/platform/x86/dell-laptop.c.ORIG
2011-07-04 19:56:24.000000000 -0300
+++ linux-3.0-rc6/drivers/platform/x86/dell-laptop.c    2011-07-08
18:27:02.420791868 -0300
@@ -560,11 +560,11 @@
        else
                dell_send_request(buffer, 0, 1);

+       ret = buffer->output[1];
+
 out:
        release_buffer();
-       if (ret)
-               return ret;
-       return buffer->output[1];
+       return ret;
 }

 static const struct backlight_ops dell_ops = {



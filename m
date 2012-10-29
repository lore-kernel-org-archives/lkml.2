Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760671Ab2J2UJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:09:04 -0400
Received: from mail.kernel.org ([198.145.19.201]:42670 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760165Ab2J2UJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:09:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>, support@connecttech.com
Subject: [ 15/34] USB: whiteheat: fix memory leak in error path
Date: Mon, 29 Oct 2012 13:07:46 -0700
Message-Id: <20121029200422.249622411@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029200420.550338074@linuxfoundation.org>
References: <20121029200420.550338074@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit c129197c99550d356cf5f69b046994dd53cd1b9d upstream.

Make sure command buffer is deallocated in case of errors during attach.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Cc: <support@connecttech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/whiteheat.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -576,6 +576,7 @@ no_firmware:
 		"%s: please contact support@connecttech.com\n",
 		serial->type->description);
 	kfree(result);
+	kfree(command);
 	return -ENODEV;
 
 no_command_private:



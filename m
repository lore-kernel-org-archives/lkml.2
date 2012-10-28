Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab2J1XoA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:44:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41953 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756614Ab2J1X13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:29 -0400
Message-Id: <20121028231601.798138720@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:56 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>, <support@connecttech.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 080/105] USB: whiteheat: fix memory leak in error path
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit c129197c99550d356cf5f69b046994dd53cd1b9d upstream.

Make sure command buffer is deallocated in case of errors during attach.

Cc: <support@connecttech.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/whiteheat.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index 346c7ef..cfd155e 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -333,6 +333,7 @@ no_firmware:
 		"%s: please contact support@connecttech.com\n",
 		serial->type->description);
 	kfree(result);
+	kfree(command);
 	return -ENODEV;
 
 no_command_private:



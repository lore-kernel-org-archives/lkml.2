Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189Ab2KZROb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:14:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48136 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933941Ab2KZROX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:14:23 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Len Sorensen <lsorense@csclub.uwaterloo.ca>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 232/270] USB: serial: Fix memory leak in sierra_release()
Date: Mon, 26 Nov 2012 14:58:42 -0200
Message-Id: <1353949160-26803-233-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>

commit f7bc5051667b74c3861f79eed98c60d5c3b883f7 upstream.

I found a memory leak in sierra_release() (well sierra_probe() I guess)
that looses 8 bytes each time the driver releases a device.

Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
Acked-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/serial/sierra.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index d423d36..7d7ab91 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -964,6 +964,7 @@ static void sierra_release(struct usb_serial *serial)
 			continue;
 		kfree(portdata);
 	}
+	kfree(serial->private);
 }
 
 #ifdef CONFIG_PM
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934085Ab2KZRYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:24:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48193 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934067Ab2KZRO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:14:57 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bill Pemberton <wfp5p@virginia.edu>, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 241/270] USB: quatech2: fix memory leak in error path
Date: Mon, 26 Nov 2012 14:58:51 -0200
Message-Id: <1353949160-26803-242-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit b8a0055050b6294826171641b182c09f78f4cc63 upstream.

Fix memory leak in attach error path where the read urb was never freed.

Cc: Bill Pemberton <wfp5p@virginia.edu>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/serial/quatech2.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/quatech2.c b/drivers/usb/serial/quatech2.c
index 8dd88eb..d170271 100644
--- a/drivers/usb/serial/quatech2.c
+++ b/drivers/usb/serial/quatech2.c
@@ -829,6 +829,7 @@ static int qt2_setup_urbs(struct usb_serial *serial)
 	if (status != 0) {
 		dev_err(&serial->dev->dev,
 			"%s - submit read urb failed %i\n", __func__, status);
+		usb_free_urb(serial_priv->read_urb);
 		return status;
 	}
 
-- 
1.7.9.5


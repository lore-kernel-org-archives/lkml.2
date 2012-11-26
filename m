Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934143Ab2KZRPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:15:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48234 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934006Ab2KZRP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:15:27 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 249/270] USB: mos7840: fix port-device leak in error path
Date: Mon, 26 Nov 2012 14:58:59 -0200
Message-Id: <1353949160-26803-250-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 3eb55cc4ed88eee3b5230f66abcdbd2a91639eda upstream.

The driver set the usb-serial port pointers to NULL on errors in attach,
effectively preventing usb-serial core from decrementing the port ref
counters and releasing the port devices and associated data.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/serial/mos7840.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 748bc6a..f717db4 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2685,7 +2685,6 @@ error:
 		kfree(mos7840_port->ctrl_buf);
 		usb_free_urb(mos7840_port->control_urb);
 		kfree(mos7840_port);
-		serial->port[i] = NULL;
 	}
 	return status;
 }
-- 
1.7.9.5


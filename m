Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761530Ab2J2WFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:05:32 -0400
Received: from mail.kernel.org ([198.145.19.201]:47781 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761319Ab2J2Vhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 068/101] USB: mos7840: fix port-device leak in error path
Date: Mon, 29 Oct 2012 14:35:21 -0700
Message-Id: <20121029213247.851032681@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 3eb55cc4ed88eee3b5230f66abcdbd2a91639eda upstream.

The driver set the usb-serial port pointers to NULL on errors in attach,
effectively preventing usb-serial core from decrementing the port ref
counters and releasing the port devices and associated data.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/mos7840.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2684,7 +2684,6 @@ error:
 		kfree(mos7840_port->ctrl_buf);
 		usb_free_urb(mos7840_port->control_urb);
 		kfree(mos7840_port);
-		serial->port[i] = NULL;
 	}
 	return status;
 }



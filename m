Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728Ab2JDVUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:20:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44933 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933693Ab2JDVUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:20:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [ 12/58] USB: serial: fix up bug with missing {}
Date: Thu,  4 Oct 2012 14:19:19 -0700
Message-Id: <20121004210636.984258877@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.449598766@linuxfoundation.org>
References: <20121004210635.449598766@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 44b0f0836b62171617d56c6528c821ceaa6ea506 upstream.

As reported by Fengguang:

FYI, coccinelle warns about

drivers/usb/serial/usb-serial.c:1415:3-51: code aligned with following code on line 1416

vim +1415 drivers/usb/serial/usb-serial.c

  1412          /* we only set the reset_resume field if the serial_driver has one */
  1413          for (sd = serial_drivers; *sd; ++sd) {
  1414                  if ((*sd)->reset_resume)
> 1415                          udriver->reset_resume = usb_serial_reset_resume;
> 1416                          break;
  1417          }

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/usb-serial.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -1426,9 +1426,10 @@ int usb_serial_register_drivers(struct u
 
 	/* we only set the reset_resume field if the serial_driver has one */
 	for (sd = serial_drivers; *sd; ++sd) {
-		if ((*sd)->reset_resume)
+		if ((*sd)->reset_resume) {
 			udriver->reset_resume = usb_serial_reset_resume;
 			break;
+		}
 	}
 
 	rc = usb_register(udriver);



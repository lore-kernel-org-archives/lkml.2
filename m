Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053Ab0FUAmi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 20:42:38 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:34768 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab0FUAmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 20:42:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=dt8D1frOI1VACes1NVaboKMvEUt5ZYNM6BAQMAS+XcnuuimTEPCm7zSnroBuJpXxN0
         oOdCxHKFgZhrKRqt9blw+Hfs+sUJ8dUga+aPoyoUK4FDBfLF3tHywLERQasGhNA2zXh5
         1qQvFfTPp1XWtKq00UusXNSB8NcsTcqstzhVw=
Subject: [PATCH v2] qcserial: fix a memory leak in qcprobe error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Matthew Garrett <mjg@redhat.com>,
       Anssi Hannula <anssi.hannula@gmail.com>,
       Bernhard Rosenkraenzer <bero@arklinux.org>, linux-usb@vger.kernel.org
Content-Type: text/plain
Date: Mon, 21 Jun 2010 08:44:17 +0800
Message-Id: <1277081057.15579.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing kfree(data) before return -ENODEV.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/usb/serial/qcserial.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 04bb759..93d72eb 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -139,6 +139,7 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 					"Could not set interface, error %d\n",
 					retval);
 				retval = -ENODEV;
+				kfree(data);
 			}
 			return retval;
 		}
@@ -155,6 +156,7 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 					"Could not set interface, error %d\n",
 					retval);
 				retval = -ENODEV;
+				kfree(data);
 			}
 			return retval;
 		}
@@ -163,6 +165,7 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 	default:
 		dev_err(&serial->dev->dev,
 			"unknown number of interfaces: %d\n", nintf);
+		kfree(data);
 		return -ENODEV;
 	}
 
-- 
1.5.4.3




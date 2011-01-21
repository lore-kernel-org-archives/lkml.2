Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab1AUOfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 09:35:25 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65124 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab1AUOfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 09:35:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=bJ0rOAf8mcYX5PkJiIUQZZfMWXbTfwU0KvdQ6AD3S5Gjh2zfzgcBSjJZTvZJzDr5K3
         pJub0V0N+M9Ham1tbGTpW80deAP6GkbIYCUf8cddYaMu4iflhyBxpcpNJ2eXXWxJ81P1
         P/Vjl0LmGTvGHQLNr6EKWUFPXegv4YLZzeipo=
Message-ID: <4D3999A7.1030201@libero.it>
Date: Fri, 21 Jan 2011 15:35:19 +0100
From: Dario Lombardo <dario.lombardo@libero.it>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH: linux-2.6]: drivers: update to pl2303 usb-serial to support
 Motorola cables
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dario Lombardo <dario.lombardo@libero.it>

Added 0x0307 device id to support Motorola cables to the pl2303 usb 
serial driver. This cable has a modified chip that is a pl2303, but 
declares itself as 0307. Fixed by adding the right device id to the 
supported devices list, assigning it the code labeled 
PL2303_PRODUCT_ID_MOTOROLA.

Signed-off-by: Dario Lombardo <dario.lombardo@libero.it>

---

--- a/drivers/usb/serial/pl2303.c    2011-01-21 09:11:09.000000000 +0100
+++ b/drivers/usb/serial/pl2303.c    2011-01-19 13:58:22.000000000 +0100
@@ -50,6 +50,7 @@
      { USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_MMX) },
      { USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_GPRS) },
      { USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_HCR331) },
+    { USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_MOTOROLA) },
      { USB_DEVICE(IODATA_VENDOR_ID, IODATA_PRODUCT_ID) },
      { USB_DEVICE(IODATA_VENDOR_ID, IODATA_PRODUCT_ID_RSAQ5) },
      { USB_DEVICE(ATEN_VENDOR_ID, ATEN_PRODUCT_ID) },
--- a/drivers/usb/serial/pl2303.h    2011-01-21 09:11:21.000000000 +0100
+++ b/drivers/usb/serial/pl2303.h    2011-01-19 13:54:30.000000000 +0100
@@ -21,6 +21,7 @@
  #define PL2303_PRODUCT_ID_MMX        0x0612
  #define PL2303_PRODUCT_ID_GPRS        0x0609
  #define PL2303_PRODUCT_ID_HCR331    0x331a
+#define PL2303_PRODUCT_ID_MOTOROLA  0x0307

  #define ATEN_VENDOR_ID        0x0557
  #define ATEN_VENDOR_ID2        0x0547

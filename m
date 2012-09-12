Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107Ab2ILXpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:45:08 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36222 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757037Ab2ILXo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:44:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Doron Cohen <doronc@siano-ms.com>
Subject: =?UTF-8?q?=5B=2031/46=5D=20USB=3A=20smsusb=3A=20remove=20=5F=5Fdevinit*=20from=20the=20struct=20usb=5Fdevice=5Fid=20table?=
Date: Wed, 12 Sep 2012 16:39:21 -0700
Message-Id: <20120912233820.931889469@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233817.662663809@linuxfoundation.org>
References: <20120912233817.662663809@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit d04dbd1c0ec17a13326c8f2279399c225836a79f upstream.

This structure needs to always stick around, even if CONFIG_HOTPLUG
is disabled, otherwise we can oops when trying to probe a device that
was added after the structure is thrown away.

Thanks to Fengguang Wu and Bjørn Mork for tracking this issue down.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reported-by: Bjørn Mork <bjorn@mork.no>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Michael Krufky <mkrufky@linuxtv.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Doron Cohen <doronc@siano-ms.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb/siano/smsusb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/dvb/siano/smsusb.c
+++ b/drivers/media/dvb/siano/smsusb.c
@@ -480,7 +480,7 @@ static int smsusb_resume(struct usb_inte
 	return 0;
 }
 
-static const struct usb_device_id smsusb_id_table[] __devinitconst = {
+static const struct usb_device_id smsusb_id_table[] = {
 	{ USB_DEVICE(0x187f, 0x0010),
 		.driver_info = SMS1XXX_BOARD_SIANO_STELLAR },
 	{ USB_DEVICE(0x187f, 0x0100),



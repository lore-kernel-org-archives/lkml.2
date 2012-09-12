Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab2ILXcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:32:05 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64318 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab2ILXbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:31:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Pavel Machek <pavel@ucw.cz>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Eliad Peller <eliad@wizery.com>,
        Devendra Naga <devendra.aaru@gmail.com>
Subject: =?UTF-8?q?=5B=20024/108=5D=20USB=3A=20winbond=3A=20remove=20=5F=5Fdevinit*=20from=20the=20struct=20usb=5Fdevice=5Fid=20table?=
Date: Wed, 12 Sep 2012 16:28:22 -0700
Message-Id: <20120912232453.080816874@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 43a34695d9cd79c6659f09da6d3b0624f3dd169f upstream.

This structure needs to always stick around, even if CONFIG_HOTPLUG
is disabled, otherwise we can oops when trying to probe a device that
was added after the structure is thrown away.

Thanks to Fengguang Wu and Bjørn Mork for tracking this issue down.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reported-by: Bjørn Mork <bjorn@mork.no>
CC: Pavel Machek <pavel@ucw.cz>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: "John W. Linville" <linville@tuxdriver.com>
CC: Eliad Peller <eliad@wizery.com>
CC: Devendra Naga <devendra.aaru@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/winbond/wbusb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -25,7 +25,7 @@ MODULE_DESCRIPTION("IS89C35 802.11bg WLA
 MODULE_LICENSE("GPL");
 MODULE_VERSION("0.1");
 
-static const struct usb_device_id wb35_table[] __devinitconst = {
+static const struct usb_device_id wb35_table[] = {
 	{ USB_DEVICE(0x0416, 0x0035) },
 	{ USB_DEVICE(0x18E8, 0x6201) },
 	{ USB_DEVICE(0x18E8, 0x6206) },



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408Ab2ILXow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:44:52 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58620 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933396Ab2ILXop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:44:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: =?UTF-8?q?=5B=2028/46=5D=20USB=3A=20spca506=3A=20remove=20=5F=5Fdevinit*=20from=20the=20struct=20usb=5Fdevice=5Fid=20table?=
Date: Wed, 12 Sep 2012 16:39:18 -0700
Message-Id: <20120912233820.612519005@linuxfoundation.org>
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

commit e694d518886c7afedcdd1732477832b2e32744e4 upstream.

This structure needs to always stick around, even if CONFIG_HOTPLUG
is disabled, otherwise we can oops when trying to probe a device that
was added after the structure is thrown away.

Thanks to Fengguang Wu and Bjørn Mork for tracking this issue down.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reported-by: Bjørn Mork <bjorn@mork.no>
CC: Hans de Goede <hdegoede@redhat.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/video/gspca/spca506.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/video/gspca/spca506.c
+++ b/drivers/media/video/gspca/spca506.c
@@ -685,7 +685,7 @@ static const struct sd_desc sd_desc = {
 };
 
 /* -- module initialisation -- */
-static const struct usb_device_id device_table[] __devinitconst = {
+static const struct usb_device_id device_table[] = {
 	{USB_DEVICE(0x06e1, 0xa190)},
 /*fixme: may be IntelPCCameraPro BRIDGE_SPCA505
 	{USB_DEVICE(0x0733, 0x0430)}, */



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab2HTEMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:12:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38485 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab2HTD7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 23:59:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        =?UTF-8?q?Thomas=20Sch=C3=A4fer?= <tschaefer@t-online.de>
Subject: =?UTF-8?q?=5B=2028/32=5D=20USB=3A=20option=3A=20add=20ZTE=20K5006-Z?=
Date: Sun, 19 Aug 2012 20:57:24 -0700
Message-Id: <20120820035651.784477355@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035647.862247088@linuxfoundation.org>
References: <20120820035647.862247088@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit f1b5c997e68533df1f96dcd3068a231bca495603 upstream.

The ZTE (Vodafone) K5006-Z use the following
interface layout:

00 DIAG
01 secondary
02 modem
03 networkcard
04 storage

Ignoring interface #3 which is handled by the qmi_wwan
driver.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Cc: Thomas Schäfer <tschaefer@t-online.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -886,6 +886,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1010, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1012, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1018, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&net_intf3_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1057, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1058, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1059, 0xff, 0xff, 0xff) },



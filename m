Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465Ab2ILXhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:37:22 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:50638 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab2ILXhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:37:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Forest Bond <forest@alittletooquiet.net>,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Juhl <jj@chaosbits.net>, Jiri Pirko <jpirko@redhat.com>
Subject: =?UTF-8?q?=5B=2001/85=5D=20USB=3A=20vt6656=3A=20remove=20=5F=5Fdevinit*=20from=20the=20struct=20usb=5Fdevice=5Fid=20table?=
Date: Wed, 12 Sep 2012 16:35:44 -0700
Message-Id: <20120912233541.903642401@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233541.747973832@linuxfoundation.org>
References: <20120912233541.747973832@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 4d088876f24887cd15a29db923f5f37db6a99f21 upstream.

This structure needs to always stick around, even if CONFIG_HOTPLUG
is disabled, otherwise we can oops when trying to probe a device that
was added after the structure is thrown away.

Thanks to Fengguang Wu and Bjørn Mork for tracking this issue down.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reported-by: Bjørn Mork <bjorn@mork.no>
CC: Forest Bond <forest@alittletooquiet.net>
CC: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: Jesper Juhl <jj@chaosbits.net>
CC: Jiri Pirko <jpirko@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6656/main_usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -222,7 +222,7 @@ DEVICE_PARAM(b80211hEnable, "802.11h mod
 // Static vars definitions
 //
 
-static struct usb_device_id vt6656_table[] __devinitdata = {
+static struct usb_device_id vt6656_table[] = {
 	{USB_DEVICE(VNT_USB_VENDOR_ID, VNT_USB_PRODUCT_ID)},
 	{}
 };



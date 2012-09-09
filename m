Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab2IIXRX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:17:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51445 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756340Ab2IIXRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:17:01 -0400
Message-Id: <20120909224157.232321049@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:37 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        =?ISO-8859-15?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Forest Bond <forest@alittletooquiet.net>,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Juhl <jj@chaosbits.net>, Jiri Pirko <jpirko@redhat.com>
Subject: [ 47/95] USB: vt6656: remove __devinit* from the struct usb_device_id table
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/vt6656/main_usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index b06fd5b..d536756 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -189,7 +189,7 @@ DEVICE_PARAM(b80211hEnable, "802.11h mode");
 // Static vars definitions
 //
 
-static struct usb_device_id vt6656_table[] __devinitdata = {
+static struct usb_device_id vt6656_table[] = {
 	{USB_DEVICE(VNT_USB_VENDOR_ID, VNT_USB_PRODUCT_ID)},
 	{}
 };



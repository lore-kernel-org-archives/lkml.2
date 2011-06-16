Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab1FPIEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 04:04:44 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56718 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab1FPIEh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 04:04:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=BDLtgYWFW2/IDInXM1Qzg1ygiKDsc9Qhj7wO+eZHEftUtO56pGxJxjVay9KkJ22N4f
         dvsE67chtK49/9bWzR8G3eBJbEBiemKFBVs4Yn0uxlH75n/5gx8nSnGn3+Tka3sEQxdu
         Pim7DUNp3qljDrJd2hpYATdL40ct8J4DO2EyI=
MIME-Version: 1.0
Date: Thu, 16 Jun 2011 10:04:36 +0200
Message-ID: <BANLkTin2w5muF+LV269DV1=L+_j8P6DT_Q@mail.gmail.com>
Subject: [PATCH] s3c2410_udc: fix custom UDC command handling
From: Viliam Mateicka <viliam.mateicka@gmail.com>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a bug in Samsung's UDC driver, which is completely disabling
the USB device when a custom UDC command is used.
Following patch seems to get the right behavior (e.g. enabling pull-up
instead of disabling then Vcc is applied). Also I'm not in mailing
list so please CC me.

Greetingz,
Vilo

Signed-off-by: Viliam Mateicka <viliam.mateicka@gmail.com>

--- drivers/usb/gadget/s3c2410_udc.c.orig       2011-05-19
06:06:34.000000000 +0200
+++ drivers/usb/gadget/s3c2410_udc.c    2011-06-16 08:57:19.000000000 +0200
@@ -1566,7 +1566,7 @@ static void s3c2410_udc_command(enum s3c
                return;
        if (udc_info->udc_command) {
-               udc_info->udc_command(S3C2410_UDC_P_DISABLE);
+               udc_info->udc_command(cmd);
        } else if (gpio_is_valid(udc_info->pullup_pin)) {
                int value;

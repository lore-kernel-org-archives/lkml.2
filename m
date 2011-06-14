Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab1FNO6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 10:58:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61640 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab1FNO6l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 10:58:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=rhEIMvMuMOxFDX6ufS8TebD26+uKxxNYLpKkv9HnWntLsbDApv1Hep7PKIvwOYr4X2
         0kjJXN3Ri3pJtSP/Rq8a2YSnVaFK+0grcGxlH9NU6N+2O2HJFyGyH5xnMPsrSE0qeFSB
         owjchs54eRcZER1kcQHn4/NB+EZ9lh2e4qeU8=
MIME-Version: 1.0
In-Reply-To: <BANLkTimL=+vaa7NB5FW192rZd08Gv-Z-OA@mail.gmail.com>
References: <BANLkTimU+E8Y0_9+H2nsF6CMg66_TDH0LQ@mail.gmail.com>
	<BANLkTimL=+vaa7NB5FW192rZd08Gv-Z-OA@mail.gmail.com>
Date: Tue, 14 Jun 2011 16:58:40 +0200
Message-ID: <BANLkTik+TD1+k1hd-hEteE5OTeDrDAuMZQ@mail.gmail.com>
Subject: [PATCH] s3c2410_udc: udc command always disables pull-up instead of
 passing the command
From: Skacore Systems <skacore.systems@gmail.com>
To: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello *,

Sorry for the HTML,
There is a bug in s3c2410_udc driver, which triggers when using custom
UDC command for USB pull-up.
As a result driver is always calling user defined UDC command with
wrong parameter (S3C2410_UDC_P_DISABLE) instead of
just passing the parameter to the user defined function.

BR.

Vilo

--- Linux-2.6.39-wp/2.6.39/drivers/usb/gadget/s3c2410_udc.c
2011-05-19 06:06:34.000000000 +0200
+++ Linux-2.6.39/linux-paytec/drivers/usb/gadget/s3c2410_udc.c
2011-06-14 11:59:55.000000000 +0200
@@ -1566,7 +1566,7 @@
                return;
        if (udc_info->udc_command) {
-               udc_info->udc_command(S3C2410_UDC_P_DISABLE);
+               udc_info->udc_command(cmd);
        } else if (gpio_is_valid(udc_info->pullup_pin)) {
                int value;

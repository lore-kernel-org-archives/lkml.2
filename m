Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab2HMUZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:25:47 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55329 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab2HMUZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:25:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Bagwell <chris@cnpbagwell.com>,
        Tushant Mirchandani <tushantin@gmail.com>,
        Ping Cheng <pingc@wacom.com>, Dmitry Torokhov <dtor@mail.ru>
Subject: [ 81/82] Input: wacom - Bamboo One 1024 pressure fix
Date: Mon, 13 Aug 2012 13:19:57 -0700
Message-Id: <20120813201753.539908526@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Bagwell <chris@cnpbagwell.com>

commit 6dc463511d4a690f01a9248df3b384db717e0b1c upstream.

Bamboo One's with ID of 0x6a and 0x6b were added with correct
indication of 1024 pressure levels but the Graphire packet routine
was only looking at 9 bits.  Increased to 10 bits.

This bug caused these devices to roll over to zero pressure at half
way mark.

The other devices using this routine only support 256 or 512 range
and look to fix unused bits at zero.

Signed-off-by: Chris Bagwell <chris@cnpbagwell.com>
Reported-by: Tushant Mirchandani <tushantin@gmail.com>
Reviewed-by: Ping Cheng <pingc@wacom.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/tablet/wacom_wac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -248,7 +248,7 @@ static int wacom_graphire_irq(struct wac
 		input_report_abs(input, ABS_X, le16_to_cpup((__le16 *)&data[2]));
 		input_report_abs(input, ABS_Y, le16_to_cpup((__le16 *)&data[4]));
 		if (wacom->tool[0] != BTN_TOOL_MOUSE) {
-			input_report_abs(input, ABS_PRESSURE, data[6] | ((data[7] & 0x01) << 8));
+			input_report_abs(input, ABS_PRESSURE, data[6] | ((data[7] & 0x03) << 8));
 			input_report_key(input, BTN_TOUCH, data[1] & 0x01);
 			input_report_key(input, BTN_STYLUS, data[1] & 0x02);
 			input_report_key(input, BTN_STYLUS2, data[1] & 0x04);



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab0CXWHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 18:07:46 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:56667 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751679Ab0CXWHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 18:07:45 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH] rt2500usb: improve powersaving reliability
Date: Wed, 24 Mar 2010 23:07:34 +0100
User-Agent: KMail/1.9.10
Cc: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
       Ivo Van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org
References: <201003221601.36559.linux@rainbow-software.org> <201003231609.57505.linux@rainbow-software.org> <4BA8E11A.2020300@gmail.com>
In-Reply-To: <4BA8E11A.2020300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003242307.36363.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to my debugging, retrying 5 times (REGISTER_BUSY_COUNT) does not
provide enough time for the device to enter the required state. Sometimes,
the device needs 12 to 15 retries. Increase it to 20 to be sure.

This improves powersaving reliability but one problem still remains: power
state change sometimes fails completely - the bpp_state and rf_state get
stuck and cannot be changed anymore.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.34-rc2-orig/drivers/net/wireless/rt2x00/rt2500usb.c	2010-03-20 02:17:57.000000000 +0100
+++ linux-2.6.34-rc2/drivers/net/wireless/rt2x00/rt2500usb.c	2010-03-24 22:55:53.000000000 +0100
@@ -968,7 +968,7 @@ static int rt2500usb_set_state(struct rt
 	 * We must wait until the register indicates that the
 	 * device has entered the correct state.
 	 */
-	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
+	for (i = 0; i < 20; i++) {
 		rt2500usb_register_read(rt2x00dev, MAC_CSR17, &reg2);
 		bbp_state = rt2x00_get_field16(reg2, MAC_CSR17_BBP_CURR_STATE);
 		rf_state = rt2x00_get_field16(reg2, MAC_CSR17_RF_CURR_STATE);


-- 
Ondrej Zary

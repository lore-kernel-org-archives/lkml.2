Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031029Ab2HGWnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:43:18 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41393 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030864Ab2HGWnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:43:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 097/109] ALSA: mpu401: Fix missing initialization of irq field
Date: Tue,  7 Aug 2012 15:35:56 -0700
Message-Id: <20120807222051.588033120@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit bc733d495267a23ef8660220d696c6e549ce30b3 upstream.

The irq field of struct snd_mpu401 is supposed to be initialized to -1.
Since it's set to zero as of now, a probing error before the irq
installation results in a kernel warning "Trying to free already-free
IRQ 0".

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=44821
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/drivers/mpu401/mpu401_uart.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/drivers/mpu401/mpu401_uart.c
+++ b/sound/drivers/mpu401/mpu401_uart.c
@@ -554,6 +554,7 @@ int snd_mpu401_uart_new(struct snd_card
 	spin_lock_init(&mpu->output_lock);
 	spin_lock_init(&mpu->timer_lock);
 	mpu->hardware = hardware;
+	mpu->irq = -1;
 	if (! (info_flags & MPU401_INFO_INTEGRATED)) {
 		int res_size = hardware == MPU401_HW_PC98II ? 4 : 2;
 		mpu->res = request_region(port, res_size, "MPU401 UART");



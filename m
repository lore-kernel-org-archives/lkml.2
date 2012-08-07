Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030206Ab2HGDml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:42:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59871 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964828Ab2HGDi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:57 -0400
Message-Id: <20120807032800.521313941@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:25 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [ 30/70] ALSA: mpu401: Fix missing initialization of irq field
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit bc733d495267a23ef8660220d696c6e549ce30b3 upstream.

The irq field of struct snd_mpu401 is supposed to be initialized to -1.
Since it's set to zero as of now, a probing error before the irq
installation results in a kernel warning "Trying to free already-free
IRQ 0".

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=44821
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/drivers/mpu401/mpu401_uart.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/drivers/mpu401/mpu401_uart.c b/sound/drivers/mpu401/mpu401_uart.c
index 1cff331..4608c2c 100644
--- a/sound/drivers/mpu401/mpu401_uart.c
+++ b/sound/drivers/mpu401/mpu401_uart.c
@@ -554,6 +554,7 @@ int snd_mpu401_uart_new(struct snd_card *card, int device,
 	spin_lock_init(&mpu->output_lock);
 	spin_lock_init(&mpu->timer_lock);
 	mpu->hardware = hardware;
+	mpu->irq = -1;
 	if (! (info_flags & MPU401_INFO_INTEGRATED)) {
 		int res_size = hardware == MPU401_HW_PC98II ? 4 : 2;
 		mpu->res = request_region(port, res_size, "MPU401 UART");



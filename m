Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796Ab2JAXA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:00:57 -0400
Received: from 1wt.eu ([62.212.114.60]:35244 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757631Ab2JAXAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:50 -0400
Message-Id: <20121001225202.605833644@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:55 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 118/180] ALSA: mpu401: Fix missing initialization of irq field
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 sound/drivers/mpu401/mpu401_uart.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/drivers/mpu401/mpu401_uart.c b/sound/drivers/mpu401/mpu401_uart.c
index 2af0999..74f5a3d 100644
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
-- 
1.7.2.1.45.g54fbc




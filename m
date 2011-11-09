Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab1KJD0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:26:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42263 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934702Ab1KJD03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:26:29 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:12 2011
Message-Id: <20111109212712.788278675@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [121/262] [media] tuner_xc2028: Allow selection of the frequency adjustment code for XC3028
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 9bed77ee2fb46b74782d0d9d14b92e9d07f3df6e upstream.

This device is not using the proper demod IF. Instead of using the
IF macro, it is specifying a IF frequency. This doesn't work, as xc3028
needs to load an specific SCODE for the tuner. In this case, there's
no IF table for 5 MHz.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/cx23885/cx23885-dvb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -843,7 +843,7 @@ static int dvb_register(struct cx23885_t
 			static struct xc2028_ctrl ctl = {
 				.fname   = XC3028L_DEFAULT_FIRMWARE,
 				.max_len = 64,
-				.demod   = 5000,
+				.demod   = XC3028_FE_DIBCOM52,
 				/* This is true for all demods with
 					v36 firmware? */
 				.type    = XC2028_D2633,



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934804Ab1KCBmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:42:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934786Ab1KCBmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:42:36 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:47 2011
Message-Id: <20111102222747.474830286@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:27:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [084/101] [media] tuner_xc2028: Allow selection of the frequency adjustment code for XC3028
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -741,7 +741,7 @@ static int dvb_register(struct cx23885_t
 			static struct xc2028_ctrl ctl = {
 				.fname   = XC3028L_DEFAULT_FIRMWARE,
 				.max_len = 64,
-				.demod   = 5000,
+				.demod   = XC3028_FE_DIBCOM52,
 				/* This is true for all demods with
 					v36 firmware? */
 				.type    = XC2028_D2633,



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab2AXCzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:55:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50579 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932731Ab2AXCsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:48:03 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:33 2012
Message-Id: <20120124023933.712937365@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:35:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Miroslav Slugen <thunder.mmm@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [110/129] [media] cx88: fix: dont duplicate xc4000 entry for radio
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 2911
Lines: 89

From: Miroslav Slugen <thunder.mmm@gmail.com>

commit b6854e3f31402476bcc9d2f41570389fa491de17 upstream.

All radio tuners in cx88 driver using same address for radio and tuner,
so there is no need to probe it twice for same tuner and we can use
radio_type UNSET, this also fix broken radio since kernel 2.6.39-rc1
for those tuners.

Signed-off-by: Miroslav Slugen <thunder.mmm@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/cx88/cx88-cards.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/media/video/cx88/cx88-cards.c
+++ b/drivers/media/video/cx88/cx88-cards.c
@@ -1573,8 +1573,8 @@ static const struct cx88_board cx88_boar
 		.name           = "Pinnacle Hybrid PCTV",
 		.tuner_type     = TUNER_XC2028,
 		.tuner_addr     = 0x61,
-		.radio_type     = TUNER_XC2028,
-		.radio_addr     = 0x61,
+		.radio_type     = UNSET,
+		.radio_addr     = ADDR_UNSET,
 		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
@@ -1611,8 +1611,8 @@ static const struct cx88_board cx88_boar
 		.name           = "Leadtek TV2000 XP Global",
 		.tuner_type     = TUNER_XC2028,
 		.tuner_addr     = 0x61,
-		.radio_type     = TUNER_XC2028,
-		.radio_addr     = 0x61,
+		.radio_type     = UNSET,
+		.radio_addr     = ADDR_UNSET,
 		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
@@ -2043,8 +2043,8 @@ static const struct cx88_board cx88_boar
 		.name           = "Terratec Cinergy HT PCI MKII",
 		.tuner_type     = TUNER_XC2028,
 		.tuner_addr     = 0x61,
-		.radio_type     = TUNER_XC2028,
-		.radio_addr     = 0x61,
+		.radio_type     = UNSET,
+		.radio_addr     = ADDR_UNSET,
 		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
@@ -2082,9 +2082,9 @@ static const struct cx88_board cx88_boar
 	[CX88_BOARD_WINFAST_DTV1800H] = {
 		.name           = "Leadtek WinFast DTV1800 Hybrid",
 		.tuner_type     = TUNER_XC2028,
-		.radio_type     = TUNER_XC2028,
+		.radio_type     = UNSET,
 		.tuner_addr     = 0x61,
-		.radio_addr     = 0x61,
+		.radio_addr     = ADDR_UNSET,
 		/*
 		 * GPIO setting
 		 *
@@ -2123,9 +2123,9 @@ static const struct cx88_board cx88_boar
 	[CX88_BOARD_WINFAST_DTV1800H_XC4000] = {
 		.name		= "Leadtek WinFast DTV1800 H (XC4000)",
 		.tuner_type	= TUNER_XC4000,
-		.radio_type	= TUNER_XC4000,
+		.radio_type	= UNSET,
 		.tuner_addr	= 0x61,
-		.radio_addr	= 0x61,
+		.radio_addr	= ADDR_UNSET,
 		/*
 		 * GPIO setting
 		 *
@@ -2164,9 +2164,9 @@ static const struct cx88_board cx88_boar
 	[CX88_BOARD_WINFAST_DTV2000H_PLUS] = {
 		.name		= "Leadtek WinFast DTV2000 H PLUS",
 		.tuner_type	= TUNER_XC4000,
-		.radio_type	= TUNER_XC4000,
+		.radio_type	= UNSET,
 		.tuner_addr	= 0x61,
-		.radio_addr	= 0x61,
+		.radio_addr	= ADDR_UNSET,
 		/*
 		 * GPIO
 		 *   2: 1: mute audio



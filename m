Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab0FCVoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 17:44:11 -0400
Received: from smtp-out04.alice.it ([85.37.17.100]:2507 "EHLO
	smtp-out04.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab0FCVoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 17:44:10 -0400
Date: Thu, 3 Jun 2010 23:43:10 +0200
From: Giuliano Pochini <pochini@shiny.it>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix divide by 0 in echoaudio driver
Message-ID: <20100603234310.5f87dc89@Jay>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.14.7; powerpc-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jun 2010 21:44:06.0993 (UTC) FILETIME=[E4795C10:01CB0365]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch has already been merged in 2.6.34:
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.34.y.git;a=commitdiff;h=b721e68bdc5b39c51bf6a1469f8d3663fbe03243

Since it fixes a /0 in the irq handler, please consider including it also
in the next maintenance release of 2.6.33.

This patch is against 2.6.33.5.


Signed-off-by: Giuliano Pochini <pochini@shiny.it>

--- a/sound/pci/echoaudio/echoaudio.c	2010-06-03 22:23:21.000000000 +0100
+++ b/sound/pci/echoaudio/echoaudio.c	2010-06-03 22:48:33.000000000 +0100
@@ -1821,7 +1821,9 @@ static irqreturn_t snd_echo_interrupt(in
 	/* The hardware doesn't tell us which substream caused the irq,
 	thus we have to check all running substreams. */
 	for (ss = 0; ss < DSP_MAXPIPES; ss++) {
-		if ((substream = chip->substream[ss])) {
+		substream = chip->substream[ss];
+		if (substream && ((struct audiopipe *)substream->runtime->
+				private_data)->state == PIPE_STATE_STARTED) {
 			period = pcm_pointer(substream) /
 				substream->runtime->period_size;
 			if (period != chip->last_period[ss]) {


-- 
Giuliano.

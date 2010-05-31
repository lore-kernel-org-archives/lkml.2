Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab0EaUdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 16:33:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53342 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab0EaUdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 16:33:10 -0400
Message-ID: <4C041D00.6070708@cryptomys.de>
Date: Mon, 31 May 2010 22:33:04 +0200
From: Martin Homuth-Rosemann <homuth-rosemann@cryptomys.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi - correct parameter gainlkup for DAQCard-6024E
 in driver ni_mio_cs.c
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18JuHMA3fc0s5offg/wGAMXlrWmF9VpZFWBRx1
 ELRhZonsSfKlEZwvSzNVbhvN3kyo5UNb/VPFGNSR3BZVzfD99u
 5Dv4C1XZ3b3qCSU18Zq8LEmiSpKD7qgUYbyXDKNE58=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Homuth-Rosemann <homuth-rosemann@gmx.net>

Correct at least one of the incorrect specs for a national instrument 
data acquisition card DAQCard-6024E. This card has only four different 
gain settings (+-10V, +-5V, +-0.5V, +-0.05V).
Signed-off-by: Martin Homuth-Rosemann <homuth-rosemann@gmx.net>
---
--- linux-2.6.33/drivers/staging/comedi/drivers/ni_mio_cs.c.orig    
2010-02-24 19:52:17.000000000 +0100
+++ linux-2.6.33/drivers/staging/comedi/drivers/ni_mio_cs.c    
2010-05-27 12:26:22.000000000 +0200
@@ -121,11 +121,11 @@ static const struct ni_board_struct ni_b
       .name = "DAQCard-6024E",    /* specs incorrect! */
       .n_adchan = 16,
       .adbits = 12,
       .ai_fifo_depth = 1024,
       .alwaysdither = 0,
-     .gainlkup = ai_gain_16,
+     .gainlkup = ai_gain_4,
       .ai_speed = 5000,
       .n_aochan = 2,
       .aobits = 12,
       .ao_fifo_depth = 0,
       .ao_range_table = &range_bipolar10,



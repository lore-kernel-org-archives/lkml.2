Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab1HVTOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 15:14:06 -0400
Received: from mail.kaapeli.fi ([84.20.139.148]:40537 "EHLO mail.kaapeli.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376Ab1HVTOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 15:14:05 -0400
Message-ID: <4E52AA7B.3070708@iki.fi>
Date: Mon, 22 Aug 2011 22:14:03 +0300
From: Jyrki Kuoppala <jkp@iki.fi>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-media@vger.kernel.org, Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix to qt1010 tuner frequency selection (media/dvb), resend
 as text-only
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch fixes frequency selection for some UHF frequencies e.g. 
channel 32 (562 MHz) on the qt1010 tuner. The tuner is used e.g. in the 
MSI Mega Sky dvb-t stick ("MSI Mega Sky 55801 DVB-T USB2.0")

One example of problem reports of the bug this fixes can be read at 
http://www.freak-search.com/de/thread/330303/linux-dvb_tuning_problem_with_some_frequencies_qt1010,_dvb

Applies to kernel versions 2.6.38.8, 2.6.39.4, 3.0.3 and 3.1-rc2.

Signed-off-by: Jyrki Kuoppala <jkp@iki.fi>

diff -upr linux-source-2.6.38.orig/drivers/media/common/tuners/qt1010.c 
linux-source-2.6.38/drivers/media/common/tuners/qt1010.c
--- linux-source-2.6.38.orig/drivers/media/common/tuners/qt1010.c 
2011-03-15 03:20:32.000000000 +0200
+++ linux-source-2.6.38/drivers/media/common/tuners/qt1010.c	2011-08-21 
23:16:38.209580365 +0300
@@ -198,9 +198,10 @@ static int qt1010_set_params(struct dvb_

  	/* 22 */
  	if      (freq < 450000000) rd[15].val = 0xd0; /* 450 MHz */
-	else if (freq < 482000000) rd[15].val = 0xd1; /* 482 MHz */
+	else if (freq < 482000000) rd[15].val = 0xd2; /* 482 MHz */
  	else if (freq < 514000000) rd[15].val = 0xd4; /* 514 MHz */
-	else if (freq < 546000000) rd[15].val = 0xd7; /* 546 MHz */
+	else if (freq < 546000000) rd[15].val = 0xd6; /* 546 MHz */
+	else if (freq < 578000000) rd[15].val = 0xd8; /* 578 MHz */
  	else if (freq < 610000000) rd[15].val = 0xda; /* 610 MHz */
  	else                       rd[15].val = 0xd0;


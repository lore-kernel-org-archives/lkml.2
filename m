Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab1IFS3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 14:29:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56931 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab1IFS3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 14:29:35 -0400
Date: Tue, 6 Sep 2011 20:29:28 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Baruch Siach <baruch@tkos.co.il>,
        Andrew Morton <akpm@linux-foundation.org>, kernel@pengutronix.de,
        Arnd Bergmann <arnd@arndb.de>
Subject: including <linux/workqueue.h> isn't self contained
Message-ID: <20110906182928.GJ28816@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

compiling drivers/rtc/rtc-imxdi.c currently results in:

drivers/rtc/rtc-imxdi.c: In function 'di_write_wait':
drivers/rtc/rtc-imxdi.c:168:301: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
drivers/rtc/rtc-imxdi.c:168:301: note: each undeclared identifier is reported only once for each function it appears in
drivers/rtc/rtc-imxdi.c:168:2: error: implicit declaration of function 'signal_pending'
drivers/rtc/rtc-imxdi.c:168:2: error: implicit declaration of function 'schedule_timeout'
drivers/rtc/rtc-imxdi.c: In function 'dryice_norm_irq':
drivers/rtc/rtc-imxdi.c:329:34: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)

This is a regression from 

	4ba8216 (BKL: That's all, folks)

that removes #inclusion of <linux/sched.h> from include/linux/hardirq.h.

Adding

	#include <linux/sched.h>

to the driver fixes it, but I wonder if that is the correct fix because
the driver only uses wait_event_interruptible_timeout (and
wake_up_interruptible) explicitly but none of the three undeclared
symbols.

Any insight welcome.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

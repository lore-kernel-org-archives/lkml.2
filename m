Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab1IHPPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 11:15:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54262 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab1IHPPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 11:15:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: including <linux/workqueue.h> isn't self contained
Date: Thu, 8 Sep 2011 17:14:29 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Andrew Morton <akpm@linux-foundation.org>, kernel@pengutronix.de
References: <20110906182928.GJ28816@pengutronix.de>
In-Reply-To: <20110906182928.GJ28816@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201109081714.30009.arnd@arndb.de>
X-Provags-ID: V02:K0:b4HDobtQw6IZrVzgny2jKmU/KTw2NbkM/XplCXCKFwr
 fcYIYC5ldVhD+BDDmdgAHfVXHGj66v+gP296zjGxVU2YqbIzUO
 ii8me7ZWIbxd8JuDA/vKiJWfn+OFiM48u4cnB/F6igAgaWFXYT
 4jdVmv0EajonT7aVRT5iLLu7ioV31X9C8GuIzAPGzezWy6PBnf
 4VSIf6GytdT0LqMt81KbPgBWlQDnO2Ix8hFnS1bdO9LmR9/iBq
 xb4+vxuuHtqW6ORGCEvSp46hozDYvreZ7WeBJmg4FqtJZdU/4a
 lOwpY/BuXckzt4wzasDCqTmawTT6z9phqSSoReSsmr/sms69jj
 dol7zu0hqIi64Wftv784=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 September 2011, Uwe Kleine-König wrote:
> compiling drivers/rtc/rtc-imxdi.c currently results in:
> 
> drivers/rtc/rtc-imxdi.c: In function 'di_write_wait':
> drivers/rtc/rtc-imxdi.c:168:301: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
> drivers/rtc/rtc-imxdi.c:168:301: note: each undeclared identifier is reported only once for each function it appears in
> drivers/rtc/rtc-imxdi.c:168:2: error: implicit declaration of function 'signal_pending'
> drivers/rtc/rtc-imxdi.c:168:2: error: implicit declaration of function 'schedule_timeout'
> drivers/rtc/rtc-imxdi.c: In function 'dryice_norm_irq':
> drivers/rtc/rtc-imxdi.c:329:34: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
> 
> This is a regression from 
> 
>         4ba8216 (BKL: That's all, folks)
> 
> that removes #inclusion of <linux/sched.h> from include/linux/hardirq.h.
> 
> Adding
> 
>         #include <linux/sched.h>
> 
> to the driver fixes it, but I wonder if that is the correct fix because
> the driver only uses wait_event_interruptible_timeout (and
> wake_up_interruptible) explicitly but none of the three undeclared
> symbols.

Sorry about that. I would just include sched.h in there as an easy
workaround. Cleaning up the dependencies around sched.h is a larger
task and has been going on for roughly as long as the BKL removal,
so it's not your job to figure it out now.

	Arnd

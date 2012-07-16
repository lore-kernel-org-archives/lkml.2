Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab2GPSoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 14:44:19 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:60522 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753884Ab2GPSoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 14:44:16 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+BShN0DtyBunwsnRhRmwlUQQATFMGVueUxLLF2RC
	OdrZki2XdTeozH
Message-ID: <50045FCF.1060207@gmx.de>
Date: Mon, 16 Jul 2012 20:39:11 +0200
From: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120625 Thunderbird/13.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 3.5-rcX: wakeup after s2ram doesn't work after a longer sleep
 time
References: <500319E9.8010001@gmx.de> <201207152221.48232.rjw@sisk.pl> <50041C1E.8070203@gmx.de> <201207161947.55896.rjw@sisk.pl>
In-Reply-To: <201207161947.55896.rjw@sisk.pl>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 07/16/2012 07:47 PM, Rafael J. Wysocki wrote:
> 
> Well, so this is a different issue definitely.
> 
Well, this helped : https://lkml.org/lkml/2012/7/16/113

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 269b1fe..3447cfa 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -717,6 +717,7 @@ static void timekeeping_resume(void)
        timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
        timekeeper.ntp_error = 0;
        timekeeping_suspended = 0;
+       timekeeping_update(false);
        write_sequnlock_irqrestore(&timekeeper.lock, flags);
 
        touch_softlockup_watchdog();

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3



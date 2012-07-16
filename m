Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab2GPThV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 15:37:21 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42882 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348Ab2GPThU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 15:37:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
Subject: Re: 3.5-rcX: wakeup after s2ram doesn't work after a longer sleep time
Date: Mon, 16 Jul 2012 21:42:57 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <500319E9.8010001@gmx.de> <201207161947.55896.rjw@sisk.pl> <50045FCF.1060207@gmx.de>
In-Reply-To: <50045FCF.1060207@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201207162142.57994.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 16, 2012, Toralf Förster wrote:
> 
> On 07/16/2012 07:47 PM, Rafael J. Wysocki wrote:
> > 
> > Well, so this is a different issue definitely.
> > 
> Well, this helped : https://lkml.org/lkml/2012/7/16/113

So, it was the same issue after all.

The patch has been merged, so it should be all good now.

Thanks,
Rafael


> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 269b1fe..3447cfa 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -717,6 +717,7 @@ static void timekeeping_resume(void)
>         timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
>         timekeeper.ntp_error = 0;
>         timekeeping_suspended = 0;
> +       timekeeping_update(false);
>         write_sequnlock_irqrestore(&timekeeper.lock, flags);
>  
>         touch_softlockup_watchdog();
> 
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934526Ab2J3Ufu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 16:35:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58185 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934472Ab2J3Ufs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 16:35:48 -0400
Date: Tue, 30 Oct 2012 21:35:35 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Milan Broz <mbroz@redhat.com>, Tvrtko Ursulin <tvrtko@ursulin.net>,
        linux-rt-users@vger.kernel.org, dm-crypt@saout.de,
        linux-kernel@vger.kernel.org, okozina@redhat.com
Subject: Re: [PATCH] Fix crypto api init for 3.6.4-rt10
Message-ID: <20121030203535.GY639@pengutronix.de>
References: <50844D01.9090805@gmail.com>
 <5084551E.5040304@ursulin.net>
 <508ED985.5060301@ursulin.net>
 <508EDD6E.7030908@gmail.com>
 <508EE395.9010709@ursulin.net>
 <508EEAF2.4090506@ursulin.net>
 <20121030094001.GV639@pengutronix.de>
 <508FA405.2050509@redhat.com>
 <508FF1D6.3030900@redhat.com>
 <alpine.LFD.2.02.1210301856390.2756@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.02.1210301856390.2756@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Oct 30, 2012 at 06:57:37PM +0100, Thomas Gleixner wrote:
> On Tue, 30 Oct 2012, Milan Broz wrote:
> 
> > Fix crypto api for 3.6.4-rt10 (broken only in realtime patchset)
> > 
> > In peterz-srcu-crypto-chain.patch the blocking notifier is changed
> > to srcu notifier and added initialization to module init fucntion.
> > 
> > Later, in crypto-make-core-static-and-init-scru-early.patch, is that
> > initialization added also to core_initcall().
> > 
> > This patch removes crypto_chain init from algapi initialization,
> > because this function is called later and already initialized
> > cryptomgr notifier is lost.
> 
> Grrr. So I forgot top zap the one Peter added. Stupid me.
>  
> > This cause a failure in initialization of larval algorithms,
> > like e.g. cbc(aes).
> 
> Thanks for spotting!
This patch fixes booting my laptop. But now it hangs after login.

thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab0HPFRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 01:17:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36544 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab0HPFR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 01:17:28 -0400
Date: Mon, 16 Aug 2010 07:17:21 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Maxim Levitsky'" <maximlevitsky@gmail.com>, ben-linux@fluff.org
Subject: Re: undefined reference to `mmc_pm_notify' when selected MMC
	without PM.
Message-ID: <20100816051721.GA17903@pengutronix.de>
References: <009801cb3adb$6550e400$2ff2ac00$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <009801cb3adb$6550e400$2ff2ac00$%kim@samsung.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Aug 13, 2010 at 08:33:40PM +0900, Kukjin Kim wrote:
> Kukjin Kim wrote:
> > 
> > Hi,
> > 
> > Following is build error when selected MMC without PM.
> > 
> > drivers/built-in.o: In function `mmc_alloc_host':
> > drivers/mmc/core/host.c:108: undefined reference to `mmc_pm_notify'
> > make[1]: *** [.tmp_vmlinux1] Error 1
> > make: *** [sub-make] Error 2
> > 
> > That is added from Maxim's ' mmc: fix all hangs related to mmc/sd card
> > insert/removal during suspend/resume '
> > (commit ID: 4c2ef25fe0b847d2ae818f74758ddb0be1c27d8e)
> > 
> > Below is temporary patch for avoiding build error.
> > But I'm not sure about this... :-(
> > 
> > ---
> > 
> > diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
> > index 0efe631..d80cfdc 100644
> > --- a/drivers/mmc/core/host.c
> > +++ b/drivers/mmc/core/host.c
> > @@ -86,7 +86,9 @@ struct mmc_host *mmc_alloc_host(int extra, struct device
> > *dev)
> >         init_waitqueue_head(&host->wq);
> >         INIT_DELAYED_WORK(&host->detect, mmc_rescan);
> >         INIT_DELAYED_WORK_DEFERRABLE(&host->disable,
> > mmc_host_deeper_disable);
> > +#ifdef CONFIG_PM
> >         host->pm_notify.notifier_call = mmc_pm_notify;
> > +#endif
> > 
> >         /*
> >          * By default, hosts do not support SGIO or large requests.
> > 
> > ---
> 
> Kindly ignore this stuff because I found Uwe's same patch just now ;-)
> Sorry for bothering.
For those who care:

	http://mid.gmane.org/1281691473-15481-1-git-send-email-u.kleine-koenig@pengutronix.de

Kgene, do you care to ack this change as it may prod akpm in taking the
fix a bit earlier?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

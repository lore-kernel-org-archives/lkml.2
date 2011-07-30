Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab1G3TCc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 15:02:32 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:54525 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab1G3TC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 15:02:28 -0400
Date: Sat, 30 Jul 2011 12:02:20 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: riyer@nvidia.com, rydberg@euromail.se, olof@lixom.net, amartin@nvidia.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v1] Input: tegra-kbc - fix computation of polling time
Message-ID: <20110730190220.GA5686@core.coreip.homeip.net>
References: <1311981417-31865-1-git-send-email-riyer@nvidia.com>
 <20110730104101.GA12309@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110730104101.GA12309@avionic-0098.mockup.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 12:41:01PM +0200, Thierry Reding wrote:
> * riyer@nvidia.com wrote:
> > From: Rakesh Iyer <riyer@nvidia.com>
> > 
> > Fix a constant definition and computation of polling time.
> > 
> > Signed-off-by: Rakesh Iyer <riyer@nvidia.com>
> > ---
> >  drivers/input/keyboard/tegra-kbc.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
> > index da3828f..263f6fc 100644
> > --- a/drivers/input/keyboard/tegra-kbc.c
> > +++ b/drivers/input/keyboard/tegra-kbc.c
> > @@ -37,7 +37,7 @@
> >  #define KBC_ROW_SCAN_DLY	5
> >  
> >  /* KBC uses a 32KHz clock so a cycle = 1/32Khz */
> > -#define KBC_CYCLE_USEC	32
> > +#define KBC_CYCLE_MS	32
> >  
> >  /* KBC Registers */
> >  
> > @@ -647,7 +647,7 @@ static int __devinit tegra_kbc_probe(struct platform_device *pdev)
> >  	debounce_cnt = min(pdata->debounce_cnt, KBC_MAX_DEBOUNCE_CNT);
> >  	scan_time_rows = (KBC_ROW_SCAN_TIME + debounce_cnt) * num_rows;
> >  	kbc->repoll_dly = KBC_ROW_SCAN_DLY + scan_time_rows + pdata->repeat_cnt;
> > -	kbc->repoll_dly = ((kbc->repoll_dly * KBC_CYCLE_USEC) + 999) / 1000;
> > +	kbc->repoll_dly = (kbc->repoll_dly + KBC_CYCLE_MS - 1) / KBC_CYCLE_MS;
> 
> You might want to consider using DIV_ROUND_UP for this.

Indeed. Adjusted locally and applied.

Thanks.

-- 
Dmitry

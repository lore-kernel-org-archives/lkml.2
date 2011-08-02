Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab1HBQuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 12:50:44 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6892 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554Ab1HBQuh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 12:50:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 02 Aug 2011 09:50:25 -0700
From: Rakesh Iyer <riyer@nvidia.com>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>,
        Thierry Reding <thierry.reding@avionic-design.de>
CC: "rydberg@euromail.se" <rydberg@euromail.se>,
        "olof@lixom.net" <olof@lixom.net>, Allen Martin <AMartin@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Date: Tue, 2 Aug 2011 09:50:25 -0700
Subject: RE: [PATCH v1] Input: tegra-kbc - fix computation of polling time
Thread-Topic: [PATCH v1] Input: tegra-kbc - fix computation of polling time
Thread-Index: AcxO6zpQWjD/SPtbS5Wa3/n8kUjYVwCSN2Xg
Message-ID: <1FC56210173BB445BD77F608D6FB8D033C90FB5CC6@HQMAIL03.nvidia.com>
References: <1311981417-31865-1-git-send-email-riyer@nvidia.com>
 <20110730104101.GA12309@avionic-0098.mockup.avionic-design.de>
 <20110730190220.GA5686@core.coreip.homeip.net>
In-Reply-To: <20110730190220.GA5686@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Dmitry and Thierry.

Regards
Rakesh

> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Saturday, July 30, 2011 12:02 PM
> To: Thierry Reding
> Cc: Rakesh Iyer; rydberg@euromail.se; olof@lixom.net; Allen Martin; linux-
> kernel@vger.kernel.org; linux-input@vger.kernel.org
> Subject: Re: [PATCH v1] Input: tegra-kbc - fix computation of polling time
> 
> On Sat, Jul 30, 2011 at 12:41:01PM +0200, Thierry Reding wrote:
> > * riyer@nvidia.com wrote:
> > > From: Rakesh Iyer <riyer@nvidia.com>
> > >
> > > Fix a constant definition and computation of polling time.
> > >
> > > Signed-off-by: Rakesh Iyer <riyer@nvidia.com>
> > > ---
> > >  drivers/input/keyboard/tegra-kbc.c |    4 ++--
> > >  1 files changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
> > > index da3828f..263f6fc 100644
> > > --- a/drivers/input/keyboard/tegra-kbc.c
> > > +++ b/drivers/input/keyboard/tegra-kbc.c
> > > @@ -37,7 +37,7 @@
> > >  #define KBC_ROW_SCAN_DLY	5
> > >
> > >  /* KBC uses a 32KHz clock so a cycle = 1/32Khz */
> > > -#define KBC_CYCLE_USEC	32
> > > +#define KBC_CYCLE_MS	32
> > >
> > >  /* KBC Registers */
> > >
> > > @@ -647,7 +647,7 @@ static int __devinit tegra_kbc_probe(struct platform_device
> *pdev)
> > >  	debounce_cnt = min(pdata->debounce_cnt, KBC_MAX_DEBOUNCE_CNT);
> > >  	scan_time_rows = (KBC_ROW_SCAN_TIME + debounce_cnt) * num_rows;
> > >  	kbc->repoll_dly = KBC_ROW_SCAN_DLY + scan_time_rows + pdata->repeat_cnt;
> > > -	kbc->repoll_dly = ((kbc->repoll_dly * KBC_CYCLE_USEC) + 999) / 1000;
> > > +	kbc->repoll_dly = (kbc->repoll_dly + KBC_CYCLE_MS - 1) / KBC_CYCLE_MS;
> >
> > You might want to consider using DIV_ROUND_UP for this.
> 
> Indeed. Adjusted locally and applied.
> 
> Thanks.
> 
> --
> Dmitry

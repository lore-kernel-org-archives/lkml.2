Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab1LZDQw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 22:16:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:9037 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664Ab1LZDQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 22:16:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="90262190"
Date: Mon, 26 Dec 2011 11:16:17 +0800
From: Feng Tang <feng.tang@intel.com>
To: Feng Tang <feng.tang@intel.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Clark, Joel" <joel.clark@intel.com>
Subject: Re: [PATCH 2/2] Input: tsc2007 - Add a z1_low_threshhold platform
 data parameter
Message-ID: <20111226111617.4523050f@feng-i7>
In-Reply-To: <20111205133541.74b72788@feng-i7>
References: <1322554378-348-1-git-send-email-feng.tang@intel.com>
	<1322554378-348-2-git-send-email-feng.tang@intel.com>
	<20111129092310.GB21758@core.coreip.homeip.net>
	<20111130103418.4514b630@feng-i7>
	<20111201054726.GC16816@core.coreip.homeip.net>
	<20111201141948.13162071@feng-i7>
	<20111201084524.GB31610@core.coreip.homeip.net>
	<20111201170455.2e8ebcfc@feng-i7>
	<20111204085405.GD14593@core.coreip.homeip.net>
	<20111205133541.74b72788@feng-i7>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Mon, 5 Dec 2011 13:35:41 +0800
Feng Tang <feng.tang@intel.com> wrote:

> > > 			/*
> > > 			 * Sample found inconsistent by debouncing
> > > or pressure is
> > > 			 * beyond the maximum. Don't report it to
> > > user space,
> > > 			 * repeat at least once more the
> > > measurement. */
> > > 			dev_dbg(&ts->client->dev, "ignored pressure
> > > %d\n", rt); }
> > 
> > What I meant that we need to ajust the logic to _exit_ the loop if we
> > receive several samples with rt > max_rt instead of adding a new
> > parameter.
> 
> Yes, I did try a similar way to set a retry limit which also works
> basically, code is like this
> 
> @@ -169,6 +169,7 @@ static irqreturn_t tsc2007_soft_irq(int irq, void *handle)
>         struct tsc2007 *ts = handle;
>         struct input_dev *input = ts->input;
>         struct ts_event tc;
> +       u32 max_retry = 2;
>         u32 rt;
>  
>         while (!ts->stopped && tsc2007_is_pen_down(ts)) {
> @@ -206,6 +207,8 @@ static irqreturn_t tsc2007_soft_irq(int irq, void *handle)
>                          * repeat at least once more the measurement.
>                          */
>                         dev_dbg(&ts->client->dev, "ignored pressure %d\n",
> rt);
> +                       if (!--max_retry)
> +                               break;
>                 }
> 
> 
> But I still have some concerns:
> 1. How many retries should we try? the tsc2007_read_values() will take about
> 70 ms on our platform, plus the "poll_period", one retry will take about
> 100ms. 2. I checked the noise data, its z1 value is always in a range from 9
> to 13, while the real data's z1 is always bigger than 300. So I think there
> is a very clear gap to tell the noise data from valid data by z1 value.
> 
> How do you think about it?

Any further comments?

Thanks,
Feng


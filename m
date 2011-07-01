Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab1GAOc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 10:32:56 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:20009 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679Ab1GAOcx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 10:32:53 -0400
Subject: Re: [PATCH V2] MMC: PM: add suspend/resume in atmel-mci
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        cjb@laptop.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@avr32linux.org
In-Reply-To: <4E0DD816.7070104@atmel.com>
References: <201106292339.12402.rjw@sisk.pl>
	 <1309441781-11012-1-git-send-email-nicolas.ferre@atmel.com>
	 <20110630131342.GK11559@pengutronix.de>  <4E0DD816.7070104@atmel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Fri, 01 Jul 2011 16:32:34 +0200
Message-ID: <1309530754.4373.3.camel@hcegtvedt.norway.atmel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 01 Jul 2011 14:32:36.0283 (UTC) FILETIME=[B8C048B0:01CC37FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-01 at 16:22 +0200, Nicolas Ferre wrote:
> Le 30/06/2011 15:13, Uwe Kleine-König :

<snipp>

> Well, actually for the current implementation the only return code is... 0.
> And here I try to have a king of best effort approach ;-)
> 
> >> +			}
> >> +			return ret;
> >> +		}
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int atmci_resume(struct device *dev)
> >> +{
> >> +	struct atmel_mci *host = dev_get_drvdata(dev);
> >> +	struct atmel_mci_slot *slot;
> >> +	int i, ret;
> >> +
> >> +	for (i = 0; i < ATMEL_MCI_MAX_NR_SLOTS; i++) {
> >> +		slot = host->slot[i];
> >> +		if (!slot)
> >> +			continue;
> >> +		ret = mmc_resume_host(slot->mmc);
> >> +		if (ret < 0)
> >> +			return ret;
> > Maybe you should try to resume host 5 even if resuming host 4 failed?
> 
> In fact all other drivers that are dealing with multiple slots are doing
> the same... So I have difficulties to know the truth.
> The question is: is it better to return an error to the "resume"
> function so that we are called later again or do we have to do our best
> to thaw everything out?

Detect failures and return the error value, but also try to resume the
other slots.

You must however then keep track of which are restored for later calls
to resume AFAICT.

<snipp>

-- 
Hans-Christian Egtvedt


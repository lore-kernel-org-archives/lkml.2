Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab2E3H1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:27:24 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38682 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962Ab2E3H1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:27:22 -0400
Date: Wed, 30 May 2012 09:27:12 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V2 3/6] time: keep track of the pending utc/tai
 threshold
Message-ID: <20120530072712.GA20140@localhost.localdomain>
References: <20120523191747.GA2348@netboy.at.omicron.at>
 <4FBD4613.7040003@linaro.org>
 <20120524064340.GA2180@netboy.at.omicron.at>
 <20120524065726.GB2180@netboy.at.omicron.at>
 <4FC57BF9.5010608@linaro.org>
 <4FC57CAA.3030809@us.ibm.com>
 <20120530051138.GA3356@netboy.at.omicron.at>
 <4FC5B682.4010509@us.ibm.com>
 <20120530061931.GA3072@netboy.at.omicron.at>
 <4FC5BCDF.20807@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC5BCDF.20807@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 11:23:27PM -0700, John Stultz wrote:
> On 05/29/2012 11:19 PM, Richard Cochran wrote:
> >On Tue, May 29, 2012 at 10:56:18PM -0700, John Stultz wrote:
> >>On 05/29/2012 10:11 PM, Richard Cochran wrote:
> >>>On Tue, May 29, 2012 at 06:49:30PM -0700, John Stultz wrote:
> >>>>diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> >>>>index 6e46cac..81c76a9 100644
> >>>>--- a/kernel/time/timekeeping.c
> >>>>+++ b/kernel/time/timekeeping.c
> >>>>@@ -962,6 +962,7 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
> >>>>  		timekeeper.xtime.tv_sec++;
> >>>>  		leap = second_overflow(timekeeper.xtime.tv_sec);
> >>>>  		timekeeper.xtime.tv_sec += leap;
> >>>>+		timekeeper.wall_to_monotonic.tv_sec -= leap;
> >>>Don't you need this in update_wall_time() too?
> >>Yep. Good point.
> >Okay, so I can confirm that this fixes the CLOCK_MONOTONIC timer issue
> >during a leap second.
> Thanks! Is it ok if I add your Tested-by:  to the patch?

Yes, by all means, thanks.

Richard

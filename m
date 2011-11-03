Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab1KCOCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 10:02:48 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:37273 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab1KCOCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 10:02:02 -0400
Message-ID: <1320328869.3681.17.camel@js-netbook>
Subject: Re: [PATCH] clocksource: Avoid selecting mult values that might
 overflow when adjusted
From: John Stultz <john.stultz@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Yong Zhang <yong.zhang0@gmail.com>,
        David Daney <ddaney.cavm@gmail.com>
Date: Thu, 03 Nov 2011 10:01:09 -0400
In-Reply-To: <alpine.LFD.2.02.1111031425200.2829@ionos>
References: <1320264087-3413-1-git-send-email-john.stultz@linaro.org>
	 <alpine.LFD.2.02.1111031304210.2829@ionos>
	 <1320325819.2892.1.camel@js-netbook>
	 <alpine.LFD.2.02.1111031425200.2829@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11110314-3352-0000-0000-0000008BD119
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 14:26 +0100, Thomas Gleixner wrote:
> On Thu, 3 Nov 2011, John Stultz wrote:
> > On Thu, 2011-11-03 at 13:05 +0100, Thomas Gleixner wrote:
> > > On Wed, 2 Nov 2011, John Stultz wrote:
> > > >  
> > > > +	WARN_ONCE(timekeeper.mult+adj >
> > > > +			timekeeper.clock->mult + timekeeper.clock->maxadj,
> > > > +			"Adjusting more then 11%%");
> > > 
> > > Shouldn't we rather limit the update instead of just warn and overflow ?
> > 
> > Well, I'm hesitant to commit to that, just yet. So I figured I'd start
> > with the warning.
> 
> OTOH, we know right there that we might warp 32bit and confuse the
> hell out of timekeeping, which is not a real good thing either.

Oh certainly, but two things:
1) The 11% max is not the actual overflow edge. Its just calculated as
safe. The overflow could as far out as ~22%.

2) This is the first case in however many years I've heard of of mult
overflowing. So before we go changing the NTP code (which is really
terribly complex, but has been working fairly well for awhile) I want to
have some sense that the 11% max adjustment assumption is really
correct.

But maybe I'm being too conservative? If we do limit the adjustment
keeping the warning, I guess we'd know why things blew up on previously
working machines. 

thanks
-john


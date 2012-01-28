Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab2A1Dxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 22:53:54 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48675 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab2A1Dxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 22:53:53 -0500
Date: Sat, 28 Jan 2012 09:22:21 +0530
From: Rabin Vincent <rabin@rab.in>
To: John Stultz <john.stultz@linaro.org>
Cc: Andreas Friedrich <afrie@gmx.net>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Subject: Re: REGRESSION 3.2-rcX: RTC auto poweron after 5 minutes
Message-ID: <20120128035221.GA19279@debian>
References: <20111226145841.GA26578@upset.ux.pdb.fsc.net>
 <20111227105708.GA29960@upset.ux.pdb.fsc.net>
 <CAH+eYFBuK+-md-9QPQ8Z4DSNvKbyOEHg0EyRa2-DaVOZFi=hYQ@mail.gmail.com>
 <1327365073.11738.2.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327365073.11738.2.camel@work-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 04:31:13PM -0800, John Stultz wrote:
> On Tue, 2011-12-27 at 20:07 +0530, Rabin Vincent wrote:
> > diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
> > index 3bcc7cf..54a3b5e 100644
> > --- a/drivers/rtc/interface.c
> > +++ b/drivers/rtc/interface.c
> > @@ -778,16 +778,10 @@ static int rtc_timer_enqueue(struct rtc_device
> > *rtc, struct rtc_timer *timer)
> > 
> >  static void rtc_alarm_disable(struct rtc_device *rtc)
> >  {
> > -	struct rtc_wkalrm alarm;
> > -	struct rtc_time tm;
> > -
> > -	__rtc_read_time(rtc, &tm);
> > -
> > -	alarm.time = rtc_ktime_to_tm(ktime_add(rtc_tm_to_ktime(tm),
> > -				     ktime_set(300, 0)));
> > -	alarm.enabled = 0;
> > +	if (!rtc->ops || !rtc->ops->alarm_irq_enable)
> > +		return;
> > 
> > -	___rtc_set_alarm(rtc, &alarm);
> > +	rtc->ops->alarm_irq_enable(rtc->dev.parent, false);
> >  }
> > 
> 
> 	Just wanted to close out on this. I know this change worked for
> Andreas, but did it also resolve the original issue for you?

Yes, the original issue remains fixed after this change.

Thanks.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab1CSBPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 21:15:48 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43156 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab1CSBPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 21:15:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=iR5KaOoyMaDB6vS2R6e3gDkViWwKGuoQyIcQTFcp1odjGzcFR7QfleCKqdhwPI0yzF
         jUZ6gY3Xnb3QzhcMV3sy9eRKcZw+hzVZ9Ec67zDzohu5rw9cqlftKVazLxrgnmElAeWT
         LXiayKnshnI3rcCW7Jht7QVeXPB2KdPKQ7oT8=
Date: Sat, 19 Mar 2011 09:15:30 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: vapier@gentoo.org
Cc: john.stultz@linaro.org, linux-kernel@vger.kernel.org, stable@kernel.org,
        rtc-linux@googlegroups.com, a.zummo@towertech.it
Subject: Re: [PATCH] rtc-bfin: add missing "return 0" in new alarm func> On
 Fri, Mar 18, 2011 at 04:26:24AM -0400, Mike Frysinger wrote:
Message-ID: <20110319011527.GA1972@gmail.com>
Mail-Followup-To: vapier@gentoo.org, john.stultz@linaro.org,
	linux-kernel@vger.kernel.org, stable@kernel.org,
	rtc-linux@googlegroups.com, a.zummo@towertech.it
References: <1300436784-26543-1-git-send-email-vapier@gentoo.org>
 <AANLkTinjTVpNbkiNKpbc7kvtMVeXfjifr7Q5Dg4B9oGE@mail.gmail.com>
 <AANLkTinC_WCh2XXk-irG9d5QZvVU439_FYWZzTGQLbG7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinC_WCh2XXk-irG9d5QZvVU439_FYWZzTGQLbG7@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	On Sat, Mar 19, 2011 at 09:10:14AM +0800, jiaweiwei wrote:
> 
> >> the end leading to the build warning:
> >>        drivers/rtc/rtc-bfin.c: In function 'bfin_rtc_alarm_irq_enable':
> >>        drivers/rtc/rtc-bfin.c:253: warning: control reaches end of
> >> non-void function
> >>
> >> CC: stable@kernel.org
> >> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Harry Wei <harryxiyou@gmail.com>
> >> ---
> >>  drivers/rtc/rtc-bfin.c |    2 ++
> >>  1 files changed, 2 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
> >> index 17971d9..0e61e2d 100644
> >> --- a/drivers/rtc/rtc-bfin.c
> >> +++ b/drivers/rtc/rtc-bfin.c
> >> @@ -276,6 +276,8 @@ static int bfin_rtc_alarm_irq_enable(struct device
> >> *dev, unsigned int enabled)
> >>                bfin_rtc_int_set_alarm(rtc);
> >>        else
> >>                bfin_rtc_int_clear(~(RTC_ISTAT_ALARM |
> >> RTC_ISTAT_ALARM_DAY));
> >> +
> >> +       return 0;
> >>  }
> >>
> >>  static int bfin_rtc_read_time(struct device *dev, struct rtc_time *tm)
> >> --
> >> 1.7.4.1
> >>
>alarm_irq_enable function forgot to add a "return 0" to
>> the end leading to the build warning:
>>       drivers/rtc/rtc-bfin.c: In function 'bfin_rtc_alarm_irq_enable':
>>       drivers/rtc/rtc-bfin.c:253: warning: control reaches end of non-void function
>
>   I am sure we should give a return-value
> but whether it is '0'? Maybe it should return
> other value.
>   Can you give some explanations for yours.

>read the interface.c code ... this func returns 0 on "success".  i
>dont know what other possible value this could return.
Oh, it is true.

Thanks.
Best Regards.
Harry Wei.

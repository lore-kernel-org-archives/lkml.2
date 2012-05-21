Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240Ab2EUUZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 16:25:06 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42439 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab2EUUZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 16:25:04 -0400
Message-ID: <4FBAA499.1070905@linaro.org>
Date: Mon, 21 May 2012 13:24:57 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V2 4/6] time: introduce leap second functional interface
References: <cover.1337348892.git.richardcochran@gmail.com> <eee0b50afdea829c727d6210afb8299a4cf30981.1337348892.git.richardcochran@gmail.com> <4FBA82DF.9060009@linaro.org> <20120521191844.GC19812@netboy.at.omicron.at>
In-Reply-To: <20120521191844.GC19812@netboy.at.omicron.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052120-7182-0000-0000-00000190D357
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2012 12:18 PM, Richard Cochran wrote:
> On Mon, May 21, 2012 at 11:01:03AM -0700, John Stultz wrote:
>> On 05/18/2012 07:09 AM, Richard Cochran wrote:
>>> +
>>> +int timekeeping_gettod_status(struct timespec *ts, time_t *offset);
>>> +
>>> +void timekeeping_delete_leap_second(void);
>>> +
>>> +void timekeeping_finish_leap_second(void);
>>> +
>>> +void timekeeping_insert_leap_second(void);
>>> +
>>> +#endif
>> Why not just add these to time.h?
> This is a private interface only for ntp.c, not for the whole rest of
> the kernel via time.h.
Hrm.  I prefer to keep things fairly flat (even having time.h and 
timex.h bugs me somewhat).  But having such a separation could be 
useful, but maybe at a slightly more coarse level. Something like 
timekeeping-internal.h and time.h, splitting all the general accessors 
away from the non-general.

I just don't want to have a ton of stray .h files, but maybe I'm 
prematurely worrying about it.

> BTW this highlights the very icky incestuous relationship between
> ntp.c and timekeeper.c. Probably there should be a comment documenting
> the (unspoken) locking sequence for ntp_lock and timekeeper.lock.
>
The locking order is pretty straight forward: timekeeper.lock -> 
ntp_lock.   This only gets messy when you require timekeeping data from 
the ntp context, but usually we provide the required data via the 
caller.  But better documentation is always welcome.

thanks
-john


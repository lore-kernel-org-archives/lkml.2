Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab2EET1p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 15:27:45 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:54627 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046Ab2EET1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 15:27:44 -0400
Message-ID: <4FA57F2A.2090109@linaro.org>
Date: Sat, 05 May 2012 12:27:38 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] ntp: advertise correct TAI offset during leap second
References: <cover.1335442155.git.richardcochran@gmail.com> <7af92d6eabef55ddce07007ea515eda2e1474c52.1335442155.git.richardcochran@gmail.com> <4F9B1C55.50004@linaro.org> <20120428061718.GA2258@netboy.at.omicron.at> <4F9EEC86.8010201@linaro.org> <20120501061605.GC2243@netboy.at.omicron.at> <20120505100259.GA8294@netboy.at.omicron.at>
In-Reply-To: <20120505100259.GA8294@netboy.at.omicron.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050519-1976-0000-0000-00000CF19A53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2012 03:02 AM, Richard Cochran wrote:
> On Tue, May 01, 2012 at 08:16:05AM +0200, Richard Cochran wrote:
>> On Mon, Apr 30, 2012 at 12:48:22PM -0700, John Stultz wrote:
>>> On 04/27/2012 11:17 PM, Richard Cochran wrote:
>>>> Wait a minute. If user space manages this variable, then shouldn't the
>>>> kernel leave it alone?
>>> Right. That's why I'm asking. I actually haven't spent much time
>>> looking at how the tai value provided via adjtimex is handled, and I
>>> want to make sure its ok if we modify it from the kernel.
>> We *are* already modifying it in kernel, but at the wrong time.
>>
>> I don't know either what ntpd does, but I will find out.
>>
>> [ But if ntpd just uses adjtimex() to use the kernel as storage for
>>    variables, then that is really stupid. ]
> I took a look at ntp-4.2.6p5, and ntpd unconditionally sets the TAI
> offset using MOD_TAI when it thinks the offset has changed.
>
> But I think it won't hurt if the kernel changes the offset
> automatically, since ntpd will just try and set the same value again.
Assuming that it doesn't happen right before the tick that adjusts the 
leapsecond.  :)
But that's a pre-existing bug and not a reason to block your patch that 
improves things.

Thanks for the extra due-diligence here!

thanks
-john


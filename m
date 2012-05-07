Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab2EGRg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 13:36:56 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:44217 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665Ab2EGRgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 13:36:55 -0400
Message-ID: <4FA80832.80403@linaro.org>
Date: Mon, 07 May 2012 10:36:50 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V1 4/5] timekeeping: Offer an interface to manipulate
 leap seconds.
References: <cover.1335510125.git.richardcochran@gmail.com> <52e139c98370c405288cbbb4ac76c435dc36731f.1335510125.git.richardcochran@gmail.com> <4F9B26D3.1030100@linaro.org> <20120505101735.GB8294@netboy.at.omicron.at>
In-Reply-To: <20120505101735.GB8294@netboy.at.omicron.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050717-5518-0000-0000-000004367DDC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2012 03:17 AM, Richard Cochran wrote:
> On Fri, Apr 27, 2012 at 04:08:03PM -0700, John Stultz wrote:
>> On 04/27/2012 01:12 AM, Richard Cochran wrote:
>>
>>> +#ifdef CONFIG_DELETE_LEAP_SECONDS
>>> +	/* Remembers whether to insert or to delete. */
>>> +	int insert_leapsecond;
>>> +#endif
>> I'm not a big fan of this additional config option.  The maintenance
>> burden for the extra condition is probably not worth the code size
>> trade-off.  Or it needs way more justification.
> Out of curiosity, I looked at ntp-4.2.6p5 to see if they really
> support deleting leap seconds or not. Even though the code appears to
> try and support them, I spotted a few bugs. There is a hard coded
> assumption that the TAI offset is increasing.
>
> This is just the reason why I suggest not supporting deletions (or
> only conditionally for nit pickers). You can code it up, but it will
> be in vain, since the code will never be tested or used in practice.
> Code that is never executed is a true mainenance burden by definition.
>
Well, testing it from a kernel perspective isn't a problem as its easy 
to write up a userland app that exercises the code path. But I agree its 
unlikely to be used in practice.

And you're argument of the added maintenance burden is reasonable. And 
while I don't find it terrible to keep, I'd *much* rather just remove it 
then add a config option and more #ifdefery.  Even so, such a removal 
needs to be an independent patch that can be discussed and argued on its 
own without mixing in other features.

thanks
-john


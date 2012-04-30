Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab2D3Tt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 15:49:26 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:52232 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756454Ab2D3TtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 15:49:24 -0400
Message-ID: <4F9EEC86.8010201@linaro.org>
Date: Mon, 30 Apr 2012 12:48:22 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] ntp: advertise correct TAI offset during leap second
References: <cover.1335442155.git.richardcochran@gmail.com> <7af92d6eabef55ddce07007ea515eda2e1474c52.1335442155.git.richardcochran@gmail.com> <4F9B1C55.50004@linaro.org> <20120428061718.GA2258@netboy.at.omicron.at>
In-Reply-To: <20120428061718.GA2258@netboy.at.omicron.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12043019-7182-0000-0000-000001643D43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2012 11:17 PM, Richard Cochran wrote:
> On Fri, Apr 27, 2012 at 03:23:17PM -0700, John Stultz wrote:
>> On 04/26/2012 05:11 AM, Richard Cochran wrote:
>>> When repeating a UTC time value during a leap second (when the UTC
>>> time should be 23:59:60), the TAI timescale should not stop. The kernel
>>> NTP code increments the TAI offset one second too late. This patch fixes
>>> the issue by incrementing the offset during the leap second itself.
>>>
>>> Signed-off-by: Richard Cochran<richardcochran@gmail.com>
>> This looks good to me. Although, have you actually tested against an
>> ntp client that sets the tai offset to make sure you're not
>> duplicating any ADJ_TAI adjustment it might make?
> No, I cooked up my own test program that uses the adjtimex interface
> directly. I really am not very familiar with the ntp.org software.
>
> Wait a minute. If user space manages this variable, then shouldn't the
> kernel leave it alone?

Right. That's why I'm asking. I actually haven't spent much time looking 
at how the tai value provided via adjtimex is handled, and I want to 
make sure its ok if we modify it from the kernel.


> This David Mills paper [1] gives a leap second example that does it
> the "other" way from Linux (see Figure 4), repeating the new epoch
> rather than the leap second. It may well be that ntp.org servers do
> behave that way. However, the NIST file claims that this way is
> unusual.
>
> So, you have a good question. But, if ntp.org uses the NIST second
> method, shouldn't Linux do the same?
>
Not sure I'm following here.  In Linux 23:59:60 is represented as 
23:59:59 + TIME_OOP.  Could you expand on what in particular is 
inconsistent here?

thanks
-john


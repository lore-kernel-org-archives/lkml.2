Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab2DSNGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 09:06:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632Ab2DSNGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 09:06:40 -0400
Message-ID: <4F900DD6.50105@redhat.com>
Date: Thu, 19 Apr 2012 09:06:30 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Salman Qazi <sqazi@google.com>, stable@kernel.org
Subject: Re: [PATCH] clocksource, prevent overflow in clocksource_cyc2ns
References: <1333552260-1170-1-git-send-email-prarit@redhat.com> <4F7C8C3E.1020203@us.ibm.com> <4F7C9402.3090602@redhat.com> <4F7CF094.5020201@us.ibm.com> <4F7D8FA1.1010107@redhat.com> <4F8F4C31.7010209@linaro.org> <4F8F555F.7040404@redhat.com> <4F8F59E2.4080301@linaro.org> <alpine.LFD.2.02.1204191437560.2542@ionos> <alpine.LFD.2.02.1204191451350.2542@ionos>
In-Reply-To: <alpine.LFD.2.02.1204191451350.2542@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/19/2012 08:52 AM, Thomas Gleixner wrote:
> On Thu, 19 Apr 2012, Thomas Gleixner wrote:
> 
>> On Wed, 18 Apr 2012, John Stultz wrote:
>>> On 04/18/2012 04:59 PM, Prarit Bhargava wrote:
>>>>

>> No. The show_state() part prints into the buffer. But it's not
>> guaranteed that the buffer is flushed right away. It could be flushed
>> later as well in a different context. And of course the flush code
>> runs with interrupts disabled and dumping out a gazillion of lines
>> over serial will cause the same hickup. Just planting random
>> touch_watchdog() calls into the code is not the right approach,
>> really.
>>
>> We should think about the reasons why we have interrupts disabled for
>> so much time. Is that really, really necessary ?

In the case of the sysrq-t, I would argue that it is.  The whole point behind
the sysrq-t is that we're capturing the *current* state of the system.  Having
that output effected by interrupts seems like a bad idea.

> 
> I'm not against making the clocksource code more robust, but I don't
> want to add crap there just to cope with complete madness elsewhere.

Maybe I came off the wrong way but I completely agree with that sentiment.  Like
yourself, I'm looking for a correct fix rather than a fast fix.

Sorry that I haven't provided any debug info but I'm still in the gathering data
stage atm.  It was just John's ping that made me "brain dump" the current info I
had.

P.

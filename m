Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab2DYMaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:30:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434Ab2DYMaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:30:06 -0400
Message-ID: <4F97EE46.4070305@redhat.com>
Date: Wed, 25 Apr 2012 08:29:58 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Salman Qazi <sqazi@google.com>, stable@kernel.org
Subject: Re: [PATCH] clocksource, prevent overflow in clocksource_cyc2ns
References: <1333552260-1170-1-git-send-email-prarit@redhat.com> <4F7C8C3E.1020203@us.ibm.com> <4F7C9402.3090602@redhat.com> <4F7CF094.5020201@us.ibm.com> <4F7D8FA1.1010107@redhat.com> <4F8F4C31.7010209@linaro.org> <4F8F555F.7040404@redhat.com> <4F8F59E2.4080301@linaro.org> <alpine.LFD.2.02.1204191437560.2542@ionos> <alpine.LFD.2.02.1204191451350.2542@ionos> <4F905576.6040406@linaro.org>
In-Reply-To: <4F905576.6040406@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/19/2012 02:12 PM, John Stultz wrote:
> On 04/19/2012 05:52 AM, Thomas Gleixner wrote:
>> On Thu, 19 Apr 2012, Thomas Gleixner wrote:
>>
>>> We should think about the reasons why we have interrupts disabled for
>>> so much time. Is that really, really necessary ?
>> I'm not against making the clocksource code more robust, but I don't
>> want to add crap there just to cope with complete madness elsewhere.
>>
> 
> Very much agreed.

Hi John and Thomas,

After much analysis I have good news to report.  The good news is that the
problem with the random tsc failures was chased down to a script left running in
which sysrq-t's were executed over ping packets.  This, as I've previously
pointed out, can cause the tsc to be erroneously marked unstable.

[Aside: I hit myself with a big cluebat when I realized that all the failures
were occurring at the same wall-clock time, 3:00AM.  That couldn't be a
coincidence.]

I'm working with lwoodman to figure out a way to get rid of the locking (as
suggested by you Thomas) around the sysrq code.

P.

> -john
> 

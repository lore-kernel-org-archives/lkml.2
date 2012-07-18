Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab2GRXLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 19:11:13 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:45130 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab2GRXLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 19:11:11 -0400
Message-ID: <50074287.3080802@linaro.org>
Date: Wed, 18 Jul 2012 16:11:03 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] Allow CLOCK_TICK_RATE to be undefined
References: <1342543300-23460-1-git-send-email-catalin.marinas@arm.com> <20120718155141.232ae14c.akpm@linux-foundation.org>
In-Reply-To: <20120718155141.232ae14c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071823-7606-0000-0000-0000021BD027
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2012 03:51 PM, Andrew Morton wrote:
> On Tue, 17 Jul 2012 17:41:40 +0100
> Catalin Marinas <catalin.marinas@arm.com> wrote:
>
>> This patch allows an architecture to not define CLOCK_TICK_RATE, in
>> which case ACTHZ defaults to (HZ << 8).
> No reason was given for this change.
>
> So those people who are wondering "why don't you just define
> CLOCK_TICK_RATE" are made all sad.

I just queued this patch with a revised commit message:

     jiffies: Allow CLOCK_TICK_RATE to be undefined

     CLOCK_TICK_RATE is a legacy constant that defines the timer
     device's granularity. On hardware with particularly coarse
     granularity, this constant is used to reduce accumulated
     time error when using jiffies as a clocksource, by calculating
     the hardware's actual tick length rather then just assuming
     it is 1sec/HZ.

     However, for the most part this is unnecessary, as most modern
     systems don't use jiffies for their clocksource, and their
     tick device is sufficiently fine grained to avoid major error.

     Thus, this patch allows an architecture to not define
     CLOCK_TICK_RATE, in which case ACTHZ defaults to (HZ << 8).


Let me know if you'd like to see further improvements.

thanks
-john


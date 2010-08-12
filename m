Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760883Ab0HLTkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 15:40:18 -0400
Received: from lo.gmane.org ([80.91.229.12]:43173 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754346Ab0HLTkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 15:40:16 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: walt <w41ter@gmail.com>
Subject: Re: [BISECTED] Removing BKL causes stack trace during early bootup
Date: Thu, 12 Aug 2010 12:40:04 -0700
Message-ID: <4C644E14.60804@gmail.com>
References: <4C6438BF.9070608@gmail.com> <20100812182633.GB5369@nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
Cc: Robert Moore <robert.moore@intel.com>, Len Brown <len.brown@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@yahoo-wildcard.a05.yahoodns.net>,
        LKML <linux-kernel@vger.kernel.org>
X-Gmane-NNTP-Posting-Host: adsl-69-234-182-12.dsl.irvnca.pacbell.net
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b4pre) Gecko/20100809 Shredder/3.2a1pre
In-Reply-To: <20100812182633.GB5369@nowhere>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2010 11:26 AM, Frederic Weisbecker wrote:
> (Adding ACPI guys and LKML in Cc)
>
> On Thu, Aug 12, 2010 at 11:09:03AM -0700, walt wrote:
>> Hi guys.  This commit produces a non-fatal call trace very early during boot
>> on my dual-CPU amd64 machine (but not on my single-CPU x86):
>>
>> commit 5e3d20a68f63fc5a310687d81956c3b96e488b84
>> Author: Arnd Bergmann<arnd@xxxx.de>
>> Date:   Sun Jul 4 00:02:26 2010 +0200
>>
>>      init: Remove the BKL from startup code
>>
>
> Hi,
>
> Thanks for bisecting this.

> This is due to ACPI that does buggy checks and then sleeps too early.
>
> I'm attaching it here.

> diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
> index e5039a2..8da1e8c 100644
> --- a/include/acpi/platform/aclinux.h
> +++ b/include/acpi/platform/aclinux.h
> @@ -152,7 +152,7 @@ static inline void *acpi_os_acquire_object(acpi_cache_t * cache)
>   #include<linux/hardirq.h>
>   #define ACPI_PREEMPTION_POINT() \
>   	do { \
> -		if (!in_atomic_preempt_off()&&  !irqs_disabled()) \
> +		if (!in_atomic()&&  !irqs_disabled()) \
>   			cond_resched(); \
>   	} while (0)
>

Your patch eliminates my stack trace, thanks.  Must be the same trace.

Nick, thanks for your excellent hints.  The stack trace was obviously
scrolling off the top, as you suggested.  Next time I'll notice it :)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946531Ab2I1Vzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:55:36 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:49225 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946515Ab2I1Vza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:55:30 -0400
Message-ID: <50661CCA.8000900@linaro.org>
Date: Fri, 28 Sep 2012 14:55:22 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 12/12] time/jiffies: bring back unconditional LATCH definition
References: <1348868177-21205-1-git-send-email-arnd@arndb.de> <1348868177-21205-13-git-send-email-arnd@arndb.de>
In-Reply-To: <1348868177-21205-13-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092821-7606-0000-0000-0000040BA662
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 02:36 PM, Arnd Bergmann wrote:
> Patch a7ea3bbf5d "time/jiffies: Allow CLOCK_TICK_RATE to be undefined"
> breaks the compilation of targets that rely on the LATCH definition,
> because of recursive header file inclusion not defining CLOCK_TICK_RATE
> before it is checked here.
>
> This fixes the problem by moving LATCH back to where it was, but it
> seems that there are still cases where SHIFTED_HZ is defined incorrectly
> because of the same problem. Need to investigate further.
>
> Without this patch, building h7201_defconfig results in:
>
> arch/arm/mach-h720x/common.c: In function 'h720x_gettimeoffset':
> arch/arm/mach-h720x/common.c:50:73: error: 'LATCH' undeclared (first use in this function)
> arch/arm/mach-h720x/common.c:50:73: note: each undeclared identifier is reported only once for each function it appears in
> arch/arm/mach-h720x/common.c:51:1: warning: control reaches end of non-void function [-Wreturn-type]

Hrrm. Ok. I had a patch for 3.7 that tried to get rid of the generic 
CLOCK_TICK_RATE derived users, but that may not fly if there's still 
LATCH users around.  I guess I'll tweak it so we keep LATCH around, 
probably by mering your change into my tree.

I suspect the long term fix is to push the LATCH definition up into arch 
specific code that is using it, so it can be made dynamic instead of a 
compile time constant. Otherwise it might be hard to get a unified 
zImage working.  But for now I guess your current fix is good short-term.

thanks
-john


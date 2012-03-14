Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030574Ab2CNTrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 15:47:10 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57976 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030451Ab2CNTrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 15:47:01 -0400
Message-ID: <4F60F5B1.8070302@linaro.org>
Date: Wed, 14 Mar 2012 20:46:57 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Lee <rob.lee@linaro.org>, Jean Pihet <j-pihet@ti.com>,
        Kevin Hilman <khilman@ti.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: next-20120313 cpuidle freezes when booting
References: <alpine.LSU.2.00.1203131454500.1335@eggly.anvils> <4F608116.80508@linaro.org> <alpine.LSU.2.00.1203141156490.3826@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1203141156490.3826@eggly.anvils>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2012 08:03 PM, Hugh Dickins wrote:
> On Wed, 14 Mar 2012, Daniel Lezcano wrote:
>> On 03/13/2012 11:29 PM, Hugh Dickins wrote:
>>> Hi Stephen,
>>>
>>> Yesterday's 3.3.0-rc7-next-20120313 gives me unpredictable freezes
>>> on x86_64, on a ThinkPad T420s - I've not dared it on more machines.
>>>
>>> Usually when booting up (sometimes just after Freeing unused kernel
>>> memory, sometimes random places elsewhere), but occasionally it manages
>>> to get as far as X; doesn't usually manage to complete suspend+resume.
>>>
>>> 3.3.0-rc6-nex-20120309 behaved similarly; the last I tried before
>>> that was 3.3.0-rc5-next20120227, which was okay.
>>>
>>> Bisection led me to "cpuidle: Add common time keeping and irq enabling",
>>> (from the cpuidle-cons tree I think), and reverting that has so far
>>> given me a working system (it's a success if I complete this mail).
>>>
>>> Below is the patch I've used to revert it (for other people having
>>> problems with recent linux-next to try); but it's not quite correct,
>>> because you did a merge on conflicting trees there, and I didn't spend
>>> time to unravel all that, just get a working x86 system - since I've
>>> left out some of your merge (in arch/arm/kernel/Makefile and arch/arm/
>>> mach-at91/cpuidle.c), this reversion probably breaks arm as is.
>>
>> Hi Hugh,
>>
>> is it possible you give the cpuidle driver your host is using ?
>
> "grep IDLE .config" tells me:
>
> CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
> CONFIG_ARCH_HAS_DEFAULT_IDLE=y
> CONFIG_CPU_IDLE=y
> CONFIG_CPU_IDLE_GOV_LADDER=y
> CONFIG_CPU_IDLE_GOV_MENU=y
> CONFIG_INTEL_IDLE=y
> # CONFIG_I7300_IDLE is not set
>
> but I've a feeling that isn't what you need to know.

Thanks for these informations, I forgot to ask you for them.
By the way, do you have CONFIG_ARCH_HAS_CPU_RELAX  ?

> Is there some /proc or /sys file I can read to tell you?

Yes, the content of /sys/devices/system/cpu/cpuidle/current_driver
and /sys/devices/system/cpu/cpuidle/current_governor_ro


> Though if it's something that changes dynamically, then what
> I read now might not be what it would say when things go wrong.

No, that won't change, so the information should be enough for me to 
find the code path where the regression is.

> I expect you've realized by now, I haven't a clue about cpuidle
> drivers: I hadn't even realized that idleness needs a driver.

No problem, thanks for git bisecting and find the culprit :)

   -- Daniel



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


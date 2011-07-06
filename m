Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab1GFPI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 11:08:56 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:34203 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab1GFPIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 11:08:55 -0400
Message-ID: <4E1479EB.2060908@mvista.com>
Date: Wed, 06 Jul 2011 19:06:19 +0400
From: Vitaly Kuzmichev <vkuzmichev@mvista.com>
Reply-To: vkuzmichev@mvista.com
Organization: MontaVista Software, LLC
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Thunderbird/3.1.10
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Wim Van Sebroeck <wim@iguana.be>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Nicolas Pitre <nico@fluxnic.net>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V2 0/6] arm_smp_twd: mpcore_wdt: Fix MPCORE watchdog setup
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com> <1309892440-3260-1-git-send-email-vkuzmichev@mvista.com> <4E14337F.1050101@arm.com> <4E1454BD.7050607@mvista.com> <4E145787.9080600@arm.com>
In-Reply-To: <4E145787.9080600@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

On 07/06/2011 04:39 PM, Marc Zyngier wrote:
> On 06/07/11 13:27, Vitaly Kuzmichev wrote:
>> Hi Marc,
>>
>> On 07/06/2011 02:05 PM, Marc Zyngier wrote:
>> [...]
>>>> The series of patches is based on arm-platforms.git/local_timers_as_devices
>>>> branch since it looks like that it is going to be merged into the mainline.
>>>
>>> Be careful here. This branch is a work in progress, likely to change
>>> very quickly, contains code that has not been posted to the ML yet, and
>>> will probably eat your pet for breakfast. As far as mainline merging is
>>> concerned, there is still a long way to go (see the GIC consolidation
>>> patches, on which the local_timers_as_devices branch relies).
>>
>> I understand.
>> When do you plan to finish this job?
>> Would not it be better to prepare two sets of patches: first one for
>> linux-2.6/master with exported function, second for arm-platforms.git
>> with removing exported function and replacing use of it by
>> clk_get_rate(smp_twd) call?
>> Is there a chance in this case, that my patches will be merged much
>> earlier than yours?
> 
> Your guess is as good as mine. It all depends on people's bandwidth to
> review long series of patches (the particular branch you used is a merge
> of 3 different series), so I'd expect a smaller, less intrusive series
> to make it quicker than my monster patch sets... ;-)

Ok, but then we are coming back to the V1 series containing the
following patches:
  ARM: smp_twd: mpcore_wdt: Fix watchdog counter loading
  ARM: smp_twd: Fix typo in twd_timer_rate printout
  ARM: mpcore_wdt: Fix WDIOC_SETOPTIONS handling
  ARM: mpcore_wdt: Fix timer mode setup

The patches V2 5/6 (Add cpufreq notifier to reload counter) and V2 6/6
(Move declarations in a separate header) are useless without smp_twd
clock and can be threw out.

I will rebase and update V1 series and repost them soon.

Thanks,
Vitaly.

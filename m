Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab1GFMjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 08:39:47 -0400
Received: from service87.mimecast.com ([94.185.240.25]:51913 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753145Ab1GFMjp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 08:39:45 -0400
Message-ID: <4E145787.9080600@arm.com>
Date: Wed, 06 Jul 2011 13:39:35 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: "vkuzmichev@mvista.com" <vkuzmichev@mvista.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Wim Van Sebroeck <wim@iguana.be>, "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Nicolas Pitre <nico@fluxnic.net>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V2 0/6] arm_smp_twd: mpcore_wdt: Fix MPCORE watchdog setup
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com> <1309892440-3260-1-git-send-email-vkuzmichev@mvista.com> <4E14337F.1050101@arm.com> <4E1454BD.7050607@mvista.com>
In-Reply-To: <4E1454BD.7050607@mvista.com>
X-Enigmail-Version: 1.1.2
X-OriginalArrivalTime: 06 Jul 2011 12:39:31.0908 (UTC) FILETIME=[C1039040:01CC3BD9]
X-MC-Unique: 111070613393901001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/11 13:27, Vitaly Kuzmichev wrote:
> Hi Marc,
> 
> On 07/06/2011 02:05 PM, Marc Zyngier wrote:
> [...]
>>> The series of patches is based on arm-platforms.git/local_timers_as_devices
>>> branch since it looks like that it is going to be merged into the mainline.
>>
>> Be careful here. This branch is a work in progress, likely to change
>> very quickly, contains code that has not been posted to the ML yet, and
>> will probably eat your pet for breakfast. As far as mainline merging is
>> concerned, there is still a long way to go (see the GIC consolidation
>> patches, on which the local_timers_as_devices branch relies).
> 
> I understand.
> When do you plan to finish this job?
> Would not it be better to prepare two sets of patches: first one for
> linux-2.6/master with exported function, second for arm-platforms.git
> with removing exported function and replacing use of it by
> clk_get_rate(smp_twd) call?
> Is there a chance in this case, that my patches will be merged much
> earlier than yours?

Your guess is as good as mine. It all depends on people's bandwidth to
review long series of patches (the particular branch you used is a merge
of 3 different series), so I'd expect a smaller, less intrusive series
to make it quicker than my monster patch sets... ;-)

> If not, I will just rework patch 2/6 to remove exported and use only
> clock interface.

Make sure all TWD users are updated with the new clock before you merge
it then, or people are going to be surprised.

	M.
-- 
Jazz is not dead. It just smells funny...


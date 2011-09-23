Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab1IWQIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 12:08:13 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:49767 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751959Ab1IWQIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 12:08:11 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Koyamangalath\, Abhilash" <abhilash.kv@ti.com>
Cc: "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "tony\@atomide.com" <tony@atomide.com>,
        "linux\@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "V\, Aneesh" <aneesh@ti.com>,
        "Shilimkar\, Santosh" <santosh.shilimkar@ti.com>,
        "Menon\, Nishanth" <nm@ti.com>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lohithakshan\, Ranjith" <ranjithl@ti.com>
Subject: Re: [PATCH v2] AM3517 : support for suspend/resume
Organization: Texas Instruments, Inc.
References: <1316008126-7322-1-git-send-email-abhilash.kv@ti.com>
	<87obycqm2v.fsf@ti.com>
	<FCCFB4CDC6E5564B9182F639FC356087037AF843F0@dbde02.ent.ti.com>
Date: Fri, 23 Sep 2011 09:07:59 -0700
In-Reply-To: <FCCFB4CDC6E5564B9182F639FC356087037AF843F0@dbde02.ent.ti.com>
	(Abhilash Koyamangalath's message of "Fri, 23 Sep 2011 18:54:22
	+0530")
Message-ID: <87obybjl7k.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Koyamangalath, Abhilash" <abhilash.kv@ti.com> writes:

[...]

>>> @@ -485,6 +489,8 @@ console_still_active:
>>>
>>>  int omap3_can_sleep(void)
>>>  {
>>> +     if (cpu_is_omap3505() || cpu_is_omap3517())
>>> +             return 0;
>>
>> This needs to be a separate patch with a descriptive changelog and
>> justification as to why you can't do WFI in idle.
> [Abhilash K V]OK
>>
>> Adding something like this means the device will *never* attempt a WFI
>> during idle.
>
> [Abhilash K V] This patch was put in as dynamic sleep feature is not
> supported by the device, there are no C states etc. The only PM
> supported is forced suspend /resume. There is just one power-domain
> and it can be in ON or RET states.
>

If the device can WFI and hit retention in suspend, there should be no
not to target the same power state in idle.

You don't have to have CPUidle with multiple C-states to use idle.

>> I suspect that avoiding WFI in idle is masking a bug that you don't see
>> in the suspend path.
>
> [Abhilash K V] I need to recap a bit to find out if there is a better
> way to indicate the lack of "idle" feature.

Yes please.  From my POV, deciding not to go idle is a SW decision, not
a hardware decision.  As the same SW mechanisms are involved, whatever
power state that can be acheived from suspend should be targetted in
idle.

Kevin


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760112Ab1CDUbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 15:31:23 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:37883 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab1CDUbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 15:31:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HryajlnGzQG/7CGcKE+BNGviwbR0k0X39h6X2EtFuHZEqVnkT4XQHB4o0u3IVBtJu6
         HgfKFPnkY9gdnIoLyyPJrAyteoFXdz16hOSmQXpJ6xv4pPGcjSBA4AGZjFiD/UOXBt97
         V1DF7h4JLQDMIRaD9fdcdtkbN94dGhPqdgsZo=
Message-ID: <4D714C17.7080102@gmail.com>
Date: Fri, 04 Mar 2011 14:31:19 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: martin persson <martin.persson@stericsson.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        "linux-arm-kernel@lists-infradead.org" 
	<linux-arm-kernel@lists-infradead.org>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Rickard ANDERSSON <rickard.andersson@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Varun Swara <Varun.Swara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: twd: Adjust localtimer frequency with cpufreq notifiers
References: <1290060899-9786-1-git-send-email-ccross@android.com>	<AANLkTimCuV5N0jr8c949uONEvieQ5MDZ9KHDXtneG5AT@mail.gmail.com>	<4D70BE9D.4000507@stericsson.com> <AANLkTin7ZXYALOy_jk1uR3SbZA51nSnU-ncSjG+n_RPn@mail.gmail.com>
In-Reply-To: <AANLkTin7ZXYALOy_jk1uR3SbZA51nSnU-ncSjG+n_RPn@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2011 02:11 PM, Colin Cross wrote:
> On Fri, Mar 4, 2011 at 2:27 AM, martin persson
> <martin.persson@stericsson.com>  wrote:
>> We've seen no problems using this patch and have been grateful for it's
>> existence. So I'm happy to put:
>>
>> Tested-by: martin.persson@stericsson.com
>>
>> /Martin
>>
>> On 03/04/2011 11:17 AM, Linus Walleij wrote:
>>>
>>> 2010/11/18 Colin Cross<ccross@android.com>:
>>>
>>>> The clock to the ARM TWD local timer scales with the cpu
>>>> frequency. To allow the cpu frequency to change while
>>>> maintaining a constant TWD frequency, pick a lower target
>>>> frequency for the TWD and use the prescaler to divide down
>>>> to the closest lower frequency.
>>>
>>> We are using this with some custom hooks for the U8500.
>>>
>>> Tested-by: Linus Walleij<linus.walleij@linaro.org>
>>>
>>> Martin Persson can probably provide an additional Tested-by
>>> from ST-Ericsson if it helps.
>>>
>>> Colin are you merging this patch for 2.6.39 through
>>> Russells tracker or pull request? It's an important patch
>>> for us.
>>>
>>> Yours,
>>> Linus Walleij
>>
>
> I never got any responses, and it conflicts with Rob Herring's patch
> 6434/1, although that has not been applied.  Russell, do you want this
> in the patch tracker?

Russell wanted to move over completely to using the clock api rather 
than making clock api usage optional and this was dependent on his 
init_early changes for Realview/Versatile. So I need to update the 
patches based on that.

I think a cleaner solution for this is platforms should define a clock 
for the local timer and the notifier can just get the clock rate again. 
But these clocks have to be implemented first on all platforms using 
local timer to make it unconditional, and I don't have the clock tree 
knowledge of all those platforms.

Rob

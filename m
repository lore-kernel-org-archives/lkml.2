Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248Ab1CDVdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 16:33:32 -0500
Received: from smtp-out.google.com ([74.125.121.67]:45064 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760167Ab1CDVda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 16:33:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wBx8PR5KTsJHeTclDGnn9c/xc2OOvWo5b42L5YfikmAJKkhGhUWXP22qX5ETLJE0iK
         JIqUFPcZc2cuSb8es2xA==
MIME-Version: 1.0
In-Reply-To: <4D714C17.7080102@gmail.com>
References: <1290060899-9786-1-git-send-email-ccross@android.com>
	<AANLkTimCuV5N0jr8c949uONEvieQ5MDZ9KHDXtneG5AT@mail.gmail.com>
	<4D70BE9D.4000507@stericsson.com>
	<AANLkTin7ZXYALOy_jk1uR3SbZA51nSnU-ncSjG+n_RPn@mail.gmail.com>
	<4D714C17.7080102@gmail.com>
Date: Fri, 4 Mar 2011 13:33:27 -0800
X-Google-Sender-Auth: sEkqci01yecRrZEgSQicD6cOZxw
Message-ID: <AANLkTims4e7o0sPxVnN0D1mNWDH7uC9q=pBQrBoad2os@mail.gmail.com>
Subject: Re: [PATCH] ARM: twd: Adjust localtimer frequency with cpufreq notifiers
From: Colin Cross <ccross@android.com>
To: Rob Herring <robherring2@gmail.com>
Cc: martin persson <martin.persson@stericsson.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Rickard ANDERSSON <rickard.andersson@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Varun Swara <Varun.Swara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 4, 2011 at 12:31 PM, Rob Herring <robherring2@gmail.com> wrote:
> On 03/04/2011 02:11 PM, Colin Cross wrote:
>>
>> On Fri, Mar 4, 2011 at 2:27 AM, martin persson
>> <martin.persson@stericsson.com>  wrote:
>>>
>>> We've seen no problems using this patch and have been grateful for it's
>>> existence. So I'm happy to put:
>>>
>>> Tested-by: martin.persson@stericsson.com
>>>
>>> /Martin
>>>
>>> On 03/04/2011 11:17 AM, Linus Walleij wrote:
>>>>
>>>> 2010/11/18 Colin Cross<ccross@android.com>:
>>>>
>>>>> The clock to the ARM TWD local timer scales with the cpu
>>>>> frequency. To allow the cpu frequency to change while
>>>>> maintaining a constant TWD frequency, pick a lower target
>>>>> frequency for the TWD and use the prescaler to divide down
>>>>> to the closest lower frequency.
>>>>
>>>> We are using this with some custom hooks for the U8500.
>>>>
>>>> Tested-by: Linus Walleij<linus.walleij@linaro.org>
>>>>
>>>> Martin Persson can probably provide an additional Tested-by
>>>> from ST-Ericsson if it helps.
>>>>
>>>> Colin are you merging this patch for 2.6.39 through
>>>> Russells tracker or pull request? It's an important patch
>>>> for us.
>>>>
>>>> Yours,
>>>> Linus Walleij
>>>
>>
>> I never got any responses, and it conflicts with Rob Herring's patch
>> 6434/1, although that has not been applied.  Russell, do you want this
>> in the patch tracker?
>
> Russell wanted to move over completely to using the clock api rather than
> making clock api usage optional and this was dependent on his init_early
> changes for Realview/Versatile. So I need to update the patches based on
> that.
>
> I think a cleaner solution for this is platforms should define a clock for
> the local timer and the notifier can just get the clock rate again. But
> these clocks have to be implemented first on all platforms using local timer
> to make it unconditional, and I don't have the clock tree knowledge of all
> those platforms.
>
> Rob
>

Using a clock along with the cpufreq notifiers would simplify my patch
some.  Maybe we can use the traction this patch has among platforms
that use the twd to get the necessary clocks added.  Can you post a
version of your patch that assumes the presence of a twd clock, and
I'll work on getting the necessary clocks added and updating my patch
on top of yours?

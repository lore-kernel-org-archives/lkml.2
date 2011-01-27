Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab1A0Uwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 15:52:39 -0500
Received: from verro.fugedabout.it ([78.46.95.7]:47385 "EHLO
	verro.fugedabout.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab1A0Uwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 15:52:37 -0500
Message-ID: <4D41DB09.5050802@fabbione.net>
Date: Thu, 27 Jan 2011 21:52:25 +0100
From: "Fabio M. Di NItto" <fabbione@fabbione.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: fdinitto@redhat.com, akpm@linux-foundation.org, rdunlap@xenotime.net,
        jmorris@namei.org, kees.cook@canonical.com, mingo@elte.hu,
        namhyung@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console: allow to retain boot console via boot option
 keep_bootcon
References: <20110119161918.1f827080.akpm@linux-foundation.org>	<4D37D18D.9060402@redhat.com>	<4D4182A7.5050503@redhat.com> <20110127.124752.71123363.davem@davemloft.net>
In-Reply-To: <20110127.124752.71123363.davem@davemloft.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2011 09:47 PM, David Miller wrote:
> From: "Fabio M. Di Nitto" <fdinitto@redhat.com>
> Date: Thu, 27 Jan 2011 15:35:19 +0100
> 
>> According to kernel/print.k:
>>
>>>         /*
>>>          * By unregistering the bootconsoles after we enable the real console
>>>          * we get the "console xxx enabled" message on all the consoles -
>>>          * boot consoles, real consoles, etc - this is to ensure that end
>>>          * users know there might be something in the kernel's log buffer that
>>>          * went to the bootconsole (that they do not see on the real console)
>>>          */
>>
>> but my understanding, and please correct if I am wrong, is that when we
>> load or initialize modules such as fbcon (I made this patch debugging a
>> crash in atyfb), a console is indeed registered and bootconsole disable,
>> while in reality the real console is not there yet (in my case fbcon was
>> loaded but not atyfb yet).
>> At a later stage, once atyfb is loaded, it registers with fbcon and then
>> the console output starts again.
> 
> It's not exactly "fbcon", it's the "VT" driver.

Thanks for the clarification. I spotted both VT and fbcon (as they are
the only two that register as console driver effectively) and of course
picked the wrong one ;)

> That loads, and nothing has attached to VT yet to provide the actual
> console hookup.

at least I got this part right...

> 
> "fbcon" waits until a usable driver registers before it hooks itself
> into the "VT" layer.
> 
> So this is why we have this large gap of time with no console output.
> It's because VT registers before it actually is able to provide
> console output services, and frankly that's a bug. :-)

Ok, I have no idea how complex and delicate that code is, but I'll try
to see if we can actually fix VT to behave as fbcon rather than adding
this patch as workaround.

Thanks
Fabio

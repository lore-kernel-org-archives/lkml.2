Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab0CQJN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 05:13:59 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33548 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab0CQJNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 05:13:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rRYpvGz8QdEX88HSZKaiPrXOtcJVpGP92Y5HhA/UbMXqAkvBkHvsjLs0yP2t0hUb2J
         WgKUsIdqiC4pZpL12+WvO6K1yMOSOml5bF9uuncsPUIWrHuB8E/c7U922HX2d7zpQMh/
         EyLy31VNggvwxTrWboy+SRmHOkq7/3S9NwKfQ=
Message-ID: <4BA09D51.90306@gmail.com>
Date: Wed, 17 Mar 2010 02:13:53 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Will L Givens <wlgivens@gmail.com>
CC: "'Michael Cree'" <mcree@orcon.net.nz>,
       =?ISO-8859-1?Q?=27Ra=FAl_Porce?= =?ISO-8859-1?Q?l=27?= 
	<armin76@gentoo.org>,
       "'Matt Turner'" <mattst88@gmail.com>, linux-kernel@vger.kernel.org,
       linux-alpha@vger.kernel.org
Subject: Re: Will's kernel compilation error
References: <b4198de61003151609je8a94ceyf6dd39acfd1a5876@mail.gmail.com> <4B9FDD4E.8080607@gentoo.org> <4BA085EE.3060700@orcon.net.nz> <009501cac5af$a757d3a0$f6077ae0$@com>
In-Reply-To: <009501cac5af$a757d3a0$f6077ae0$@com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2010 01:55 AM, Will L Givens wrote:
>
>
>> -----Original Message-----
>> From: Michael Cree [mailto:mcree@orcon.net.nz]
>> Sent: Wednesday, March 17, 2010 02:34
>> To: Raúl Porcel
>> Cc: Matt Turner; Will L Givens; linux-kernel@vger.kernel.org; linux-
>> alpha@vger.kernel.org
>> Subject: Re: Will's kernel compilation error
>>
>> On 17/03/10 08:34, Raúl Porcel wrote:
>>> Have one.
>>>
>>> My error is as follows:
>>>
>>> net/built-in.o: In function `svc_auth_unregister':
>>> (.text+0xb822c): relocation truncated to fit: GPREL16 against `.sbss'
>>
>> Right, I've confirmed that with the supplied config.  What's happening
>> is that the small data area (where certain static data are stored) has
>> exceeded 64kB which is the limit under the small data model.  As noted
>> elsewhere on this thread it can be solved by compiling with the large
>> data model, but that incurs extra CPU instructions whenever the data
>> area is accessed.
>>
>> A better solution, in my view, is to concert some drivers to modules.
>> I
>> note that the config has a large number of devices to be built (some of
>> which are denoted as having been tested on x86/x86_64/ia64 only).  I
>> converted a few drivers, and most of the selected filesystems (do you
>> really need them all at boot time?) into modules.  The kernel then
>> builds correctly.
>>
>> But if people insist on being able to build impractical monolithic
>> kernels on Alpha I will post my patch to add a kernel option for the
>> large data model.
>>
>> Cheers
>> Michael.
>
> Well a monolithic kernel, which mine isn't, actually runs faster than a
> modular one despite being larger... that's been proven several times over
> the years. In the past I used to roll monolithic kernels simply for
> emergency boot situations and because kernel modules were notorious for not
> compiling properly with all kinds of undefined symbols... rolling them into
> the kernel was a quick fix. Do you honestly believe all those different
> modules, written by a slew of different people, will build properly let
> alone function properly? Kernel-2.6.34-rc1 is the FIRST one that I've seen
> where the netfilter modules all compiled!
>
> Another thing, some components 'have' to be built into the kernel because
> they won't automatically load or the kernel config makes it mandatory. The
> auto load function of past kernels has been pretty iffy at best and granted
> I've yet to actually load this release, I do have my doubts. So important
> things such as my aic7xxx drivers, ali drivers, 751 chipset, etc. I roll
> into the kernel itself.
>
> The things that you've stated I can understand but on when you get right
> down to it, it's not a major issue. My 'monolithic' kernel is only 1.9MB @
> 89MB/s. Personally I feel they should make small-data an patch addon, it
> would save a lot of people a some grief. Some ppl will select them (modules)
> either intentionally or by accident and the majority of folks are not
> running AT HDD's on a flaky IDE controller. Sincerely Will L G
>
> PS Whatever you guys decide please make it obvious... the aboot/kernel
> change a few years ago, caused a lot of Alpha Linux users to bug out...
> About the only ppl aware of the change was Ivan and a handful of Debian
> folks.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
can you bisect this?

Justin P.Mattock

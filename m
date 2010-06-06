Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751070Ab0FFEOk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 00:14:40 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54767 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab0FFEOj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 00:14:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B4GKxrByzqw8MMDmYhlkrz8fzry0ZrvLywn3rv9rdwfph8cl0IzjJJopjQiOu3kMBc
         v24Io6pURE+vKJKnQjX6WjbBCMWFN8QDDbm87nJnH1dU3dte5aqHT3ksgS8V45DcDpKA
         qv6LM7Vzq7RepYITh6yfOg8B7zt4L3OD/X0mA=
MIME-Version: 1.0
In-Reply-To: <4C08B105.5050203@suse.cz>
References: <AANLkTik0PUKP3QLPRbb3nlh034_inmaeVbXy3q5_LQz-@mail.gmail.com>
	<20100527154916.GA5585@infradead.org>
	<20100527184653.GA11830@merkur.ravnborg.org>
	<20100603133055.GA27797@sepie.suse.cz>
	<AANLkTik_QtJQKWYSYcFgjFvNjlqOWMV5iqBGeQeu4SuI@mail.gmail.com>
	<4C08B105.5050203@suse.cz>
Date: Sun, 6 Jun 2010 09:44:37 +0530
Message-ID: <AANLkTik7AFBokgXJmEg7PZIsIkQMbf8FlvKlo5aLP8jE@mail.gmail.com>
Subject: Re: config automatically switches from 32-bit to 64-bit for x86
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Michal,

On Fri, Jun 4, 2010 at 1:23 PM, Michal Marek <mmarek@suse.cz> wrote:
> On 4.6.2010 08:23, Jaswinder Singh Rajput wrote:
>> Hello Michal and Sam,
>>
>> On Thu, Jun 3, 2010 at 7:00 PM, Michal Marek <mmarek@suse.cz> wrote:
>>> What about always making the prompt visible, so that the previously set
>>> value gets reused? The downside is that 'make ARCH=i386 menuconfig' in a
>>> clean tree on x86_64 will default to 64bit, because it will find the
>>> setting in the config of the running 64bit kernel :(. But after manually
>>> turning CONFIG_64BIT off, the setting will be preserved.
>>>
>>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>>> index dcb0593..05ec418 100644
>>> --- a/arch/x86/Kconfig
>>> +++ b/arch/x86/Kconfig
>>> @@ -3,7 +3,7 @@ mainmenu "Linux Kernel Configuration for x86"
>>>
>>>  # Select 32 or 64 bit
>>>  config 64BIT
>>> -       bool "64-bit kernel" if ARCH = "x86"
>>> +       bool "64-bit kernel"
>>>        default ARCH = "x86_64"
>>>        ---help---
>>>          Say yes to build a 64-bit kernel - formerly known as x86_64
>>>
>>
>> This patch works !!
>
> Does
> $ make mrproper
> $ make ARCH=i386 menuconfig
> on x86_64 also work for you? Here, it takes CONFIG_64BIT=y from
> /boot/config-`uname -r`. I see no easy way to solve this atm.
>

Yes, this also works.

Thanks,
--
Jaswinder Singh.

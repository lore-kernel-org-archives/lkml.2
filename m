Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab0FDHxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 03:53:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:44766 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149Ab0FDHxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 03:53:43 -0400
Message-ID: <4C08B105.5050203@suse.cz>
Date: Fri, 04 Jun 2010 09:53:41 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: config automatically switches from 32-bit to 64-bit for x86
References: <AANLkTik0PUKP3QLPRbb3nlh034_inmaeVbXy3q5_LQz-@mail.gmail.com>	<20100527154916.GA5585@infradead.org>	<20100527184653.GA11830@merkur.ravnborg.org>	<20100603133055.GA27797@sepie.suse.cz> <AANLkTik_QtJQKWYSYcFgjFvNjlqOWMV5iqBGeQeu4SuI@mail.gmail.com>
In-Reply-To: <AANLkTik_QtJQKWYSYcFgjFvNjlqOWMV5iqBGeQeu4SuI@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4.6.2010 08:23, Jaswinder Singh Rajput wrote:
> Hello Michal and Sam,
> 
> On Thu, Jun 3, 2010 at 7:00 PM, Michal Marek <mmarek@suse.cz> wrote:
>> What about always making the prompt visible, so that the previously set
>> value gets reused? The downside is that 'make ARCH=i386 menuconfig' in a
>> clean tree on x86_64 will default to 64bit, because it will find the
>> setting in the config of the running 64bit kernel :(. But after manually
>> turning CONFIG_64BIT off, the setting will be preserved.
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index dcb0593..05ec418 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -3,7 +3,7 @@ mainmenu "Linux Kernel Configuration for x86"
>>
>>  # Select 32 or 64 bit
>>  config 64BIT
>> -       bool "64-bit kernel" if ARCH = "x86"
>> +       bool "64-bit kernel"
>>        default ARCH = "x86_64"
>>        ---help---
>>          Say yes to build a 64-bit kernel - formerly known as x86_64
>>
> 
> This patch works !!

Does
$ make mrproper
$ make ARCH=i386 menuconfig
on x86_64 also work for you? Here, it takes CONFIG_64BIT=y from
/boot/config-`uname -r`. I see no easy way to solve this atm.

Michal

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab1JNQoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:44:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63899 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab1JNQog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:44:36 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <201110141827.53906.arnd@arndb.de>
References: <1317172068-14872-1-git-send-email-pdeschrijver@nvidia.com>
	<201110141729.41515.arnd@arndb.de>
	<74CDBE0F657A3D45AFBB94109FB122FF173BE1A283@HQMAIL01.nvidia.com>
	<201110141827.53906.arnd@arndb.de>
Date: Fri, 14 Oct 2011 09:44:34 -0700
Message-ID: <CAOesGMgDwMeVmwo1WJ3tU+ZdjCSJ6F8mY42e_KwTmzAkGQsqmg@mail.gmail.com>
Subject: Re: [PATCH] arm/tegra: select AUTO_ZRELADDR by default
From: Olof Johansson <olof@lixom.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Warren <swarren@nvidia.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Colin Cross (ccross@android.com)" <ccross@android.com>,
        Erik Gilling <konkers@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 9:27 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 14 October 2011, Stephen Warren wrote:
>> Arnd Bergmann wrote at Friday, October 14, 2011 9:30 AM:
>> ...
>> > You mention that tegra30 will require AUTO_ZRELADDR.
>>
>> Well, just to be clear, here's the situation I think:
>>
>> Tegra20's SDRAM starts at physical address 0.
>>
>> Tegra30's SDRAM starts at physical address 2G.
>>
>> To support that, we could either:
>>
>> a) Introduce a new Kconfig variable for Tegra30, make T20/T30 mutually
>> exclusive, and update arch/arm/mach-tegra/Makefile.boot to set zreladdr
>> etc. based on the new Tegra30 config variable too. Then, there's no need
>> for AUTO_ZRELADDR anywhere.
>>
>> b) Have no new config variable, build a unified T20/T30 kernel, leave
>> Makefile.boot untouched, and rely on using AUTO_ZRELADDR for Tegra30 to
>> account for the different SDRAM physical addresses.
>
> Ok, thanks for the explanation, that makes it much clearer. For
> completeness, you could also do both of the above and make T20/T30 mutually
> exclusive unless AUTO_ZRELADDR is set. That might be more complex than
> necessary, I don't know.

That is likely to get messy.

Seems like there could be some use for a (silent) option for a
platform to indicate that it can do XIP kernel (or zImage), and thus
not able to use AUTO_ZRELADDR (or other options that require rewriting
text segment of zImage or kernel).

Language gets awkard though, since it'd be a negative option (or all
platforms would need to add it). MACH_XIP_UNSUPPORTED perhaps?


-Olof

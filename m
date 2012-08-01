Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab2HAH4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 03:56:19 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64797 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab2HAH4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 03:56:18 -0400
Message-ID: <5018E11E.7080907@linaro.org>
Date: Wed, 01 Aug 2012 08:56:14 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, linus.walleij@stericsson.com,
        broonie@opensource.wolfsonmicro.com, olalilja@yahoo.se,
        STEricsson_nomadik_linux@list.st.com, lrg@ti.com
Subject: Re: [PATCH 5/6] ARM: ux500: Enable HIGHMEM on all mop500 platforms
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org> <5017EBDC.6010005@linaro.org> <20120731143732.GS6802@n2100.arm.linux.org.uk> <201207312050.03113.arnd@arndb.de> <20120731220145.GD10335@n2100.arm.linux.org.uk>
In-Reply-To: <20120731220145.GD10335@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/12 23:01, Russell King - ARM Linux wrote:
> On Tue, Jul 31, 2012 at 08:50:02PM +0000, Arnd Bergmann wrote:
>> On Tuesday 31 July 2012, Russell King - ARM Linux wrote:
>>> I still fail to see how not having highmem enabled would ever cause memory
>>> corruption errors (unless something dealing with memory in a very very
>>> wrong way - iow, not using one of the reservation or memory allocation
>>> methods provided by the kernel.)
>>
>> The problem is that all users of ux500 systems pass a command line like
>>
>> vmalloc=256M mem=128M@0 mali.mali_mem=32M@128M hwmem=168M@160M mem=48M@328M mem_issw=1M@383M mem=640M@384M
>>
>> This is of course totally bogus and should not be done. If I understand
>> Lee correctly, one of the issues resulting from passing a command
>> line like this without enabling highmem is memory corruption.
>
> But the question is _why_ does that corruption happen.
>
>  From the above, we will end up with the kernel getting:
>
> 0x00000000 - 0x07ffffff (128M @ 0)
> 0x14800000 - 0x177fffff (48M  @ 328M)
> 0x18000000 - 0x3fffffff (640M @ 384M)
>
> with:
>
> 0x08000000 - 0x081fffff used for mali
> 0x0a000000 - 0x147fffff used for hwmem
> 0x17f00000 - 0x17ffffff used for mem_issw
>
> Now, with highmem disabled, the kernel should still map exactly the
> regions: 0x00000000 - 0x07ffffff, 0x14800000 - 0x177fffff, into the
> direct mapped region, and truncate the 0x18000000 - 0x3fffffff
> region appropriately, reducing the amount of memory available such
> that it won't overlap the vmalloc area (which you've specified to be
> a minimum of 256M.)
>
> This should _NOT_ cause any memory corruption.
>
> So, come on guys.  Debugging is *mandatory* for this kind of problem.
> Papering over it is obscene.

Actually I didn't go any further with it, as I changed to another 
identical piece of hardware and couldn't reproduce the issue.

FYI, here's the boot log from the broken board:

http://paste.ubuntu.com/1102017/

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

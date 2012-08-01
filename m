Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab2HAN4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 09:56:06 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49525 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab2HAN4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 09:56:04 -0400
Message-ID: <5019356E.6020407@linaro.org>
Date: Wed, 01 Aug 2012 14:55:58 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com
Subject: Re: [PATCH 5/6] ARM: ux500: Ensure probing of Audio devices when
 Device Tree is enabled
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org> <201207312054.13818.arnd@arndb.de> <5018DBEE.9090203@linaro.org> <201208011332.02500.arnd@arndb.de>
In-Reply-To: <201208011332.02500.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/12 14:32, Arnd Bergmann wrote:
> On Wednesday 01 August 2012, Lee Jones wrote:
>>> Looks like you're adding the same call to each of the three cases:
>>> mop500, snowball and hrefv60+. How about moving it before or after
>>> the if/elseif block?
>>
>> The Snowball one is different 'mop500_msp_init' -> 'mop500_of_msp_init'.
>
> Ah, I see. Is there a problem in always using mop500_of_msp_init then?
> I would guess that this just means you'd have to put the msp into the
> device tree files, which don't yet exist for mop500 and hrefv60.

Although that is true, it's only part of the issue.

mop500_of_msp_init is only a temporary solution to aid in step-by-step 
enablement of DT for audio. By the end of the patch-set it has been 
removed (along with the call to it if 'of_machine_is_compatible 
("calaosystems,snowball-a9500")'. What I can do it write a patch to 
consolidate the calls _after_ "ARM: ux500: Remove platform registration 
of MSP devices", as a bolt-on.


-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

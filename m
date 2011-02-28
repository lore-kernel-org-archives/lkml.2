Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab1B1K25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 05:28:57 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63522 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab1B1K24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 05:28:56 -0500
Message-ID: <4D6B7896.6000703@mvista.com>
Date: Mon, 28 Feb 2011 13:27:34 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "hjk@hansjkoch.de" <hjk@hansjkoch.de>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 2/2] Defines DA850/AM18xx/OMAPL1-38 SOC resources used
 by PRUSS UIO driver
References: <1298556402-26456-1-git-send-email-pratheesh@ti.com> <1298556402-26456-2-git-send-email-pratheesh@ti.com> <1298556402-26456-3-git-send-email-pratheesh@ti.com> <4D6796D6.5050008@mvista.com> <B85A65D85D7EB246BE421B3FB0FBB593024BF3591A@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024BF3591A@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 28-02-2011 7:46, TK, Pratheesh Gangadhar wrote:

>>> This patch defines PRUSS, ECAP clocks, memory and IRQ resources
>>> used by PRUSS UIO driver in DA850/AM18xx/OMAPL1-38 devices. UIO

>>      It's OMAP-L138.
> Ok.

>>> driver exports 64K I/O region of PRUSS, 128KB L3 RAM and 256KB
>>> DDR buffer to user space. PRUSS has 8 host event interrupt lines
>>> mapped to IRQ_DA8XX_EVTOUT0..7 of ARM9 INTC.These in conjunction
>>> with shared memory can be used to implement IPC between ARM9 and
>>> PRUSS.

>>> Signed-off-by: Pratheesh Gangadhar<pratheesh@ti.com>

[...]

>>> diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-
>> davinci/devices-da8xx.c
>>> index beda8a4..4ea3d1f 100644
>>> --- a/arch/arm/mach-davinci/devices-da8xx.c
>>> +++ b/arch/arm/mach-davinci/devices-da8xx.c
>>> @@ -725,3 +725,76 @@ int __init da8xx_register_cpuidle(void)
>>>
>>>    	return platform_device_register(&da8xx_cpuidle_device);
>>>    }
>>> +static struct resource pruss_resources[] = {
>>> +	[0] = {
>>> +		.start  = DA8XX_PRUSS_BASE,
>>> +		.end    = DA8XX_PRUSS_BASE + SZ_64K - 1,
>>> +		.flags  = IORESOURCE_MEM,
>>> +	},
>>> +	[1] = {
>>> +		.start  = DA8XX_L3RAM_BASE,
>>> +		.end    = DA8XX_L3RAM_BASE + SZ_128K - 1,
>>> +		.flags  = IORESOURCE_MEM,
>>> +	},
>>> +	[2] = {
>>> +		.start  = 0,
>>> +		.end    = SZ_256K - 1,

>>      Huh? I don't see where it's filled...

> The current use is only to indicate memory block size to the PRUSS UIO driver when we allocate DDR memory using dma_alloc_coherent.

    Why not pass this size via the platform data? There shouldn't be "dummy" 
resources.

> sram_alloc is changed to use L3_RAM (128KB) instead of ARM RAM (8KB) in Mistral patch set - I need to follow the same convention
 > for L3 RAM as well if I need to align with that patch. Is there a better 
way to do this?

    Didn't understand about L3 RAM.
    Also, please wrap your text at 80 columns.

WBR, Sergei

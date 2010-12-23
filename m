Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab0LWSv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 13:51:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:57025 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808Ab0LWSv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 13:51:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,219,1291622400"; 
   d="scan'208";a="586741289"
Message-ID: <4D139A4C.7000003@linux.intel.com>
Date: Thu, 23 Dec 2010 10:51:56 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Yinghai <yinghai@kernel.org>
CC: Florian Fainelli <ffainelli@freebox.fr>,
        "sodaville@linutronix.de" <sodaville@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [sodaville] [PATCH] x86/trampoline: fallback to fixed	trampoline
 address if no e820 map is provided
References: <201012142219.40062.ffainelli@freebox.fr>	<201012231057.35021.ffainelli@freebox.fr> <7A03AE18-9737-41D6-8EF5-6C6C29C1BF0D@kernel.org>
In-Reply-To: <7A03AE18-9737-41D6-8EF5-6C6C29C1BF0D@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2010 05:16 AM, Yinghai wrote:
> 
> On Dec 23, 2010, at 1:57 AM, Florian Fainelli <ffainelli@freebox.fr> wrote:
> 
>> On Tuesday 14 December 2010 22:19:39 Florian Fainelli wrote:
>>> From: Florian Fainelli <ffainelli@freebox.fr>
>>>
>>> Since 893f38d1 (x86: Use find_e820() instead of hard coded trampoline
>>> address), the trampoline base address should be provided by the BIOS as an
>>> e820 area. Some minimalistic BIOSes (like CEFDK on CE4100) may not provide
>>> any e820 area, still we should fallback to a fixed trampoline base address
>>> for SMP to work correctly.
> 
> No e820 memmap ?
> 
> Not sure how does it work
> 
> Do you have boot log with debug ?
> 
> Also recent kernel is using memblock already for finding free area.
> 

OK, this deeply troubles me.  This is clearly not the right approach
here... the memory map should be fed to the kernel, this has been a
requirement all along, and Linus has very deliberately not agreed to
exceptions (and I agree with that stance.)

So this patch is a non-starter... I presume the memory map is being
provided in through the device (which means it should be fed into
memblock in current kernels, although the ordering may need to be tweaked?)

	-hpa

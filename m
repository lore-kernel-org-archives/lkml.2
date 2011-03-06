Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab1CFULp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 15:11:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55232 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab1CFULo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 15:11:44 -0500
Message-ID: <4D73EA6B.1050002@zytor.com>
Date: Sun, 06 Mar 2011 12:11:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Haim D." <haimdaniel@gmail.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: x86_32 machine with 4G - possible wrong last_pfn value ?
References: <AANLkTi=BszM8mwQ+Ooff+8D1vOXZ1=LLOp3MwPcPQu4-@mail.gmail.com> <AANLkTi=H8uOpqC56GCt9U89nDWChG5nQa4kUz+fxHPdc@mail.gmail.com>
In-Reply-To: <AANLkTi=H8uOpqC56GCt9U89nDWChG5nQa4kUz+fxHPdc@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2011 07:04 AM, Haim D. wrote:
> Hi,
> I'm running  a x86_32 bit 4G machine with 2.4.33 and 2.6.34, I've
> noticed the difference between max_pfn values
> 2.4.33 shows 0x100000
> 2.4.34 shows  0xdffe0
> 

[ ... ]

> Mar  6 13:27:17 localhost kernel: BIOS-provided physical RAM map:
> Mar  6 13:27:17 localhost kernel:  BIOS-e820: 0000000000000000 -
> 000000000009fc00 (usable)
> Mar  6 13:27:17 localhost kernel:  BIOS-e820: 000000000009fc00 -
> 00000000000a0000 (reserved)
> Mar  6 13:27:17 localhost kernel:  BIOS-e820: 00000000000e0000 -
> 0000000000100000 (reserved)
> Mar  6 13:27:17 localhost kernel:  BIOS-e820: 0000000000100000 -
> 00000000dffe0000 (usable)
> Mar  6 13:27:17 localhost kernel:  BIOS-e820: 00000000dffe0000 -
> 00000000dffee000 (ACPI data)
> Mar  6 13:27:17 localhost kernel:  BIOS-e820: 00000000dffee000 -
> 00000000e0000000 (ACPI NVS)
> Mar  6 13:27:17 localhost kernel:  BIOS-e820: 00000000fee00000 -
> 00000000fee01000 (reserved)
> Mar  6 13:27:17 localhost kernel:  BIOS-e820: 00000000ffb00000 -
> 0000000100000000 (reserved)
> Mar  6 13:27:17 localhost kernel:  BIOS-e820: 0000000100000000 -
> 0000000120000000 (usable)

Based on this memory map, 0xdffe0 is the correct max_pfn value.

> Mar  6 13:27:17 localhost kernel: Warning only 4GB will be used.
> Mar  6 13:27:17 localhost kernel: Use a PAE enabled kernel.
> Mar  6 13:27:17 localhost kernel: (find_max_low_pfn:1003) max_low_pfn to 753664
> Mar  6 13:27:17 localhost kernel: 1152MB HIGHMEM available.
> Mar  6 13:27:17 localhost kernel: 2944MB LOWMEM available.

... for a non-PAE kernel, apparently compiled with a weird split.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


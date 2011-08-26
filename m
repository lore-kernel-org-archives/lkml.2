Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab1HZQhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 12:37:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50032 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754976Ab1HZQhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 12:37:31 -0400
Message-ID: <4E57CBBB.3040806@zytor.com>
Date: Fri, 26 Aug 2011 09:37:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Tony Vroon <tony@linx.net>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
        suresh.b.siddha@intel.com
Subject: Re: MTRR setup failure on Fujitsu Lifebook S761
References: <4E579397.6010009@linx.net>
In-Reply-To: <4E579397.6010009@linx.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2011 05:37 AM, Tony Vroon wrote:
> 
> Full dmesg:
> Initializing cgroup subsys cpu
> Linux version 3.1.0-rc3-00161-g671ee7f (root@adrastea) (gcc version
> 4.5.3 (Gentoo 4.5.3-r1 p1.0, pie-0.4.5) ) #1 SMP PREEMPT Fri Aug 26
> 08:46:08 BST 2011
> Command line: auto BOOT_IMAGE=3.1.0-rc3-00161 rw root=0
> Disabled fast string operations
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
>  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 00000000ca98f000 (usable)
>  BIOS-e820: 00000000ca98f000 - 00000000cae9f000 (reserved)
>  BIOS-e820: 00000000cae9f000 - 00000000caf9f000 (ACPI NVS)
>  BIOS-e820: 00000000caf9f000 - 00000000cafff000 (ACPI data)
>  BIOS-e820: 00000000cafff000 - 00000000cb000000 (usable)
>  BIOS-e820: 00000000cb000000 - 00000000cfa00000 (reserved)
>  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
>  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
>  BIOS-e820: 00000000fed10000 - 00000000fed1a000 (reserved)
>  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
>  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>  BIOS-e820: 00000000ffda0000 - 0000000100000000 (reserved)
>  BIOS-e820: 0000000100000000 - 000000012e600000 (usable)
> NX (Execute Disable) protection: active
> DMI 2.6 present.
> DMI: FUJITSU LIFEBOOK S761/FJNB225, BIOS Version 1.15 07/05/2011
> e820 update range: 0000000000000000 - 0000000000010000 (usable) ==>
> (reserved)
> e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
> No AGP bridge found
> last_pfn = 0x12e600 max_arch_pfn = 0x400000000
> MTRR default type: uncachable
> MTRR fixed ranges enabled:
>   00000-9FFFF write-back
>   A0000-BFFFF uncachable
>   C0000-FFFFF write-protect
> MTRR variable ranges enabled:
>   0 base 0FFC00000 mask FFFC00000 write-protect
>   1 base 000000000 mask F80000000 write-back
>   2 base 080000000 mask FC0000000 write-back
>   3 base 0C0000000 mask FE0000000 write-back
>   4 base 0D0000000 mask FF0000000 uncachable
>   5 base 0CC000000 mask FFC000000 uncachable
>   6 base 0CB000000 mask FFF000000 uncachable
>   7 base 100000000 mask FC0000000 write-back
>   8 base 130000000 mask FF0000000 uncachable
>   9 base 12F000000 mask FFF000000 uncachable

Hm, I don't see any evidence of the MTRR sanitizer running at all...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


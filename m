Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab0CSOs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 10:48:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:47086 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab0CSOsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 10:48:55 -0400
Date: Fri, 19 Mar 2010 15:48:50 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: remove early_res debug output (was Re: Confusing bootmem
 messages on bootup)
In-Reply-To: <alpine.LNX.2.00.1003191526560.18642@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1003191544010.18642@pobox.suse.cz>
References: <alpine.LNX.2.00.1003191526560.18642@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ some more CCs added ]

On Fri, 19 Mar 2010, Jiri Kosina wrote:

> Hi,
> 
> current tree (HEAD on 39710479303fd3a) gives quite non-informative and 
> confusing output during bootup:
> 
> 
> === cut here ===
> Subtract (85 early reservations)
>   #1 [0001000000 - 00023dc5e8]   TEXT DATA BSS
>   #2 [003753c000 - 0037fefdaa]         RAMDISK
>   #3 [00023dd000 - 00023dd214]             BRK
>   #4 [00000f8390 - 0000100000]   BIOS reserved
>   #5 [00000f8380 - 00000f8390]    MP-table mpf
>   #6 [000009dc00 - 000009e271]   BIOS reserved
>   #7 [000009e54d - 00000f8380]   BIOS reserved
>   #8 [000009e271 - 000009e54d]    MP-table mpc
>   #9 [0000010000 - 0000012000]      TRAMPOLINE
>   #10 [0000012000 - 0000016000]     ACPI WAKEUP
>   #11 [0000016000 - 0000018000]         PGTABLE
>   #12 [0000018000 - 0000019000]         PGTABLE
>   #13 [0000019000 - 000001d640]      MEMNODEMAP
>   #14 [00023dd240 - 00023e2240]       NODE_DATA
>   #15 [0100000000 - 0100005000]       NODE_DATA
>   #16 [0130000000 - 0130005000]       NODE_DATA
>   #17 [01b0000000 - 01b0005000]       NODE_DATA
>   #18 [00023e2240 - 00023e3240]         BOOTMEM
>   #19 [00023dc600 - 00023dc780]         BOOTMEM
>   #20 [0080000000 - 0080000180]         BOOTMEM
>   #21 [0130005000 - 0130005180]         BOOTMEM
>   #22 [01b0005000 - 01b0005180]         BOOTMEM
>   #23 [0002be4000 - 0002be5000]         BOOTMEM
>   #24 [0002be5000 - 0002be6000]         BOOTMEM
>   #25 [0002c00000 - 0004800000]        MEMMAP 0
>   #26 [0100200000 - 0102000000]        MEMMAP 1
>   #27 [0130200000 - 0131e00000]        MEMMAP 2
>   #28 [01b0200000 - 01b1e00000]        MEMMAP 3
>   #29 [00023dc780 - 00023dcb80]         BOOTMEM
>   #30 [00023e3240 - 0002403240]         BOOTMEM
>   #31 [0080000180 - 0080020180]         BOOTMEM
>   #32 [0080020180 - 0080030180]         BOOTMEM
>   #33 [0130005180 - 0130025180]         BOOTMEM
>   #34 [01b0005180 - 01b0025180]         BOOTMEM
>   #35 [0002404000 - 0002405000]         BOOTMEM
>   #36 [00023dcb80 - 00023dcbc1]         BOOTMEM
>   #37 [00023dcc00 - 00023dccc9]         BOOTMEM
>   #38 [00023dcd00 - 00023dcfd8]         BOOTMEM
>   #39 [0002403240 - 00024032a8]         BOOTMEM
>   #40 [00024032c0 - 0002403328]         BOOTMEM
>   #41 [0002403340 - 00024033a8]         BOOTMEM
>   #42 [00024033c0 - 0002403428]         BOOTMEM
>   #43 [0002403440 - 00024034a8]         BOOTMEM
>   #44 [00024034c0 - 0002403528]         BOOTMEM
>   #45 [0002403540 - 00024035a8]         BOOTMEM
>   #46 [00024035c0 - 0002403628]         BOOTMEM
>   #47 [0002403640 - 00024036a8]         BOOTMEM
>   #48 [00024036c0 - 0002403728]         BOOTMEM
>   #49 [0002403740 - 00024037a8]         BOOTMEM
>   #50 [00024037c0 - 0002403828]         BOOTMEM
>   #51 [0002403840 - 0002403860]         BOOTMEM
>   #52 [0002403880 - 00024038a0]         BOOTMEM
>   #53 [00024038c0 - 0002403958]         BOOTMEM
>   #54 [0002403980 - 0002403a18]         BOOTMEM
>   #55 [0002600000 - 000261c000]         BOOTMEM
>   #56 [0002680000 - 000269c000]         BOOTMEM
>   #57 [0002700000 - 000271c000]         BOOTMEM
>   #58 [0002780000 - 000279c000]         BOOTMEM
>   #59 [0080200000 - 008021c000]         BOOTMEM
>   #60 [0080280000 - 008029c000]         BOOTMEM
>   #61 [0080300000 - 008031c000]         BOOTMEM
>   #62 [0080380000 - 008039c000]         BOOTMEM
>   #63 [0131e00000 - 0131e1c000]         BOOTMEM
>   #64 [0131e80000 - 0131e9c000]         BOOTMEM
>   #65 [0131f00000 - 0131f1c000]         BOOTMEM
>   #34 [01b0005180 - 01b0025180]         BOOTMEM
>   #35 [0002404000 - 0002405000]         BOOTMEM
>   #36 [00023dcb80 - 00023dcbc1]         BOOTMEM
>   #37 [00023dcc00 - 00023dccc9]         BOOTMEM
>   #38 [00023dcd00 - 00023dcfd8]         BOOTMEM
>   #39 [0002403240 - 00024032a8]         BOOTMEM
>   #40 [00024032c0 - 0002403328]         BOOTMEM
>   #41 [0002403340 - 00024033a8]         BOOTMEM
>   #42 [00024033c0 - 0002403428]         BOOTMEM
>   #43 [0002403440 - 00024034a8]         BOOTMEM
>   #44 [00024034c0 - 0002403528]         BOOTMEM
>   #45 [0002403540 - 00024035a8]         BOOTMEM
>   #46 [00024035c0 - 0002403628]         BOOTMEM
>   #47 [0002403640 - 00024036a8]         BOOTMEM
>   #48 [00024036c0 - 0002403728]         BOOTMEM
>   #49 [0002403740 - 00024037a8]         BOOTMEM
>   #50 [00024037c0 - 0002403828]         BOOTMEM
>   #51 [0002403840 - 0002403860]         BOOTMEM
>   #52 [0002403880 - 00024038a0]         BOOTMEM
>   #53 [00024038c0 - 0002403958]         BOOTMEM
>   #54 [0002403980 - 0002403a18]         BOOTMEM
>   #55 [0002600000 - 000261c000]         BOOTMEM
>   #56 [0002680000 - 000269c000]         BOOTMEM
>   #57 [0002700000 - 000271c000]         BOOTMEM
>   #58 [0002780000 - 000279c000]         BOOTMEM
>   #59 [0080200000 - 008021c000]         BOOTMEM
>   #60 [0080280000 - 008029c000]         BOOTMEM
>   #61 [0080300000 - 008031c000]         BOOTMEM
>   #62 [0080380000 - 008039c000]         BOOTMEM
>   #63 [0131e00000 - 0131e1c000]         BOOTMEM
>   #64 [0131e80000 - 0131e9c000]         BOOTMEM
>   #65 [0131f00000 - 0131f1c000]         BOOTMEM
>   #66 [0131f80000 - 0131f9c000]         BOOTMEM
>   #67 [01b1e00000 - 01b1e1c000]         BOOTMEM
>   #68 [01b1e80000 - 01b1e9c000]         BOOTMEM
>   #69 [01b1f00000 - 01b1f1c000]         BOOTMEM
>   #70 [01b1f80000 - 01b1f9c000]         BOOTMEM
>   #71 [0002403a40 - 0002403a60]         BOOTMEM
>   #72 [0002403a80 - 0002403aa0]         BOOTMEM
>   #73 [0002403ac0 - 0002403b00]         BOOTMEM
>   #74 [0002403b00 - 0002403b80]         BOOTMEM
>   #75 [0002403b80 - 0002403cb0]         BOOTMEM
>   #76 [0002403cc0 - 0002403d10]         BOOTMEM
>   #77 [0002403d40 - 0002403d90]         BOOTMEM
>   #78 [0002405000 - 000240d000]         BOOTMEM
>   #79 [0020000000 - 0024000000]         BOOTMEM
>   #80 [0002403dc0 - 0002403de0]         BOOTMEM
>   #81 [0004800000 - 0008800000]         BOOTMEM
>   #82 [000240d000 - 000242d000]         BOOTMEM
>   #83 [000242d000 - 000246d000]         BOOTMEM
>   #84 [000001ee40 - 0000026e40]         BOOTMEM
>  27 40 - 80 9d
>  100 100 - 1000 1000
>  246d 2480 - 2600 2600
>  261c 2640 - 2680 2680
>  269c 26c0 - 2700 2700
>  271c 2740 - 2780 2780
>  279c 27c0 - 2bc0 2be4
>  2be6 - 2c00
>  8800 8800 - 20000 20000
>  24000 24000 - 37500 3753c
>  37ff0 38000 - 80000 80000
>  80031 80040 - 80200 80200
>  8021c 80240 - 80280 80280
>  8029c 802c0 - 80300 80300
>  8031c 80340 - 80380 80380
>  8039c 803c0 - cff00 cff00
>  100005 100040 - 100200 100200
>  102000 102000 - 130000 130000
>  130026 130040 - 130200 130200
>  131e1c 131e40 - 131e80 131e80
>  131e9c 131ec0 - 131f00 131f00
>  131f1c 131f40 - 131f80 131f80
>  131f9c 131fc0 - 1b0000 1b0000
>  1b0026 1b0040 - 1b0200 1b0200
>  1b1e1c 1b1e40 - 1b1e80 1b1e80
>  1b1e9c 1b1ec0 - 1b1f00 1b1f00
>  1b1f1c 1b1f40 - 1b1f80 1b1f80
>  1b1f9c 1b1fc0 - 230000 230000
> 
> === cut here ===
> 
> The first part (the early reservations themselves with the names) are 
> fine, but the numbers that follow without any other explanation seem to be 
> just completely useless to me ...
> 
> I haven't yet looked at which code actually introduced this, but I guess 
> we should just remove it ... ?

OK, this has been introduced by 

	commit 08677214e318297f228237be0042aac754f48f1d
	Author: Yinghai Lu <yinghai@kernel.org>
	Date:   Wed Feb 10 01:20:20 2010 -0800

	    x86: Make 64 bit use early_res instead of bootmem before slab

and is caused by forgotten (I guess) debugging output while freeing the 
pages when CONFIG_NO_BOOTMEM is set. Please consider applying the 
following patch to reduce noise.



From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] x86: remove early_res debug output

Commit 08677214e318297 ("x86: Make 64 bit use early_res instead of bootmem 
before slab") introduced early_res replacement for bootmem, but left code 
in __free_pages_memory() which dumps all the ranges that are beeing freed, 
without any additional information, causing some noise in dmesg during 
bootup.

Just remove printing of the ranges, that doesn't provide anything useful 
anyway.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

--- 

 mm/bootmem.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index d7c791e..9754c26 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -180,19 +180,12 @@ static void __init __free_pages_memory(unsigned long start, unsigned long end)
 	end_aligned = end & ~(BITS_PER_LONG - 1);
 
 	if (end_aligned <= start_aligned) {
-#if 1
-		printk(KERN_DEBUG " %lx - %lx\n", start, end);
-#endif
 		for (i = start; i < end; i++)
 			__free_pages_bootmem(pfn_to_page(i), 0);
 
 		return;
 	}
 
-#if 1
-	printk(KERN_DEBUG " %lx %lx - %lx %lx\n",
-		 start, start_aligned, end_aligned, end);
-#endif
 	for (i = start; i < start_aligned; i++)
 		__free_pages_bootmem(pfn_to_page(i), 0);
 

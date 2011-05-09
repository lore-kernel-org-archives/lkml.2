Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab1EIFtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 01:49:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35473 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab1EIFtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 01:49:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] Check end_pfn in pageblock_is_reserved
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Mel Gorman <mel@csn.ul.ie>, Dave Hansen <dave@linux.vnet.ibm.com>
In-Reply-To: <1304434549-2837-1-git-send-email-minchan.kim@gmail.com>
References: <1304434549-2837-1-git-send-email-minchan.kim@gmail.com>
Message-Id: <20110509145053.1644.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon,  9 May 2011 14:49:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve]
> added new function "pageblock_is_reserved". But it doesn't check end_pfn of system
> so it meets following BUG in my system. This patch fixes it.
> 
> [    1.859574] type=2000 audit(1304330017.656:1): initialized
> [    1.884130] BUG: unable to handle kernel paging request at f77fe000
> [    1.890557] IP: [<c01dfe3f>] setup_per_zone_wmarks+0x17f/0x280
> [    1.896493] *pde = 013fb067 *pte = 00000000
> [    1.900921] Oops: 0000 [#1] SMP
> [    1.904309] last sysfs file:
> [    1.907324] Modules linked in:
> [    1.910482]
> [    1.912024] Pid: 1, comm: swapper Not tainted 2.6.39-rc5-mm1+ #49 SAMSUNG ELECTRONICS CO.,LTD Samsung DeskT
> [    1.924756] EIP: 0060:[<c01dfe3f>] EFLAGS: 00010006 CPU: 0
> [    1.930282] EIP is at setup_per_zone_wmarks+0x17f/0x280
> [    1.935554] EAX: 00040080 EBX: 000403fe ECX: 00000000 EDX: f77fe000
> [    1.941859] ESI: 00110000 EDI: f77fcfc0 EBP: f5077f88 ESP: f5077f50
> [    1.948170]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [    1.953613] Process swapper (pid: 1, ti=f5076000 task=f5078000 task.ti=f5076000)
> [    1.961056] Stack:
> [    1.963116]  00000091 00000000 000003b5 00000286 c0803c80 c0803ca4 0003709b 00000000
> [    1.971377]  006effe0 006effc0 00040000 00000000 f50783d8 00000001 f5077f94 c0846e40
> [    1.979633]  00000000 f5077fc4 c0101125 00000000 000002c8 f50783d8 f5077fb0 c01a8b44
> [    1.987890] Call Trace:
> [    1.990386]  [<c0846e40>] init_per_zone_wmark_min+0x39/0x7c
> [    1.996001]  [<c0101125>] do_one_initcall+0x35/0x170
> [    2.001014]  [<c01a8b44>] ? irq_to_desc+0x14/0x20
> [    2.005758]  [<c0846e07>] ? memmap_init_zone+0xca/0xca
> [    2.010941]  [<c080c2bc>] kernel_init+0xbd/0x153
> [    2.015606]  [<c080c1ff>] ? parse_early_options+0x25/0x25
> [    2.021047]  [<c05e7542>] kernel_thread_helper+0x6/0x10
> [    2.026318] Code: 76 33 8b 4d ec 39 c3 8b 15 80 62 e0 c0 8d 3c 0e 8d 3c 3a 76 67 8b 0f 80 e5 04 75 19 8b 4d
> [    2.049095] EIP: [<c01dfe3f>] setup_per_zone_wmarks+0x17f/0x280 SS:ESP 0068:f5077f50
> [    2.056996] CR2: 00000000f77fe000
> [    2.060362] ---[ end trace 82bc55f036371117 ]---
> 
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Arve Hjønnevåg <arve@android.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Dave Hansen <dave@linux.vnet.ibm.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

Good catch.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>





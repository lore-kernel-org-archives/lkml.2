Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759703Ab0ENTsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:48:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59810 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759605Ab0ENTsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:48:31 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v17 00/37] Use lmb with x86
Date: Fri, 14 May 2010 12:45:26 -0700
Message-Id: <1273866363-14249-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4BEDA8D2.00AF,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the new lmb could be used to replace early_res in x86.

Suggested by: David, Ben, and Thomas

-v6: change sequence as requested by Thomas
-v7: seperate them to more patches
-v8: add boundary checking to make sure not free partial page.
-v9: use lmb_debug to control print out of reserve_lmb.
     add e820 clean up, and e820 become __initdata
-v10:use lmb.rmo_size and ARCH_DISCARD_LMB according to Michael
     change name to lmb_find_area/reserve_lmb_area/free_lmb_area,
      according to Michael
     update find_lmb_area to use __lmb_alloc_base according to ben
-v11:move find_lmb_area_size back to x86.
     x86 has own find_lmb_area, and could be disabled by ARCH_LMB_FIND_AREA
      because _lmb_find_base has different behavoir from x86's old one.
      one from high to high and one from low to high
      need more test
     tested for x86 32bit/64bit, numa/nonuma, nobootmem/bootmem.
-v12:refresh the series with current tip
     seperate nobootmem.c, so could remove some #ifdef
     still keep CONFIG_NO_BOOTMEM, in x86 .c, and could use the as tags
     so other lmb could refer them to use NO_BOOTMEM.

-v14:refresh to current tip

-v15:remove x86 version lmb_find_area
     remove other nobootmem and x86 e820 from this patchset

-v16: rebase to Ben's cleanup powerpc/lmb
     move back most func back to arch/x86/mm/lmb.c

-v17: remove exposing of lmb_add_region
     seperate first lmb core related patch to several small patches.

this patcheset is based on tip/master+powerpc/lmb

todo:
	1. use for_each_lmb to replace for cycle
	2. replace range handling with lmb.
	3. kill __lmb_find_area and use lmb_find_area directly

Thanks

Yinghai

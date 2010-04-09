Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab0DIGIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 02:08:06 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:37883 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764Ab0DIGH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 02:07:28 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v12 00/39] use lmb with x86
Date: Thu,  8 Apr 2010 23:03:29 -0700
Message-Id: <1270793048-23796-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4BBEC3E1.0062,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the new lmb could be used to early_res in x86.

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

still keep find_lmb_area, may replace those find_lmb_area will lmb_alloc, if
everything go fine

Please put them into tip and -next to have more test coverage.

Thanks

Yinghai

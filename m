Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab0C2Cus (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 22:50:48 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:43328 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab0C2Cqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 22:46:43 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v9 00/31] use lmb with x86
Date: Sun, 28 Mar 2010 19:42:53 -0700
Message-Id: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0205.4BB01478.0155,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the new lmb could be used to early_res in x86.

Suggested by: David, Ben, and Thomas

First three patches should go into 2.6.34

-v6: change sequence as requested by Thomas
-v7: seperate them to more patches
-v8: add boundary checking to make sure not free partial page.
-v9: use lmb_debug to control print out of reserve_lmb.
     add e820 clean up, and e820 become __initdata

> size vmlinux.*
   text		   data	    bss		    dec		    hex	filename
20195694	4149812	12627536	36973042	23429f2	vmlinux.before_lmb_patchset
20198187	4163892	12614736	36976815	23438af	vmlinux.after_lmb_patchset

Before:
[   12.124431] Freeing unused kernel memory: 2740k freed
After:
[   11.514822] Freeing unused kernel memory: 2764k freed

So We move about 24k to .init

Please check

Thanks

Yinghai

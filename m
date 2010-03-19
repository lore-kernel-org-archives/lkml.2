Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751069Ab0CSG4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 02:56:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63416 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750705Ab0CSG4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 02:56:46 -0400
Message-ID: <4BA3206B.9020405@cn.fujitsu.com>
Date: Fri, 19 Mar 2010 14:57:47 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Michal Marek <mmarek@suse.cz>
Subject: [PATCH] kconfig: recalc symbol value before showing search results
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A symbol's value won't be recalc-ed until we save config file or
enter the menu where the symbol sits.

So If I enable OPTIMIZE_FOR_SIZE, and search FUNCTION_GRAPH_TRACER:

  Symbol: FUNCTION_GRAPH_TRACER [=y]
  Prompt: Kernel Function Graph Tracer
    Defined at kernel/trace/Kconfig:140
    Depends on: ... [=y] && (!X86_32 [=y] || !CC_OPTIMIZE_FOR_SIZE [=y])
    ...

>From the dependency it should result in FUNCTION_GRAPH_TRACER=n,
but it still shows FUNCTION_GRAPH_TRACER=y.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 scripts/kconfig/symbol.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 6c8fbbb..dfef8d1 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -750,6 +750,7 @@ struct symbol **sym_re_search(const char *pattern)
 				return NULL;
 			}
 		}
+		sym_calc_value(sym);
 		sym_arr[cnt++] = sym;
 	}
 	if (sym_arr)
-- 1.6.3 

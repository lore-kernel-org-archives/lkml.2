Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab2ENL6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 07:58:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34157 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab2ENL6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 07:58:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4FB0F36C.4010906@jp.fujitsu.com>
Date: Mon, 14 May 2012 20:58:36 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: [Patch 2/4] x86: use memblock_set_current_limit() to set memblock.current_limit
References: <4FACA79C.9070103@cn.fujitsu.com> <4FB0F174.1000400@jp.fujitsu.com>
In-Reply-To: <4FB0F174.1000400@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memblock.current_limit is set directly though memblock_set_current_limit()
is prepared. So fix it.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
  arch/x86/kernel/setup.c |    4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-3.4-rc6/arch/x86/kernel/setup.c
===================================================================
--- linux-3.4-rc6.orig/arch/x86/kernel/setup.c	2012-05-15 04:43:11.862313172 +0900
+++ linux-3.4-rc6/arch/x86/kernel/setup.c	2012-05-15 06:44:53.504030089 +0900
@@ -897,7 +897,7 @@ void __init setup_arch(char **cmdline_p)

  	cleanup_highmap();

-	memblock.current_limit = get_max_mapped();
+	memblock_set_current_limit(get_max_mapped());
  	memblock_x86_fill();

  	/*
@@ -933,7 +933,7 @@ void __init setup_arch(char **cmdline_p)
  		max_low_pfn = max_pfn;
  	}
  #endif
-	memblock.current_limit = get_max_mapped();
+	memblock_set_current_limit(get_max_mapped());

  	/*
  	 * NOTE: On x86-32, only from this point on, fixmaps are ready for use.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab0DNFDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 01:03:50 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35259 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab0DNFDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 01:03:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 14 Apr 2010 13:59:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Chris Mason <chris.mason@oracle.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] mm: disallow direct reclaim page writeback
Message-Id: <20100414135945.2b0a1e0d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100414014041.GD2493@dastard>
References: <1271117878-19274-1-git-send-email-david@fromorbit.com>
	<20100413095815.GU25756@csn.ul.ie>
	<20100413111902.GY2493@dastard>
	<20100413193428.GI25756@csn.ul.ie>
	<20100413202021.GZ13327@think>
	<20100414014041.GD2493@dastard>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010 11:40:41 +1000
Dave Chinner <david@fromorbit.com> wrote:

>  50)     3168      64   xfs_vm_writepage+0xab/0x160 [xfs]
>  51)     3104     384   shrink_page_list+0x65e/0x840
>  52)     2720     528   shrink_zone+0x63f/0xe10

A bit OFF TOPIC.

Could you share disassemble of shrink_zone() ?

In my environ.
00000000000115a0 <shrink_zone>:
   115a0:       55                      push   %rbp
   115a1:       48 89 e5                mov    %rsp,%rbp
   115a4:       41 57                   push   %r15
   115a6:       41 56                   push   %r14
   115a8:       41 55                   push   %r13
   115aa:       41 54                   push   %r12
   115ac:       53                      push   %rbx
   115ad:       48 83 ec 78             sub    $0x78,%rsp
   115b1:       e8 00 00 00 00          callq  115b6 <shrink_zone+0x16>
   115b6:       48 89 75 80             mov    %rsi,-0x80(%rbp)

disassemble seems to show 0x78 bytes for stack. And no changes to %rsp
until retrun.

I may misunderstand something...

Thanks,
-Kame


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab0DACKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 22:10:08 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51933 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756406Ab0DACKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 22:10:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] proc: pagemap: Hold mmap_sem during page walk
Cc: kosaki.motohiro@jp.fujitsu.com, Matt Mackall <mpm@selenic.com>,
       San Mehat <san@google.com>, linux-kernel@vger.kernel.org,
       Brian Swetland <swetland@google.com>, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1003311754110.3707@i5.linux-foundation.org>
References: <1270071636.3552.978.camel@calx> <alpine.LFD.2.00.1003311754110.3707@i5.linux-foundation.org>
Message-Id: <20100401104625.12C6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  1 Apr 2010 11:10:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So there is a very real reason for that pattern existing. It's just that 
> that reason has nothing to do with locking the thing into the page tables. 
> That is absolutely NOT guaranteed by the get_user_pages() physical page 
> pinning (munmap() is an extreme example of this, but I think swapout will 
> clear it too in try_to_unmap_one().

Right. To increment page->count only affect vmscan to prevent free page.
Not prevent pageout I/O nor page unmapping from a process.

Thanks.



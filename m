Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab0DIIRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 04:17:12 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46232 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab0DIIRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 04:17:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 02/13] mm: Revalidate anon_vma in page_lock_anon_vma()
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <n2x28c262361004090101ufa54ff03zc9a94c8808841206@mail.gmail.com>
References: <20100409160252.80E6.A69D9226@jp.fujitsu.com> <n2x28c262361004090101ufa54ff03zc9a94c8808841206@mail.gmail.com>
Message-Id: <20100409170529.80E9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  9 Apr 2010 17:17:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan,

> OFF-TOPIC:
> 
> I think you pointed out good thing, too. :)
> 
> You mean although application call mlock of any vma, few pages on the vma can
> be swapout by race between mlock and reclaim?
> 
> Although it's not disaster, apparently it breaks API.
> Man page
> " mlock() and munlock()
>   mlock()  locks pages in the address range starting at addr and
> continuing for len bytes. All pages that contain a part of the
> specified address range are guaranteed to be resident in RAM when the
> call returns  successfully;  the pages are guaranteed to stay in RAM
> until later unlocked."
> 
> Do you have a plan to solve such problem?
> 
> And how about adding simple comment about that race in page_referenced_one?
> Could you send the patch?

I'm surprising this mail. you were pushing much patch in this area.
I believed you know all stuff ;)

My answer is, it don't need to fix, because it's not bug. The point is
that this one is race issue. not "pageout after mlock" issue.
If pageout and mlock occur at the exactly same time, the human can't
observe which event occur in first. it's not API violation.

Thanks.



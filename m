Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab0KWHRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 02:17:16 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37376 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab0KWHRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 02:17:02 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2]mm/oom-kill: direct hardware access processes should get bonus
Cc: kosaki.motohiro@jp.fujitsu.com, "Figo.zhang" <figo1802@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1011150159330.2986@chino.kir.corp.google.com>
References: <20101115095446.BF00.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011150159330.2986@chino.kir.corp.google.com>
Message-Id: <20101123154843.7B8D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 23 Nov 2010 16:16:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 15 Nov 2010, KOSAKI Motohiro wrote:
> 
> > > I think in cases of heuristics like this where we obviously want to give 
> > > some bonus to CAP_SYS_ADMIN that there is consistency with other bonuses 
> > > given elsewhere in the kernel.
> > 
> > Keep comparision apple to apple. vm_enough_memory() account _virtual_ memory.
> > oom-killer try to free _physical_ memory. It's unrelated.
> > 
> 
> It's not unrelated, the LSM function gives an arbitrary 3% bonus to 
> CAP_SYS_ADMIN.  

Unrelated. LSM _is_ security module. and It only account virtual memory.


> Such threads should also be preferred in the oom killer 
> over other threads since they tend to be more important but not an overly 
> drastic bias such that they don't get killed when using an egregious 
> amount of memory.  So in selecting a small percentage of memory that tends 
> to be a significant bias but not overwhelming, I went with the 3% found 
> elsewhere in the kernel.  __vm_enough_memory() doesn't have that 
> preference for any scientifically calculated reason, it's a heuristic just 
> like oom_badness().

__vm_enough_memory() only gurard to memory overcommiting. And it doesn't
have any recover way. We expect admin should recover their HAND. In the
other hand, oom-killer _is_ automatic recover way. It's no need admin's 
hand. That's the reason why CAP_ADMIN is important or not.




> > > > CAP_SYS_RAWIO mean the process has a direct hardware access privilege
> > > > (eg X.org, RDB). and then, killing it might makes system crash.
> > > > 
> > > 
> > > Then you would want to explicitly filter these tasks from oom kill just as 
> > > OOM_SCORE_ADJ_MIN works rather than giving them a memory quantity bonus.
> > 
> > No. Why does userland recover your mistake?
> > 
> 
> You just said killing any CAP_SYS_RAWIO task may make the system crash, so 
> presuming that you don't want the system to crash, you are suggesting we 
> should make these threads completely immune?  That's never been the case 
> (and isn't for oom_kill_allocating_task, either), so there's no history 
> you can draw from to support your argument.

No. I only require YOU have to investigate userland usecase BEFORE making
change.




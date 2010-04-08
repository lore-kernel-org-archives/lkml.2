Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab0DHCDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 22:03:40 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48038 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758310Ab0DHCDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 22:03:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas of a mergeable VMA
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
       hannes@cmpxchg.org
In-Reply-To: <alpine.LFD.2.00.1004071625490.3586@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004071505510.3586@i5.linux-foundation.org> <alpine.LFD.2.00.1004071625490.3586@i5.linux-foundation.org>
Message-Id: <20100408101925.FB9F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  8 Apr 2010 11:03:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Wow, your patch is very cool. I'm surprising such 20 lines patch makes
lots simplify.

> On Wed, 7 Apr 2010, Linus Torvalds wrote:
> > 
> > Yes. The failure point is too late to do anything really interesting with, 
> > and the old code also just causes a SIGBUS. My intention was to change the 
> > 
> > 	WARN_ONCE(!vma->anon_vma);
> > 
> > into returning that SIGBUS - which is not wonderful, but is no different 
> > from old failures.
> 
> Not SIGBUS, but VM_FAULT_OOM, of course.

Now pagefault don't insert anon_vma anymore, right? if so, SIGBUS is better.
Now SIGBUS and VM_FAULT_OOM make different result.

SIGBUS       -> kill current task
VM_FAULT_OOM -> invoke oom-killer (see pagefault_out_of_memory())

If current task can't recover proper anon_vma. we should just kill current
instead random highest badness process. otherwise !anon_vma process continue
to randomly invoke oom-killer.

Perhaps, I'm missing something.




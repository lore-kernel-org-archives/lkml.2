Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab1E3BMi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 21:12:38 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45915 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab1E3BMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 21:12:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DE2EEFB.1080803@jp.fujitsu.com>
Date: Mon, 30 May 2011 10:12:27 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: mingo@elte.hu, akpm@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: Fix boot crash in mm_alloc()
References: <20110529072256.GA20983@elte.hu> <BANLkTikHejgEyz9LfJ962Bu89vn1cBP+WQ@mail.gmail.com> <BANLkTimqhkiBSArm7n0_9FD+LW6hWBWxFA@mail.gmail.com> <BANLkTin8yxh=Bjwf7AEyzPCoghnYO2brLQ@mail.gmail.com>
In-Reply-To: <BANLkTin8yxh=Bjwf7AEyzPCoghnYO2brLQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/30 3:43), Linus Torvalds wrote:
> On Sun, May 29, 2011 at 10:19 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> STILL TOTALLY UNTESTED! The fixes were just from eyeballing it a bit
>> more, not from any actual testing.
> 
> Ok, I eyeballed it some more, and tested both the OFFSTACK and ONSTACK
> case, and decided that I had better commit it now rather than wait any
> later since I'll do the -rc1 later today, and will be on an airplane
> most of tomorrow.
> 
> The exact placement of the cpu_vm_mask_var is up for grabs. For
> example, I started thinking that it might be better to put it *after*
> the mm_context_t, since for the non-OFFSTACK case it's generally
> touched at the beginning rather than the end.
> 
> And the actual change to make the mm_cachep kmem_cache_create() use a
> variable-sized allocation for the OFFSTACK case is similarly left as
> an exercise for the the reader. So effectively, this reverts a lot of
> de03c72cfce5, but does so in a way that should make very it easy to
> get back to where KOSAKI was aiming for.
> 
> Whatever. I was hoping to get comments on it, but I think I need to
> rather push it out to get tested and public than wait any longer. The
> patch *looks* fine, tests ok on my machine, and removes more lines
> than it adds despite the new big comment.

Hi

Thank you Linus and I'm sorry for bother you and guys. So, if I understand
this thread correctly, rest my homework is 1) make cpumask_allocation variable
size 2) remove NR_CPUS bit fill/copy from fork/exec path. Right?

I think (2) is big matter than (1). NR_CPUS(=4096) bits copy easily screw up
cache behavior. Anyway, will do. Thank you!




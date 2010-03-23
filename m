Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab0CWTOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 15:14:55 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:65150 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab0CWTOx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 15:14:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=KlzqxTkCVLTcDrDPZu9lM4Mi3qna3NlN6JqzrnN7G16fV0noStlSuhm3rGFITzvtjM
         dA0rd6oHYQwkQ5dmeXik8haLX6BqJ9gIFPoOYEL8Cs/X0XEUJksST3hCUpFyrumAKVJZ
         wlF+6Zxi+N08OG88Bxb+89FmUkWHyoOCgmIM0=
Subject: Re: [Bugme-new] [Bug 15618] New: 2.6.18->2.6.32->2.6.33 huge regression in performance
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Anton Starikov <ant.starikov@gmail.com>
In-Reply-To: <alpine.LFD.2.00.1003231037410.18017@i5.linux-foundation.org>
Date: Tue, 23 Mar 2010 20:14:48 +0100
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Transfer-Encoding: 8BIT
Message-Id: <9D040E9A-80F2-468F-A6CD-A4912615CD3F@gmail.com>
References: <bug-15618-10286@https.bugzilla.kernel.org/> <20100323102208.512c16cc.akpm@linux-foundation.org> <20100323173409.GA24845@elte.hu> <alpine.LFD.2.00.1003231037410.18017@i5.linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 23, 2010, at 6:45 PM, Linus Torvalds wrote:

> 
> 
> On Tue, 23 Mar 2010, Ingo Molnar wrote:
>> 
>> It shows a very brutal amount of page fault invoked mmap_sem spinning 
>> overhead.
> 
> Isn't this already fixed? It's the same old "x86-64 rwsemaphores are using 
> the shit-for-brains generic version" thing, and it's fixed by
> 
> 	1838ef1 x86-64, rwsem: 64-bit xadd rwsem implementation
> 	5d0b723 x86: clean up rwsem type system
> 	59c33fa x86-32: clean up rwsem inline asm statements
> 
> NOTE! None of those are in 2.6.33 - they were merged afterwards. But they 
> are in 2.6.34-rc1 (and obviously current -git). So Anton would have to 
> compile his own kernel to test his load.


Applied mentioned patches. Things didn't improve too much.

before:
prog: Total exploration time 9.880 real 60.620 user 76.970 sys

after:
prog: Total exploration time 9.020 real 59.430 user 66.190 sys

perf report:

    38.58%             prog  [kernel]                                           [k] _spin_lock_irqsave
    37.42%             prog  ./prog                                             [.] DBSLLlookup_ret
     6.22%             prog  ./prog                                             [.] SuperFastHash
     3.65%             prog  /lib64/libc-2.11.1.so                              [.] __GI_memcpy
     2.09%             prog  ./anderson.6.dve2C                                 [.] get_successors
     1.75%             prog  [kernel]                                           [k] clear_page_c
     1.73%             prog  ./prog                                             [.] index_next_dfs
     0.71%             prog  [kernel]                                           [k] handle_mm_fault
     0.38%             prog  ./prog                                             [.] cb_hook
     0.33%             prog  ./prog                                             [.] get_local
     0.32%             prog  [kernel]                                           [k] page_fault

Anton.


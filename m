Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab0CWR5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 13:57:40 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:55397 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab0CWR5j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 13:57:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=ZwEEDCe3qw/Y7tR/Smd+Bt3pXkgx0gaWUi3PU5cA2yKyOttkiK+0NPRJN/p4AGE1GZ
         fCqDO1z+7qZphJAL6CgfZBvCCywb18WaoVcoGVZ8i/koVi0hejcPeUq3DgadgL7yGYCN
         /VTR4PbTGBJWMcKBXWnUZVF2s+mFYrwa798/4=
Subject: Re: [Bugme-new] [Bug 15618] New: 2.6.18->2.6.32->2.6.33 huge regression in performance
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Anton Starikov <ant.starikov@gmail.com>
In-Reply-To: <alpine.LFD.2.00.1003231037410.18017@i5.linux-foundation.org>
Date: Tue, 23 Mar 2010 18:57:34 +0100
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Transfer-Encoding: 8BIT
Message-Id: <54F3A3FB-E99F-4278-AAAB-5B6A09247C4B@gmail.com>
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

Thanks for info, I will try it now.

> We could mark them as stable material if the load in question is a real 
> load rather than just a test-case. On one of the random page-fault 
> benchmarks the rwsem fix was something like a 400% performance 
> improvement, and it was apparently visible in real life on some crazy SGI 
> "initialize huge heap concurrently on lots of threads" load.

It is not just a test-case, it is real-life code. With real-life problems on 2.6.32 and later :)


Anton.
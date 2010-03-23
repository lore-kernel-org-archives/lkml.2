Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab0CWUoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 16:44:00 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46197 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab0CWUn6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 16:43:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=ULG1PrctSz3tPwy0tPa+E6npvi0IJ5egpV1Aru0t1JrdXI3nK6pzCFtqJOfN+pO3Cx
         ib6Goslf4bdhohC5OCreDB/jynS1lqZDUWaq8i5VGT6/DmF2vCXRB1evMz+2Z46fRA1A
         9CdQ8TeXm27rttfxYivODuZ1PO9AY31xejKI4=
Subject: Re: [Bugme-new] [Bug 15618] New: 2.6.18->2.6.32->2.6.33 huge regression in performance
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Anton Starikov <ant.starikov@gmail.com>
In-Reply-To: <alpine.LFD.2.00.1003231253570.18017@i5.linux-foundation.org>
Date: Tue, 23 Mar 2010 21:43:54 +0100
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Transfer-Encoding: 8BIT
Message-Id: <9FC34DA1-D6DD-41E5-8B76-0712A813C549@gmail.com>
References: <bug-15618-10286@https.bugzilla.kernel.org/> <20100323102208.512c16cc.akpm@linux-foundation.org> <20100323173409.GA24845@elte.hu> <alpine.LFD.2.00.1003231037410.18017@i5.linux-foundation.org> <9D040E9A-80F2-468F-A6CD-A4912615CD3F@gmail.com> <alpine.LFD.2.00.1003231253570.18017@i5.linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think we got a winner!

Problem seems to be fixed.

Just for record, I used next patches:

59c33fa7791e9948ba467c2b83e307a0d087ab49
5d0b7235d83eefdafda300656e97d368afcafc9a
1838ef1d782f7527e6defe87e180598622d2d071
4126faf0ab7417fbc6eb99fb0fd407e01e9e9dfe
bafaecd11df15ad5b1e598adc7736afcd38ee13d
0d1622d7f526311d87d7da2ee7dd14b73e45d3fc


Thanks,
Anton.

On Mar 23, 2010, at 8:54 PM, Linus Torvalds wrote:

> 
> 
> On Tue, 23 Mar 2010, Anton Starikov wrote:
> 
>> 
>> On Mar 23, 2010, at 6:45 PM, Linus Torvalds wrote:
>> 
>>> 
>>> 
>>> On Tue, 23 Mar 2010, Ingo Molnar wrote:
>>>> 
>>>> It shows a very brutal amount of page fault invoked mmap_sem spinning 
>>>> overhead.
>>> 
>>> Isn't this already fixed? It's the same old "x86-64 rwsemaphores are using 
>>> the shit-for-brains generic version" thing, and it's fixed by
>>> 
>>> 	1838ef1 x86-64, rwsem: 64-bit xadd rwsem implementation
>>> 	5d0b723 x86: clean up rwsem type system
>>> 	59c33fa x86-32: clean up rwsem inline asm statements
>>> 
>>> NOTE! None of those are in 2.6.33 - they were merged afterwards. But they 
>>> are in 2.6.34-rc1 (and obviously current -git). So Anton would have to 
>>> compile his own kernel to test his load.
>> 
>> 
>> Applied mentioned patches. Things didn't improve too much.
> 
> Yeah, I missed at least one commit, namely
> 
> 	bafaecd x86-64: support native xadd rwsem implementation
> 
> which is the one that actually makes x86-64 able to use the xadd version.
> 
> 		Linus


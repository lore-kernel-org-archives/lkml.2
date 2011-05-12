Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800Ab1ELVld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:41:33 -0400
Received: from smtp-out.google.com ([74.125.121.67]:8232 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757968Ab1ELVlc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:41:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BaUtSZV8rExLYotsySrrwwJomdfX5hqCqTGs0+4O1Mn6uIc9UUEfU0q6ZG1vG2fHLc
         Iywmi/3RAss8rmY9raLw==
MIME-Version: 1.0
In-Reply-To: <20110512213657.GC17596@elte.hu>
References: <BANLkTim8mAzZbdOhBodaOFKM5esP-Q+K7g@mail.gmail.com>
	<BANLkTi==OatTqfDbnAmHQA0t2DmokEd-CA@mail.gmail.com>
	<BANLkTik7wQc05OQTHThBbrFhKx2pM1Tx+A@mail.gmail.com>
	<20110512213657.GC17596@elte.hu>
Date: Thu, 12 May 2011 23:41:28 +0200
Message-ID: <BANLkTi=O-59PS5cXevufqm741wwH5kuxXg@mail.gmail.com>
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 11:36 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>> > The bug is that perf doesn't say "I can't match kernel symbols", but
>> > instead does some crazy matching and gives total crap module information (I
>> > think it just picks the one that shows up last in /proc/kallsyms).
>>
>> But I agree perf must not silently return bogus information. It should print
>> a big warning message and/or fallback to printing the raw addresses. [...]
>
> Yes, agreed, this is a bug in perf. I found out about this about two weeks ago
> and reported it to Arnaldo, but he is away right now - he might be able to fix
> it next week the earliest.
>
>> [...] So much for having perf in the kernel source tree to keep things in
>> sync...
>
> What do you mean?
>
I meant that when this kptr feature was added, people should have scanned the
entire tree (include tools/perf) to look for potential impact on
programs relying
on /proc/kallsyms. Having perf in the tree should have made this easier to
catch. That's all.



> Thanks,
>
>        Ingo
>

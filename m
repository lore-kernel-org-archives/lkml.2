Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab0FJAI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 20:08:59 -0400
Received: from smtp-out.google.com ([74.125.121.35]:6982 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab0FJAI5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 20:08:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=v/QjJf4JH/qSZmUliDwkyacmVRQSsm8notrrY1ZlVQbRIMEwZ3Ca53coLBrDE6Ffs
	YsOiqskMQ3R4INmzLTDOw==
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1006091525250.4506@i5.linux-foundation.org>
References: <20100609210014.7464.92234.stgit@bumblebee1.mtv.corp.google.com>
	<alpine.LFD.2.00.1006091408430.4506@i5.linux-foundation.org>
	<1276119207.1745.154.camel@laptop>
	<alpine.LFD.2.00.1006091517450.4506@i5.linux-foundation.org>
	<alpine.LFD.2.00.1006091525250.4506@i5.linux-foundation.org>
Date: Wed, 9 Jun 2010 17:08:52 -0700
Message-ID: <AANLkTim56xHJM-6ZgFvEO2YetDLCnjaCoOtxYGTqtE0c@mail.gmail.com>
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be 
	reused immediately.
From: Salman Qazi <sqazi@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, tytso@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 9, 2010 at 3:27 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Wed, 9 Jun 2010, Linus Torvalds wrote:
>>
>> Quite possibly. I'd worry about the overflow case a bit, but it's
>> certainly going to get the right value when base << MAX_INT.
>
> Having given it a couple of seconds more thought, I don't think there is
> an overflow case either. All of a/b/base are guaranteed to be non-negative
> (or our pid code is in worse trouble anyway), so there is no overflow
> possible. So yes. Just comparing a-base < b-base should always be safe

I don't think this gives the right answer in the a < base < b  case.
Here a - base < 0 and
b - base > 0.  But we really want b to be before a, since a has rolled
over further than b.  I think
the right solution is comparing (a - base + max_pid) % max_pid with (b
- base + max_pid) % max_pid.  Am I correct or deluded?
.
>
>                        Linus
>
>
>

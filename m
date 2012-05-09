Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab2EIHfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 03:35:55 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61234 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab2EIHfx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 03:35:53 -0400
MIME-Version: 1.0
In-Reply-To: <87sjfcfynb.fsf@rustcorp.com.au>
References: <87ehtf3lqh.fsf@rustcorp.com.au>
	<20120227155338.7b5110cd.akpm@linux-foundation.org>
	<20120228112422.GC11324@alboin.amr.corp.intel.com>
	<87ipijzfwn.fsf@rustcorp.com.au>
	<20120420112149.GH25458@amd.local0.net>
	<87sjfcfynb.fsf@rustcorp.com.au>
Date: Wed, 9 May 2012 17:35:53 +1000
Message-ID: <CAPa8GCCSBxZZVS+ROshEW9qXwXLpwkoeiFiL0xnSGW6rsDQyrA@mail.gmail.com>
Subject: Re: [PATCH 3/3] brlocks/lglocks: turn into functions
From: Nick Piggin <npiggin@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Nick Piggin <npiggin@kernel.dk>, Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 May 2012 13:39, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Fri, 20 Apr 2012 21:21:49 +1000, Nick Piggin <npiggin@kernel.dk> wrote:
>> This still not merged?
>
> No, I've been away.  I've put it in -next for tomorrow, though I'm not
> sure what the best way to get it to Linus next merge window.
>
>> There is a reason, which is performance. Extra function call, but also
>> IIRC the percpu accessor was not so fast doing it this way. Maybe
>> that's improved...
>>
>> So what's the performance difference?
>
> What benchmarks you usually run?  Feel free to try it out and report
> back; I only have small hardware here.

Nothing big. The actual scalability should be unchanged, because you're
not going to be dirtying any shared cachelines. It's the use of dynamic
percpu allocator and out of line calls etc which will slow down straight
line performance.

How many microseconds does it take to stat("./dir1/dir2/myfile"), for
example?

`git diff` of a large tree, for something more realistic but still going to
exercise that path.

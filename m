Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459Ab2EOPZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:25:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44671 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab2EOPZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:25:26 -0400
Message-ID: <4FB2755F.9020606@gmail.com>
Date: Tue, 15 May 2012 09:25:19 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Perf events warning..
References: <CA+55aFzNQqa9nuhZUog-+B0SfU6ip_QSt73R=2Du=M2ua1cFBA@mail.gmail.com>  <1337034048.27020.137.camel@laptop>  <CA+55aFxHw_SOX7fvcwskwP0qvLwyeXxTFjk589pnQtmYevhvpw@mail.gmail.com> <1337078996.27694.26.camel@twins>
In-Reply-To: <1337078996.27694.26.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/12 4:49 AM, Peter Zijlstra wrote:
> On Mon, 2012-05-14 at 15:25 -0700, Linus Torvalds wrote:
>> On Mon, May 14, 2012 at 3:20 PM, Peter Zijlstra<a.p.zijlstra@chello.nl>  wrote:
>>>
>>> So far I can't make any of the things I came up stick. You ran something
>>> simple like: 'perf record -e cycles:pp -F 20000 make test' ? Or did you
>>> do something more interesting?
>>
>> It was not much more complex than that.
>>
>> It did use "make -j64 test" to make the load a *bit* more interesting
>> (and go noticeably faster), but other than that you got it.
>
> OK, that limits the scope of crazy scenarios I have to consider, still
> no immediate clue though..
>
> I think I've found a possible race, but I can't make it work with that
> workload. I've also let your workload run for 2+ hours in trying to
> reproduce, but no luck, it must be a very narrow window indeed.
>
> I'll keep prodding at it..

Perhaps it is specific to processor generation? Yesterday I noted that 
perf-stat -g trips a WARNING only on Nehalem. Westmere works fine - 
perf-stat -g generates output and no warning is triggered. Arnaldo is 
using Sandy Bridge - though it's not clear if his success (3.4.0-rc3 on 
server named sandy) or fail (3.4.0-rc4-uprobes on felicio) was on a SNB.

David

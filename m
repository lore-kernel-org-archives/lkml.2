Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab1E0PEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 11:04:45 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37631 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1E0PEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 11:04:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PSikPCNFm7LupY710F2bnjkoOq9morA1/kauLDOi45Bfd99Fg4Gkwtl7BOBYiNJWk1
         trL8HhlI0qNy/7zaRxc2QngJuPAQCvh+nkAlbBHRKP1HmgFJJvaf5kgdQO4f/RjHzP/O
         lX1PiuBMdFlXnZ4GkzBK7WOPl1Th2Ok8sQ/ZU=
Message-ID: <4DDFBD83.3020105@gmail.com>
Date: Fri, 27 May 2011 09:04:35 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: perf: h/w counters not counted and no error/info reported to
 user
References: <4DDECFC8.7090903@gmail.com> <20110527095036.GK21386@elte.hu>
In-Reply-To: <20110527095036.GK21386@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/27/2011 03:50 AM, Ingo Molnar wrote:
> 
> * David Ahern <dsahern@gmail.com> wrote:
> 
>> By default (tip-perf-core) perf-stat enables a number of H/W counters:
>>
>> perf stat  -- sleep 1
> 
> did you mean to do 'perf stat -a sleep 1' ?

Adding the -a has its own problems. It blocks reading from fd=0 (stdin);
I have to type Ctrl-D to see the results. The FD array gets initialized
to 0 and some case is not erroring out or setting the fd.

perf stat -a -- sleep 1

 Performance counter stats for 'sleep 1':

       2008.600377 task-clock
               545 context-switches
                31 CPU-migrations
               198 page-faults
       101,938,898 cycles
140,734,186,560,480 stalled-cycles-frontend
                 0 stalled-cycles-backend
       115,406,129 instructions

        26,361,321 branches
         1,068,804 branch-misses

       1.003842524 seconds time elapsed

The stalled-cycles-frontend is off the chats, but shows a value.
Similarly, backed shows 0 versus <not counted>.


> 
> 'perf stat sleep 1' in itself will only measure that very simple 
> command - which does not do much.

Simple program for a simple test. I just wanted to know which counters
are available for a given processor.

Per your comment and Corey's I tried a program that does some work:

perf stat -- openssl speed aes

Performance counter stats for 'openssl speed aes':

      44964.148608 task-clock
             4,593 context-switches
                48 CPU-migrations
               487 page-faults
   124,134,470,217 cycles
     <not counted> stalled-cycles-frontend
     <not counted> stalled-cycles-backend
   319,440,401,206 instructions
     6,710,107,937 branches
         1,638,412 branch-misses

      45.012092601 seconds time elapsed
This time I get data for 4 events -- which I did not get with sleep --
but I get <not counted> for the stalled cycles.

How is the <not counted> supposed to be interpreted?

Also, back to the 'perf stat -- sleep 1' example: If I run it with
individual -e <event> args I get values -- up to 3. Sure sleep is a
simple program, but some counter value comes out. What's magical about 3?

David


> 
> Thanks,
> 
> 	Ingo

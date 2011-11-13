Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab1KMVDY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 16:03:24 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52732 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1KMVDX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 16:03:23 -0500
MIME-Version: 1.0
X-Originating-IP: [197.237.16.88]
In-Reply-To: <20111113134314.GA2699@ghostprotocols.net>
References: <1319048598-15030-1-git-send-email-dsahern@gmail.com>
 <20111019183848.GE2229@ghostprotocols.net> <4E9F1AA0.4010706@gmail.com>
 <20111019192011.GG2229@ghostprotocols.net> <4E9F4B50.1060207@gmail.com>
 <20111020130041.GB1772@ghostprotocols.net> <CAHVUoiSwem2r9J==gmHPfst3_0ZB5bd0ykf9cPUMdhZFaXC9EA@mail.gmail.com>
 <20111113134314.GA2699@ghostprotocols.net>
From: Brian Marete <marete@toshnix.com>
Date: Mon, 14 Nov 2011 00:03:02 +0300
Message-ID: <CAHVUoiSgT8DuauMCpM1G_GWeqmHsPBzudew+5xJLuDGW7d9Ryw@mail.gmail.com>
Subject: Re: [PATCH] perf top: fix crash on annotate request
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 13, 2011 at 4:43 PM, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> Em Fri, Nov 11, 2011 at 01:01:47AM +0300, Brian Marete escreveu:
>> On Thu, Oct 20, 2011 at 4:00 PM, Arnaldo Carvalho de Melo
>> <acme@ghostprotocols.net> wrote:
>> > I.e. the map_ip for this method is messing up things, what symbol is
>> > this? I.e. please provide:
>
>> > p *sym
>> > p *map
>
>> I have am experiencing the same segfault using perf from the latest
>> linus' tree. The gdb backtrace is below. Which patch fixes it? Or is
>> it already fixed in some git tree on kernel.org?
>
> Can you perform this command?
>
> [acme@felicio linux]$ git log | head -1
> commit 3439a8da16bcad6b0982ece938c9f8299bb53584

I can answer this straight away: Yes. This is the same HEAD I have.

>
>> Program received signal SIGSEGV, Segmentation fault.
>> 0x000000000042e27e in symbol__inc_addr_samples (sym=0x1279e70, map=0x9677a0,
>>     evidx=0, addr=256544) at util/annotate.c:73
>> 73            h->addr[offset]++;
>
>> # Output of p *sym
>> $1 = {rb_node = {rb_parent_color = 19423281, rb_right = 0x0, rb_left = 0x0},
>>   start = 1124896, end = 1126163, namelen = 16, binding = 0 '\000',
>>   ignore = false, name = 0x1279e70 "1`(\001"}
>
> It is going well before the start of this symbol:
>
> addr(256544) < sym->start(1124896)
>

I will reproduce (which I am always able to do) run another bt and report back.

-- 
Brian Gitonga Marete
Toshnix Systems
Tel: +254722151590

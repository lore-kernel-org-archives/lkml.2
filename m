Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab1DAOn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 10:43:26 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43349 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757386Ab1DAOnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 10:43:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=yFE6GSuf2WB3nFFxiHlZva6byWS5RZVXtldiNr5OiGGY/n4Wo7WSms7Fha28ZVuZWx
         qc9R09RsFCYxksfUFYERRAdLfBms7wtdSuu59VB8cVKNHTEJs/zxnNBdDtIBhZRKK5bS
         hwjBf3hRwASRk8WvR35Hn1EuFL0yOilmfz8HI=
Date: Fri, 1 Apr 2011 16:43:15 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH -tip v3 0/6] perf: Introduce branch sub commands
Message-ID: <20110401144312.GB2335@nowhere>
References: <20110324113137.20235.42265.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110324113137.20235.42265.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 08:31:37PM +0900, Akihiro Nagai wrote:
> Hi,
> 
> This patch series provides the commands 'perf branch record' and 'perf branch trace'
> version 3. These commands record and analyze a BTS (Branch Trace Store) log.
> And, they provide the interface to use BTS log for application developers.
> 
> BTS is a facility of Intel x86 processors, which records the address of
> 'branch to/from' on every branch/jump instruction and interrupt.
> This facility is very useful for developers to test their software,
> for example, coverage test, execution path analysis, dynamic step count ...etc.
> These test tools have a big advantage, which user doesn't have to modify target
> executable binaries, because the BTS is a hardware feauture.
> 
> But, there are few applications using BTS. Reasons I guess are ...
>  - Few people know what BTS is.
>  - Few people know how to use BTS on Linux box.
>  - It's hard to analyze the BTS log because it includes just a series of addresses.
> 
> So, I want to provide a user-friendly interface to BTS for application developers.
> 
> 
>  About new sub commands
> ========================
> 'perf branch record' provides an easy way to record BTS log.
> Usage is 'perf branch record <command>'.  This command is just an alias to
> 'perf record -e branches:u -c 1 <command>'. But, new one is more simple and
> more intuitive.
> 
> 'perf branch trace' can parse and analyze recorded BTS log and print various
> information of execution path. This command can show address, pid, command name,
> function+offset, file path of elf.
> You can choose the printed information with option.
> 
> Example: 'perf branch trace'
> function+offset
> irq_return+0x0  => _start+0x0
> irq_return+0x0  => _start+0x0
> _start+0x3      => _dl_start+0x0
> irq_return+0x0  => _dl_start+0x0
> irq_return+0x0  => _dl_start+0x26
> irq_return+0x0  => _dl_start+0x2d
> _dl_start+0x71  => _dl_start+0x93
> _dl_start+0x97  => _dl_start+0x78
> ...
> 
> This is the default behavior of 'perf branch trace'. It prints function+offset.
> 
> 
> Example2: 'perf branch -cas trace'
> command address            function+offset                  
> ls      0xffffffff8146fe0e irq_return+0x0  => ls   0x0000003806200b20 _start+0x0

You probably want to display the comm (and/or the pid/tid) only once. Those are not
going to change between the source and destination.

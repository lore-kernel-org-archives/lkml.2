Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739Ab2EDPJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 11:09:29 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49275 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750974Ab2EDPJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 11:09:26 -0400
Date: Fri, 4 May 2012 12:03:12 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>, namhyung.kim@lge.com,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        jolsa@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] perf: Fix build failure on OpenSuse userspace
Message-ID: <20120504150312.GC10068@infradead.org>
References: <87sjfgafqj.fsf@sejong.aot.lge.com>
 <20120503.215020.954262287222794218.davem@davemloft.net>
 <CACqU3MVqpz=azeUOUfmtoLEPvqngfJHSHFe7ujemeRT1-B=osA@mail.gmail.com>
 <CACqU3MWLKMhTdh-HUh0MhE_hZmwNPG5FOxWarjO4BsRemmG8sA@mail.gmail.com>
 <CACqU3MVVgo7R8CmGwi6utE0F0urf5NW58s23bmNU_rSQAg2pww@mail.gmail.com>
 <20120504024706.GA10461@kroah.com>
 <CACqU3MUwDaRXwAd3fu7sUmM2ApH+pfu4rf1-TNKt1ja+wYpJ9w@mail.gmail.com>
 <20120504031614.GA12048@kroah.com>
 <20120504070928.GA18351@gmail.com>
 <CACqU3MXRGP3Ep2sJwAB+aOTp9ezifRy+FhVkGjZpzTSW2PhCqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACqU3MXRGP3Ep2sJwAB+aOTp9ezifRy+FhVkGjZpzTSW2PhCqg@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, May 04, 2012 at 10:44:28AM -0400, Arnaud Lacombe escreveu:
>     CC util/parse-events-flex.o
> <stdout>: In function â€˜yy_get_next_bufferâ€™:
> <stdout>:1510:3: error: comparison between signed and unsigned integer
> expressions [-Werror=sign-compare]
> util/parse-events.l: In function â€˜parse_events_lexâ€™:
> util/parse-events.l:122:1: error: ignoring return value of
> â€˜fwriteâ€™, declared with attribute warn_unused_result
> [-Werror=unused-result]
> cc1: all warnings being treated as errors
> 
> So I doubt -Wno-unused-parameter will do any good here.
> 
> How about my solution, pre-generating the lexer/tokenizer ? It has
> been used without trouble in other place of the tree for years. I
> don't really see the point of micro-managing flex/bison issue here.

This was what we did in the first place:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=89812fc81f8d62d70433a8ff63d26819f372e8ec

Then we asked Linus about it and he said:

https://lkml.org/lkml/2012/3/28/417

So we:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=65f3e56e0c81d1f581c4bdef7646ae5a8d51f494

- Arnaldo

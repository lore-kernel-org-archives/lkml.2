Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937640Ab0CPJzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 05:55:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54296 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937631Ab0CPJzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 05:55:37 -0400
Date: Tue, 16 Mar 2010 10:55:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: acme@infradead.org, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       efault@gmx.de, a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: [PATCH 2/2] perf top: Properly notify the user that vmlinux is
 missing
Message-ID: <20100316095523.GJ7961@elte.hu>
References: <20100315192125.GL6965@ghostprotocols.net>
 <20100315.122605.124976085.davem@davemloft.net>
 <20100316094611.GG7961@elte.hu>
 <20100316.025134.196872789.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316.025134.196872789.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 16 Mar 2010 10:46:11 +0100
> 
> > i'd really like that to happen - i.e. if we had the kernel (and modules) image 
> > exposed as a (almost-)standard ELF object via /sys or so.
> > 
> > We already have some aspects of that, via /sys/kernel/notes, but it should be 
> > done for real. That would also make build-id support less of a hack.
> > 
> > ( I'd not include CFI debuginfo in there though - that would be way too large.
> >   More compressed debuginfo could be included perhaps. )
> 
> That's interesting and useful, but wouldn't help my case as the images I'm 
> usually booting are completely stripped.

/me too

> That's why I end up with "[kernel.kallsyms]" for kernel profiling :-)

The kernel image itself is still present in RAM, obviously. So are the symbols 
(packed for kallsyms).

So exposing a virtual ELF image via /sys (or /proc/kernel.so) wouldnt take up 
much more RAM and would be rather useful, right?

	Ingo

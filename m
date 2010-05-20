Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab0ETOWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 10:22:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751934Ab0ETOWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 10:22:13 -0400
Date: Thu, 20 May 2010 07:18:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       Miklos Szeredi <miklos@szeredi.hu>, peterz@infradead.org,
       fweisbec@gmail.com, tardyp@gmail.com, mingo@elte.hu, acme@redhat.com,
       tzanussi@gmail.com, paulus@samba.org, linux-kernel@vger.kernel.org,
       arjan@infradead.org, ziga.mahkovec@gmail.com, davem@davemloft.net,
       linux-mm@kvack.org, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, tj@kernel.org,
       jens.axboe@oracle.com, Michael Kerrisk <mtk.manpages@gmail.com>,
       linux-man@vger.kernel.org
Subject: Re: Unexpected splice "always copy" behavior observed
In-Reply-To: <20100520015605.GA28411@Krystal>
Message-ID: <alpine.LFD.2.00.1005200715460.23538@i5.linux-foundation.org>
References: <1274280968.26328.774.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1005190758070.23538@i5.linux-foundation.org> <E1OElGh-0005wc-I8@pomaz-ex.szeredi.hu> <1274283942.26328.783.camel@gandalf.stny.rr.com> <20100519155732.GB2039@Krystal>
 <20100519162729.GE2516@laptop> <20100519191439.GA2845@Krystal> <alpine.LFD.2.00.1005191220370.23538@i5.linux-foundation.org> <20100519214905.GA22486@Krystal> <alpine.LFD.2.00.1005191659100.23538@i5.linux-foundation.org> <20100520015605.GA28411@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 May 2010, Mathieu Desnoyers wrote:
> 
>        Programs  can  use  posix_fadvise()  to announce an intention to access
>        file data in a specific pattern in the future, thus allowing the kernel
>        to perform appropriate optimizations.

It's true for some of them. The random-vs-linear behavior is a flag for 
the future, for example (relevant for prefetching).

In fact, it's technically true even for DONTNEED. It's true that we won't 
need the pages in the future! So we throw the pages away. But that means 
that we throw the _current_ pages away.

If we actually touch pages later, than that obviously invalidates the fact 
that we said 'DONTNEED' - we clearly needed them.

		Linus

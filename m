Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934310Ab0EZKLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 06:11:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:50186 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932719Ab0EZKLc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 06:11:32 -0400
Subject: Re: [PATCH 0/4] convert perf to local64_t
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>, Paul Mundt <lethal@linux-sh.org>,
       Will Deacon <will.deacon@arm.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100526100844.GB5311@nowhere>
References: <20100521134205.781916350@chello.nl>
	 <20100526100844.GB5311@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 May 2010 12:11:10 +0200
Message-ID: <1274868670.5882.5189.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-26 at 12:08 +0200, Frederic Weisbecker wrote:
> On Fri, May 21, 2010 at 03:42:05PM +0200, Peter Zijlstra wrote:
> > These patches introduce local64_t.
> > 
> > Since perf_event:count is only modified cross-cpu when child-counters
> > feed back their changes on exit, and we can use a secondary variable
> > for that, we can convert perf to use local64_t instead of atomic64_t
> > and use instructions without buslock semantics.
> > 
> > The local64_t implementation uses local_t for 64 bits, since local_t is
> > of type long, for 32 bit it falls back to atomic64_t. Architectures can
> > provide their own implementation as usual.
> 
> 
> It seems nobody disagrees with it. Can we give it a try?

I'll push it to mingo around -rc2 or so, to let the dust settle from the
current merge.

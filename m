Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab0KRF6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 00:58:50 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46591 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab0KRF6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 00:58:49 -0500
X-AuditID: b753bd60-a41a1ba000003e7d-13-4ce4c094e89d
Message-ID: <4CE4C091.8060306@hitachi.com>
Date: Thu, 18 Nov 2010 14:58:41 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        "Ted Ts'o" <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [ANNOUNCE] New utility: 'trace'
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6> <20101117013700.GA3290@thunk.org> <20101117132404.GF27063@elte.hu> <1290001128.2109.785.camel@laptop> <20101117140002.GH27063@elte.hu> <1290003110.2109.822.camel@laptop> <1290006634.30543.61.camel@gandalf.stny.rr.com> <1290008637.2109.967.camel@laptop> <20101117182344.GD13717@Krystal>
In-Reply-To: <20101117182344.GD13717@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/11/18 3:23), Mathieu Desnoyers wrote:
> Amongst others, Ericsson rely on this kind of feature. The case where we're
> filtering "out" should be really, really fast (even if it makes the recording
> slightly slower). If there is a race modifying the data underneath between the
> filter execution and the copy to the buffers, I really don't think it matters.
> If the tracepoint caller context don't provide data consistency guarantees for
> the parameters it passes, we should not expect 100% perfect consistency between
> filter and what is actually saved in the trace. The trace analysis tools should
> just be able to cope with that, but I really don't think anyone should care.
> 
> So I would recommend no copy, filter directly on the source data, stop the
> filter chain as soon as a non-match is observed. Copy the data into the buffers
> if the filter passes.

Indeed, so that we can eliminate memory write accesses. :)

Thanks,

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

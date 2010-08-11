Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434Ab0HKOoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 10:44:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36918 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab0HKOoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 10:44:15 -0400
X-Authority-Analysis: v=1.1 cv=6Y8H/nL8L93N+XbmwlK57FdrlxW9D5uKLQCRlCnhMcQ= c=1 sm=0 a=ZI5MULQygNwA:10 a=Q9fys5e9bTEA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:17 a=JfrnYn6hAAAA:8 a=ww77_pfMzP2emOSOIQcA:9 a=q6RZo5ydMQE3huxcNMgHYUCWVqEA:4 a=PUjeQqilurYA:10 a=3Rfx1nUSh_UA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.87.39
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
In-Reply-To: <20100806141348.GB30349@Krystal>
References: <20100714231117.GA22341@Krystal>
	 <20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal>
	 <1280855904.1923.675.camel@laptop>
	 <AANLkTinydcsYG6wj06bj0++EfiWUMQnZk=QvLQp=S8YB@mail.gmail.com>
	 <1280903273.1923.682.camel@laptop> <20100804140605.GA29371@Krystal>
	 <1280933410.1923.1267.camel@laptop> <20100806014231.GA496@Krystal>
	 <1281089471.1947.399.camel@laptop>  <20100806141348.GB30349@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 11 Aug 2010 10:44:09 -0400
Message-ID: <1281537849.3058.23.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-06 at 10:13 -0400, Mathieu Desnoyers wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:

> Less code = less instruction cache overhead. I've also shown that the LTTng code
> is at least twice faster. In terms of complexity, it is not much more complex; I
> also took the extra care of doing the formal proofs to make sure the
> corner-cases were dealt with, which I don't reckon neither Steven nor yourself
> have done.

Yes Mathieu, you did a formal proof. Good for you. But honestly, it is
starting to get very annoying to hear you constantly stating that,
because, to most kernel developers, it is meaningless. Any slight
modification of your algorithm, renders the proof invalid.

You are not the only one that has done a proof to an algorithm in the
kernel, but you are definitely the only one that constantly reminds
people that you have done so. Congrats on your PhD, and in academia,
proofs are important.

But this is a ring buffer, not a critical part of the workings of the
kernel. There are much more critical and fragile parts of the kernel
that work fine without a formal proof.

Paul McKenney did a proof for RCU not for us, but just to help give him
a warm fuzzy about it. RCU is much more complex than the ftrace ring
buffer, and it also is much more critical. If Paul gets it wrong, a
machine will crash. He's right to worry. And even Paul told me that no
formal proof makes up for large scale testing. Which BTW, the ftrace
ring buffer has gone through.

Someday I may go ahead and do that proof, but I did do a very intensive
state diagram, and I'm quite confident that it works. It's been deployed
for quite a bit, and the design has yet to be a factor in any bug report
of the ring buffer.

-- Steve



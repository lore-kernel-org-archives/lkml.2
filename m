Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab0ERQKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 12:10:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55274 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab0ERQKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 12:10:43 -0400
X-Authority-Analysis: v=1.1 cv=ThiPuEJrAfM5PTlEgIT3cJp8+3pkHBIG3CaogqDGxqo= c=1 sm=0 a=8EtQVlZUVNwA:10 a=hO-oPbc3tlwA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=wNM0KSR54ppBKsNzgvwA:9 a=NkknEO9UKuWKQbML3x_Q6hUbHJYA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: Unexpected splice "always copy" behavior observed
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Pierre Tardy <tardyp@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       ziga.mahkovec@gmail.com, davem <davem@davemloft.net>,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <1274197993.26328.755.camel@gandalf.stny.rr.com>
References: <20100518153440.GB7748@Krystal>
	 <1274197993.26328.755.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 18 May 2010 12:10:39 -0400
Message-ID: <1274199039.26328.758.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-18 at 11:53 -0400, Steven Rostedt wrote:

> I'm currently looking at the network code to see if it is better.

The network code seems to do the right thing. It sends the actual page
directly to the network.

Hopefully we can find a way to avoid the copy to file. But the splice
code was created to avoid the copy to and from userspace, it did not
guarantee no copy within the kernel itself.

-- Steve



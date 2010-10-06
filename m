Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475Ab0JFUbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 16:31:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38046 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759059Ab0JFUbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 16:31:40 -0400
X-Authority-Analysis: v=1.1 cv=vbQZhf6WRU4XF+4tPWNJEMYU0N1CowIjcRZ/qR/IBDs= c=1 sm=0 a=cD81UUMRb2IA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1xyqmJOagibntsUD8z0A:9 a=H9IuXV-XBcOJXjcHBbwxOu939_kA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC PATCH] poll(): add poll_wait_set_exclusive()
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20101006190434.GA5783@Krystal>
References: <20101006175635.GA21652@Krystal>
	 <AANLkTik3MWtEpi=mzf2-_x4_kdrwv-EOjeVHNzbmfian@mail.gmail.com>
	 <20101006190434.GA5783@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 06 Oct 2010 16:31:36 -0400
Message-ID: <1286397096.6661.2.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-06 at 15:04 -0400, Mathieu Desnoyers wrote:

> For reference, here is the use-case: The user-space daemon runs typically one
> thread per cpu, each with a handle on many file descriptors. Each thread waits
> for data to be available using poll(). In order to follow the poll semantic,
> when data becomes available on a file descriptor, the kernel wakes up all
> threads at once, but in my case only one of them will successfully consume the
> data (all other thread's splice or read will fail with -ENODATA). With many
> threads, these useless wakeups add an unwanted overhead and scalability
> limitation.

Mathieu, I'm curious to why you have multiple threads reading the same
fd. Since the threads are per cpu, does the fd handle all CPUs? Or do
you have an fd per event per CPU, in which case the threads should just
poll off of their own fds.

-- Steve



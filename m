Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab0JaXDV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 19:03:21 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:55490 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab0JaXDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 19:03:18 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 31 Oct 2010 16:02:43 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@davide-lnx1
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
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
Subject: Re: [RFC PATCH] poll(): add poll_wait_set_exclusive()
In-Reply-To: <20101007165303.GA799@Krystal>
Message-ID: <alpine.DEB.2.00.1010311512380.16129@davide-lnx1>
References: <20101006175635.GA21652@Krystal> <AANLkTik3MWtEpi=mzf2-_x4_kdrwv-EOjeVHNzbmfian@mail.gmail.com> <20101006190434.GA5783@Krystal> <AANLkTin6na1PyFDK5Oua0_ep8PzUNi=iceYdGQ03=F-Y@mail.gmail.com> <20101007165303.GA799@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Oct 2010, Mathieu Desnoyers wrote:

> > Also, doesn't eventpoll already support exclusive polling? I dunno.
> > Davide might be interested in the discussion regardless.
> 
> Looking at epoll(7), the behavior of EPOLLONESHOT when there are multiple epoll
> instances monitoring a file descriptor seems unclear: does it stop event
> propagation after delivery to the first epoll instance (this is the behavior I
> am looking for), or does it stop the event delivery after having woken up all
> epoll instances monitoring the file descriptor ? Davide might have the answer to
> this one.

Sorry for the late response, but I am very slowly wroking my way through a 
long backlog.
In your case above, both fds will get event report, in epoll, with 
EPOLLONESHOT (because the one-shot applies to the epoll-fd/monitored-fd 
pair/key).
As for the exclusive wakeup feature, I am not totally against it, though 
it is borderline as far as use cases vs. added complexity.
The POLLEX/EPOLLEX would be nicer, if it wouldn't lead to a racy interface 
(say one thread uses [E]POLLEX and the another not).
IMO this is more fcntl(2) flag territory, as the application would set the 
behavior globally (for the file), though again, I am not sure the use 
cases justify the introduction and handling of the new flag.



- Davide



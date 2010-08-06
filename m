Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761430Ab0HFOP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 10:15:27 -0400
Received: from mail.openrapids.net ([64.15.138.104]:51990 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756064Ab0HFOPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 10:15:25 -0400
Date: Fri, 6 Aug 2010 10:15:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
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
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
Message-ID: <20100806141524.GC30349@Krystal>
References: <20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal> <1280855904.1923.675.camel@laptop> <AANLkTinydcsYG6wj06bj0++EfiWUMQnZk=QvLQp=S8YB@mail.gmail.com> <1280903273.1923.682.camel@laptop> <20100804140605.GA29371@Krystal> <1280933410.1923.1267.camel@laptop> <20100806014231.GA496@Krystal> <1281089471.1947.399.camel@laptop> <1281093298.1947.476.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281093298.1947.476.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:14:18 up 195 days, 16:51,  5 users,  load average: 0.11, 0.05,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Fri, 2010-08-06 at 12:11 +0200, Peter Zijlstra wrote:
> > > You need to read the whole trace to find these cookies (even if it is just once
> > > at the beginning if you create an index).
> 
> Even if you want to index all sync points you can quickly skip through
> the file using the sync-distance, after which you'll have, on average,
> only 1/2 avg-event-size to read before you find your next sync point.
> 
> So suppose you have a 1M sync-distance, and an effective average event
> size of 128 bytes, then for a 4G file, you can find all sync points by
> only reading ~262144 bytes (not counting for the fact that the pagecache
> will bring in full pages, which would result in something like 16M to be
> read in total or somesuch -- which, again assumes read-ahead isn't going
> to play tricks on you).

How do you distinguish between sync events and random payload data ?

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

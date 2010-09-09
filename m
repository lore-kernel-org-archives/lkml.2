Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab0IIMrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 08:47:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42871 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab0IIMrk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 08:47:40 -0400
Subject: Re: perf events over (net) console?
From: Peter Zijlstra <peterz@infradead.org>
To: Harald Gustafsson <hgu1972@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Song Yuan <song.yuan@ericsson.com>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <AANLkTikuqHFdOoiB4ejRygi3EV3p4HN2jgjJwM6Sw+31@mail.gmail.com>
References: <AANLkTi=yeHyOeewm9tdsHRtj+=d+vE5=NRKGaPyq_yGH@mail.gmail.com>
	 <1284031141.402.1.camel@laptop> <20100909112940.GA5267@nowhere>
	 <20100909114053.GA15140@elte.hu>
	 <AANLkTikuqHFdOoiB4ejRygi3EV3p4HN2jgjJwM6Sw+31@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 09 Sep 2010 14:47:33 +0200
Message-ID: <1284036453.402.11.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-09 at 14:31 +0200, Harald Gustafsson wrote:

> Sorry for being daft...

No worries, I'm sure we all qualify at times ;-)

> >> >
> >> > You need a process context anyway to read the data and send it to
> >> > whatever place you want it.
> >> >
> >> > Putting that in-kernel serves no purpose what so ever.
> >>
> >> But if we bring the splice support, that can be done with minimal
> >> userspace noise. Plus that would work with the usual sockets but not
> >> limited to that.
> >
> > Yes. If we can transform the data over the network without it touching
> > disk, then that would be a sufficiently 'does not disturb other tasks'
> > measurement method.
> 
> Thanks for the pointers to more information, and yes my thoughts was
> more about avoiding the data copy then avoiding any processing context
> at all.

Right, currently you get a single copy with mmap() + write(), once we
manage to fix splice() and actually provide perf-splice() you'd be able
to do zero-copy.



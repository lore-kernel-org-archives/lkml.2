Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab0IILlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 07:41:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46066 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055Ab0IILlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 07:41:02 -0400
Date: Thu, 9 Sep 2010 13:40:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Harald Gustafsson <hgu1972@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Song Yuan <song.yuan@ericsson.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf events over (net) console?
Message-ID: <20100909114053.GA15140@elte.hu>
References: <AANLkTi=yeHyOeewm9tdsHRtj+=d+vE5=NRKGaPyq_yGH@mail.gmail.com>
 <1284031141.402.1.camel@laptop>
 <20100909112940.GA5267@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100909112940.GA5267@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0008]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Thu, Sep 09, 2010 at 01:19:01PM +0200, Peter Zijlstra wrote:
> > On Thu, 2010-09-09 at 13:06 +0200, Harald Gustafsson wrote:
> > > Hi,
> > > 
> > > We would like to monitor the perf events continuously on a remote 
> > > machine. Does it exist a solution (in the kernel) to direct the 
> > > output to a console or maybe even a netconsole? We would like to 
> > > avoid a user space application to transfer it, due to that the 
> > > machine will be running a test which will heavily load it and we 
> > > want to avoid as many unrelated user space tasks as possible. If 
> > > not mainlined does anyone have a patch for this?
> > 
> > No, and its a daft requirement.
> > 
> > You need a process context anyway to read the data and send it to 
> > whatever place you want it.
> > 
> > Putting that in-kernel serves no purpose what so ever.
> 
> But if we bring the splice support, that can be done with minimal 
> userspace noise. Plus that would work with the usual sockets but not 
> limited to that.

Yes. If we can transform the data over the network without it touching 
disk, then that would be a sufficiently 'does not disturb other tasks' 
measurement method.

Thanks,

	Ingo

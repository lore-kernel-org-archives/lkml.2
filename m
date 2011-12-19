Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab1LSXev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 18:34:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45940 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab1LSXes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 18:34:48 -0500
X-Authority-Analysis: v=2.0 cv=SqgSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=jYu58pNXGn8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=lqPVVqY_XRlDlGsjoTQA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1324337685.5916.47.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/2] tracing, sched: Add delay info to sched_switch
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arun Sharma <asharma@fb.com>, linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Date: Mon, 19 Dec 2011 18:34:45 -0500
In-Reply-To: <1324337287.24621.22.camel@twins>
References: <1324337005-31718-1-git-send-email-asharma@fb.com>
	 <1324337005-31718-3-git-send-email-asharma@fb.com>
	 <1324337287.24621.22.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-20 at 00:28 +0100, Peter Zijlstra wrote:
> On Mon, 2011-12-19 at 15:23 -0800, Arun Sharma wrote:
> > +#ifdef CONFIG_SCHEDSTATS
> > +               __entry->delay          = next->se.statistics.block_start ? next->se.statistics.block_start
> > +                                         : next->se.statistics.sleep_start ? next->se.statistics.sleep_start : 0;
> > +               __entry->delay = __entry->delay ? now - __entry->delay : 0;
> > +#else
> > +               __entry->delay = 0;
> > +#endif 
> 
> I don't really like this, this should be one of those sched_*_stat
> thingies, not sched_switch().

Agreed.

-- Steve



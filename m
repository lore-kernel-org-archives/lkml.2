Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab1GJVZw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 17:25:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52609 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145Ab1GJVZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 17:25:49 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=U4WHxWBNt-MA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=uGEvdhCgAAAA:8 a=CjxXgO3LAAAA:8 a=gu6fZOg2AAAA:8 a=2VR6CGoi2jS6xoWlVLAA:9 a=PUjeQqilurYA:10 a=C7YnqLjT7bEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [Bug #38132] [Warning] 2.6.39.x latencytop
From: Steven Rostedt <rostedt@goodmis.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Andrew Watts <akwatts@ymail.com>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <CAOJsxLEGqpcQP3S+TLBjpRsM=UTk=zyuHBoswXkVwbHsLaDqqg@mail.gmail.com>
References: <AtAvQwe5sAK.A.loH.OlYGOB@chimera>
	 <gK_efVqs2fP.A.Y3H.jlYGOB@chimera>
	 <CAOJsxLEGqpcQP3S+TLBjpRsM=UTk=zyuHBoswXkVwbHsLaDqqg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sun, 10 Jul 2011 17:25:45 -0400
Message-ID: <1310333145.2269.6.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-10 at 14:53 +0300, Pekka Enberg wrote:
> On Sun, Jul 10, 2011 at 1:58 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.38 and 2.6.39.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.38 and 2.6.39.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=38132
> > Subject         : [Warning] 2.6.39.x latencytop
> > Submitter       : Andrew Watts <akwatts@ymail.com>
> > Date            : 2011-06-14 17:07 (27 days old)
> > Message-ID      : <80098.5633.qm@web111013.mail.gq1.yahoo.com>
> > References      : http://marc.info/?l=linux-kernel&m=130807128506490&w=2
> 
> This is a WARN_ON added in commit 6752ab4a ("tracing: Deprecate
> tracing_enabled for tracing_on") that lets the user know about
> deprecated ABI. It's somewhat unfortunate that there's no mention in
> the changelog if everyone agreed on the deprecation or not...
> 
> That said, assuming the deprecation is OK (hi Steven, Frederic, Ingo!)
> I think this issue can be closed.

I deprecated it because I said I would for the last year ;)

The tracing_enabled never did what it was suppose to do. It was suppose
to be a "quick" way to disable tracing without fully disabling it. It
was suppose to try to turn things off to a low overhead but not fully
off without any overhead. The problem is that it never really worked
well. The only tracer that does anything different with it as suppose to
tracing_on, is the irqsoff tracers. They stop looking at max latencies
when you echo 0 into tracing_enabled. But that's it. Everything else,
it's just the same as echoing 0 into tracing_on. I think the irqsoff
tracers now even look at tracing_on if it should trace a max latency or
not, so tracing_enabled doesn't even help with that.

We can keep it around but I don't see any good reason for it besides not
having latency top give a warning.

Question: Why is latency top even touching this file?

-- Steve



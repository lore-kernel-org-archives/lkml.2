Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3ACPcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 10:32:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9022 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab3ACPcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 10:32:52 -0500
X-Authority-Analysis: v=2.0 cv=O9a7TWBW c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=v87cGlukdQQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Fx92VpDN7C8A:10 a=LtLSWtEiw2clOTEZL5QA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1357227169.10284.32.camel@gandalf.local.home>
Subject: Re: [RFC PATCH 3/3 -v2] x86,smp: auto tune spinlock backoff delay
 factor
From: Steven Rostedt <rostedt@goodmis.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jan Beulich <JBeulich@suse.com>, Rik van Riel <riel@redhat.com>,
        therbert@google.com, walken@google.com, jeremy@goop.org,
        tglx@linutronix.de, aquini@redhat.com, lwoodman@redhat.com,
        linux-kernel@vger.kernel.org
Date: Thu, 03 Jan 2013 10:32:49 -0500
In-Reply-To: <1357220117.21409.24539.camel@edumazet-glaptop>
References: <20121221184940.103c31ad@annuminas.surriel.com>
	 <20121221185147.4ae48ab5@annuminas.surriel.com>
	 <20121221185613.1f4c9523@annuminas.surriel.com>
	 <20121222033339.GF27621@home.goodmis.org> <50D52E0C.6000103@redhat.com>
	 <1356549008.20133.20856.camel@edumazet-glaptop> <50DB5531.90500@redhat.com>
	 <CANN689HeTk0jNJb4sF_0t714MvFnU0vLw0=JeXYRUwMx8GDnXQ@mail.gmail.com>
	 <1356618448.30414.948.camel@edumazet-glaptop> <50DC5CC0.6010003@redhat.com>
	 <50DC9662020000780009210D@nat28.tlf.novell.com>
	 <50DC9CE1.9030709@redhat.com>
	 <50E5580102000078000B29D1@nat28.tlf.novell.com>
	 <1357219477.10284.23.camel@gandalf.local.home>
	 <1357220117.21409.24539.camel@edumazet-glaptop>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-03 at 05:35 -0800, Eric Dumazet wrote:
> On Thu, 2013-01-03 at 08:24 -0500, Steven Rostedt wrote:
> > On Thu, 2013-01-03 at 09:05 +0000, Jan Beulich wrote:
> > 
> > > > How much bus traffic do monitor/mwait cause behind the scenes?
> > > 
> > > I would suppose that this just snoops the bus for writes, but the
> > > amount of bus traffic involved in this isn't explicitly documented.
> > > 
> > > One downside of course is that unless a spin lock is made occupy
> > > exactly a cache line, false wakeups are possible.
> > 
> > And that would probably be very likely, as the whole purpose of Rik's
> > patches was to lower cache stalls due to other CPUs pounding on spin
> > locks that share the cache line of what is being protected (and
> > modified).
> 
> A monitor/mwait would be an option only if using MCS (or K42 variant)
> locks, where each cpu would wait on a private and dedicated cache line.


But then would the problem even exist? If the lock is on its own cache
line, it shouldn't cause a performance issue if other CPUs are spinning
on it. Would it?

-- Steve




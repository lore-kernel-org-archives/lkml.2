Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab3ACNfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 08:35:22 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:51747 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab3ACNfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 08:35:20 -0500
Subject: Re: [RFC PATCH 3/3 -v2] x86,smp: auto tune spinlock backoff delay
 factor
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jan Beulich <JBeulich@suse.com>, Rik van Riel <riel@redhat.com>,
        therbert@google.com, walken@google.com, jeremy@goop.org,
        tglx@linutronix.de, aquini@redhat.com, lwoodman@redhat.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1357219477.10284.23.camel@gandalf.local.home>
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
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jan 2013 05:35:17 -0800
Message-ID: <1357220117.21409.24539.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-03 at 08:24 -0500, Steven Rostedt wrote:
> On Thu, 2013-01-03 at 09:05 +0000, Jan Beulich wrote:
> 
> > > How much bus traffic do monitor/mwait cause behind the scenes?
> > 
> > I would suppose that this just snoops the bus for writes, but the
> > amount of bus traffic involved in this isn't explicitly documented.
> > 
> > One downside of course is that unless a spin lock is made occupy
> > exactly a cache line, false wakeups are possible.
> 
> And that would probably be very likely, as the whole purpose of Rik's
> patches was to lower cache stalls due to other CPUs pounding on spin
> locks that share the cache line of what is being protected (and
> modified).

A monitor/mwait would be an option only if using MCS (or K42 variant)
locks, where each cpu would wait on a private and dedicated cache line.




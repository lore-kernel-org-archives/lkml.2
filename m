Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab0KTUuH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 15:50:07 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17158 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab0KTUuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 15:50:05 -0500
Date: Sat, 20 Nov 2010 21:37:08 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Mike Galbraith <efault@gmx.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
In-Reply-To: <1290282678.28711.23.camel@maggy.simson.net>
Message-ID: <alpine.LNX.2.00.1011202136310.24071@swampdragon.chaosbits.net>
References: <1287479765.9920.9.camel@marge.simson.net>  <1287487757.24189.40.camel@marge.simson.net>  <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com>  <1287511983.7417.45.camel@marge.simson.net>  <1287514410.7368.10.camel@marge.simson.net> 
 <20101020025652.GB26822@elte.hu>  <1287648715.9021.20.camel@marge.simson.net>  <20101021105114.GA10216@Krystal> <1287660312.3488.103.camel@twins>  <20101021162924.GA3225@redhat.com>  <1288076838.11930.1.camel@marge.simson.net>  <1288078144.7478.9.camel@marge.simson.net>
  <AANLkTimOJAv2uRfq4bW_QPngkGCmJDjNX5n_izpX=eB8@mail.gmail.com>  <1289489200.11397.21.camel@maggy.simson.net> <30291.1289860866@localhost>  <AANLkTikeLeLvYcZJ4HcAUH1ax13scgnrT27CSR=YzO_C@mail.gmail.com>  <alpine.LNX.2.00.1011202031130.24071@swampdragon.chaosbits.net>
 <1290282678.28711.23.camel@maggy.simson.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Nov 2010, Mike Galbraith wrote:

> On Sat, 2010-11-20 at 20:33 +0100, Jesper Juhl wrote:
> > On Mon, 15 Nov 2010, Linus Torvalds wrote:
> > 
> > > On Mon, Nov 15, 2010 at 2:41 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> > > >
> > > > So the set of all tasks that never call proc_set_tty() ends up in the same one
> > > > big default group, correct?
> > > 
> > > Well, yes and no.
> > > 
> > > Yes, that's what the code currently does. But I did ask Mike (and he
> > > delivered) to try to make the code look and work in a way where the
> > > whole "tty thing" is just one of the heuristics.
> > > 
> > > It's not clear exactly what the non-tty heuristics would be, but I do
> > > have a few suggestions:
> > > 
> > >  -  I think it might be a good idea to associate a task group with the
> > > current "cred" of a process, and fall back on it in the absense of a
> > > tty-provided one.
> > > 
> > Or how about (just brainstorming here) a group per 'process group'?
> 
> I switched to per session, which on my system at least looks like more
> than enough granularity.
> 
Sounds sane and it's closer to the original 'per tty' which was so 
successful.

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.


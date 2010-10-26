Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499Ab0JZH3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 03:29:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57657 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757516Ab0JZH3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 03:29:11 -0400
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Mike Galbraith <mgalbraith@suse.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
In-Reply-To: <1288076838.11930.1.camel@marge.simson.net>
References: <1287479765.9920.9.camel@marge.simson.net>
	 <1287487757.24189.40.camel@marge.simson.net>
	 <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com>
	 <1287511983.7417.45.camel@marge.simson.net>
	 <1287514410.7368.10.camel@marge.simson.net>
	 <20101020025652.GB26822@elte.hu>
	 <1287648715.9021.20.camel@marge.simson.net>
	 <20101021105114.GA10216@Krystal> <1287660312.3488.103.camel@twins>
	 <20101021162924.GA3225@redhat.com>
	 <1288076838.11930.1.camel@marge.simson.net>
Content-Type: text/plain
Date: Tue, 26 Oct 2010 09:29:04 +0200
Message-Id: <1288078144.7478.9.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-26 at 09:07 +0200, Mike Galbraith wrote:
> On Thu, 2010-10-21 at 18:29 +0200, Oleg Nesterov wrote:
> 
> > It is not clear to me why do we need rcu_read_lock() and how it can help.
> > The tty can go away right after dereferencing signal->tty.
> 
> Which was Marcus' crash.  Didn't happen here only because I didn't have
> CONFIG_PREEMPT set.
> 
> Changes since v2:
>   - drop  

Bumped mouse, message escaped.

Doesn't matter though, damn thing just blew up during enable/disable
plus hackbench stress test, despite holding a reference to the tty at
every place tty changes (under sighand lock), and moving the task with
that reference held.

CONFIG_PREEMPT is being a little S.O.B.

	-Mike


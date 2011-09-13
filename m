Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab1IMQOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 12:14:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:39234 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab1IMQOM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 12:14:12 -0400
Subject: Re: [ANNOUNCE] 3.0.4-rt13
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Tue, 13 Sep 2011 18:13:50 +0200
In-Reply-To: <1315927699.6445.6.camel@marge.simson.net>
References: <alpine.LFD.2.02.1109101052340.2723@ionos>
	 <1315737307.6544.1.camel@marge.simson.net>
	 <1315817948.26517.16.camel@twins>
	 <1315835562.6758.3.camel@marge.simson.net>
	 <1315839187.6758.8.camel@marge.simson.net> <1315926499.5977.19.camel@twins>
	 <1315927699.6445.6.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1315930430.5977.21.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-13 at 17:28 +0200, Mike Galbraith wrote:
> On Tue, 2011-09-13 at 17:08 +0200, Peter Zijlstra wrote:
> > On Tue, 2011-09-13 at 15:36 +0200, Peter Zijlstra wrote:
> > > Does the below cure things? It breaks !rt builds, but we can cure that
> > > if it works..
> > 
> > n/m its broken like hell..
> 
> Since this seems to be a legitimate need for a non-preemptive wakeup,
> how about we [re]create one to get rid of abuse?  (otoh, that would add
> a branch everywhere.. btdt a couple times, always ended up tossing it)

Nah, we absolutely need to kill that preempt_disable/enable stuff in
there, it covers an O(n^2) loop, its complete crap.

Just need to wrap my head around that code..

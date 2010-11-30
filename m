Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab0K3R3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:29:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:43217 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960Ab0K3R3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:29:17 -0500
Subject: Re: High CPU load when machine is idle (related to PROBLEM:
 Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
From: Peter Zijlstra <peterz@infradead.org>
To: Damien Wyart <damien.wyart@free.fr>
Cc: tmhikaru@gmail.com, Venkatesh Pallipadi <venki@google.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>
In-Reply-To: <877hfueosm.fsf@free.fr>
References: <20101109185516.GQ8332@bombadil.infradead.org>
	 <1289329348.2191.69.camel@laptop>
	 <20101110034507.GV8332@bombadil.infradead.org>
	 <1289390424.2191.98.camel@laptop> <20101114051406.GA2050@roll>
	 <20101125133106.GA12914@brouette> <1290693807.2145.36.camel@laptop>
	 <1290888920.32004.1.camel@laptop> <20101128114027.GA2745@brouette>
	 <1291030726.32004.4.camel@laptop> <20101129194041.GA8280@roll>
	 <1291071677.32004.527.camel@laptop> <1291129145.32004.874.camel@laptop>
	 <877hfueosm.fsf@free.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 30 Nov 2010 18:29:31 +0100
Message-ID: <1291138171.32004.1030.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 17:53 +0100, Damien Wyart wrote:
> * Peter Zijlstra <peterz@infradead.org> [101130 15:59]:
> > OK, so here's a less crufty patch that gets the same result on my
> > machine, load drops down to 0.00 after a while.
> 
> Seems OK too here.
> 
> > It seems a bit slower to reach 0.00, but that could be because
> > I actually changed the load computation for NO_HZ=n as well, I added
> > a rounding factor in calc_load(), we no longer truncate the division.
> 
> Yes, really feels slower, but in the two configurations as you write.
> Then this is a matter of convention, do not know which version is more
> "correct" or "natural", but this is coherent in the two modes (HZ and
> NO_HZ).
> 
> Do you plan to push this one to upstream/stable, or do you plan further
> modifications?

No this is about it, I've written a bit more comments, and I'll need to
come up with a changelog, I'll also wait for Kyle's testers to come
back, but yes, then I'll push it upstream/stable.

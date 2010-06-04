Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab0FDDnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 23:43:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:52555 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756997Ab0FDDnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 23:43:05 -0400
Date: Thu, 3 Jun 2010 20:45:21 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, tytso@mit.edu,
       Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
       Arve Hj?nnev?g <arve@android.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: suspend blockers & Android integration
Message-ID: <20100603204521.09808a7f@infradead.org>
In-Reply-To: <alpine.LFD.2.00.1006031917500.8175@i5.linux-foundation.org>
References: <20100603193045.GA7188@elte.hu>
	<20100603231153.GA11302@elte.hu>
	<20100603232302.GA16184@elte.hu>
	<alpine.LFD.2.00.1006031630300.8175@i5.linux-foundation.org>
	<20100603234634.GA21831@elte.hu>
	<alpine.LFD.2.00.1006031856420.8175@i5.linux-foundation.org>
	<alpine.LFD.2.00.1006031917500.8175@i5.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010 19:26:50 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> If the system is idle (or almost idle) for long times, I would
> heartily recommend actively shutting down unused cores. Some CPU's
> are hopefully smart enough to not even need that kind of software
> management, but I suspect even the really smart ones might be able to
> take advantage of the kernel saying: "I'm shutting you down, you
> don't have to worry about latency AT ALL, because I'm keeping another
> CPU active to do any real work".

sadly the reality is that "offline" is actually the same as "deepest C
state". At best.

As far as I can see, this is at least true for all Intel and AMD cpus.

And because there's then no power saving (but a performance cost), it's
actually a negative for battery life/total energy.

(lots of experiments inside Intel seem to confirm that, it's not just
theory)





-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab0DWQE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:04:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:56668 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757837Ab0DWQE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:04:56 -0400
Date: Fri, 23 Apr 2010 09:06:48 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, tglx@linutronix.de, davej@redhat.com,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with
 ondemand during disk IO
Message-ID: <20100423090648.17399f47@infradead.org>
In-Reply-To: <20100423083828.GA1573@ucw.cz>
References: <20100418115949.7b743898@infradead.org>
	<20100418120346.1b478410@infradead.org>
	<20100423052439.GB4829@ucw.cz>
	<20100423065248.3b0a98ab@infradead.org>
	<20100423083828.GA1573@ucw.cz>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010 10:38:28 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> On Fri 2010-04-23 06:52:48, Arjan van de Ven wrote:
> > On Fri, 23 Apr 2010 07:24:39 +0200
> > Pavel Machek <pavel@ucw.cz> wrote:
> > 
> > > 
> > > Well, and now, if you do something like cat /dev/<your usb1.1
> > > hdd> > /dev/null, you'll keep cpu on max frequency. Not a problem
> > > hdd> > for new
> > > core i7, but probably big deal for athlon 64.
> > 
> > do you have facts not speculation for this? Does the athlon 64
> > really
> 
> You want the patch applied, you should be able to justify it.

You make a claim... all I am asking if you are doing just random guess
or basing this on facts.

The machines I have access to don't show any impact during actual idle,
because they stop clocks and generally even lower the voltage. 
You make a claim that a certain machine does not do either... all I'm
asking if that claim is based on data or on speculation.

> 
> > keep its voltage high during idle? That would surprise me greatly...
> > (and if it does, does it matter? the clock is stopped anyway there)
> 
> Yes, I believe it keeps voltage up, and as a leakage is big part of
> power consumption there, stopped clocks will not help much.

again do you have actual data? 

 
> I believe you are developing on wrong machine. Seems like core i7 just
> wants max frequency, all the time. Older designs were not like that.
> 
> Do you have early intel speedstep machine near you?

oh I use many different machines. the intel machines at least stop the
clocks, and for a really long time also lower the frequency in idle.
(especially during deeper C states, but even during C1)

> 
> > the only place where my patch makes a real difference is when the
> > cpu is idle due to blocking IO! So do you have data that the athlon
> > 64 gets too hot if you select a high frequency during an idle
> > period, where the clock is already stopped?
> 
> iirc even idle power consumption was much higher when on max
> voltage... I'll get some numbers from my old notes; I no longer have
> the hw.

make sure it's data based on tickless... without tickless we were never
really idle ;-(



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

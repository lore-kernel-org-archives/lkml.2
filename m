Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab0DWPYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 11:24:35 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:39024 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755420Ab0DWPYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 11:24:33 -0400
Date: Fri, 23 Apr 2010 10:38:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, tglx@linutronix.de, davej@redhat.com,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with
 ondemand during disk IO
Message-ID: <20100423083828.GA1573@ucw.cz>
References: <20100418115949.7b743898@infradead.org>
 <20100418120346.1b478410@infradead.org>
 <20100423052439.GB4829@ucw.cz>
 <20100423065248.3b0a98ab@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100423065248.3b0a98ab@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2010-04-23 06:52:48, Arjan van de Ven wrote:
> On Fri, 23 Apr 2010 07:24:39 +0200
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > 
> > Well, and now, if you do something like cat /dev/<your usb1.1 hdd> >
> > /dev/null, you'll keep cpu on max frequency. Not a problem for new
> > core i7, but probably big deal for athlon 64.
> 
> do you have facts not speculation for this? Does the athlon 64
> really

You want the patch applied, you should be able to justify it.

> keep its voltage high during idle? That would surprise me greatly...
> (and if it does, does it matter? the clock is stopped anyway there)

Yes, I believe it keeps voltage up, and as a leakage is big part of
power consumption there, stopped clocks will not help much.

I believe you are developing on wrong machine. Seems like core i7 just
wants max frequency, all the time. Older designs were not like that.

Do you have early intel speedstep machine near you?

> the only place where my patch makes a real difference is when the cpu
> is idle due to blocking IO! So do you have data that the athlon 64 gets
> too hot if you select a high frequency during an idle period, where the
> clock is already stopped?

iirc even idle power consumption was much higher when on max
voltage... I'll get some numbers from my old notes; I no longer have
the hw.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934415Ab1JaL6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 07:58:22 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:49745 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932810Ab1JaL6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 07:58:21 -0400
X-Sasl-enc: 9GCUrAEIbJJ/VcW+wlcPSrIdr3zRfJBZz/E2i3gCyQ6h 1320062300
Date: Mon, 31 Oct 2011 09:58:17 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: HT (Hyper Threading) aware process scheduling doesn't work as
 it should
Message-ID: <20111031115817.GA20448@khazad-dum.debian.net>
References: <269467866.49093.1320004632156.JavaMail.mail@webmail17>
 <20111030212644.GA7106@khazad-dum.debian.net>
 <815860869.50724.1320011477430.JavaMail.mail@webmail17>
 <20111031091607.GB7106@khazad-dum.debian.net>
 <574299906.69412.1320054001912.JavaMail.mail@webmail05>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <574299906.69412.1320054001912.JavaMail.mail@webmail05>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Oct 2011, Artem S. Tashkinov wrote:
> > On Oct 31, 2011, Henrique de Moraes Holschuh  wrote: 
> > 
> > On Sun, 30 Oct 2011, Artem S. Tashkinov wrote:
> > > > Please make sure both are set to 0.  If they were not 0 at the time you
> > > > ran your tests, please retest and report back.
> > > 
> > > That's 0 & 0 for me.
> > 
> > How idle is your system during the test?
> 
> load average: 0.00, 0.00, 0.00

I believe cpuidle will interfere with the scheduling in that case.  Could
you run your test with higher loads (start with one, and go up to eight
tasks that are CPU-hogs, measuring each step)?

> I have to insist that people conduct this test on their own without trusting my
> words. Probably there's something I overlook or don't fully understand but from

What you should attempt to do is to give us a reproducible test case.  A
shell script or C/perl/python/whatever program that when run clearly shows
the problem you're complaining about on your system.  Failing that, a very
detailed description (read: step by step) of how you're testing things.

I can't see anything wrong in my X5550 workstation (4 cores, 8 threads,
single processor, i.e. not NUMA) running 3.0.8.

> what I see, there's a serious issue here (at least Microsoft XP and 7 work exactly

So far it looks like that, since your system is almost entirely idle, it
could be trying to minimize task-run latency by scheduling work to the few
cores/threads that are not in deep sleep (they take time to wake up, are
often cache-cold, etc).

Please use tools/power/x86/turbostat to track core usage and idle-states
instead of top/htop.  That might give you better information, and I
think you will appreciate getting to know that tool.  Note: turbostat
reports *averages* for each thread.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

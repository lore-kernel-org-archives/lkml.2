Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab0HIH07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 03:26:59 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:49608 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755441Ab0HIH05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 03:26:57 -0400
Date: Mon, 9 Aug 2010 09:26:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>
Subject: Re: Memory corruption during hibernation since 2.6.31
Message-ID: <20100809072646.GD1463@ucw.cz>
References: <201007282334.08063.rjw@sisk.pl>
 <20100729132325.59871484.kamezawa.hiroyu@jp.fujitsu.com>
 <20100729142245.4AA5.A69D9226@jp.fujitsu.com>
 <20100729142429.58b49dce.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.1.00.1007291027410.7491@tigran.mtv.corp.google.com>
 <20100729185529.GW16655@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100729185529.GW16655@random.random>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I've CC'ed Andrea because we were having an offline conversation about
> > whether ksmd (and his khugepaged) need to set_freezable(); and I wonder
> > if this swap bug underlies his interest, though he was mainly worrying
> > about I/O in progress.
> 
> My opinion is that with current freezer model it is needed for suspend
> to disk. The kthread_should_stop seems useless for kswapd/ksmd, but
> I'm afraid it might get useful in the future so just to stay on the
> safe side I added it to khugepaged as well, but it's contributing to
> the pollution.
> 
> I've no idea why the freezing isn't preemptive (through the scheduler,
> all these kernel threads are obviously lowlatency beasts) by default

Hibernation woulld like all  tasks frozen with no locks held - so that
write to disk does not have to care about locking.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

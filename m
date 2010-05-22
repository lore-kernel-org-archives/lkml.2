Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382Ab0EVUyS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 16:54:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58943 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755473Ab0EVUyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 16:54:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Regression] Negative time on Acer Ferrari One with current -git
Date: Sat, 22 May 2010 22:55:27 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       John Stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <201005212343.25184.rjw@sisk.pl> <alpine.LFD.2.00.1005222020570.3368@localhost.localdomain> <alpine.LFD.2.00.1005222032080.3368@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005222032080.3368@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005222255.27301.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 May 2010, Thomas Gleixner wrote:
> On Sat, 22 May 2010, Thomas Gleixner wrote:
> 
> > On Sat, 22 May 2010, Rafael J. Wysocki wrote:
> > > On Saturday 22 May 2010, Thomas Gleixner wrote:
> > > 
> > > > Also which clocksource is used ?
> > > 
> > > hpet
> > 
> > Hmm, there is only one hpet related commit sin .34:  30a564be9d
> > and I can hardly see how this should be related.
> 
> Does the problem persist if you disable HPET on the kernel command line ?

I didn't try that, but I bisected it in the meantime which lead to:

commit 64ce4c2f5252f25798117fa80a027993163d6d84
Author: John Stultz <johnstul@us.ibm.com>
Date:   Thu Mar 11 14:04:47 2010 -0800

    time: Clean up warp_clock()

    warp_clock() currently accesses timekeeping internal state directly, which
    is unnecessary.  Convert it to use the proper timekeeping interfaces.

    Signed-off-by: John Stultz <johnstul@us.ibm.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

So I don't think it's an hpet issue. :-)

I'm now going to revert that commit and see what happens.

Thanks,
Rafael

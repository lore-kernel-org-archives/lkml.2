Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab0FESBu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 14:01:50 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:55561 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab0FESBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 14:01:49 -0400
Subject: Re: [RFC][PATCH 5/6] Cleanup hrtimer.c's direct access to
 wall_to_monotonic
From: john stultz <johnstul@us.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <201006051223.06000.arnd@arndb.de>
References: <1275706406-8111-1-git-send-email-johnstul@us.ibm.com>
	 <1275706406-8111-5-git-send-email-johnstul@us.ibm.com>
	 <1275706406-8111-6-git-send-email-johnstul@us.ibm.com>
	 <201006051223.06000.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Jun 2010 11:01:45 -0700
Message-ID: <1275760905.1734.2.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-06-05 at 12:23 +0200, Arnd Bergmann wrote:
> On Saturday 05 June 2010, John Stultz wrote:
> >         do {
> >                 seq = read_seqbegin(&xtime_lock);
> >                 xts = __current_kernel_time();
> > -               tom = wall_to_monotonic;
> > +               tom = __get_wall_to_monotonic();
> >         } while (read_seqretry(&xtime_lock, seq));
> >  
> 
> Would it make sense to also limit the use of xtime_lock to the
> timekeeping code? I suppose you could merge the various accessors
> (current_kernel_time, get_monotonic_coarse, __current_kernel_time,
> __get_wall_to_monotonic) with a single function doing

Yep. I hope to keep chipping at it to get there. 

However xtime_lock protects a bit more then just the timekeeping
internals, and its currently not limiting the rework I'm hoping to do
with the timekeeping internal structures. So little bits at a time. :)

thanks
-john





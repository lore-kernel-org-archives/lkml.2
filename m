Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab0EGQZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 12:25:51 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:49830 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab0EGQZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 12:25:49 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.193.102
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18cuwzQH4LJYH40/z/mDfz9
Date: Fri, 7 May 2010 09:25:44 -0700
From: Tony Lindgren <tony@atomide.com>
To: James Kosin <james.kosin.04@cnu.edu>
Cc: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
Message-ID: <20100507162544.GE387@atomide.com>
References: <eGUaB-4mU-1@gated-at.bofh.it>
 <eGUtX-4Kd-3@gated-at.bofh.it>
 <eGWvL-7Fy-1@gated-at.bofh.it>
 <eGWFt-7S7-17@gated-at.bofh.it>
 <eGWP9-8jH-17@gated-at.bofh.it>
 <4BE37DDD.8000402@cox.net>
 <p2jd6200be21005061953y497b0766k15123f69ff7db630@mail.gmail.com>
 <4BE38290.6040404@cnu.edu>
 <g2rd6200be21005062010s1a490b3dref465f5df64b8f7@mail.gmail.com>
 <4BE386D1.2050608@cnu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BE386D1.2050608@cnu.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* James Kosin <james.kosin.04@cnu.edu> [100506 20:14]:
> On 5/6/2010 11:10 PM, Arve Hjønnevåg wrote:
> >>>>         
> >>> One if the benefit we get from using suspend is that an unprivileged
> >>> app that does not have access to suspend blockers cannot prevent
> >>> suspend. You lose this advantage if you trigger suspend only from the
> >>> idle task.

This assumes that you're using cached values for echo mem > /sys/power/state
and the system keeps on running.

IMHO if you want to keep the system running, then you should just use
cpuidle and implement good idle modes.

Then when someting in the userspace knows you've been idle long enough,
you can suspend.

> >> If the process (privileged or unprivileged) doesn't want to suspend, why
> >> not just provide an interface to allow suspend to be turned off at the
> >> user level.  This could block the suspend cycle in itself, and you
> >> shouldn't need fine grained off/on cycles.  If an application really
> >> needs the system not to suspend then they (the user) should know the
> >> consequences and power requirements for such a task.
> >>
> >> I didn't say it had to be only from the idle task; but, that is the most
> >> logical place.  If the other threads are not idle then they really
> >> require work and will most likely already have a bock on the suspend anyway.
> >>
> >>     
> > I think you missed my point. Unprivileged processes should not be
> > allowed to prevent suspend.

You could just freeze the GUI process based on some policy if you
worry about misbehaving timers in various apps. This way the cpuidle
modes will allow you to run some userspace policy daemon. And then that
can suspend if needed based on how it's configured.
  
> Ah, you want a way for the system to suspend (and enforce the suspend)
> when only unprivileged processes are the only thing running....
> 
> That would mean a lot of work defining the unprivileged (or privileged)
> processes, and properly suspending (or enforcing) when needed.  Yuck. 
> Sorry I commented then, this is really getting deep into what I love to
> do at work.

Hmm, yeah sounds a bit messy.

Tony

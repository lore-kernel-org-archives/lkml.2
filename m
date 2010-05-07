Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab0EGPzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 11:55:08 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:55963 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756847Ab0EGPzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 11:55:04 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.193.102
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+MKbwCHFTthveK3PP2zgiG
Date: Fri, 7 May 2010 08:54:55 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Cc: Brian Swetland <swetland@google.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       mark gross <mgross@linux.intel.com>, markgross@thegnar.org,
       Len Brown <len.brown@intel.com>, linux-doc@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
Message-ID: <20100507155455.GC387@atomide.com>
References: <20100505202826.GB7450@linux.intel.com>
 <Pine.LNX.4.44L0.1005051705200.1885-100000@iolanthe.rowland.org>
 <z2ta55d774e1005051437heb584584q6afca0b4b254d5d0@mail.gmail.com>
 <20100505234755.GI29604@atomide.com>
 <l2ra55d774e1005051656wbf4f3d7cr8cc9de0478e509f1@mail.gmail.com>
 <20100506000552.GJ29604@atomide.com>
 <g2yd6200be21005052116n5dd8708fk33eaf8944379bfc2@mail.gmail.com>
 <20100506170420.GB30928@atomide.com>
 <i2od6200be21005061710mae9a437by90b22f61cbc2ae15@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <i2od6200be21005061710mae9a437by90b22f61cbc2ae15@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arve Hjønnevåg <arve@android.com> [100506 17:05]:
> 2010/5/6 Tony Lindgren <tony@atomide.com>:
> > * Arve Hjønnevåg <arve@android.com> [100505 21:11]:

<snip>

> >> This is not a rare event. For example, the matrix keypad driver blocks
> >> suspend when a key is down so it can scan the matrix.
> >
> > Sure, but how many times per day are you suspending?
> >
> 
> How many times we successfully suspend is irrelevant here. If the
> driver blocks suspend the number of suspend attempts depend on your
> poll frequency.

I guess what I'm trying to say is that a failed suspend should be
a rare event.
 
> >> >> With the suspend block model we know the moment we're capable of
> >> >> suspending and then can suspend at that moment.  Continually trying to
> >> >> suspend seems like it'd be inefficient power-wise (we're going to be
> >> >> doing a lot more work as we try to suspend over and over, or we're
> >> >> going to retry after a timeout and spend extra time not suspended).
> >> >>
> >> >> We can often spend minutes (possibly many) at a time preventing
> >> >> suspend when the system is doing work that would be interrupted by a
> >> >> full suspend.
> >> >
> >> > Maybe you a userspace suspend policy manager would do the trick if
> >> > it knows when the screen is blanked and no audio has been played for
> >> > five seconds etc?
> >> >
> >>
> >> If user space has to initiate every suspend attempt, then you are
> >> forcing it to poll whenever a driver needs to block suspend.
> >
> > Hmm I don't follow you. If the userspace policy daemon timer times
> > out, the device suspends. If the device does not suspend because of
> > a blocking driver, then the timers get reset and you try again based
> > on some event such as when the screen blanks.
> >
> 
> This retry is what I call polling. You have to keep retrying until you
> succeed. Also, using the screen blank timeout for this polling is not
> a good idea. You do not want to toggle the screen off and on with with
> every suspend attempt.

The number of retries depends on the power management policy for your
device. And that is often device and use specific.

So having to retry suspend should be a rare event. The userspace should
mostly know when it's OK to suspend.

Regards,

Tony

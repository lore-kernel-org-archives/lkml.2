Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab2DRQSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 12:18:05 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42944 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab2DRQSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 12:18:02 -0400
Message-ID: <1334765995.1298.5.camel@fujitsu-laptop>
Subject: Re: BUG: sleeping function called from invalid context at
 kernel/mutex.c:271
From: "Alexander E. Patrakov" <patrakov@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Date: Wed, 18 Apr 2012 22:19:55 +0600
In-Reply-To: <1334762504.1595.2.camel@fujitsu-laptop>
References: <1334561244.3339.7.camel@aep-desktop>
	 <20120418025626.GB23877@home.goodmis.org>
	 <20120418040636.GD2449@linux.vnet.ibm.com>
	 <1334724679.2019.20.camel@aep-desktop>
	 <1334750926.28106.36.camel@gandalf.stny.rr.com>
	 <1334756757.1269.28.camel@fujitsu-laptop>
	 <1334756901.28106.38.camel@gandalf.stny.rr.com>
	 <1334762504.1595.2.camel@fujitsu-laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Steven Rostedt wrote:
> > On Wed, 2012-04-18 at 19:45 +0600, Alexander E. Patrakov wrote:
> > 
> > > > Do you see the RT throttling message too? That's a bug with an RT task
> > > > going haywire. If that is happening, an RT task may be preventing an RCU
> > > > grace period to finish, and causing the RCU stalls.
> > > 
> > > I am currently at home, writing this from a laptop with 3.3.1, and there
> > 
> > Have you seen the memory leaks on your laptop?
> > 
> > > are no such messages in dmesg (yet?). Also I don't know any RT tasks
> > > that may run on my computer, except pulseaudio, which has a built-in
> > 
> > There are kernel threads that run at RT priorities too.
> > 
> > > safeguard against this. As for the work computer, should I check
> > > tomorrow, and with which kernel version?
> > > 
> > 
> > I'm only interested in the kernel version that happens to leak. If other
> > versions don't leak then we don't need to worry about them ;-)
> 
> Attached is a config and a full dmesg on 3.3.0 on the laptop. No obvious
> memory leak - but this may be just the beginning, as the laptop still
> responds well enough for me to send this email.

Given how short the time to trigger the BUG was on the laptop, the fact
that it mentioned ipv6 in the trace and that the BUG is not triggered
yet on 3.3.0 + 731184bff, I am confident that the BUG is dead now. Fixed
by 731184bff, which is in 3.3.1.

-- 
Alexander E. Patrakov


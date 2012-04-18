Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab2DRNoI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:44:08 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:42378 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751263Ab2DRNoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:44:05 -0400
Message-ID: <1334756757.1269.28.camel@fujitsu-laptop>
Subject: Re: BUG: sleeping function called from invalid context at
 kernel/mutex.c:271
From: "Alexander E. Patrakov" <patrakov@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Date: Wed, 18 Apr 2012 19:45:57 +0600
In-Reply-To: <1334750926.28106.36.camel@gandalf.stny.rr.com>
References: <1334561244.3339.7.camel@aep-desktop>
	 <20120418025626.GB23877@home.goodmis.org>
	 <20120418040636.GD2449@linux.vnet.ibm.com>
	 <1334724679.2019.20.camel@aep-desktop>
	 <1334750926.28106.36.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 2012-04-18 at 10:51 +0600, Alexander E. Patrakov wrote:
> 
> > > > 
> > > > Hmm, this can also be reported if you have an rcu leak. Which would also
> > > > explain your memory leak. RCU is the kernel's "garbage collector" and if
> > > > it gets stuck, then you will definitely start seeing memory leaks, as
> > > > memory wont be freed.
> > > 
> > > If RCU is stuck, you should see RCU CPU stall warnings, which can
> > > give clues as to what is causing RCU to get stuck.
> > 
> > Yes, there were such warnings, but all of them said that the stall ended
> > before dump start. So nothing reportable here, but I have just found
> > that https://bugzilla.novell.com/show_bug.cgi?id=754186 looks quite
> > similar in the sense that it (and duplicates) also has undumpable stalls
> > of increasing length, and IPv6 is in use both at home and at work.
> > 
> 
> Do you see the RT throttling message too? That's a bug with an RT task
> going haywire. If that is happening, an RT task may be preventing an RCU
> grace period to finish, and causing the RCU stalls.

I am currently at home, writing this from a laptop with 3.3.1, and there
are no such messages in dmesg (yet?). Also I don't know any RT tasks
that may run on my computer, except pulseaudio, which has a built-in
safeguard against this. As for the work computer, should I check
tomorrow, and with which kernel version?

-- 
Alexander E. Patrakov


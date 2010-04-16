Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab0DPAWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 20:22:09 -0400
Received: from www.tglx.de ([62.245.132.106]:56883 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758178Ab0DPAWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 20:22:07 -0400
Date: Fri, 16 Apr 2010 02:21:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chase Douglas <chase.douglas@canonical.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 3/3] Stop tracing on a schedule bug
In-Reply-To: <alpine.LFD.2.00.1004160138200.3625@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1004160204510.3625@localhost.localdomain>
References: <1271262016-18650-1-git-send-email-chase.douglas@canonical.com>  <1271262016-18650-3-git-send-email-chase.douglas@canonical.com>  <20100415210357.GG5069@nowhere>  <k2u40ec3ea41004151445je53e7ef2u5c0e48e038e4efca@mail.gmail.com> 
 <alpine.LFD.2.00.1004160051390.3625@localhost.localdomain> <p2n40ec3ea41004151627u11ca4d7dw46cbd6b58df9f1c8@mail.gmail.com> <alpine.LFD.2.00.1004160138200.3625@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Apr 2010, Thomas Gleixner wrote:
> BTW, if interacting with grub is that hard: how does an user start the
> tracer at all ?

Just looked through the other patches and noticed that the patch which
provides the tracing_off(level) stuff is incomplete as it provides
only a command line option to change that tracing off level.

The command line option is merily for tracing which happens to be
started on the command line i.e. _BEFORE_ we have usable user space.

So your grub argument is just crap. If the user cannot change this
setting w/o fiddling with the obscured grub then he can not start the
tracer on the command line either.

But somehow he can start the tracer later when user space is up and
running, but there is no way to change that setting anymore. Therefor
you go through the kernel and impose settings at will.

1) Your patch simply lacks an interface to change that setting via
   debugfs/tracing/wtf

   WTF should I reboot my machine to change that setting from the
   default BUG to WARN or NONE ? There is no reason at all.

2) tracing off can be done via filters on functions and/or events
   already - so I doubt that the tracing_off_event(level) is necessary
   at all.

   schedule_bug() definitely deserves a separate trace_schedule_bug()
   event which can be used to stop the tracer by already existing
   functionality.

Thanks,

	tglx

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933478Ab0LUCPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 21:15:33 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:42744 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933294Ab0LUCPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 21:15:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rlgTVnu7AowGBCTB5YaR9fa7YOW63FIezSJEzUVHR/5OeGB/ATYRnMJe1Jkb1OFWKI
         OyMMEwuzxBVhLTUnpmWWkZCkAgBvAfD49fAAlT6lSrGkhxefjoEXXACjRHdTo6a0zDRj
         hZouqnP68VlXEWlIaSh5nGCnN9eOqSopi+xzU=
Date: Tue, 21 Dec 2010 03:15:26 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 00/15] Nohz task support
Message-ID: <20101221021523.GA2605@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292859886.22905.22.camel@gandalf.stny.rr.com>
 <20101220233341.GA1715@nowhere>
 <1292895399.22905.68.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292895399.22905.68.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 08:36:39PM -0500, Steven Rostedt wrote:
> On Tue, 2010-12-21 at 00:33 +0100, Frederic Weisbecker wrote:
> >  
> > > I wounder if we could just have this happen automatically.
> > 
> > But this would add some global overhead, especially in the syscall
> > path as we need to take the slow path to hook userspace resume/exit.
> >  
> 
> I guess we could measure the overhead. See if the timer causes more
> overhead than the added overhead of the syscall, or not.

Indeed, but may be let's stage that first as a conditional attribute
and if it proves better results most of the time, then let's make it
the default.

Hm?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377Ab0LUAOD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 19:14:03 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:47431 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676Ab0LUAOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 19:14:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dMiBCb1kuTrdfs3GWrwAHFrX96IQmBH6v9qnroS9kNrH1hYF0hcEE8zy8Xbvk92FJu
         Gu3VlJl+ycJaSVpHHM5jOhP+VepFXKjTwo83sBZyd6zwfEhrzQS5B5WrU9Hjjsz/tcC2
         20ORYzLoHADs8NhWgfXc/1OT43IqwCe2LjBnk=
Date: Tue, 21 Dec 2010 01:13:56 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 02/15] nohz_task: Avoid nohz task cpu as non-idle
 timer target
Message-ID: <20101221001354.GG1715@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-3-git-send-email-fweisbec@gmail.com>
 <1292860078.5021.6.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292860078.5021.6.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 04:47:58PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> > Unbound timers are preferably targeted for non idle cpu. If
> > possible though, prioritize idle cpus over nohz task cpus,
> > because the main point of nohz task is to avoid unnecessary
> > timer interrupts.
> 
> Oh is it?
> 
> I'd very much expect the cpu that arms the timer to get the interrupt. I
> mean, if the task doesn't want to get interrupted by timers,
> _DON'T_USE_TIMERS_ to begin with.
> 
> So no, don't much like this at all.

I suspect TIMER_NOT_PINNED has been introduced to save some power by
avoiding to wake up idle cpus.

This is used by mod_timer(), schedule_timeout(), mod_timer_pending()
So that's widely used and removing that could have a deep impact on
power.

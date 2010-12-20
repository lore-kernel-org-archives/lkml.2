Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333Ab0LTXjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 18:39:10 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:63065 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933273Ab0LTXjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 18:39:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=davhP2454TTpXFM0q5uhHMFT9H+h4J2fYpOfod+Hd8tbWZC9gOVyQalbeDJiJL4yPg
         thvWyq/58NqgMreL4Hktk0NAny+HO9o2aLIuZkKSvjzD1MUCwEayqFK6xr8rkRXs8A+M
         w+hhqeTqDlOBK4DyaqKU39joR93sdJtKnV1IA=
Date: Tue, 21 Dec 2010 00:39:01 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 05/15] nohz_task: Restart the tick when another
 task compete on the cpu
Message-ID: <20101220233857.GC1715@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-6-git-send-email-fweisbec@gmail.com>
 <1292860401.5021.9.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292860401.5021.9.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 04:53:21PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> > +#ifdef CONFIG_NO_HZ_TASK
> > +       /*
> > +        * CHECKME:
> > +        * Ideally, we need to check if the target has a nohz task
> > +        * and only send the IPI if so. But there is nothing but
> > +        * a racy way to do that. Or can we assume at that point
> > +        * of the wake up that if cpu_has_nohz_task(cpu) is 0, then
> > +        * it's ok, even if it has a task about to switch to nohz
> > +        * task mode?
> > +        */
> > +       if (rq->nr_running == 2)
> > +               smp_send_update_nohz_task_cpu(cpu);
> > +#endif 
> 
> This is the wrong place, use ttwu_activate(), since activate_task() is
> the thing that pokes at nr_running.

Ok, will do.

Thanks.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab0LURFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 12:05:22 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:40880 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab0LURFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 12:05:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FYJy2f2MShlLqaN8+m57RfLCih5q1wGuUcAu0naCE6egnmFGNwChGpn+iANGd2NHGf
         IsmvNh8lKpVXFe2h3Xzr6w3/x9iUZs23wuXGhXu7UDTBWLdPYS/EXObmVOn6YVACIg3t
         kM9Yen4Eygc+Aq2VNLQ0MArGvlB417BQc/xlU=
Date: Tue, 21 Dec 2010 18:05:15 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 15/15] nohz_task: Procfs interface
Message-ID: <20101221170512.GM1750@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-16-git-send-email-fweisbec@gmail.com>
 <1292859744.5021.4.camel@laptop>
 <20101220155737.GA1742@nowhere>
 <1292861799.5021.27.camel@laptop>
 <20101221012418.GI1715@nowhere>
 <1292919280.5021.203.camel@laptop>
 <4D10B2E9.9040806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D10B2E9.9040806@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 04:00:09PM +0200, Avi Kivity wrote:
> On 12/21/2010 10:14 AM, Peter Zijlstra wrote:
> >On Tue, 2010-12-21 at 02:24 +0100, Frederic Weisbecker wrote:
> >>
> >>  >  Also, I'm not quite happy with the pure userspace restriction, but at
> >>  >  least I see why you did that event though you didn't mention that.
> >>
> >>  What do you mean? The fact that kernel threads can not be nohz task?
> >
> >No, that you key off kernel/user boundary transitions. Arguably one
> >could allow simply system calls and page-faults to happen without
> >restarting the tick, then again, RCU is very pervasive these days so I'm
> >not quite sure you can actually make that happen.
> >
> 
> For an example of a per-cpu flag that is checked on every exit with
> zero additional overhead on the flag clear case, look at
> TIF_USER_RETURN_NOTIFY.

Right, but the problem is actually that if we want to automate the nohz
attribute on every tasks, then you need you have this flag set for
all of these threads.

No problem with that, but if nobody wants the nohz attribute, we don't
need to force that slow path.

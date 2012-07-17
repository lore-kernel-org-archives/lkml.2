Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab2GQE2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 00:28:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5664 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab2GQE17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 00:27:59 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=IEFAe7w0650A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=UejcNrzcuEgphWSHMR0A:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1342499278.24525.13.camel@gandalf.stny.rr.com>
Subject: Re: 3.4.4-rt13: btrfs + xfstests 006 = BOOM..  and a bonus rt_mutex
 deadlock report for absolutely free!
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Chris Mason <chris.mason@fusionio.com>,
        "Chris L. Mason" <clmason@fusionio.com>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 17 Jul 2012 00:27:58 -0400
In-Reply-To: <1342498722.7353.37.camel@marge.simpson.net>
References: <1342072060.7338.102.camel@marge.simpson.net>
	 <20120713125043.GH30128@shiny> <1342260883.7368.30.camel@marge.simpson.net>
	 <20120715175612.GF25961@shiny.int.fusionio.com>
	 <1342404140.7659.27.camel@marge.simpson.net>
	 <1342454547.5410.3.camel@gandalf.stny.rr.com>
	 <1342455968.7659.93.camel@marge.simpson.net>
	 <1342456567.7659.97.camel@marge.simpson.net>
	 <1342458195.2783.5.camel@acer.local.home>
	 <1342498722.7353.37.camel@marge.simpson.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-17 at 06:18 +0200, Mike Galbraith wrote:
>  
> > There's that too. But the issue I was talking about is with all trylock
> > loops. As holding an rt-mutex now disables migration, if a high priority
> > process preempts a task that holds the lock, and then the high prio task
> > starts spinning waiting for that lock to release, the lower priority
> > process will never get to run to release it. The cpu_chill() doesn't
> > help.
> 
> Hrm.  I better go make a testcase, this one definitely wants pounding
> through thick skull.

Actually, I was mistaken. I forgot that we defined 'cpu_chill()' as
msleep(1) on RT, which would keep a deadlock from happening.

It doesn't explain the performance enhancement you get :-/

-- Steve



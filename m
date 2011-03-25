Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab1CYPyB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 11:54:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984Ab1CYPyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 11:54:00 -0400
Date: Fri, 25 Mar 2011 16:53:56 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>, fweisbec@gmail.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] tracing - avoid soft lockup in trace_pipe
Message-ID: <20110325155356.GG1922@jolsa.brq.redhat.com>
References: <20110314141853.GB1936@jolsa.brq.redhat.com>
 <1300112926.9910.100.camel@gandalf.stny.rr.com>
 <20110314150746.GA4453@jolsa.brq.redhat.com>
 <1300116057.9910.106.camel@gandalf.stny.rr.com>
 <20110314180621.GA5987@jolsa.brq.redhat.com>
 <20110321121008.GA1979@jolsa.brq.redhat.com>
 <1301019798.14261.159.camel@gandalf.stny.rr.com>
 <1301022889.14261.167.camel@gandalf.stny.rr.com>
 <20110325110518.GC1922@jolsa.brq.redhat.com>
 <1301068177.14261.192.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301068177.14261.192.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 11:49:37AM -0400, Steven Rostedt wrote:
> On Fri, 2011-03-25 at 12:05 +0100, Jiri Olsa wrote:
> 
> > right, I'm now able to trigger the issue when running setting the tracing
> > as said in the patch and plus running this in few instacies:
> > 
> > (while [ 1 ]; do find / > /dev/null ; done) &
> 
> That didn't work for me either. But if I run hackbench 50 on the box,
> then the trace does hang while it is running.
> 
> > 
> > It's strange I did not need this last time.. not sure why :)
> > 
> > 
> > anyway, the original reproducer I picked this issue from is ltp suite:
> > http://sourceforge.net/projects/ltp/files/LTP%20Source/ltp-20100131/ltp-full-20100131.tgz/download
> > 
> > and running following test:
> > ltp-full-20101031/testcases/kernel/tracing/ftrace_stress_test/ftrace_stress_test.sh 
> > 
> > reproduces the issue all the time for me, and the patch fixies it.
> > Attaching patch rebased to the current master with changed comment.
> 
> Thanks, I'll queue it up for 2.6.40, as I do not think this is that
> critical of a bug.
great, thanks

jirka

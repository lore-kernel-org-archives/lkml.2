Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab1CYPtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 11:49:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52641 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab1CYPtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 11:49:39 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=PNp5keGnr-sA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=FP58Ms26AAAA:8 a=wuBOXYkujozFg8MotWoA:9 a=I14lvYSmDetFdoJopmkgDUdwzDoA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCHv3] tracing - avoid soft lockup in trace_pipe
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, fweisbec@gmail.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110325110518.GC1922@jolsa.brq.redhat.com>
References: <20110313145811.GA30558@redhat.com>
	 <1300111651.9910.87.camel@gandalf.stny.rr.com>
	 <20110314141853.GB1936@jolsa.brq.redhat.com>
	 <1300112926.9910.100.camel@gandalf.stny.rr.com>
	 <20110314150746.GA4453@jolsa.brq.redhat.com>
	 <1300116057.9910.106.camel@gandalf.stny.rr.com>
	 <20110314180621.GA5987@jolsa.brq.redhat.com>
	 <20110321121008.GA1979@jolsa.brq.redhat.com>
	 <1301019798.14261.159.camel@gandalf.stny.rr.com>
	 <1301022889.14261.167.camel@gandalf.stny.rr.com>
	 <20110325110518.GC1922@jolsa.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 25 Mar 2011 11:49:37 -0400
Message-ID: <1301068177.14261.192.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 12:05 +0100, Jiri Olsa wrote:

> right, I'm now able to trigger the issue when running setting the tracing
> as said in the patch and plus running this in few instacies:
> 
> (while [ 1 ]; do find / > /dev/null ; done) &

That didn't work for me either. But if I run hackbench 50 on the box,
then the trace does hang while it is running.

> 
> It's strange I did not need this last time.. not sure why :)
> 
> 
> anyway, the original reproducer I picked this issue from is ltp suite:
> http://sourceforge.net/projects/ltp/files/LTP%20Source/ltp-20100131/ltp-full-20100131.tgz/download
> 
> and running following test:
> ltp-full-20101031/testcases/kernel/tracing/ftrace_stress_test/ftrace_stress_test.sh 
> 
> reproduces the issue all the time for me, and the patch fixies it.
> Attaching patch rebased to the current master with changed comment.

Thanks, I'll queue it up for 2.6.40, as I do not think this is that
critical of a bug.

-- Steve



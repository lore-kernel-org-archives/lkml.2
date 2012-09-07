Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933364Ab2IGOmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 10:42:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14087 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab2IGOmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 10:42:11 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=dv6za2K3W50A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=hUPM8fjf3YcA:10 a=IPOSIB3mYOGryxCwkksA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1347028929.8178.8.camel@gandalf.local.home>
Subject: Re: [PATCH tip/core/rcu 11/15] rcu: Avoid spurious RCU CPU stall
 warnings
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Date: Fri, 07 Sep 2012 10:42:09 -0400
In-Reply-To: <1347001230.18408.72.camel@twins>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
	 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346352988-32444-11-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346943414.18408.31.camel@twins>
	 <1346944049.1680.23.camel@gandalf.local.home>
	 <1346944758.18408.35.camel@twins>
	 <20120906210354.GC2448@linux.vnet.ibm.com>
	 <1346967661.1680.52.camel@gandalf.local.home>
	 <20120906215838.GM2448@linux.vnet.ibm.com>
	 <1346969153.1680.60.camel@gandalf.local.home>
	 <20120906222239.GQ2448@linux.vnet.ibm.com>
	 <1347001230.18408.72.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 09:00 +0200, Peter Zijlstra wrote:
> On Thu, 2012-09-06 at 15:22 -0700, Paul E. McKenney wrote:
> > Ah!
> > 
> > It is perfectly legal to avoid -starting- an RCU grace period for a
> > minute, or even longer.  If RCU has nothing to do, in other words, if no
> > one registers any RCU callbacks, then RCU need not start a grace period.
> > 
> > Of course, this would mean that it would eventually be a full minute
> > since the last start of a grace period.  This is not a problem, after
> > all, Linux went through a full ten years before experiencing its first
> > grace period.
> > 
> > But the stall-warning code just checked how long it had been since
> > the last start of a grace period, failing to note that this grace
> > period had long since completed.  So it splatted out a warning.
> > This warning was spurious in the sense that there was no bug aside
> > from the missing check that the grace period was still in progress.
> > 
> > And this commit fixes that bug in RCU. 
> 
> OK, that makes sense.. it just looks like both Steve and me got confused
> by the initial changelog. 

Right, I think the change log needs to be fixed ;-)

-- Steve



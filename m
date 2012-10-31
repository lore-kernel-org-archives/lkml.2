Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab2JaAH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 20:07:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16352 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab2JaAH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 20:07:57 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=bYqEZP2IH2oA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ED5KP61D5LcA:10 a=WEIArCIlw_fgFkZjPx4A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351642073.4004.38.camel@gandalf.local.home>
Subject: Re: [PATCH 04/32] x86: New cpuset nohz irq vector
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Date: Tue, 30 Oct 2012 20:07:53 -0400
In-Reply-To: <CAFTL4hyD=JU6UgayiXZ-UfusWEn9Rjsy7qTHN8NQZ4pL2HV-=Q@mail.gmail.com>
References: <20121029202711.062749374@goodmis.org>
	 <20121029203847.242305452@goodmis.org>
	 <1351618787.8467.136.camel@gandalf.local.home>
	 <CAFTL4hyD=JU6UgayiXZ-UfusWEn9Rjsy7qTHN8NQZ4pL2HV-=Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-31 at 00:51 +0100, Frederic Weisbecker wrote:

> > Probably just use irq_work for self ipis, and normal ipis for other
> > CPUs.
> 
> Right. And that's one more reason why we want to know if the arch
> implements irq work with self ipis or not. If the arch can't, then we
> just don't stop the tick.

We can just allow certain archs to have cpuset/nohz. Make it depend on
features that you want (or makes nohz easier to implement).

> 
> > Also, what reason do we have to force a task out of nohz? IOW, do we
> > really need this?
> 
> When a posix CPU timer is enqueued, when a new task is enqueued, etc...

I was thinking about something other than itself. That is, who would
enqueue a posix cpu timer on the cpu other than the task running with
nohz on that cpu?

A new task would send the schedule ipi too. Which would enqueue the task
and take the cpu out of nohz, no?


> 
> >
> > Also, perhaps we could just tag onto the schedule_ipi() function instead
> > of having to create a new IPI for all archs?
> 
> irq work should be just fine. No need to add more overhead on the
> schedule ipi I think.

irq_work can send the work to another CPU right? This part I wasn't sure
about.

-- Steve



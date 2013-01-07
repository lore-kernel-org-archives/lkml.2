Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab3AGW37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 17:29:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11960 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab3AGW35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 17:29:57 -0500
X-Authority-Analysis: v=2.0 cv=O9a7TWBW c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=f2n6SYgbXc8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=wIjj_We_h9UA:10 a=0dTx1kH39yvZSBp3USsA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1357597795.5190.10.camel@gandalf.local.home>
Subject: Re: [PATCH V2 Resend 3/4] workqueue: Schedule work on non-idle cpu
 instead of current one
From: Steven Rostedt <rostedt@goodmis.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Tejun Heo <tj@kernel.org>, Vincent Guittot <vincent.guittot@linaro.org>,
        pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        suresh.b.siddha@intel.com, venki@google.com, mingo@redhat.com,
        peterz@infradead.org, Arvind.Chauhan@arm.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Date: Mon, 07 Jan 2013 17:29:55 -0500
In-Reply-To: <CAKohpom9DxoojtcpMfmyGeUcEw8=tsS4n+TFMRV3+9_UBaod7g@mail.gmail.com>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
	 <ad25c731a6ca1bd1269555245952f05c856a9759.1352196505.git.viresh.kumar@linaro.org>
	 <20121126171539.GZ15971@htj.dyndns.org>
	 <CAKohpom9=K976NmyFWtXx2UQyRcLAqsoGw-5AaqXRpSL6uxP_g@mail.gmail.com>
	 <CAKohpokBMhto6xzp3MPGRJqstEkkC=kzgrKNhVXzi1Y8GejkXg@mail.gmail.com>
	 <20130104150928.GC15633@mtj.dyndns.org>
	 <CAKohpo=hhScCDUnDcqnZx4YzU_8nF1658jmSM_wzsOpSCxXwqA@mail.gmail.com>
	 <1357565303.10284.73.camel@gandalf.local.home>
	 <CAKohpom9DxoojtcpMfmyGeUcEw8=tsS4n+TFMRV3+9_UBaod7g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-07 at 23:29 +0530, Viresh Kumar wrote:

> > By default, I would suggest for cache locality,
> > that we try to keep it on the same CPU. But if there's a better CPU to
> > run on, it runs there.
> 
> That would break our intention behind this routine. We should run
> it on a cpu which we think is the best one for it power/performance wise.

If you are running on a big.Little box sure. But for normal (read x86 ;)
systems, it should probably stay on the current CPU.

> 
> So, i would like to call the sched_select_cpu() routine from this routine to
> get the suggested cpu.

Does the caller need to know? Or if you have a big.LITTLE setup, it
should just work automagically?

> 
> This routine would however would see more changes later to optimize it
> more.
> 
> > Also, we could still add a debug option that
> > makes it always run on other CPUs to slap developers that don't read.
> 
> I don't think we need it :(
> It would be a new API, with zero existing users. And so, whomsoever uses
> it, should know what exactly he is doing :)

Heh, you don't know kernel developers well do you? ;-)

Once a new API is added to the kernel tree, it quickly becomes
(mis)used.

-- Steve



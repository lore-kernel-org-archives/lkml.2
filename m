Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab2IFWF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 18:05:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3318 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab2IFWF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 18:05:56 -0400
X-Authority-Analysis: v=2.0 cv=Hsb06jvS c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=dv6za2K3W50A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=hUPM8fjf3YcA:10 a=g_RyfWv84Cq2eLNl8eoA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1346969153.1680.60.camel@gandalf.local.home>
Subject: Re: [PATCH tip/core/rcu 11/15] rcu: Avoid spurious RCU CPU stall
 warnings
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Date: Thu, 06 Sep 2012 18:05:53 -0400
In-Reply-To: <20120906215838.GM2448@linux.vnet.ibm.com>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
	 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346352988-32444-11-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346943414.18408.31.camel@twins>
	 <1346944049.1680.23.camel@gandalf.local.home>
	 <1346944758.18408.35.camel@twins>
	 <20120906210354.GC2448@linux.vnet.ibm.com>
	 <1346967661.1680.52.camel@gandalf.local.home>
	 <20120906215838.GM2448@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 14:58 -0700, Paul E. McKenney wrote:

> > All these cases deserve a warning.
> 
> Agreed, and that is the whole purpose of the stall warnings.

Then let me ask the question again. According to the change log:

> If a given CPU avoids the idle loop but also avoids starting a new
> RCU grace period for a full minute, RCU can issue spurious RCU CPU
> stall warnings.  This commit fixes this issue by adding a check for
> ongoing grace period to avoid these spurious stall warnings.


I'm still confused by what is "this issue"? And why is it being fixed.
It sounds to me that the "issue" was a CPU avoiding starting a new RCU
grace period for a full minute. Which to me sounds like a bug in which
we *want* a warning. Why is this patch needed?

-- Steve



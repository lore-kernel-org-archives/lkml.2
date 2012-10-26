Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab2JZNJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 09:09:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9137 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab2JZNJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 09:09:29 -0400
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=rDHpwsyNOsUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=HXw8KzeH-oIA:10 a=Eow2fQRh3KNJYC_SyjMA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351256965.8467.61.camel@gandalf.local.home>
Subject: Re: [PATCH 01/16] math128: Introduce various 128bit primitives
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>, mingo@redhat.com, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 26 Oct 2012 09:09:25 -0400
In-Reply-To: <1351255155.8467.55.camel@gandalf.local.home>
References: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com>
	 <1351115634-8420-2-git-send-email-juri.lelli@gmail.com>
	 <CA+55aFwLnz4ZNgKxJ6ANn7usppJC_OKHy0uVuh2+EhYTuiL5yw@mail.gmail.com>
	 <1351172849.12171.10.camel@twins>
	 <CA+55aFx5jCKtEbEY9iuv0J2TFipkwJP=tBH-F2x_bzJG1RBzTQ@mail.gmail.com>
	 <1351241389.12171.45.camel@twins> <20121026092421.GB628@gmail.com>
	 <1351244130.16863.7.camel@twins> <20121026094207.GA2179@gmail.com>
	 <1351245264.16863.12.camel@twins>
	 <alpine.LFD.2.02.1210261208170.2756@ionos>
	 <1351255155.8467.55.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 08:39 -0400, Steven Rostedt wrote:
> On Fri, 2012-10-26 at 12:36 +0200, Thomas Gleixner wrote:
> 
> > By all means. nsec precision is a completly academic thought
> > exercise. It's really pointless to even think about anything below
> > microseconds resolution.
> > 
> > We can still have the user space interface handing in the information
> > in nsec resolution, but it's reasonable to scale it down to something
> > useful. Just shift the incoming information right by 10, so you're in
> > the 1us resolution for all the internal math and all your limitation
> > problems are gone. A shift by ten for converting back and forth to
> > nsecs is not a real performance issue.
> 
> Just make sure this is well documented in the man pages, and that should
> eliminate any "surprises". This is a new interface, we can just make
> this part of the ABI. "The units are in nanoseconds, but all
> calculations are performed to the nearest microsecond. Take this into
> account for error analysis". People should be fine with this.

Actually, a shift by 10 is a division by 1024, which is not truly down
to a microsecond. Would just a shift by 9 work as well? This would make
the resolution closer to a half of microsecond. Otherwise things will
probably get screwy if the user passes in 1000 ns, and gets a zero
result.

-- Steve



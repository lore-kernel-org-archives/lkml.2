Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab0JSNy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:54:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34392 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab0JSNy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:54:57 -0400
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=wGm5nfgfXM4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=-wO6tt5DGF0_dsZHe7sA:9 a=cz2ZsIPYWDnzJk26uVgbfLiu8gQA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, laijs@cn.fujitsu.com,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        eric.dumazet@gmail.com, kaneshige.kenji@jp.fujitsu.com,
        David Miller <davem@davemloft.net>, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>
In-Reply-To: <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6>
References: <4C724298.4050509@jp.fujitsu.com>
	 <tip-2bf2160d8805de64308e2e7c3cd97813cb58ed2f@git.kernel.org>
	 <20100908112529.GA25931@elte.hu> <1287395077.29097.1543.camel@twins>
	 <1287398936.29097.1548.camel@twins> <4CBD79CF.2060706@jp.fujitsu.com>
	 <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6>
	 <20101019132236.GA19197@Krystal>
	 <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 19 Oct 2010 09:54:55 -0400
Message-ID: <1287496495.16971.372.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 15:41 +0200, Thomas Gleixner wrote:
> On Tue, 19 Oct 2010, Mathieu Desnoyers wrote:

> Dudes, a vector computation is hardly a performance problem in that
> function and definitely not an excuse for designing such horrible
> interfaces.

Yes, now we can be a bit more liberal. But when these tracepoints were
going in, people were watching to make sure they have practically zero
impact when tracing was disabled.

Now that people are more use to tracepoints, they are more understanding
to have cleaner code over that extra few more lines of machine code in
the fast path.

-- Steve



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab2FNXs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 19:48:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20084 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab2FNXsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:48:25 -0400
X-Authority-Analysis: v=2.0 cv=NbpkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=G0s97Kyuy1EA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=0oI9Mjj4URGTeiNsa7IA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339717703.13377.285.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] tracing: Fix the outmost stupidity of tracing_off()
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Thu, 14 Jun 2012 19:48:23 -0400
In-Reply-To: <alpine.LFD.2.02.1206150106511.3086@ionos>
References: <alpine.LFD.2.02.1206142345100.3086@ionos>
	 <1339714725.13377.252.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.02.1206150106511.3086@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 01:12 +0200, Thomas Gleixner wrote:

> That's still not an excuse for utter stupidity, really. Just check the
> commit date vs. your discovery time.
> 
> I told you often enough to be more careful, but that one is really
> beyond comprehension.

I'm really thinking that this was due to a bad push. As I believe I had
stale code (made this fix locally, but pushed the broken branch) and all
my changes were on top of it. When updating to the latest tip, I had
code I didn't want to merge, or conflicts happened, that I ended up
cherry-picking changes. Which breaks from my normal workflow, which is
to make sure my old changes fast forward to tip before doing a rebase of
my new code.

I have several branches that I work on and when they are ready, I rebase
them on top of tip, run a bunch of tests, and then push them out.

I'm a heavy user of tracing_off() too, and since the development of my
work is usually on older branches, I would not have noticed the bug. As
after I get things working I usually rebase on top of tip before doing
my final tests and asking for the pull request.

I'm usually very careful about checking that things fast forward and
such, and that rebases don't have strange conflicts. This one slipped
by, and yes, I'm extremely ashamed and embarrassed by it. That's why I
said in my pull request 'This was one of those "oh crap" moments'.

-- Steve



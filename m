Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285Ab2J2OiD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 10:38:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16124 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759249Ab2J2Oh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 10:37:59 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=4456EzkC7ncA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=HN6keoNmPfQA:10 a=pGLkceISAAAA:8 a=TaiTUGwJvLFDZ6K1fv8A:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351521477.8467.78.camel@gandalf.local.home>
Subject: Re: [RFC PATCH 9/9] printk: Wake up klogd using irq_work
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Mon, 29 Oct 2012 10:37:57 -0400
In-Reply-To: <1351517296-9173-10-git-send-email-fweisbec@gmail.com>
References: <1351517296-9173-1-git-send-email-fweisbec@gmail.com>
	 <1351517296-9173-10-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 14:28 +0100, Frederic Weisbecker wrote:
> klogd is woken up asynchronously from the tick in order
> to do it safely.
> 
> However if printk is called when the tick is stopped, the reader
> won't be woken up until the next interrupt, which might not fire
> before a while. As a result, the user may miss some message.

Just a grammar nit (and goes for your previous patch as well). We say
"might not fire for a while." or you could say ".. for some time", but
not "before a while" ;-)

I wounder what the French translation of that is.

-- Steve


> 
> To fix this, lets implement the printk tick using a lazy irq work.
> This subsystem takes care of the timer tick state and can
> fix up accordingly.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>



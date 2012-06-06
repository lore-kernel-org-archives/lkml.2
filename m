Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab2FFOhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:37:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20604 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab2FFOhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:37:39 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=ugXGoXdywmAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=g2AdxcNTe4MC7UN34qAA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338993457.13348.547.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH 06/12] ftrace/x86: Add save_regs for i386 function
 calls
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Wed, 06 Jun 2012 10:37:37 -0400
In-Reply-To: <20120606040014.660425497@goodmis.org>
References: <20120606035058.108720095@goodmis.org>
	 <20120606040014.660425497@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 23:51 -0400, Steven Rostedt wrote:

> +ENTRY(ftrace_regs_caller)
> +	pushf	/* push flags before compare */
> +	cmpl $0, function_trace_stop
> +	jne ftrace_exit
> +
> +

Masami,

Do we really need to push before the compare? As the compare flags are
really meaningless with calling functions, and here we are only trying
to hide what the cmpl did. If something else was tracing without regs,
and we put a probe just after the nop, then it would include the cmpl
changes. My version of the patch doesn't restore the flags, so two
probes would have different values. But again, do we care? What would
need to know the value of cmp flags when calling into a function when
they are not going to be restored anyway.

-- Steve



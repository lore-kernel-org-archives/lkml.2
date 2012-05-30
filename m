Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab2E3Ljm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 07:39:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30859 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab2E3Ljk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 07:39:40 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=wwwCnHkgN0EA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=muDU9TWqX4S6gBgt5GwA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338377978.13348.308.camel@gandalf.stny.rr.com>
Subject: Re: [RFC PATCH -tip  0/9]ftrace, kprobes: Ftrace-based kprobe
 optimization
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Wed, 30 May 2012 07:39:38 -0400
In-Reply-To: <4FC5C55E.9000909@hitachi.com>
References: <20120529124833.9191.23007.stgit@localhost.localdomain>
	 <1338331514.13348.298.camel@gandalf.stny.rr.com>
	 <4FC5C55E.9000909@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 15:59 +0900, Masami Hiramatsu wrote:

> Hmm, I'm not so sure how the notrace and filter works.
> What happens if I set a foo function-entry on filter
> and keep notrace empty?
>  - only foo's nop is replaced with call?
>  - or all functions including foo is traced?

>From Documentation/trace/ftrace.txt:

"If a function exists in both set_ftrace_filter
 and set_ftrace_notrace, the function will _not_ be traced."

The filters work exactly the same. If notrace always take precedence
over filter. If you have foo and bar in filter, and put foo in notrace,
then only bar is traced.

"filter" means "limit tracing only to these functions"
"notrace" means "do not trace this function"

Think of 'filter' as a way of making the 'available_filter_functions'
smaller. It filters the list. But 'notrace' is just like adding a
'notrace' tag. It stops it from being traced regardless.

-- Steve




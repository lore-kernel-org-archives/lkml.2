Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235Ab1JHFAL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 01:00:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37032 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab1JHFAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 01:00:08 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=kycaZ6zZ8KAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=cahJxx6UZF3xCAIBq47FAQ==:17 a=echqnOHk58CYoKWxhsQA:9 a=PUjeQqilurYA:10 a=cahJxx6UZF3xCAIBq47FAQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 69.204.222.235
Subject: Re: [PATCH 1/4] [BUGFIX] ftrace/kprobes: Fix not to delete probes
 if in use
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>
Date: Sat, 08 Oct 2011 01:00:04 -0400
In-Reply-To: <20111004104438.14591.6553.stgit@fedora15>
References: <20111004104438.14591.6553.stgit@fedora15>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318050006.4729.103.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 19:44 +0900, Masami Hiramatsu wrote:
> Fix kprobe-tracer not to delete a probe if the probe is in use.
> In that case, delete operation will return -EBUSY.
> 
> This bug can cause a kernel panic if enabled probes are deleted
> during perf record.
> 
> (Add some probes on functions)
> # perf record -e probe:\* -aR sh
> sh-4.2# perf probe --del probe:\*
> sh-4.2# exit
> (kernel panic)


Hi Masami,

I was able to reproduce the panic. I'm currently running patch 1 and 4
through my standard tests before pushing this out as urgent.

Does this exist in previous kernels? If so, I'll also add the stable tag
to it.

Could you resend the trivial patches when you make your necessary
corrections. They are not important as these are and I'll add them to a
separate queue.

Thanks!

-- Steve



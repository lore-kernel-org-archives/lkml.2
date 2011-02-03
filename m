Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab1BCQd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 11:33:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57078 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279Ab1BCQd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 11:33:28 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=CoHOllCSD4cA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=4S4xdSmPAAAA:8 a=j4rIMuExxd8CEp4h4u8A:9 a=RnhaeQ6zQtjIpIdMLtEA:7 a=Z_kzvDFPve5fXLCjVRZqgg2_BWIA:4 a=PUjeQqilurYA:10 a=Ln2jchK5FvgA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC 0/4] tracing,x86_64 - function/graph trace without
 mcount/-pg/framepointer
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com
In-Reply-To: <1296747761-9082-1-git-send-email-jolsa@redhat.com>
References: <1296747761-9082-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 03 Feb 2011 11:33:25 -0500
Message-ID: <1296750805.10797.87.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-03 at 16:42 +0100, Jiri Olsa wrote:
> hi,
> 
> I recently saw the direct jump probing made for kprobes
> and tried to use it inside the trace framework.
> 
> The global idea is patching the function entry with direct
> jump to the trace code, instead of using pregenerated gcc
> profile code.

Interesting, but ideally, it would be nice if gcc provided a better
"mcount" mechanism. One that calls mcount (or whatever new name it would
have) before it does anything with the stack.

> 
> I started this just to see if it would be even possible
> to hook with new probing to the current trace code. It
> appears it's not that bad. I was able to run function
> and function_graph trace on x86_64.
> 
> For details on direct jumps probe, please check:
> http://www.linuxinsight.com/ols2007-djprobe-kernel-probing-with-the-smallest-overhead.html
> 
> 
> I realize using this way to hook the functions has some
> drawbacks, from what I can see it's roughly:
> - no all functions could be patched

What's the reason for not all functions?

> - need to find a way to say which function is safe to patch
> - memory consumption for detour buffers and symbol records
> 
> but seems there're some advantages as well:
> - trace code could be in a module

What makes this allow module code?

ftrace could do that now, but it would require a separate handler. I
would need to disable preemption before calling the module code function
handler.

> - no profiling code is needed
> - framepointer can be disabled (framepointer is needed for
>   generating profile code)

Again ideally, gcc should fix this.

-- Steve



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab2APX7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 18:59:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56689 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab2APX7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 18:59:12 -0500
X-Authority-Analysis: v=2.0 cv=Hf6Wv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=Nm_YeelVK4oA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=3qVtcTwzbr1ns_pp6IUA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326758348.7642.179.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 7/7] ftrace, perf: Add filter support for function trace
 event
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Date: Mon, 16 Jan 2012 18:59:08 -0500
In-Reply-To: <1325495060-6402-8-git-send-email-jolsa@redhat.com>
References: <1324493791-5688-1-git-send-email-jolsa@redhat.com>
	 <1325495060-6402-1-git-send-email-jolsa@redhat.com>
	 <1325495060-6402-8-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-02 at 10:04 +0100, Jiri Olsa wrote:
> Adding support to filter function trace event via perf
> interface. It is now possible to use filter interface
> in the perf tool like:
> 
>   perf record -e ftrace:function --filter="(ip == mm_*)" ls
> 
> The filter syntax is restricted to the the 'ip' field only,
> and following operators are accepted '==' '!=' '||', ending
> up with the filter strings like:
> 
>   ip == f1[, ]f2 ... || ip != f3[, ]f4 ...
> 
> with comma ',' or space ' ' as a function separator. If the
> space ' ' is used as a separator, the right side of the
> assignment needs to be enclosed in double quotes '"'.
> 
> The '==' operator adds trace filter with same effect as would
> be added via set_ftrace_filter file.
> 
> The '!=' operator adds trace filter with same effect as would
> be added via set_ftrace_notrace file.
> 
> The right side of the '!=', '==' operators is list of functions
> or regexp. to be added to filter separated by space.
> 
> The '||' operator is used for connecting multiple filter definitions
> together. It is possible to have more than one '==' and '!='
> operators within one filter string.

Hate to ask you this, but can you rebase this patch against latest
tip/perf/core? Things have changed that cause this patch not to apply.

I'll go ahead and test your other 6 patches.

Thanks!

-- Steve



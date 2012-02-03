Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab2BCNx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 08:53:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353Ab2BCNx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 08:53:56 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=p8-UtJQVZEYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=akOD49uET5piAnFdoXMA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328277235.5882.143.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 5/7] ftrace, perf: Add support to use function
 tracepoint in perf
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Date: Fri, 03 Feb 2012 08:53:55 -0500
In-Reply-To: <20120202181409.GH9071@somewhere.redhat.com>
References: <1326912275-26405-1-git-send-email-jolsa@redhat.com>
	 <1327776209-4883-1-git-send-email-jolsa@redhat.com>
	 <1327776209-4883-6-git-send-email-jolsa@redhat.com>
	 <20120202181409.GH9071@somewhere.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-02 at 19:14 +0100, Frederic Weisbecker wrote:

> All the above from perf_ftrace_function_call() to here should perhaps
> go to trace_function.c.

Please no. This is a perf specific call into the function tracer.
Unless it is rewritten to be a completely generic function. As with the
normal rational on "generic" vs "specific" in the kernel. When there's
only one user, then keep it "specific". When we get two or more users,
then it can be converted to be generic.

Please do not put this into trace_function.c, as the only user of it is
here.

-- Steve



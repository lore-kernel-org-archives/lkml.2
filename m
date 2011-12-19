Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab1LST1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 14:27:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60030 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab1LST1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 14:27:50 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=L1L9NTbhfHkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=GxSvwpomSuXbLTSrgyAA:9 a=ewNhGe2X1KKppH-wywgA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1324322868.5916.40.camel@gandalf.stny.rr.com>
Subject: Re: [PATCHv2 10/10] ftrace, graph: Add global_ops filter callback
 for graph tracing
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Date: Mon, 19 Dec 2011 14:27:48 -0500
In-Reply-To: <1323105776-26961-11-git-send-email-jolsa@redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
	 <1323105776-26961-1-git-send-email-jolsa@redhat.com>
	 <1323105776-26961-11-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-05 at 18:22 +0100, Jiri Olsa wrote:
> The function graph tracer should depend on the global_ops filter,
> and process only functions that pass the global_ops filter.
> 
> Currently the function graph tracer gets all the functions
> enabled for tracing no matter what ftrace_ops enabled them.
> 
> Adding a hook for the graph entry callback, which ensures the
> function is compared against the global_ops filter and bail
> out of if it does not match.
> 
> This hook is enabled only if there's at least one non global
> ftrace_ops registered.


Sorry, I don't like this fix. Right now just let function graph tracer
act weird. If we put in this workaround, it would let us be lazy and not
work on function graph for a proper fix.

The function graph code needs a overhaul anyway. A proper fix may
require fixes in the arch code where the assembly is, as well as a bit
of rewriting of the original code.

This is on my todo list, although it is a bit low priority now. With
this patch set coming in, I can up the priority on the real fix. So
please remove this patch, but keep pinging me to fix it for real ;)

-- Steve



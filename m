Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1KCOLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 10:11:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59139 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab1KCOLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 10:11:54 -0400
X-Authority-Analysis: v=1.1 cv=rFxaVhpzdNKRsWyFDFmDbYx/QEtlW7L1Gw9MiLxO4aw= c=1 sm=0 a=CMzmyBkqurIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=VwQbUJbxAAAA:8 a=hfw4SXqtpos_gL9gzsYA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1320329512.27370.13.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] event: fix TP_printk() argument in sched_switch
From: Steven Rostedt <rostedt@goodmis.org>
To: David Ahern <dsahern@gmail.com>
Cc: avagin@gmail.com, Andrew Vagin <avagin@openvz.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, devel@openvz.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Thu, 03 Nov 2011 10:11:52 -0400
In-Reply-To: <4EB29E9C.1010004@gmail.com>
References: <1320273611-2463347-1-git-send-email-avagin@openvz.org>
	 <1320275277.4793.54.camel@gandalf.stny.rr.com> <4EB28FA6.3040204@gmail.com>
	 <4EB29E9C.1010004@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 08:01 -0600, David Ahern wrote:
> On 11/03/2011 06:57 AM, Andrew Vagin wrote:
> > 
> >> NACK!
> >>
> >> This is a perf userspace bug, not a kernel one. Please fix the userspace
> >> tool instead.
> >>
> >> Note, the new version of libparsevent handles this case without issue.
> >> Perf just needs to be updated.
> > I don't understand. I've got
> > git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
> > and it reports the same error. Where am I wrong?
> 
> Have you installed the plugins?
> 

That's cheating ;)  Yeah, the plugins override what is printed, but this
is a trivial thing that the parsing itself should easily be able to
handle. I'm working on a fix now.

trace-cmd report -N

will fail.  That's because -N does not load the plugins.

-- Steve



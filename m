Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab2EYSqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 14:46:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21472 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab2EYSqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 14:46:17 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Aua4qMZyJ18A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=ofITSWqhkfWE5f55TTIA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337971575.13348.268.camel@gandalf.stny.rr.com>
Subject: Re: BUG - function tracing with breakpoints
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>
Date: Fri, 25 May 2012 14:46:15 -0400
In-Reply-To: <4FBFC421.3020901@linux.intel.com>
References: <20120524160146.GA6226@redhat.com>
	  <1337876398.13348.178.camel@gandalf.stny.rr.com>
	  <20120524172223.GA10689@redhat.com>
	  <1337902816.13348.224.camel@gandalf.stny.rr.com>
	  <4FBEC9E6.8040301@linux.intel.com>
	  <1337909963.13348.232.camel@gandalf.stny.rr.com>
	  <1337910106.13348.234.camel@gandalf.stny.rr.com>
	  <1337956262.13348.257.camel@gandalf.stny.rr.com>
	 <1337959746.13348.264.camel@gandalf.stny.rr.com>
	 <4FBFC421.3020901@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 10:40 -0700, H. Peter Anvin wrote:
> On 05/25/2012 08:29 AM, Steven Rostedt wrote:
> > 
> > This would make sense for this bug, as if modifying_ftrace_code was not
> > seen by other CPUs, it wouldn't go into the ftrace_int3_handler() path.
> > That would cause this issue. But the bug remains after the smp_mb()'s
> > were put in place. Although it behaves a little differently not. Maybe
> > there's something else I missed?
> > 
> 
> Perhaps you should make the modifying_ftrace_code modification atomic...
> it seems odd to have it not be atomic when it is clearly accessed across
> CPUs that way.

I guess I can make it atomic. Not really a big deal as this (and soon
one other place) is the only place that changes its value.

I've found another place that may be causing harm, and I'm currently
working on fixing it. Hopefully after that's done, this problem will go
away.

Thanks,

-- Steve


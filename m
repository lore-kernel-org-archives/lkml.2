Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab1CHXc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 18:32:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42467 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594Ab1CHXc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 18:32:57 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=KpzchuzAFZgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=6MPoj5K3uD9BaDuxVBMA:9 a=VPuDFQoQCPpLFmZvNJ-Eo881yIwA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH][RFC] tracing: Enable tracepoints via module parameters
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        chris <chris@chris-wilson.co.uk>
In-Reply-To: <20110308232258.GA25987@Krystal>
References: <1299622684.20306.77.camel@gandalf.stny.rr.com>
	 <20110308232258.GA25987@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 08 Mar 2011 18:32:55 -0500
Message-ID: <1299627175.20306.96.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-08 at 18:22 -0500, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > A few months ago it was suggested to have a way to enable tracepoints in
> > a module when it is loaded. I tried various methods, but this one seems
> > to be the least intrusive. In fact, it requires no modification to the
> > module code.
> > 
> > The trace event now adds its own MODULE_INFO() and kernel_param_ops that
> > and links the information about a tracepoint into the module's __param
> > section. A module can be loaded with a tracepoint active by adding
> > trace_<tracepoint>=1 as one of the parameters.
> 
> Hi Steven,
> 
> Can you walk me through the expected sequence someone wanting to enable a few
> specific module tracepoints would have to go through ? I'm thinking here about
> the context of a distro which has on-demand module loading. The scenario I am
> thinking about is a distro specifying a basic set of tracepoints to enable in a
> "standard catch-all tracing configuration", which includes some tracepoints in
> yet-unloaded modules. I'm trying to figure out what the end user experience will
> look like if we go for the solution you propose here.
> 

You would add it like any other module parameter.

Just update it in your /etc/modprobe.d/ directory.

-- Steve



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab0CWNS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 09:18:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57997 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab0CWNSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 09:18:55 -0400
X-Authority-Analysis: v=1.0 c=1 a=oxWlMIsUhZYA:10 a=IkcTkHD0fZMA:10 a=BDIIb_0b5fgvPHABnRMA:9 a=lKcKy2lcsXcgqC4qjy-Rh6G7MQkA:4 a=QEXdDO2ut3YA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 0/18] Allow different tracers to be compiled
 independently
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@elte.hu>, Theodore Tso <tytso@MIT.EDU>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jan Kara <jack@suse.cz>,
       Thomas Gleixner <tglx@linutronix.de>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Douglas Santos <douglas.santos@polymtl.ca>
In-Reply-To: <20100323122747.GA14954@Krystal>
References: <1269304340-25372-1-git-send-email-jack@suse.cz>
	 <20100323010419.GA8292@nowhere>
	 <DA3F0457-83D6-4A95-AC86-188BC1C9B2F0@mit.edu>
	 <20100323080526.GB4848@elte.hu>  <20100323122747.GA14954@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Mar 2010 09:18:51 -0400
Message-ID: <1269350331.5363.233.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-23 at 08:27 -0400, Mathieu Desnoyers wrote:
> * Ingo Molnar (mingo@elte.hu) wrote:
> > 

> 
> We're in complete agreement here. When I considered if it was worth it to create
> such a per-tracepoint group compile-time disabling in the first place, I decided
> not to do it precisely due to the added-value that comes with the availability
> of system-wide tracepoints. And I think with the static jump patching, we are
> now at a point where the overhead is stunningly low.
> 
> Now, space-wise, the one thing I would consider appropriate as a compromise for
> small embedded systems would be to allow the TRACE_EVENT probes to be compiled
> as modules.

Yeah, I agree here. Hmm, I wonder if we could automate this. That is, we
could now, create a module per trace system if it is so configured. It
would move the functions that create, record and output the trace points
in TRACE_EVENT() into a separate module. Then you just need to load the
modules you want to trace (grouped by system).

We can make add kobjects to /sys so that udev loads them automatically
for distros.

-- Steve




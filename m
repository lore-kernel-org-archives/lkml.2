Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab0KJRGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 12:06:05 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44838 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757081Ab0KJRGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 12:06:04 -0500
Date: Wed, 10 Nov 2010 18:05:59 +0100
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        ying.huang@intel.com, tglx@linutronix.de, akpm@linux-foundation.org,
        mchehab@redhat.com,
        =?utf-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC/Requirements/Design] h/w error reporting
Message-ID: <20101110170559.GA15704@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Ingo Molnar <mingo@elte.hu>, "Luck, Tony" <tony.luck@intel.com>,
	linux-kernel@vger.kernel.org, ying.huang@intel.com,
	tglx@linutronix.de, akpm@linux-foundation.org, mchehab@redhat.com,
	=?utf-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Arjan van de Ven <arjan@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
References: <4cd9edd7543527b78@agluck-desktop.sc.intel.com>
 <20101110101450.GA18481@elte.hu>
 <1289400056.12418.139.camel@gandalf.stny.rr.com>
 <1289400234.2191.129.camel@laptop>
 <1289401781.12418.145.camel@gandalf.stny.rr.com>
 <1289403019.2084.17.camel@laptop>
 <1289407960.12418.169.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1289407960.12418.169.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 11:52:40AM -0500, Steven Rostedt wrote:
> Also, lets not focus now on implementation. Let's try to concentrate on
> what we want the tools to be able to do.
> 
> For example, I would like:
> 
> Very small entries, and pick and chose what I want in my entries.
> 
> A way to read it fast to a file or over the network (splice).
> 
> The read backwards seems like a cool idea, but I would not want to throw
> away the read forwards part either.

It would also be cool to be able to allocate those buffers as early as
possible, even if before MCA is enabled, so that I won't have to copy
MCE data which got logged before the tracing subsystem got enabled to
the buffers proper.

-- 
Regards/Gruss,
Boris.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab1HHVa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 17:30:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35409 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab1HHVay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 17:30:54 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=JVmKiHRY1FkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=fJs8Fh-PZohCs0LbTGwA:9 a=MALq8dt0wkdbvOxrUOQA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 0/8] Having perf use libparsevent.a
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20110806065122.GC13220@elte.hu>
References: <20110805205921.909038487@goodmis.org>
	 <20110805212409.GA21114@elte.hu>
	 <1312592488.18583.215.camel@gandalf.stny.rr.com>
	 <20110806065122.GC13220@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 08 Aug 2011 17:30:52 -0400
Message-ID: <1312839052.18583.243.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-08-06 at 08:51 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Ingo, I was trying to do as you said, but to do so would require a 
> > lot of restructuring of the perf code base. I started talking with 
> > Arnaldo, as he's doing a lot of the work in the tools/perf code, 
> > and he's the one that suggested that I do it this way. It made 
> > things a lot easier.
> 
> Could you guys please talk some more and clear it up? There's 
> absolutely no technical reason why tools/perf/lib/ (or 
> tools/perf/libperf/) should be harder than tools/lib/.

The issue was trying to use the Makefile within perf for the building.
There was issues with the warning flags and also the deps that are
automatically made with libparsevent.

But you are correct, if I were to just move the pointers over to
tools/perf/lib/events instead of tools/lib/events and had it be a
separate entity in the build process, then it would not be any different
between the two locations.

But there are two non-technical issues with that. Is it wise to have a
different type of build process within the tools/perf directory. The
libparsevents follows the Linux build system more than the git build
system.

The other being, is the parse events a perf only thing? Maybe having a
tools/lib would be nice even if it is. Because we can put things in
tools/lib that will go as a separate package. perf could depend on
tools/lib but there's no reason that tools/lib should depend on perf.

-- Steve



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab0KJVeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 16:34:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50283 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142Ab0KJVeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 16:34:36 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=0Gcdu3wDtgIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=G1koFLn1gv4A7iRKHjMA:9 a=e_l8eaHGDtHmwEckP8QPlvm7O2UA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: RE: Tracing Requirements (was: [RFC/Requirements/Design] h/w error
 reporting)
From: Steven Rostedt <rostedt@goodmis.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1289423194.12418.195.camel@gandalf.stny.rr.com>
References: <1289400056.12418.139.camel@gandalf.stny.rr.com>
	 <1289400234.2191.129.camel@laptop>
	 <1289401781.12418.145.camel@gandalf.stny.rr.com>
	 <1289403019.2084.17.camel@laptop> <20101110174852.GB4001@elte.hu>
	 <1289412329.12418.177.camel@gandalf.stny.rr.com>
	 <1289413460.2084.27.camel@laptop> <20101110184105.GH22410@elte.hu>
	 <1289415645.12418.180.camel@gandalf.stny.rr.com>
	 <20101110191127.GA6190@nowhere> <20101110202316.GA32396@Krystal>
	 <987664A83D2D224EAE907B061CE93D5301649A71DC@orsmsx505.amr.corp.intel.com>
	 <1289423194.12418.195.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 10 Nov 2010 16:34:34 -0500
Message-ID: <1289424874.12418.199.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 16:06 -0500, Steven Rostedt wrote:

> > Perhaps you could explain the use cases of your "flight recorder",
> > because it seems that the name doesn't fit exactly, and this is
> > causing me (and maybe others) some confusion.

> 2) overwrite mode (flight recorder) - when the writer reaches the
> reader, it pushes the reader forward, and writes the new events over the
> old ones. This way, new events are always existent, where as old events
> are lost.

Ah, I forgot to mention use cases.

Even when recording a trace (lots of data, so it is saved to disk and
not all in kernel memory) I like to know that if something happens and
disables the trace, I have all the trace information up to the point of
failure.

With producer/consumer mode, you risk the reader being late and the
events in the trace that led up to failure (or any other anomaly) were
dropped.

-- Steve



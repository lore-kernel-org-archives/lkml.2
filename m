Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab2BVA6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 19:58:52 -0500
Received: from mga03.intel.com ([143.182.124.21]:28386 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab2BVA6j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 19:58:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="68880160"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>, Steven Rostedt <rostedt@goodmis.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: RAS trace event proto
Thread-Topic: RAS trace event proto
Thread-Index: AQHM7+BCctoWvh/p/Eytj6bC0rxzbpZHzceAgAAeR4CAAAoAAIAAAzCA///wA6A=
Date: Wed, 22 Feb 2012 00:58:37 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F03DA60@ORSMSX104.amr.corp.intel.com>
References: <20120220145920.GB5728@aftab> <4F438CE9.7080807@redhat.com>
 <20120221141231.GA15515@aftab>
 <1329835698.25686.60.camel@gandalf.stny.rr.com>
 <20120221145943.GB15515@aftab>
In-Reply-To: <20120221145943.GB15515@aftab>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > Also, folding everything into just one string prevents (or make hard) the usage of
> > > > the perf filters, for example, to filter only the errors at the memory controller 1.
> > > 
> > > Huh, because you can't grep through the trace anymore...?
> > > 
> > 
> > I believe Mauro is talking about the tracing filters used by both perf
> > and ftrace that lets you ignore trace events when the contents of the
> > event does not match the filter. This is filtering out events before
> > they go to the buffer.
>
> Oh ok, in that case we could filter the errors - if needed - before they
> get even reported. I say "if needed" because normally we want to collect
> all hw errors in the trace, IMHO.

I'm also struggling to understand an end-user use case where you would
want filtering.  Mauro - can you expand a bit on why someone would just
want to see the errors from memory controller 1?

My mental model of the world is that large systems have some background
noise - a trickle of corrected errors that happen in normal operation.
User shouldn't care about these errors unless they breach some threshold.

When something goes wrong, you may see a storm of corrected errors, or
some uncorrected errors. In either case you'd like to get as much information
as possible to identify the component that is at fault. I'd definitely like
to see some structure to the error reporting, so that mining for data patterns
in a storm isn't hideously platform dependent.

It might be easier to evaluate the competing ideas here with some sample
output in addition to the code.

-Tony


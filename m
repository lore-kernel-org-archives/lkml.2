Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab0LGMYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 07:24:50 -0500
Received: from www.tglx.de ([62.245.132.106]:46156 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853Ab0LGMYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 07:24:48 -0500
Date: Tue, 7 Dec 2010 13:24:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
cc: Ian Munsie <imunsie@au1.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/3] perf record/report: Process events in order
In-Reply-To: <20101207105446.GA6911@ghostprotocols.net>
Message-ID: <alpine.LFD.2.00.1012071323030.2653@localhost6.localdomain6>
References: <alpine.LFD.2.00.1012051220450.2653@localhost6.localdomain6> <1291603026-11785-4-git-send-email-imunsie@au1.ibm.com> <alpine.LFD.2.00.1012061014180.2653@localhost6.localdomain6> <1291637998-sup-4601@au1.ibm.com> <alpine.LFD.2.00.1012061359140.2653@localhost6.localdomain6>
 <1291640985-sup-4443@au1.ibm.com> <alpine.LFD.2.00.1012061447080.2653@localhost6.localdomain6> <1291679635-sup-9860@au1.ibm.com> <alpine.LFD.2.00.1012070942070.2653@localhost6.localdomain6> <20101207105446.GA6911@ghostprotocols.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Dec 2010, Arnaldo Carvalho de Melo wrote:
> Em Tue, Dec 07, 2010 at 11:47:35AM +0100, Thomas Gleixner escreveu:
> > Having time ordered output of -D needs more than fixing the time stamp
> > issue. The dump_printf/dump_trace stuff is scattered all over the
> > place. So that needs more code churn, as you want to output the non
> > synth events when the ordered queue is drained.
> 
> We can fix that, but then it was supposed to be a dump, something as it
> comes from the perf.data file.
> 
> Perhaps we need something new, that does ordered dumps, I think we can
> just move all the dump_fprintf stuff to one place, and have calls for
> those where it is now (unordered) and another one from the ordered
> place, but looking at different debug variables?

I have a patch series ready to consolidate all this. Will send soon.

Thanks,

	tglx

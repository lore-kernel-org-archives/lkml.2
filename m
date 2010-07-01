Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab0GAPxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:53:23 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:48566 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab0GAPxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:53:21 -0400
X-Greylist: delayed 70912 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Jul 2010 11:53:21 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GfaEFPNth8ZfP5fzBX9O8zEkazIVkMes/RyWO2wKG3qjd2q1xr7yQ43DlJYbxJq7KU
         2YFKyc5GCdYlSsNOX1rMigtbO8U+SktZ5Qux8YHc3apm9IfyYO95p8XxywOhoji3GHwV
         FIKl7Z46cYrz+5KVKR1lvPEnjojXjTA1RpD+s=
Date: Thu, 1 Jul 2010 17:53:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       David Miller <davem@davemloft.net>, Paul Mundt <lethal@linux-sh.org>,
       Will Deacon <will.deacon@arm.com>, Borislav Petkov <bp@amd64.org>
Subject: Re: [RFC PATCH 3/6] perf: Generalize some arch callchain code
Message-ID: <20100701155330.GD10616@nowhere>
References: <1277998562-21366-1-git-send-regression-fweisbec@gmail.com> <1277998562-21366-4-git-send-regression-fweisbec@gmail.com> <1277999161.1917.216.camel@laptop> <20100701154922.GC10616@nowhere> <1277999482.1917.219.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277999482.1917.219.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 05:51:22PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-07-01 at 17:49 +0200, Frederic Weisbecker wrote:
> > On Thu, Jul 01, 2010 at 05:46:01PM +0200, Peter Zijlstra wrote:
> > > On Thu, 2010-07-01 at 17:35 +0200, Frederic Weisbecker wrote:
> > > > - Most archs use one callchain buffer per cpu, except x86 that needs
> > > >   to deal with NMIs. Provide a default perf_callchain_buffer()
> > > >   implementation that x86 overrides. 
> > > 
> > > sparc and power also have NMI like contexts.
> > 
> > 
> > Ah and the comments suggest it's because pmu interrupts can't nest or so.
> > Anyway, that's notwithstanding the race that 5th patch fixes.
> 
> Right, but they could interrupt a software event or the like.


Yeah indeed.


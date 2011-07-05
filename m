Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab1GEMYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:24:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932068Ab1GEMYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:24:20 -0400
Date: Tue, 5 Jul 2011 08:24:05 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        Stephane Eranian <eranian@google.com>, Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip, final] perf, x86: Add hw_watchdog_set_attr() in a
 sake of nmi-watchdog on P4
Message-ID: <20110705122405.GU3765@redhat.com>
References: <20110705100320.GK17941@sun>
 <20110705102017.GA12458@elte.hu>
 <20110705103403.GN17941@sun>
 <20110705105959.GA14435@elte.hu>
 <20110705110550.GQ17941@sun>
 <20110705112002.GA15654@elte.hu>
 <20110705113620.GS17941@sun>
 <20110705114437.GC15654@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110705114437.GC15654@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 01:44:37PM +0200, Ingo Molnar wrote:
> > Probably I miss something and you mean something completely different?
> 
> What i am missing is that you have not pointed out the *core problem* 
> you are fixing and it's not obvious from the changelog either!

Cyril,

I think you didn't explain the fact that without this patch if you enable
nmi_watchdog, then the 'perf' tool doesn't work on a P4.  This is bad for
end users.  It seems like with all the P4 register coupling an end user
can run either the nmi_watchdog _or_ perf but not both.

For RHEL-6 this was bad because we like to enable the nmi_watchdog.

This patch does some magic and allows the end user to use the nmi_watchdog
_and_ perf concurrently (a common expected behaviour).

I hope that clears things up Ingo.

Cheers,
Don

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab1LFVN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 16:13:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52293 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753267Ab1LFVN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 16:13:58 -0500
Date: Tue, 6 Dec 2011 21:13:42 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Message-ID: <20111206211342.GI3366@decadent.org.uk>
References: <1319773015.6759.30.camel@deadeye>
 <tip-fbdc4b9a6c29befbcca65e5366e5aaf2abb7a013@git.kernel.org>
 <1323185640.7454.269.camel@deadeye>
 <1323193731.32012.81.camel@twins>
 <20111206175558.3215907c@lxorguk.ukuu.org.uk>
 <20111206175919.GA5386@elte.hu>
 <20111206181715.GG3366@decadent.org.uk>
 <20111206182847.GB12094@elte.hu>
 <20111206191458.GA25568@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206191458.GA25568@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [tip:core/locking] lockdep, rtmutex, bug: Show taint flags on
 error
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 08:14:58PM +0100, Ingo Molnar wrote:
> 
> Anyway, SOB flaming aside, i think there's now consensus that we 
> don't want to disable lockdep for TAINT_OOT modules.
 
OK, glad we could work this out.

> Mind (re-)sending a delta patch against tip:master that excludes 
> that taint flag in addition to the already excluded 
> TAINT_FIRMWARE case? That should close this rather verbose 
> chapter of taint flag handling changes for good ;-)

I originally assumed that lock debugging was being disabled on a
tainted kernel in order to save kernel developers from having to
handle false lockdep errors that are due to external bugs.  The
intent of my proposed change was to achieve this same effect by
showing taint flags instead.  Although the immediate motivation
for this was the new TAINT_OOT_MODULE, I don't see that it is
important for any taint flag to have this disabling effect now.

If you want to ensure that lock debugging is not available to
proprietary modules, I don't have a problem with that, although there
is no legal or practical way for us to stop proprietary module
developers evading this check and doing lock debugging in the privacy
of their offices.

So what I would like to do is either:

1. No longer disable lock debugging due to any taint
or
2. Disable lock debugging only when TAINT_PROPRIETARY_MODULE is set

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus

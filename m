Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab0JPSUu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 14:20:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34496 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab0JPSUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 14:20:49 -0400
Date: Sat, 16 Oct 2010 20:20:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, ying.huang@intel.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, dzickus@redhat.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] x86, NMI: Rewrite NMI handler
Message-ID: <20101016182037.GA26090@elte.hu>
References: <1287195738-3136-4-git-send-email-dzickus@redhat.com>
 <tip-e21f3e4957f4a55f546873605a5caa59556bb144@git.kernel.org>
 <1287250157.1998.124.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287250157.1998.124.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Sat, 2010-10-16 at 16:36 +0000, tip-bot for Huang Ying wrote:
> > Commit-ID:  e21f3e4957f4a55f546873605a5caa59556bb144
> > Gitweb:     http://git.kernel.org/tip/e21f3e4957f4a55f546873605a5caa59556bb144
> > Author:     Huang Ying <ying.huang@intel.com>
> > AuthorDate: Fri, 15 Oct 2010 22:22:16 -0400
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Sat, 16 Oct 2010 15:01:27 +0200
> > 
> > x86, NMI: Rewrite NMI handler
> > 
> > The original NMI handler is quite outdated in many aspects. This
> > patch tries to fix it.
> > 
> > The order to process the NMI sources are changed as follow:
> > 
> >  notify_die(DIE_NMI_IPI);
> >  notify_die(DIE_NMI);
> >  /* process io port 0x61 */
> >  nmi_watchdog_touch();
> >  unknown_nmi();
> 
> NACK!
> 
> I object to the DIE_NMI_IPI existance..

Ok - i've zapped the commits for the time being.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab0K2I3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 03:29:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55445 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab0K2I33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 03:29:29 -0500
Date: Mon, 29 Nov 2010 09:29:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        David Miller <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the final tree (tip
 tree related)
Message-ID: <20101129082916.GA12374@elte.hu>
References: <20101122133949.93201b15.sfr@canb.auug.org.au>
 <20101129135023.4a931f86.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101129135023.4a931f86.sfr@canb.auug.org.au>
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> On Mon, 22 Nov 2010 13:39:49 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > After merging the final tree, today's linux-next build (sparc64 defconfig)
> > failed like this:
> > 
> > arch/sparc/kernel/nmi.c:54: error: redefinition of 'touch_nmi_watchdog'
> > include/linux/nmi.h:21: note: previous definition of 'touch_nmi_watchdog' was here
> > 
> > Caused (or, at least exposed) by commit
> > 5f2b0ba4d94b3ac23cbc4b7f675d98eb677a760a ("x86, nmi_watchdog: Remove the
> > old nmi_watchdog").  Sparc appears to have a touch_nmi_watchdog() and
> > defines ARCH_HAS_NMI_WATCHDOG but not CONFIG_HARDLOCKUP_DETECTOR.
> > 
> > I have reverted that commit for today (as well as commit
> > 072b198a4ad48bd722ec6d203d65422a4698eae7 "x86, nmi_watchdog: Remove all
> > stub function calls from old nmi_watchdog" that depends on it).
> 
> This build failure is back, so I have reverted the above commits again.

Don, have you got a fix for that?

Thanks,

	Ingo

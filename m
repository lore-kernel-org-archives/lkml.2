Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717Ab2BKNug (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 08:50:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38285 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174Ab2BKNuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 08:50:35 -0500
Date: Sat, 11 Feb 2012 14:50:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: aowi@novozymes.com, Andreas Herrmann <herrmann.der.user@googlemail.com>,
        "JK (Jesper Agerbo Krogh)" <JK@novozymes.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Memory issues with Opteron 6220
Message-ID: <20120211135019.GE28098@elte.hu>
References: <20120208143741.GB28486@otto.nzcorp.net>
 <20120208205628.GA18909@alberich.amd.com>
 <20120209124355.GA20902@otto.nzcorp.net>
 <20120209132825.GB8830@elte.hu>
 <20120209134920.GA25934@otto.nzcorp.net>
 <CAE9FiQUiMBUh9xSKoLj_1ZPXY3wTehB6i1V_mPmx7rs5XqMZTw@mail.gmail.com>
 <20120209175114.GA5525@otto.nzcorp.net>
 <CAE9FiQUc5Xzvt94sS5HBmQ9E1hyB7GRozP2-xgZk=9y4AUOk9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQUc5Xzvt94sS5HBmQ9E1hyB7GRozP2-xgZk=9y4AUOk9g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Thu, Feb 9, 2012 at 9:51 AM, Anders Ossowicki <aowi@novozymes.com> wrote:
> > On Thu, Feb 09, 2012 at 05:11:04PM +0100, Yinghai Lu wrote:
> >> mtrr setting has some problem too.
> >>
> >> [    3.098277] mtrr: your CPUs had inconsistent fixed MTRR settings
> >> [ 3.100001] mtrr: probably your BIOS does not setup all CPUs.
> >> [    3.110000] mtrr: corrected configuration.
> >>
> >> can you boot with "debug ignore_loglevel show_msr=16" ?
> >
> > Yep, right here:
> > http://dev.exherbo.org/~arkanoid/atlas-dmesg-3.2.5-20120209-mtrr.txt
> >
> 
> Too bad, print_cpu_info() calling for AP get removed by some 
> commit.
> 
> now we can not print initial AP register anymore.

Mind sending a patch that puts it back, so that it's printed via 
KERN_DEBUG or such, i.e. does not get emitted in the default 
log. Maybe even tie it to apic=debug or so.

Thanks,

	Ingo

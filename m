Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759978Ab1CDQXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 11:23:51 -0500
Received: from [46.28.109.124] ([46.28.109.124]:55182 "EHLO
	host1.jankratochvil.net" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759966Ab1CDQXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 11:23:50 -0500
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Mar 2011 11:23:50 EST
Date: Fri, 4 Mar 2011 17:14:41 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110304161441.GA12987@host1.jankratochvil.net>
References: <20110301152457.GE26074@htj.dyndns.org>
 <20110301190638.GA12196@host1.dyn.jankratochvil.net>
 <AANLkTiknaHNADRa3R4Tefg2TGuFmKPZY-_08_krFiNFF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTiknaHNADRa3R4Tefg2TGuFmKPZY-_08_krFiNFF@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Mar 2011 23:14:14 +0100, Denys Vlasenko wrote:
> On Tue, Mar 1, 2011 at 8:06 PM, Jan Kratochvil <jan.kratochvil@redhat.com> wrote:
> > Currently it is already a problem that apps did not / do not expect the first
> > waitpid after PTRACE_ATTACH may not be SIGSTOP.
> 
> That's exactly why we want to add a better alternative, which doesn't
> insert that blasted SIGSTOP.

But it insteads blasted SIGTRAP (or some other signal) instead.

It would be best if such PTRACE_SEIZE (similar to PTRACE_INTERRUPT) would
guarantee the first waitpid afterwards returns the artificial signal from
PTRACE_SEIZE.


Thanks,
Jan

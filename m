Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab2HXOxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 10:53:20 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:46170 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab2HXOxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 10:53:15 -0400
Date: Fri, 24 Aug 2012 07:52:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: sedat.dilek@gmail.com, Paul McKenney <paul.mckenney@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-next <linux-next@vger.kernel.org>
Subject: Re: [next-20120823] NOHZ: local_softirq_pending 200 on s/r
Message-ID: <20120824145247.GB2472@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+icZUW2aUP=vjBeoksFU=NAVFMJEiBQy6sNKZczzRPEP9kOfw@mail.gmail.com>
 <1345793168.4331.64.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345793168.4331.64.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082414-2398-0000-0000-000009BBDA2C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 09:26:08AM +0200, Mike Galbraith wrote:
> On Thu, 2012-08-23 at 12:04 +0200, Sedat Dilek wrote:
> 
> > Jack Winter confirmed to see similiar NOHZ messages also on
> > v3.4.9-rt17 kernel (CPU: Core2Duo when no suspend performed):
> > 
> > [15223.171585] NOHZ: local_softirq_pending 08
> 
> These can be caused by blocking while holding local_softirq_lock.
> 
> Even with per softirq threads, and then (yet more overhead) splitting
> the lock to make sure one softirq type can't block another, _and_ only
> griping if the lock for the pending softirq is _not_ held, seems the
> little bugger can still be triggered very rarely by syn flood induced
> handler bail/raise.  Annoying little gripe :)

Hmmm...  Now that you mention it, if I understand correctly, the
conversion of spinlocks to sleeplocks in -rt would seem to invalidate
this particular diagnostic completely.

So, what am I missing?

							Thanx, Paul


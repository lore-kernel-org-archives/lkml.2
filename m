Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab1JTRs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 13:48:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754406Ab1JTRsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 13:48:54 -0400
Date: Thu, 20 Oct 2011 13:48:26 -0400
From: Don Zickus <dzickus@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Chen, Gong" <gong.chen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "hughd@chromium.org" <hughd@chromium.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH -next] make pstore/kmsg_dump run after stopping
 other cpus in panic path
Message-ID: <20111020174826.GA3452@redhat.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C5747DC7B@USINDEVS01.corp.hds.com>
 <20111017164715.e42591d5.akpm@linux-foundation.org>
 <20111018124929.GA3452@redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C57565D3A@USINDEVS01.corp.hds.com>
 <20111018151058.GE3452@redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C5756688D@USINDEVS01.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C5756688D@USINDEVS01.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 11:13:26AM -0400, Seiji Aguchi wrote:
> Don,
> 
> >That is part of the wider problem with kmsg_dump that Vivek talks about
> >with me, is that it is just a giant hook in the panic path with limited
> >auditing.  So we need to explicit set our expectations with BUG_ONs/WARNs
> >otherwise we might get bit later by them.
> 
> I found an issue while developing a patch v2.
> 
> We can't call BUG_ON(in_nmi() && reason != KMSG_DUMP_PANIC)
> because kmsg_dump(KMSG_DUMP_EMERG) is called in NMI context if "panic" kernel parameter is set.

I am confused.  Did you mean 'panic' kernel parameter is _not_ set?

Actually, BUG_ON is probably overkill, perhaps a WARN_ON would be more
appropriate.

> 
> I will keep doing research bust_spinlock() or vprintk() so that lockdep checking works and we can avoid any deadlocks.

I wonder if it would be smarter to split your patch in half.  The part
where you move kmsg_dump to below stop_cpus is probably non-controversial.
That might make it sooner than the more controversial bust_spinlock
pieces.

Cheers,
Don

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab2GPScX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 14:32:23 -0400
Received: from trent.utfs.org ([94.185.90.103]:35719 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab2GPScV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 14:32:21 -0400
Date: Mon, 16 Jul 2012 11:32:07 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Li Zhong <zhong@linux.vnet.ibm.com>
cc: Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, arjan@linux.intel.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH RESEND] Fix a dead loop in async_synchronize_full()
In-Reply-To: <1342086988.4091.44.camel@ThinkPad-T420>
Message-ID: <alpine.DEB.2.01.1207161130080.26923@trent.utfs.org>
References: <1341817465.4579.5.camel@ThinkPad-T420>  <20120711154232.165cbca9.akpm@linux-foundation.org>  <CABE8wwsqyo=BPCy4xy1PAVKFWe=GqYRdYowXkQ6UZoXdtEdCZA@mail.gmail.com> <1342086988.4091.44.camel@ThinkPad-T420>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2012 at 17:56, Li Zhong wrote:
> On Wed, 2012-07-11 at 15:50 -0700, Dan Williams wrote:
> > On Wed, Jul 11, 2012 at 3:42 PM, Andrew Morton
> > <akpm@linux-foundation.org> wrote:
> > > The patch is fairly wordwrapped - please fix up your email client.
> > >
> > > More seriously, it does not apply to linux-next due to some fairly
> > > significant changes which have been sitting in Dan's tree since May.
> > > What's going on?
> > >
> > 
> > Those changes missed the 3.5 merge window, but now that they have
> > Arjan's ack they should head upstream via James for 3.6.  Right now
> > they are on his pending [1] branch.
> > 
> > As far as the comment:
> > 
> > > It seems async_synchronize_full() wants to synchronize all entries in
> > > all running lists(domains), so maybe we could just check the entry_count
> > > to know whether all works are finished.
> > 
> > ...at first glance this is what the new async patches achieve.
> > async_synchronize_full should now sync work across all domains, but if
> > you can reproduce this bug it would be nice to confirm that the
> > pending changes fix it.
> > 
> 
> I have tested your pending patches, they fix the problem here.
> 
> But with ASYNC_DOMAIN_EXCLUSIVE added for the domains defined on the
> stack, I think we lack a function that could wait for all the works in
> all domains (however, maybe actually we don't need such an interface).
> 
> Also, I think it's not good to exclude them from
> async_synchronize_full() just because they are defined on the stack. 

Is this still scheduled to go into 3.5? I'm asking because -rc7 has been 
released and does not contain this fix. W/o this fix, my powerpc system 
won't boot[0] :-\

Thanks,
Christian.

[0] http://nerdbynature.de/bits/3.5.0-rc5/soft_lockup/
-- 
BOFH excuse #28:

CPU radiator broken

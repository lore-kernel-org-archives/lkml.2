Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030277Ab2GLJ4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 05:56:41 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:54167 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759052Ab2GLJ4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 05:56:39 -0400
Message-ID: <1342086988.4091.44.camel@ThinkPad-T420>
Subject: Re: [PATCH RESEND] Fix a dead loop in async_synchronize_full()
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, arjan@linux.intel.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Christian Kujau <lists@nerdbynature.de>,
        Cong Wang <xiyou.wangcong@gmail.com>
Date: Thu, 12 Jul 2012 17:56:28 +0800
In-Reply-To: <CABE8wwsqyo=BPCy4xy1PAVKFWe=GqYRdYowXkQ6UZoXdtEdCZA@mail.gmail.com>
References: <1341817465.4579.5.camel@ThinkPad-T420>
	 <20120711154232.165cbca9.akpm@linux-foundation.org>
	 <CABE8wwsqyo=BPCy4xy1PAVKFWe=GqYRdYowXkQ6UZoXdtEdCZA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12071209-4790-0000-0000-000003A7889F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 15:50 -0700, Dan Williams wrote:
> On Wed, Jul 11, 2012 at 3:42 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > The patch is fairly wordwrapped - please fix up your email client.
> >
> > More seriously, it does not apply to linux-next due to some fairly
> > significant changes which have been sitting in Dan's tree since May.
> > What's going on?
> >
> 
> Those changes missed the 3.5 merge window, but now that they have
> Arjan's ack they should head upstream via James for 3.6.  Right now
> they are on his pending [1] branch.
> 
> As far as the comment:
> 
> > It seems async_synchronize_full() wants to synchronize all entries in
> > all running lists(domains), so maybe we could just check the entry_count
> > to know whether all works are finished.
> 
> ...at first glance this is what the new async patches achieve.
> async_synchronize_full should now sync work across all domains, but if
> you can reproduce this bug it would be nice to confirm that the
> pending changes fix it.
> 

I have tested your pending patches, they fix the problem here.

But with ASYNC_DOMAIN_EXCLUSIVE added for the domains defined on the
stack, I think we lack a function that could wait for all the works in
all domains (however, maybe actually we don't need such an interface).

Also, I think it's not good to exclude them from
async_synchronize_full() just because they are defined on the stack. 

> --
> Dan
> 
> [1]: http://git.kernel.org/?p=linux/kernel/git/jejb/scsi.git;a=shortlog;h=refs/heads/pending
> 



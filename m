Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030473Ab2GKWuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:50:46 -0400
Received: from mga06.intel.com ([134.134.136.21]:61285 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751439Ab2GKWup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:50:45 -0400
MIME-Version: 1.0
In-Reply-To: <20120711154232.165cbca9.akpm@linux-foundation.org>
References: <1341817465.4579.5.camel@ThinkPad-T420>
	<20120711154232.165cbca9.akpm@linux-foundation.org>
Date: Wed, 11 Jul 2012 15:50:43 -0700
Message-ID: <CABE8wwsqyo=BPCy4xy1PAVKFWe=GqYRdYowXkQ6UZoXdtEdCZA@mail.gmail.com>
Subject: Re: [PATCH RESEND] Fix a dead loop in async_synchronize_full()
From: Dan Williams <dan.j.williams@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        arjan@linux.intel.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Christian Kujau <lists@nerdbynature.de>,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 3:42 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> The patch is fairly wordwrapped - please fix up your email client.
>
> More seriously, it does not apply to linux-next due to some fairly
> significant changes which have been sitting in Dan's tree since May.
> What's going on?
>

Those changes missed the 3.5 merge window, but now that they have
Arjan's ack they should head upstream via James for 3.6.  Right now
they are on his pending [1] branch.

As far as the comment:

> It seems async_synchronize_full() wants to synchronize all entries in
> all running lists(domains), so maybe we could just check the entry_count
> to know whether all works are finished.

...at first glance this is what the new async patches achieve.
async_synchronize_full should now sync work across all domains, but if
you can reproduce this bug it would be nice to confirm that the
pending changes fix it.

--
Dan

[1]: http://git.kernel.org/?p=linux/kernel/git/jejb/scsi.git;a=shortlog;h=refs/heads/pending

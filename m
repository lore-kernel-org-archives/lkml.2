Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab2HWX2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 19:28:19 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:48871 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab2HWX2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 19:28:15 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-46-5036bc8ce42f
Date: Fri, 24 Aug 2012 08:28:45 +0900
From: Minchan Kim <minchan@kernel.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH 0/2] revert changes to zcache_do_preload()
Message-ID: <20120823232845.GE5369@bbox>
References: <1345735991-6995-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <20120823205648.GA2066@barrios>
 <5036AA38.6010400@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5036AA38.6010400@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 05:10:00PM -0500, Seth Jennings wrote:
> On 08/23/2012 03:56 PM, Minchan Kim wrote:
> > Hi Seth,
> > 
> > On Thu, Aug 23, 2012 at 10:33:09AM -0500, Seth Jennings wrote:
> >> This patchset fixes a regression in 3.6 by reverting two dependent
> >> commits that made changes to zcache_do_preload().
> >>
> >> The commits undermine an assumption made by tmem_put() in
> >> the cleancache path that preemption is disabled.  This change
> >> introduces a race condition that can result in the wrong page
> >> being returned by tmem_get(), causing assorted errors (segfaults,
> >> apparent file corruption, etc) in userspace.
> >>
> >> The corruption was discussed in this thread:
> >> https://lkml.org/lkml/2012/8/17/494
> > 
> > I think changelog isn't enough to explain what's the race.
> > Could you write it down in detail?
> 
> I didn't come upon this solution via code inspection, but
> rather through discovering that the issue didn't exist in
> v3.5 and just looking at the changes since then.

Okay, then, why do you think the patchsets are culprit?
I didn't look the cleanup patch series of Xiao at that time
so I can be wrong but as I just look through patch of
"zcache: optimize zcache_do_preload", I can't find any fault
because zcache_put_page checks irq_disable so we don't need
to disable preemption so it seems that patch is correct to me.
If the race happens by preemption, BUG_ON in zcache_put_page
should catch it.

What do you mean? Do you have any clue in your mind?

        The commits undermine an assumption made by tmem_put() in
        the cleancache path that preemption is disabled.

> 
> > And you should Cc'ed Xiao who is author of reverted patch.
> 
> Thanks for adding Xiao.  I meant to do this. For some reason
> I thought that you submitted that patchset :-/

Even, I didn't notice that patchset at that time. :)

> My bad.
> 
> Seth
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim

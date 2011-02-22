Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab1BVOyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:54:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689Ab1BVOyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:54:45 -0500
Subject: Re: [PATCH 4/7] KVM: sort memslots and use binary search to search
 the right slot
From: Alex Williamson <alex.williamson@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
In-Reply-To: <4D63C753.3030906@redhat.com>
References: <4D636EF8.60800@cn.fujitsu.com>
	 <4D636FE8.8000505@cn.fujitsu.com>  <4D63C753.3030906@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Feb 2011 07:54:41 -0700
Message-ID: <1298386481.5764.60.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 16:25 +0200, Avi Kivity wrote:
> On 02/22/2011 10:12 AM, Xiao Guangrong wrote:
> > Sort memslots then search the slot with binary search to speed up the
> > slot searching
> >
> 
> I'm not sure if a binary search is the right algorithm here.  It 
> introduces a lot of branches which may be mispredicted.
> 
> Options we've discussed are:
> 
> - Sort slots by size, use linear search (so the largest slots are found 
> quickly)
> - Weighted balanced tree 
> http://en.wikipedia.org/wiki/Weight-balanced_tree, use weight == slot size

I've got an implementation using a weight balanced tree working now.  I
need to do some testing to see if I can detect any performance
difference from the current unsorted, linear array.

> Both options still make the miss case (mmio) slow.  We could cache the 
> result of a miss in an spte by using a reserved bit, and checking the 
> page fault error code (or seeing if we get an ept violation or ept 
> misconfiguration), so if we get repeated mmio on a page, we don't need 
> to search the slot list/tree.

I haven't started on this idea yet.  Thanks,

Alex




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab0FDSUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 14:20:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647Ab0FDSUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 14:20:32 -0400
Date: Fri, 4 Jun 2010 12:18:25 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: rework remove-write-access for a slot
Message-ID: <20100604151825.GA11087@amt.cnet>
References: <4C061C16.9040208@cn.fujitsu.com>
 <4C063E01.7040206@redhat.com>
 <4C08B5D0.6090104@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C08B5D0.6090104@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 04:14:08PM +0800, Lai Jiangshan wrote:
> Avi Kivity wrote:
> > On 06/02/2010 11:53 AM, Lai Jiangshan wrote:
> >> Current code uses slot_bitmap to find ptes who map a page
> >> from the memory slot, it is not precise: some ptes in the shadow page
> >> are not map any page from the memory slot.
> >>
> >> This patch uses rmap to find the ptes precisely, and remove
> >> the unused slot_bitmap.

Note that the current code is precise: memslot_id does unalias_gfn.

> > Patch looks good; a couple of comments:
> > 
> > - We might see a slowdown with !tdp, since we no longer have locality. 
> > Each page will map to an spte in a different page.  However, it's still
> > worth it in my opinion.
> 
> Yes, this patch hurts the cache since we no longer have locality.
> And if most pages of the slot are not mapped(rmap_next(kvm, rmapp, NULL)==NULL),
> this patch will worse than old method I think.

Can you get some numbers before/after patch, with/without lots of shadow
pages instantiated? Better with large amount of memory for the guest.

Because shrinking kvm_mmu_page is good.


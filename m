Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab0JGE1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 00:27:55 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59139 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab0JGE1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 00:27:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 7 Oct 2010 13:22:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        containers@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Restrict size of page_cgroup->flags
Message-Id: <20101007132233.f695aa2c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101007035608.GN4195@balbir.in.ibm.com>
References: <20101006142314.GG4195@balbir.in.ibm.com>
	<20101007085858.0e07de59.kamezawa.hiroyu@jp.fujitsu.com>
	<20101007031203.GK4195@balbir.in.ibm.com>
	<20101007121816.bbd009c1.kamezawa.hiroyu@jp.fujitsu.com>
	<20101007035608.GN4195@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Oct 2010 09:26:08 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-10-07 12:18:16]:
> 
> > On Thu, 7 Oct 2010 08:42:04 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-10-07 08:58:58]:
> > > 
> > > > On Wed, 6 Oct 2010 19:53:14 +0530
> > > > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > > 
> > > > > I propose restricting page_cgroup.flags to 16 bits. The patch for the
> > > > > same is below. Comments?
> > > > > 
> > > > > 
> > > > > Restrict the bits usage in page_cgroup.flags
> > > > > 
> > > > > From: Balbir Singh <balbir@linux.vnet.ibm.com>
> > > > > 
> > > > > Restricting the flags helps control growth of the flags unbound.
> > > > > Restriciting it to 16 bits gives us the possibility of merging
> > > > > cgroup id with flags (atomicity permitting) and saving a whole
> > > > > long word in page_cgroup
> > > > > 
> > > > > Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> > > > 
> > > > Doesn't make sense until you show the usage of existing bits.
> > > 
> > > ??
> > > 
> > Limiting something for NOT EXISTING PATCH doesn't make sense, in general.
> > 
> > 
> > > > And I guess 16bit may be too large on 32bit systems.
> > > 
> > > too large on 32 bit systems? My intention is to keep the flags to 16
> > > bits and then use cgroup id for the rest and see if we can remove
> > > mem_cgroup pointer
> > > 
> > 
> > You can't use flags field to store mem_cgroup_id while we use lock bit on it.
> > We have to store something more stable...as pfn or node-id or zone-id.
> > 
> > It's very racy. 
> >
> 
> Yes, correct it is racy, there is no easy way from what I know we can write
> the upper 16 bits of the flag without affecting the lower 16 bits, if
> the 16 bits are changing. One of the techniques could be to have lock
> for the unsigned long word itself - but I don't know what performance
> overhead that would add. Having said that I would like to explore
> techniques that allow me to merge the two.
> 

to store pfn, we need to limit under 12bit.
I'll schedule my patch if dirty_ratio one goes.

Thanks,
-Kame



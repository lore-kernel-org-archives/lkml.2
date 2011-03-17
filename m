Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab1CQG0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 02:26:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43013 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab1CQG0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 02:26:14 -0400
Date: Thu, 17 Mar 2011 07:26:12 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Check whether pages are poisoned before copying
Message-ID: <20110317062612.GE11094@one.firstfloor.org>
References: <4D817234.9070106@jp.fujitsu.com> <4D8172D7.3040201@jp.fujitsu.com> <20110317041424.GD11094@one.firstfloor.org> <4D819A2A.8050606@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D819A2A.8050606@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 02:20:42PM +0900, Hidetoshi Seto wrote:
> (2011/03/17 13:14), Andi Kleen wrote:
> > On Thu, Mar 17, 2011 at 11:32:55AM +0900, Hidetoshi Seto wrote:
> >> So to avoid the above problem, add poison checks for both of 4K pages
> >> and the THP before copying in __collapse_huge_page_copy().
> > 
> > I don't think you need the check for the huge page -- it should not be allocated
> > in this case.
> 
> Is there no case that the THP is once allocated but poison flag
> is set before copy?  Though I know it is one of corner cases,
> having this check for THP is worse than nothing.

There's a theoretical window, but it's only a few instructions.
Probably not worth caring about, especially since you have a similar
window after your check again.

BTW normally I don't recommend to add new poison checks without
doing new studies with page-types if the case is likely and happens
with enough memory.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

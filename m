Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab0CYJMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 05:12:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35116 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab0CYJMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 05:12:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 25 Mar 2010 18:08:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 02/11] mm,migration: Do not try to migrate unmapped
 anonymous pages
Message-Id: <20100325180846.c6ded3ab.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100325180726.6C89.A69D9226@jp.fujitsu.com>
References: <20100325083235.GF2024@csn.ul.ie>
	<20100325180221.e1d9bae7.kamezawa.hiroyu@jp.fujitsu.com>
	<20100325180726.6C89.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010 18:09:34 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > On Thu, 25 Mar 2010 08:32:35 +0000
> > Mel Gorman <mel@csn.ul.ie> wrote:

> >  IIUC, the race in memory-hotunplug was fixed by this patch [2/11].
> > 
> >  But, this behavior of unmap_and_move() requires access to _freed_
> >  objects (spinlock). Even if it's safe because of SLAB_DESTROY_BY_RCU,
> >  it't not good habit in general.
> > 
> >  After direct compaction, page-migration will be one of "core" code of
> >  memory management. Then, I agree to patch [1/11] as our direction for
> >  keeping sanity and showing direction to more updates. Maybe adding
> >  refcnt and removing RCU in futuer is good.
> 
> But Christoph seems oppose to remove SLAB_DESTROY_BY_RCU. then refcount
> is meaningless now. I agree you if we will remove SLAB_DESTROY_BY_RCU
> in the future.
> 
removing rcu_read_lock/unlock in unmap_and_move() and removing
SLAB_DESTROY_BY_RCU is different story.

Thanks,
-Kame


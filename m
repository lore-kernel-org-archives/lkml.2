Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab0CYCt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 22:49:28 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39551 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab0CYCt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 22:49:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 02/11] mm,migration: Do not try to migrate unmapped anonymous pages
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20100319085949.GQ12388@csn.ul.ie>
References: <20100319152103.876F.A69D9226@jp.fujitsu.com> <20100319085949.GQ12388@csn.ul.ie>
Message-Id: <20100325095349.944E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 25 Mar 2010 11:49:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Mar 19, 2010 at 03:21:41PM +0900, KOSAKI Motohiro wrote:
> > > > then, this logic depend on SLAB_DESTROY_BY_RCU, not refcount.
> > > > So, I think we don't need your [1/11] patch.
> > > > 
> > > > Am I missing something?
> > > > 
> > > 
> > > The refcount is still needed. The anon_vma might be valid, but the
> > > refcount is what ensures that the anon_vma is not freed and reused.
> > 
> > please please why do we need both mechanism. now cristoph is very busy and I am
> > de fact reviewer of page migration and mempolicy code. I really hope to understand
> > your patch.
> 
> As in, why not drop the RCU protection of anon_vma altogeter? Mainly, because I
> think it would be reaching too far for this patchset and it should be done as
> a follow-up. Putting the ref-count everywhere will change the cache-behaviour
> of anon_vma more than I'd like to slip into a patchset like this. Secondly,
> Christoph mentions that SLAB_DESTROY_BY_RCU is used to keep anon_vma cache-hot.
> For these reasons, removing RCU from these paths and adding the refcount
> in others is a patch that should stand on its own.

Hmmm...
I haven't understand your mention because I guess I was wrong.

probably my last question was unclear. I mean,

1) If we still need SLAB_DESTROY_BY_RCU, why do we need to add refcount?
    Which difference is exist between normal page migration and compaction?
2) If we added refcount, which race will solve?

IOW, Is this patch fix old issue or compaction specific issue?




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab0CXVVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 17:21:09 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:36354 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab0CXVVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 17:21:07 -0400
Date: Wed, 24 Mar 2010 16:19:24 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jonathan Corbet <corbet@lwn.net>, Mel Gorman <mel@csn.ul.ie>,
       Andrea Arcangeli <aarcange@redhat.com>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 07/11] Memory compaction core
In-Reply-To: <20100324141400.72479ce6.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1003241617230.16858@router.home>
References: <1269347146-7461-1-git-send-email-mel@csn.ul.ie> <1269347146-7461-8-git-send-email-mel@csn.ul.ie> <20100324133347.9b4b2789.akpm@linux-foundation.org> <20100324145946.372f3f31@bike.lwn.net> <20100324141400.72479ce6.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010, Andrew Morton wrote:

> > ...except that we've seen a fair number of null pointer dereference
> > exploits that have told us something altogether different.  Are we
> > *sure* we don't want to test for null pointers...?
> >
>
> It's hard to see what the test gains us really - the kernel has
> zillions of pointer derefs, any of which could be NULL if we have a
> bug.  Are we more likely to have a bug here than elsewhere?
>
> This one will oops on a plain old read, so it's a bit moot in this
> case.

If the object pointed to is larger than page size and we are
referencing a member with an offset larger than page size later then we
may create an exploit without checks.

But the structure here is certainly smaller than that. So no issue here.




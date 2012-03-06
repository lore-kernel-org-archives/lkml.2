Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab2CFXb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 18:31:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63889 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab2CFXbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 18:31:25 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of rientjes@google.com designates 10.42.145.72 as permitted sender) smtp.mail=rientjes@google.com; dkim=pass header.i=rientjes@google.com
Date: Tue, 6 Mar 2012 15:31:22 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mgorman@suse.de>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miao Xie <miaox@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset: mm: Remove memory barrier damage from the page
 allocator
In-Reply-To: <20120305094411.GD3481@suse.de>
Message-ID: <alpine.DEB.2.00.1203061529480.18656@chino.kir.corp.google.com>
References: <20120302112358.GA3481@suse.de> <alpine.DEB.2.00.1203021018130.15125@router.home> <20120302174349.GB3481@suse.de> <1330723529.11248.237.camel@twins> <alpine.DEB.2.00.1203021540040.18377@chino.kir.corp.google.com> <20120305094411.GD3481@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2012, Mel Gorman wrote:

> > It's very expensive even without memory barriers since the page allocator 
> > wraps itself in {get,put}_mems_allowed() until a page or NULL is returned 
> > and an update to current's set of allowed mems can stall indefinitely 
> > trying to change the nodemask during this time. 
> 
> Hmm, this sounds problematic. Are you seeing a problem with the behaviour
> with the patch applied or the existing behaviour?
> 

Sorry, yes, this is with the existing behavior prior to your patch.  We 
definitely need fixes for get_mems_allowed() because it's possible that a 
write to cpuset.mems will never return even when trying to add nodes to 
its nodemask in oom conditions if one of the cpuset's tasks is looping 
forever in the page allocator.

I'll review your updated version posted from today.

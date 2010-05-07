Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791Ab0EGBo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 21:44:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750845Ab0EGBo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 21:44:26 -0400
Date: Thu, 6 May 2010 18:40:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] mm,migration: Fix race between shift_arg_pages and
 rmap_walk by guaranteeing rmap_walk finds PTEs created within the temporary
 stack
In-Reply-To: <1273188053-26029-3-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.LFD.2.00.1005061836110.901@i5.linux-foundation.org>
References: <1273188053-26029-1-git-send-email-mel@csn.ul.ie> <1273188053-26029-3-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 7 May 2010, Mel Gorman wrote:
> 
> Page migration requires rmap to be able to find all migration ptes
> created by migration. If the second rmap_walk clearing migration PTEs
> misses an entry, it is left dangling causing a BUG_ON to trigger during
> fault. For example;

So I still absolutely detest this patch.

Why didn't the other - much simpler - patch work? The one Rik pointed to:

	http://lkml.org/lkml/2010/4/30/198

and didn't do that _disgusting_ temporary anon_vma?

Alternatively, why don't we just take the anon_vma lock over this region, 
so that rmap can't _walk_ the damn thing?

			Linus

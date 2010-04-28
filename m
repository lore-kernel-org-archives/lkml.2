Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab0D1Ppu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 11:45:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349Ab0D1Ppt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 11:45:49 -0400
Date: Wed, 28 Apr 2010 17:45:08 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] Fix migration races in rmap_walk() V2
Message-ID: <20100428154508.GT510@random.random>
References: <1272403852-10479-1-git-send-email-mel@csn.ul.ie>
 <alpine.DEB.2.00.1004271723090.24133@router.home>
 <20100427223242.GG8860@random.random>
 <20100428091345.496ca4c4.kamezawa.hiroyu@jp.fujitsu.com>
 <20100428002056.GH510@random.random>
 <20100428142356.GF15815@csn.ul.ie>
 <20100428145737.GG15815@csn.ul.ie>
 <20100428151614.GQ510@random.random>
 <20100428152354.GH15815@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428152354.GH15815@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 04:23:54PM +0100, Mel Gorman wrote:
> Is it possible to delay the linkage like that? As arguments get copied into
> the temporary stack before it gets moved, I'd have expected the normal fault
> path to prepare and attach the anon_vma. We could special case it but
> that isn't very palatable either.

I'm not sure what is more palatable, but I feel it should be fixed in
execve.

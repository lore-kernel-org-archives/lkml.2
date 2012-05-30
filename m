Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab2E3TtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 15:49:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48441 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab2E3TtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 15:49:03 -0400
Date: Wed, 30 May 2012 21:48:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <cl@linux.com>
Cc: kosaki.motohiro@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@google.com>,
        Dave Jones <davej@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org,
        hughd@google.com, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, andi@firstfloor.org
Subject: Re: [PATCH 2/6] mempolicy: Kill all mempolicy sharing
Message-ID: <20120530194858.GW27374@one.firstfloor.org>
References: <1338368529-21784-1-git-send-email-kosaki.motohiro@gmail.com> <1338368529-21784-3-git-send-email-kosaki.motohiro@gmail.com> <alpine.DEB.2.00.1205301439410.31768@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205301439410.31768@router.home>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 02:41:22PM -0500, Christoph Lameter wrote:
> On Wed, 30 May 2012, kosaki.motohiro@gmail.com wrote:
> 
> > refcount will be decreased even though was not increased whenever alloc_page_vma()
> > is called. As you know, mere mbind(MPOL_MF_MOVE) calls alloc_page_vma().
> 
> Most of these issues are about memory migration and shared memory. If we
> exempt shared memory from memory migration (after all that shared memory
> has its own distinct memory policies already!) then a lot of these issues
> wont arise.

Soft memory offlining needs migration. It's fairly important that this
works: on the database systems most memory is in shared memory and they
have a lot of memory, so predictive failure analysis and soft offlining
helps a lot.

Classic migration is probably not too important here, but they pretty
much rely on the same low level mechanism.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab2HTTfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:35:18 -0400
Received: from a194-183.smtp-out.amazonses.com ([199.255.194.183]:14488 "EHLO
	a194-183.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751691Ab2HTTfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:35:15 -0400
Date: Mon, 20 Aug 2012 19:35:14 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Jones <davej@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 2/5] mempolicy: Remove mempolicy sharing
In-Reply-To: <1345480594-27032-3-git-send-email-mgorman@suse.de>
Message-ID: <00000139458826d2-f72fceae-338d-4f6c-84f3-67d8817ece99-000000@email.amazonses.com>
References: <1345480594-27032-1-git-send-email-mgorman@suse.de> <1345480594-27032-3-git-send-email-mgorman@suse.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2012, Mel Gorman wrote:

> Ideally, the shared policy handling would be rewritten to either properly
> handle COW of the policy structures or at least reference count MPOL_F_SHARED
> based exclusively on information within the policy.  However, this patch takes
> the easier approach of disabling any policy sharing between VMAs. Each new
> range allocated with sp_alloc will allocate a new policy, set the reference
> count to 1 and drop the reference count of the old policy. This increases
> the memory footprint but is not expected to be a major problem as mbind()
> is unlikely to be used for fine-grained ranges. It is also inefficient
> because it means we allocate a new policy even in cases where mbind_range()
> could use the new_policy passed to it. However, it is more straight-forward
> and the change should be invisible to the user.


Hmmm. I dont like the additional memory use but this is definitely an
issue that needs addressing.

Reviewed-by: Christoph Lameter <cl@linux.com>

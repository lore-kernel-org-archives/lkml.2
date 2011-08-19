Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab1HSHtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 03:49:33 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45697 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab1HSHs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 03:48:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:date:message-id:x-mailer:
	in-reply-to:references:x-system-of-record;
	b=BolYAgC2617YmziwLMax/nXIpHj8KuxoYMdIp5HLlofGZ1/mFrab66zVZoIPEVKIU
	nYCW1P2x/API/+mOEjq6A==
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Andrea Arcangeli <aarcange@redhat.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>
Subject: [PATCH 5/9] kvm: use get_page instead of get_page_unless_zero
Date: Fri, 19 Aug 2011 00:48:27 -0700
Message-Id: <1313740111-27446-6-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1313740111-27446-1-git-send-email-walken@google.com>
References: <1313740111-27446-1-git-send-email-walken@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In transparent_hugepage_adjust(), we can use get_page instead of
get_page_unless_zero and an assertion that the count was not zero.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 arch/x86/kvm/mmu.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index aee3862..d9b7f0c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2353,8 +2353,7 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
 			*gfnp = gfn;
 			kvm_release_pfn_clean(pfn);
 			pfn &= ~mask;
-			if (!get_page_unless_zero(pfn_to_page(pfn)))
-				BUG();
+			get_page(pfn_to_page(pfn));
 			*pfnp = pfn;
 		}
 	}
-- 
1.7.3.1


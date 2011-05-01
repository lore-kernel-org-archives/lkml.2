Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761246Ab1EAQyN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 12:54:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50363 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761221Ab1EAQyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 12:54:08 -0400
Date: Sun, 1 May 2011 18:53:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH tip:x86/urgent] x86, NUMA: Fix empty memblk detection in
 numa_cleanup_meminfo()
Message-ID: <20110501165354.GC21833@elte.hu>
References: <20110501104555.GN29280@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110501104555.GN29280@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> From: Yinghai Lu <yinghai@kernel.org>
> 
> numa_cleanup_meminfo() trims each memblk between low (0) and high
> (max_pfn) limits and discards empty ones.  However, the emptiness
> detection incorrectly used equality test.  If the start of a memblk is
> higher than max_pfn, it is empty but fails the equality test and
> doesn't get discarded.
> 
> Fix it by using >= instead of ==.
> 
> tj: Extracted the actual fix from the original patch and rewrote patch
>     description.

Well, the bit still missing from the description is why this fix matters for 
x86/urgent: under what scenarios does this cause problems, how frequent is it, 
how severe are the prolems, etc. etc. Would be nice to have something about 
that in the changelog as well.

Thanks,

	Ingo

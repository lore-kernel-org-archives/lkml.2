Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab1BNCiY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 21:38:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:5538 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab1BNCiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 21:38:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,466,1291622400"; 
   d="scan'208";a="887160607"
Subject: Re: [PATCH 0/4]x86: allocate up to 32 tlb invalidate vectors
 -resend
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <1295232719.1949.706.camel@sli10-conroe>
References: <1295232719.1949.706.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 10:38:18 +0800
Message-ID: <1297651098.24560.0.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-17 at 10:51 +0800, Shaohua Li wrote:
> last post is lost, resent.
> 
> Hi,
> In workload with heavy page reclaim, flush_tlb_page() is frequently
> used. We currently have 8 vectors for tlb flush, which is fine for small
> machines. But for big machines with a lot of CPUs, the 8 vectors are
> shared by all CPUs and we need lock to protect them. This will cause a
> lot of lock contentions. please see the patch 3 for detailed number of
> the lock contention.
> Andi Kleen suggests we can use 32 vectors for tlb flush, which should be
> fine for even 8 socket machines. Test shows this reduces lock contention
> dramatically (see patch 3 for number).
> One might argue if this will waste too many vectors and leave less
> vectors for devices. This could be a problem. But even we use 32
> vectors, we still leave 78 vectors for devices. And we now have per-cpu
> vector, vector isn't scarce any more, but I'm open if anybody has
> objections.
any comments on this patch set?

Thanks,
Shaohua



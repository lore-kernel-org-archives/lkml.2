Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954Ab0KOOCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 09:02:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:59921 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756619Ab0KOOCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 09:02:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,200,1288594800"; 
   d="scan'208";a="857688452"
Subject: Re: [RFC 0/4]x86: allocate up to 32 tlb invalidate vectors
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        "hpa@zytor.com" <hpa@zytor.com>
In-Reply-To: <1288766655.23014.113.camel@sli10-conroe>
References: <1288766655.23014.113.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 22:02:45 +0800
Message-ID: <1289829765.14740.2.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-03 at 14:44 +0800, Shaohua Li wrote:
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
> 
Hi Ingo & hpa, any comments about this series?

Thanks,
Shaohua


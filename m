Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab0KCGoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 02:44:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:19688 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712Ab0KCGoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 02:44:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,287,1286175600"; 
   d="scan'208";a="343954152"
Subject: [RFC 0/4]x86: allocate up to 32 tlb invalidate vectors
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 14:44:15 +0800
Message-ID: <1288766655.23014.113.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
In workload with heavy page reclaim, flush_tlb_page() is frequently
used. We currently have 8 vectors for tlb flush, which is fine for small
machines. But for big machines with a lot of CPUs, the 8 vectors are
shared by all CPUs and we need lock to protect them. This will cause a
lot of lock contentions. please see the patch 3 for detailed number of
the lock contention.
Andi Kleen suggests we can use 32 vectors for tlb flush, which should be
fine for even 8 socket machines. Test shows this reduces lock contention
dramatically (see patch 3 for number).
One might argue if this will waste too many vectors and leave less
vectors for devices. This could be a problem. But even we use 32
vectors, we still leave 78 vectors for devices. And we now have per-cpu
vector, vector isn't scarce any more, but I'm open if anybody has
objections.

Thanks,
Shaohua


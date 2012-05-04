Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760702Ab2EDXwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 19:52:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:30340 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758151Ab2EDXwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 19:52:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="139103666"
Subject: RE: [PATCH] sched: Enable arch-specific asym packing option in
 sched domain
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Diwakar Tundlam <dtundlam@nvidia.com>
Cc: "'Peter Zijlstra'" <a.p.zijlstra@chello.nl>,
        "'Ingo Molnar'" <mingo@kernel.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Christoph Lameter'" <cl@gentwo.org>,
        "'Michael Neuling'" <mikey@neuling.org>,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        "'David Rientjes'" <rientjes@google.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Date: Fri, 04 May 2012 16:55:18 -0700
In-Reply-To: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF103@HQMAIL04.nvidia.com>
References: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF0FF@HQMAIL04.nvidia.com>
	 <1DD7BFEDD3147247B1355BEFEFE46652379C3DF101@HQMAIL04.nvidia.com>
	 <1336169422.16236.1.camel@twins>
	 <1DD7BFEDD3147247B1355BEFEFE46652379C3DF102@HQMAIL04.nvidia.com>
	 <1336170586.16236.11.camel@twins>
	 <1DD7BFEDD3147247B1355BEFEFE46652379C3DF103@HQMAIL04.nvidia.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1336175718.16162.16.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-04 at 16:18 -0700, Diwakar Tundlam wrote:
> Yes, this is for Nvidia's ARM Quad-core Tegra CPU. It is a single package, organized flatly.
> To save power, we want cores to be loaded up in order from cpu0, 1, etc.
> The ASYM_PACKING flag seems to do exactly what we need if set in the domain flag.

Diwakar, But ASYM_PACKING will lead to more task migrations and also it
relies on the periodic load balancing to correct it.

Perhaps we should expose this info more natively and prefer the lower
siblings during task wakeup etc. And perhaps be more aggressive in
moving the load to lower siblings etc.

Can you elaborate more about the power-saving scenario and what causes
the power-savings etc to better understand the problem.

thanks,
suresh





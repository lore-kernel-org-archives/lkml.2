Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab0GZJkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 05:40:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:44297 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321Ab0GZJkc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 05:40:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,261,1278313200"; 
   d="scan'208";a="821599872"
From: "Kleen, Andi" <andi.kleen@intel.com>
To: Oleg Nesterov <oleg@redhat.com>,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: Roland McGrath <roland@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Date: Mon, 26 Jul 2010 10:40:28 +0100
Subject: RE: [PATCH] Don't apply for write lock on tasklist_lock if parent
	doesn't ptrace other processes
Thread-Topic: [PATCH] Don't apply for write lock on tasklist_lock if parent
	doesn't ptrace other processes
Thread-Index: AcssoFYm4cL2PsnYTYuKsDofZ5zWbAABh1Lg
Message-ID: <F4DF93C7785E2549970341072BC32CD752CEF3E4@irsmsx503.ger.corp.intel.com>
References: <1279176663.2096.1264.camel@ymzhang.sh.intel.com>
 <20100721144944.5351c741.akpm@linux-foundation.org>
 <20100721222529.EFBAA400B6@magilla.sf.frob.com>
 <20100722090524.GA6647@redhat.com>
 <1279874705.2096.1274.camel@ymzhang.sh.intel.com>
 <20100723173453.GA29831@redhat.com>
 <1280120732.2085.3.camel@ymzhang.sh.intel.com>
 <20100726085324.GA32223@redhat.com>
In-Reply-To: <20100726085324.GA32223@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The only difference is that we are doing the function call +
> list_empty()
> under tasklist, just a few instructions compared to "do a lot more
> work"
> in forget_original_parent().
> 
> How this can make the 2% difference ? This looks like a noise to me,
> or do you think I missed something?

It could be a cache miss or something like that. Instructions are not
all the same cost. Only detailed profiling with different performance counters
could give you more information.

-Andi


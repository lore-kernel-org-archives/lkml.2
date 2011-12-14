Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab1LNTFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 14:05:42 -0500
Received: from mga14.intel.com ([143.182.124.37]:43365 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307Ab1LNTFj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 14:05:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="85741970"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Date: Wed, 14 Dec 2011 11:05:37 -0800
Subject: RE: [PATCH 5/6] x86, mce: handle "action required" errors
Thread-Topic: [PATCH 5/6] x86, mce: handle "action required" errors
Thread-Index: Acy6eg+q69gGjYk5Tt2jdDDMIYQ5eAAF+/8A
Message-ID: <0207C53569FE594381A4F2EB66570B2A019147F182@orsmsx508.amr.corp.intel.com>
References: <cover.1323803130.git.tony.luck@intel.com>
 <80cbf65ae6e4bd610523cc8568b0c2dcb8c629b6.1323803130.git.tony.luck@intel.com>
 <20111214160409.GG23589@aftab>
In-Reply-To: <20111214160409.GG23589@aftab>
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

> > +	if (!mce_find_info(&paddr))
> > +		mce_panic("Lost address", NULL, NULL);
>
> Wouldn't it be good to return struct mce_info *mi here in addition to
> &paddr...

Great idea (actually "instead of" works better than "in addition too").

> so that you don't need to iterate again over the mce_info array but do:
>
>	mce_clear_info(mi);

Just coded it - looks much better. Will send new version soon with
this change, and Ingo's suggestions incorporated.

> This assumes, of course, that you have only one AR MCE per task, per
> return to userspace. I guess this is fine for now.

While we might have multiple memory references in flight at once, we'd
have to be really unlucky to hit multiple 2-bit errors at the same
time (unless there was some system level failure in the memory controller,
in which case we not likely to be able to recover).

In current processor implementations, the recoverable errors are all
reported in just one machine check bank - so we can't actually process
more than one at a time.

-Tony

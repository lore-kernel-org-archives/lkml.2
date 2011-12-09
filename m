Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab1LIWJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 17:09:20 -0500
Received: from mga03.intel.com ([143.182.124.21]:20401 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab1LIWJT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 17:09:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="45746029"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
CC: LKML <linux-kernel@vger.kernel.org>, X86-ML <x86@kernel.org>,
        EDAC devel <linux-edac@vger.kernel.org>
Date: Fri, 9 Dec 2011 14:08:59 -0800
Subject: RE: [PATCH 2/2] x86, MCE: Drain mcelog buffer
Thread-Topic: [PATCH 2/2] x86, MCE: Drain mcelog buffer
Thread-Index: Acy2p1X2jtPHdg6HQa6tKjfBaFC9ogAFrRpA
Message-ID: <0207C53569FE594381A4F2EB66570B2A018EFB7A7D@orsmsx508.amr.corp.intel.com>
References: <1323353332-5671-1-git-send-email-bp@amd64.org>
 <1323353332-5671-3-git-send-email-bp@amd64.org>
 <0207C53569FE594381A4F2EB66570B2A018EFB7762@orsmsx508.amr.corp.intel.com>
 <20111209182448.GA29629@gere.osrc.amd.com>
 <0207C53569FE594381A4F2EB66570B2A018EFB77AE@orsmsx508.amr.corp.intel.com>
 <20111209191819.GA17086@aftab>
In-Reply-To: <20111209191819.GA17086@aftab>
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

> Well, off the top of my head, we could probably _not_ delete the already
> logged MCEs (bool keep arg, or similar) and when the last one registers,
> it passes keep=false and cleans them up. And since we probably know
> which one is the last - order is enforced by the initcalls order -
> we're done.

Knowing when the last one has come is hard if there are modules as well
as built-in registrants.  We could save the whole list, and deliver a
copy of the history of the world so far to each as they register (never
deleting anything). But that sounds odd - why should a module loaded
6 months after system boot expect to see everything.

> However, is the platform module using MCA at all or will it probably use
> PCIe AER instead?
Don't know - its hypothetical - but it is possible that MCA might be used
for not-cpu stuff.

> Also, at the time the platform module inits, we've already regged the
> CPU decoders so we can go ahead and safely delete the logged MCEs.

I think if we ensure that the cpu decoder gets first chance to register,
we should be OK with giving it all the pended stuff. We can defer doing
something more complicated until the point that someone has a real use
case.

-Tony

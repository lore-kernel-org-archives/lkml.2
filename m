Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030278Ab2EKRCs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 13:02:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:37468 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932689Ab2EKRCp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 13:02:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="141951991"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: RE: [PATCH v.23-2] RAS: use tracepoint to handle hw issues
Thread-Topic: [PATCH v.23-2] RAS: use tracepoint to handle hw issues
Thread-Index: AQHNL4YeaA7E6BnMIESUIXda6cSFE5bEyvFw
Date: Fri, 11 May 2012 17:02:43 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F192ED5D3@ORSMSX104.amr.corp.intel.com>
References: <1336683628-12954-1-git-send-email-mchehab@redhat.com>
 <1336748054-21325-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1336748054-21325-1-git-send-email-mchehab@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For example:
>
> mc_event: Corrected error:memory read on memory stick "DIMM_1A" (mc:0 channel:0 slot:0 page:0x586b6e offset:0xa66 grain:32 syndrome:0x0 area:DMA)

This is looking so much better.

I looked through your examples from drivers on what text we might see
in the "memory read" position ... and agree that it would be a lot of
work to make them all come up with grammatically clean messages, especially
for all the poorly documented (or undocumented) "default/unknown/..." cases.

Back to my "does the casual user really need to know" soapbox. What different
actions do we expect a user to take when we tell them "read error" or "write
error" or "unknown error"?  I'm beginning to think that this belongs inside
the brackets! Perhaps as:  type:"memory read"?

Then we'd have:

mc_event: Corrected error on memory stick "DIMM_1A" (bunch of stuff for deep diagnosis by vendor)

Knowing that the error was Corrected/Uncorrected is vital to the user. It lets them know
the urgency with which they need to take action ... we need to educate them that a few
"Corrected" errors are perfectly normal and nothing to raise blood pressure about.

Knowing which memory stick was involved - also very important. If they do take action,
they should be able to swap out the memory stick that was the source of the problem.

Everything else is just for memory geeks like me, you and Boris (and OEMs who want to
diagnose root cause of problems they see by pattern analysis across errors from multiple
machines with DIMMS from different batches/vendors).

-Tony

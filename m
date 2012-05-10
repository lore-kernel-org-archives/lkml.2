Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711Ab2EJWh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 18:37:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:27269 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757002Ab2EJWhz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 18:37:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="139276660"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: RE: [PATCH v22] edac, ras/hw_event.h: use events to handle hw issues
Thread-Topic: [PATCH v22] edac, ras/hw_event.h: use events to handle hw
 issues
Thread-Index: AQHNLucGAM9WTwKCAkugBSt4/JhDM5bD8d8A//+OUNCAAIoHgP//jH7w
Date: Thu, 10 May 2012 22:37:53 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F192EC247@ORSMSX104.amr.corp.intel.com>
References: <1336679788-4982-1-git-send-email-mchehab@redhat.com>
 <20120510204042.GA4598@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192EC1A2@ORSMSX104.amr.corp.intel.com>
 <4FAC3C35.70101@redhat.com>
In-Reply-To: <4FAC3C35.70101@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

     kworker/u:6-201   [007] .N..   186.197280: mc_error: [Hardware Error]: mem_ctl#0: Corrected error memory read error on memory stick "DIMM_A1" (channel:0 slot:1  page:0x2f1eb3 offset:0x446 grain:32 syndrome:0x0 1 error(s): Unknown: Err=0001:0090 socket=0 channel=0/mask=1 rank=5)
     
The word "error" appears *five* times on this line (once with a capital E).
I feel beaten, bruised and ready to give up on this machine with just one
actual error reported :-)

We could get rid of one by:
 s/Corrected error memory read error/Corrected memory read error/

(though we'd need to see if things still read well for all other "msg" options.

Or perhaps it could say:
   ... Corrected error: memory read on memory stick ...
or even:
   ... Corrected error: read on memory stick ...

This part could get shortened too:
   mc_error: [Hardware Error]:
will mc_error ever report something that isn't a "Hardware Error"?
I don't think we have to preserve this legacy string when moving
to a new reporting mechanism.


> There are still some space to improve the fields provided by the drivers.
Apart from reporting "channel" twice, that doesn't look too bad. Maybe
the "1 error(s)" could say "count: 1"?

-Tony


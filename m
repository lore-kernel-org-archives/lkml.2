Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966033Ab2FAXTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 19:19:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:8233 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965953Ab2FAXTT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 19:19:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="159721094"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, "Chen, Gong" <gong.chen@intel.com>
Subject: RE: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
Thread-Topic: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
Thread-Index: AQHNOZYGtI1DcNZxtEGCK0mbRpqc+pbZOc0AgABYoYCAAAkdAIAAFPOAgAd2gYCAACJ1AIAADiKAgAAIj4CAAZ5vgIABK+aAgAAJUICAAB0igIAAG5oAgAAHRYCAAAZIAIAAApkAgAAB+ICAAAOVAIAAENkAgAAQiYCAACboAIAAApWAgAAIOQCAAAHrAP//kZqggAFGGgD//+9NkIAAg10A//+uljAAGNEXgAAORO2A
Date: Fri, 1 Jun 2012 23:19:17 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F192F76FF@ORSMSX104.amr.corp.intel.com>
References: <20120531171337.GN14515@aftab.osrc.amd.com>
 <1338492772.13348.388.camel@gandalf.stny.rr.com>
 <20120531194207.GC16998@aftab.osrc.amd.com>
 <1338495092.13348.419.camel@gandalf.stny.rr.com>
 <20120531201824.GD16998@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192F6DE2@ORSMSX104.amr.corp.intel.com>
 <20120601091026.GC20959@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192F71DB@ORSMSX104.amr.corp.intel.com>
 <20120601160050.GE28216@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192F74E1@ORSMSX104.amr.corp.intel.com>
 <20120601230001.GE30418@aftab.osrc.amd.com>
In-Reply-To: <20120601230001.GE30418@aftab.osrc.amd.com>
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

> Uuh, that doesn't sound good. Can't you guys make the CMCI run on one
> CPU only? I mean, it is a single CECC, no need to stop all cores on the
> socket for it, right?
>
> Arguably, it'll be best if the core that sees the CECC fires the CMCI
> too and the others continue on their merry way.

That would be best ... but life is more complicated. We can get CMCI for
some processor errors where the error will be logged in a per-core bank,
but for some reason it is hard to have just the threads on that core see
the CMCI. So we just use a shotgun to blast everything standing in the
general direction of the error - so that the one (or two) cpus that can
actually see the error will get the message.  In the normal case when
there is a very low rate of errors, this doesn't do much harm. But it makes
the storm situation when there are many errors a whole lot worse (20x
worse for Westmere with 10 cores * 2 threads).

-Tony 

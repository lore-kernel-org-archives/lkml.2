Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933588Ab2FASXC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 14:23:02 -0400
Received: from mga03.intel.com ([143.182.124.21]:24398 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932410Ab2FASXA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 14:23:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="106799973"
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
Thread-Index: AQHNOZYGtI1DcNZxtEGCK0mbRpqc+pbZOc0AgABYoYCAAAkdAIAAFPOAgAd2gYCAACJ1AIAADiKAgAAIj4CAAZ5vgIABK+aAgAAJUICAAB0igIAAG5oAgAAHRYCAAAZIAIAAApkAgAAB+ICAAAOVAIAAENkAgAAQiYCAACboAIAAApWAgAAIOQCAAAHrAP//kZqggAFGGgD//+9NkIAAg10A//+uljA=
Date: Fri, 1 Jun 2012 18:21:29 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F192F74E1@ORSMSX104.amr.corp.intel.com>
References: <20120531151408.GJ14515@aftab.osrc.amd.com>
 <4FC798E2.4000402@redhat.com> <20120531171337.GN14515@aftab.osrc.amd.com>
 <1338492772.13348.388.camel@gandalf.stny.rr.com>
 <20120531194207.GC16998@aftab.osrc.amd.com>
 <1338495092.13348.419.camel@gandalf.stny.rr.com>
 <20120531201824.GD16998@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192F6DE2@ORSMSX104.amr.corp.intel.com>
 <20120601091026.GC20959@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192F71DB@ORSMSX104.amr.corp.intel.com>
 <20120601160050.GE28216@aftab.osrc.amd.com>
In-Reply-To: <20120601160050.GE28216@aftab.osrc.amd.com>
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

> This is why I'm advocating the userspace - you can implement almost
> anything there - we only need the kernel to be as thin and as fast when
> reporting those errors so that we can have the most reliable and full
> info as possible. The kernel's job is only to report as many errors
> as it possibly can so that userspace can create a good picture of the
> situation.

I'm with you on this. Userspace is the right place to analyze and set
policy for actions.

But we need to make sure that user space can actually run. That's the
motivation behind the CMCI disable patches. Since Intel broadcasts CMCI
to all cpus on a socket - a CMCI storm on a single socket machine will
stop any user code from running.

I'd make one small change to what you said:

The kernel's job is to report enough error information that user space
can make an accurate assessment of the source of the error.

I.e. "enough" is less than "as many errors as it possibly can".

-Tony

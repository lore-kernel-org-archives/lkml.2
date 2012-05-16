Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966060Ab2EPU13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 16:27:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:44679 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965840Ab2EPU11 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 16:27:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="144065288"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>, Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: RE: [PATCH v22] edac, ras/hw_event.h: use events to handle hw issues
Thread-Topic: [PATCH v22] edac, ras/hw_event.h: use events to handle hw
 issues
Thread-Index: AQHNLucGAM9WTwKCAkugBSt4/JhDM5bD8d8A//+OUNCAAIoHgP//jH7wgACxNwCAAJBjgIAAJPoAgABQGwCAABS1gIAEYecAgAAO1YCAAZ5KgIAAD5sAgAAJQYCAATnRgIAAIBUAgAAhboCAAAiJAIAAEjiAgAA0Y4D//45dUA==
Date: Wed, 16 May 2012 20:27:24 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F192EFA27@ORSMSX104.amr.corp.intel.com>
References: <20120514133404.GE4231@aftab.osrc.amd.com>
 <4FB1163D.3010302@redhat.com> <20120515150957.GC27806@aftab.osrc.amd.com>
 <4FB27EDC.8040001@redhat.com> <20120515163855.GE27806@aftab.osrc.amd.com>
 <4FB38DDF.7030009@redhat.com> <20120516131656.GA2202@aftab.osrc.amd.com>
 <4FB3C4D3.7000802@redhat.com> <20120516154708.GC2202@aftab.osrc.amd.com>
 <4FB3DB45.4060101@redhat.com> <20120516195951.GA5326@aftab.osrc.amd.com>
In-Reply-To: <20120516195951.GA5326@aftab.osrc.amd.com>
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

> No, userspace will be doing parsing because it is the only sensible
> thing to do. The kernel's job is to carry out enough information for
> the user to handle the error in a way which is just enough. No more, no
> less. It is in no f*cking way expected to make it pretty and in suitable
> portions so that userspace can consume it.

My requirement on prettiness was just that the information useful
to a normal system owner come first. Enough to know how serious the
problem is, and which component is affected. The fine details must
be in the "( ... )" part - and will generally only be of interest
to very sophisticated users.

We've reached that goal.

Looking at the next part ... which is how to write useful analysis
tools that study these logs. We have some common elements in trace
records - but a there is (deliberately) plenty of scope for drivers
to add their own customizations. If these bits are going to be
used by the user mode tools - then they will have per-driver
parsing code that will be tightly linked to the version of the driver.

Are we happy with this? Once the patch goes it, we have created an
ABI which will be hard to change.

-Tony

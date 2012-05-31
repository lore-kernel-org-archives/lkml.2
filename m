Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab2EaUwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 16:52:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:7290 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201Ab2EaUww convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 16:52:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="106445235"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>, Steven Rostedt <rostedt@goodmis.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: RE: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
Thread-Topic: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
Thread-Index: AQHNOZYGtI1DcNZxtEGCK0mbRpqc+pbZOc0AgABYoYCAAAkdAIAAFPOAgAd2gYCAACJ1AIAADiKAgAAIj4CAAZ5vgIABK+aAgAAJUICAAB0igIAAG5oAgAAHRYCAAAZIAIAAApkAgAAB+ICAAAOVAIAAENkAgAAQiYCAACboAIAAApWAgAAIOQCAAAHrAP//kZqg
Date: Thu, 31 May 2012 20:52:21 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F192F6DE2@ORSMSX104.amr.corp.intel.com>
References: <20120531142229.GF14515@aftab.osrc.amd.com>
 <4FC783EA.80704@redhat.com> <20120531145416.GI14515@aftab.osrc.amd.com>
 <4FC787BF.3020006@redhat.com> <20120531151408.GJ14515@aftab.osrc.amd.com>
 <4FC798E2.4000402@redhat.com> <20120531171337.GN14515@aftab.osrc.amd.com>
 <1338492772.13348.388.camel@gandalf.stny.rr.com>
 <20120531194207.GC16998@aftab.osrc.amd.com>
 <1338495092.13348.419.camel@gandalf.stny.rr.com>
 <20120531201824.GD16998@aftab.osrc.amd.com>
In-Reply-To: <20120531201824.GD16998@aftab.osrc.amd.com>
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

> It could be very quiet (i.e., machine runs with no errors) and it could
> have bursts where it reports a large number of errors back-to-back
> depending on access patterns, DIMM health, temperature, sea level and at
> least a bunch more factors.

Yes - the normal case is a few errors from stray neutrons ...  perhaps
a few per month, maybe on a very big system a few per hour.  When something
breaks, especially if it affects a wide range of memory addresses, then
you will see a storm of errors.

> So I can imagine buffers filling up suddenly and fast, and userspace
> having hard time consuming them in a timely manner.

But I'm wondering what agent is going to be reporting all these
errors.  Intel has CMCI - so you can get a storm of interrupts
which would each generate a trace record ... but we are working
on a patch to turn off CMCI if a storm is detected. AMD doesn't
have CMCI, so errors just report from polling - and we have a
maximum poll rate which is quite low by trace standards (even
when multiplied by NR_CPUS).

Will EDAC drivers loop over some chipset registers blasting
out huge numbers of trace records ... that seems just as bad
for system throughput as a CMCI storm. And just as useless.

General principle: If there are very few errors happening then
it is important to log every single one of them.  If there are
so many that we can't keep up, then we must sample at some level,
and we might as well do that at generation point.

-Tony

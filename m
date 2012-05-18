Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440Ab2ERTKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 15:10:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:7382 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758716Ab2ERTKo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 15:10:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="142186783"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>, Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: RE: [PATCH v24b] RAS: Add a tracepoint for reporting memory
 controller events
Thread-Topic: [PATCH v24b] RAS: Add a tracepoint for reporting memory
 controller events
Thread-Index: AQHNNHP7b1UvI8JPs0uFG6MbkxJ3NJbO+iuAgACdgwCAAC3LAIAAEa6AgAAc+wCAAAsugIAAC6aAgAAHYgCAACPlAIAADRwAgAAX+QD//4uwYA==
Date: Fri, 18 May 2012 19:10:42 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F192F1A33@ORSMSX104.amr.corp.intel.com>
References: <20120517214859.GA16777@aftab.osrc.amd.com>
 <20120518071244.GE429@gmail.com> <20120518095638.GA20215@aftab.osrc.amd.com>
 <4FB62BAB.90808@redhat.com> <20120518124338.GJ20215@aftab.osrc.amd.com>
 <4FB64D5B.1030301@redhat.com> <20120518140521.GM20215@aftab.osrc.amd.com>
 <4FB65D52.9060108@redhat.com> <20120518164014.GX20215@aftab.osrc.amd.com>
 <4FB6866E.7090503@redhat.com> <20120518185258.GE20215@aftab.osrc.amd.com>
In-Reply-To: <20120518185258.GE20215@aftab.osrc.amd.com>
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

> That's why _each_ _driver_ will have its format and the userspace tools
> parsing it will know about it!

Sounds like a full employment program for parser writers.

There are some interesting fields that should be common to all
drivers ... so have twenty parsers that can handle:

	paddr: 0x1234
	PADDR: 0x1234
	Paddr = 0x1234
	Phys = 1234
	addr: 0x1234
	Address: 0x000000001234

looks like a lot of make-work ... when the OS can standardize in the ABI
that there is a 64-bit binary value that is the physical address of the
error (and another 64-bit mask saying which, if any, bits are valid).

So we should be looking for the set of always relevant values that can
be kept explicitly separate in fields in TP_PROTO, and per-driver specific
stuff (grain/syndrome??) bits that will have to go into the "details"
string and require some driver specific user-mode parsing to use.

-Tony

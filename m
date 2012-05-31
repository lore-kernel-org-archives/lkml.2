Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab2EaRC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 13:02:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:22939 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564Ab2EaRC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 13:02:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="106354288"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: RE: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
Thread-Topic: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
Thread-Index: AQHNOZYGtI1DcNZxtEGCK0mbRpqc+pbZOc0AgABYoYCAAAkdAIAAFPOAgAd2gYCAACJ1AIAADiKAgAAIj4CAAZ5vgIABK+aA///7NhA=
Date: Thu, 31 May 2012 16:51:27 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F192F6C61@ORSMSX104.amr.corp.intel.com>
References: <1337854460-25191-1-git-send-email-mchehab@redhat.com>
 <20120524105604.GC27063@aftab.osrc.amd.com> <4FBE5E1D.7070804@redhat.com>
 <20120524164554.GM27063@aftab.osrc.amd.com> <4FBE7755.2080301@redhat.com>
 <20120529115851.GB29157@aftab.osrc.amd.com> <4FC4D6E2.9060501@redhat.com>
 <20120529145245.GG29157@aftab.osrc.amd.com> <4FC4E9EB.5030801@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F192F6672@ORSMSX104.amr.corp.intel.com>
 <20120531100005.GC14074@aftab.osrc.amd.com>
In-Reply-To: <20120531100005.GC14074@aftab.osrc.amd.com>
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

>>                         u8 shift = MCI_MISC_ADDR_LSB(m->misc);
>>                         m->addr >>= shift;
>>                         m->addr <<= shift;
>
> That's 64 bytes max, IIRC.

No, it's a 6-bit field used as a shift ... so if it has value "6", it means
cache line granularity. Value "12" would mean 4K granularity. Architecturally
it could say "30" to mean gigabyte, or even "63" to mean "everything is gone".

>> while a few (IIRC patrol scrub) will report with page (4K)
>> granularity. Linux doesn't really care - they all have to get rounded
>> up to page size because we can't take away just one cache line from a
>> process.
>
> I'd like to see that :-)

Patrol scrub works inside the depths of the memory controller on rank/row
addresses, not on system physical addresses. When it finds a problem, a
reverse translation is needed to be able to report a system physical
address in MCi_ADDR. Getting all the bits right is apparently a hard thing
to do, so the MCI_MISC_ADDR_LSB bits are used to indicate that some low
order bits are not valid.

-Tony

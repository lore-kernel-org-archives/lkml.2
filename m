Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831Ab1FXQqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 12:46:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:39791 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216Ab1FXQqb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 12:46:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,420,1304319600"; 
   d="scan'208";a="20266723"
From: "Luck, Tony" <tony.luck@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Rick van Rein <rick@vanrein.org>
CC: Craig Bergstrom <craigb@google.com>, Andi Kleen <andi@firstfloor.org>,
        Stefan Assmann <sassmann@kpanic.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>
Date: Fri, 24 Jun 2011 09:40:51 -0700
Subject: RE: [PATCH v2 0/3] support for broken memory modules (BadRAM)
Thread-Topic: [PATCH v2 0/3] support for broken memory modules (BadRAM)
Thread-Index: AcwyihoyDT7BYO++QVCsCEAGR7byBAAAMIeA
Message-ID: <987664A83D2D224EAE907B061CE93D5301E942ED99@orsmsx505.amr.corp.intel.com>
References: <1308741534-6846-1-git-send-email-sassmann@kpanic.de>
 <20110623133950.GB28333@srcf.ucam.org> <4E0348E0.7050808@kpanic.de>
 <20110623141222.GA30003@srcf.ucam.org> <4E035DD1.1030603@kpanic.de>
 <20110623170014.GN3263@one.firstfloor.org>
 <987664A83D2D224EAE907B061CE93D5301E938F2FD@orsmsx505.amr.corp.intel.com>
 <BANLkTikTTCU3eKkCtrbLbtpLJtksehyEMg@mail.gmail.com>
 <20110624080535.GA19966@phantom.vanrein.org> <4E04B848.6000908@zytor.com>
In-Reply-To: <4E04B848.6000908@zytor.com>
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

> > I am very curious about your findings.  Independently of those, I am in
> > favour of a patch that enables longer e820 tables if it has no further
> > impact on speed or space.
> > 
>
> That is already in the mainline kernel, although only if fed from the
> boot loader (it was developed in the context of mega-NUMA machines); the
> stub fetching from INT 15h doesn't use this at the moment.

Does it scale?  Current X86 systems go up to about 2TB - presumably
in the form of 256 8GB DIMMs (or maybe 512 4GB ones).  If a faulty
row or column on a DIMM can give rise to 4K bad pages, then these
large systems could conceivably have 1-2 million bad pages (while
still being quite usable - a loss of 4-8G from a 2TB system is down
in the noise).  Can we handle a 2 million entry e820 table? Do we
want to?

Perhaps we may end up with a composite solution. Use e820 to map out
the bad pages below some limit (like 4GB). Preferably in the boot loader
so it can find a range of good memory to load the kernel. Then use
badRAM patterns for addresses over 4GB for Linux to avoid bad pages
by flagging their page structures.

-Tony

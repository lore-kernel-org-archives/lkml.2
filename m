Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab2H2OnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 10:43:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:14059 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731Ab2H2OnQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 10:43:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,334,1344236400"; 
   d="scan'208";a="186447721"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
CC: "andi@firstfloor.org" <andi@firstfloor.org>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Subject: RE: [PATCH RFC] x86/mce: Move MCE sysfs attributes out of the
 per-cpu location
Thread-Topic: [PATCH RFC] x86/mce: Move MCE sysfs attributes out of the
 per-cpu location
Thread-Index: AQHNhboI/HiJHrjV/U2L338+9HRRYpdxB6MA///UF2A=
Date: Wed, 29 Aug 2012 14:43:12 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F193989D6@ORSMSX104.amr.corp.intel.com>
References: <20120829074154.6755.98941.stgit@localhost.localdomain>
 <20120829101302.GA26977@aftab.osrc.amd.com>
In-Reply-To: <20120829101302.GA26977@aftab.osrc.amd.com>
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

> Note: I'm not sure if it's ok to change sysfs entries and this does break
> userspace tools that depend on the current path for some of these attributes.
> So, they will need to be updated to use the new path. However, if we ever get
> to a point where cpu0 can be offlined, these tools will need to be updated
> anyway (as they mostly hardcode machinecheck0 currently)

Linus' clarified his "never break user space" edict at the kernel summit
on Monday. Paraphrasing:

  If nobody notices, or nobody complains, then we can make changes. But
  if anyone does complain, then the patch gets reverted.

So if you want to do this, the right approach would be to change the
utilities that use this to look in the new location for these sysfs files
first, and fall back to looking in the old per-cpu place.

Next (or in parallel) have the kernel provide both interfaces.

Wait a long[1] time so that most people have updated utilities.

Delete the per-cpu interfaces from the kernel.

Delete the per-cpu references from the utilities.

-Tony

[1] Long enough that there are no complaints. At least a year, probably two or more.

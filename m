Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab1GUR5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 13:57:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:60731 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432Ab1GUR53 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 13:57:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,242,1309762800"; 
   d="scan'208";a="30843694"
From: "Luck, Tony" <tony.luck@intel.com>
To: Don Zickus <dzickus@redhat.com>, "Huang, Ying" <ying.huang@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>
Date: Thu, 21 Jul 2011 10:57:28 -0700
Subject: RE: [PATCH] pstore: change mutex locking to spin_locks
Thread-Topic: [PATCH] pstore: change mutex locking to spin_locks
Thread-Index: AcxHoZLQo/nV48+kTHGbnVGKAW+r4wALUofA
Message-ID: <987664A83D2D224EAE907B061CE93D5301E9EC9DC6@orsmsx505.amr.corp.intel.com>
References: <1311195386-22743-1-git-send-email-dzickus@redhat.com>
 <4E277584.1060200@intel.com> <20110721122731.GV3765@redhat.com>
In-Reply-To: <20110721122731.GV3765@redhat.com>
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

> > Is it safe to call pstore_mkfile with IRQ disabled?
> > 
> > pstore_mkfile -> d_alloc_name -> d_alloc -> kmem_cache_alloc(, GFP_KERNEL).
>
> Don't know.  But would that mean we would have to put the pstore_mkfile
> on a workqueue then or something similar?

That might be a good idea anyway.  In the "oops" case we'd like the file
to appear in the pstore filesystem if the system stayed healthy despite
the oops[1]. There isn't any reason why the pstore entry must appear instantly.
Delaying the creation would avoid running into problems related to the
oops.

-Tony

[1] So we can remove it to free pstore backend space - if we didn't die
from the oops, then the oops is going to be in /var/log/messages.

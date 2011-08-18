Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab1HRQeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 12:34:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:55393 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261Ab1HRQeg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 12:34:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,245,1312182000"; 
   d="scan'208";a="39887677"
From: "Luck, Tony" <tony.luck@intel.com>
To: Don Zickus <dzickus@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu, 18 Aug 2011 09:33:17 -0700
Subject: RE: pstore: change mutex locking to spin_locks
Thread-Topic: pstore: change mutex locking to spin_locks
Thread-Index: Acxdpp3ZJFNewSLKRbub3iChIlbObgAHUE1w
Message-ID: <987664A83D2D224EAE907B061CE93D5301EA4D7C88@orsmsx505.amr.corp.intel.com>
References: <4e4568eb10165cbab6@agluck-desktop.sc.intel.com>
 <20110817142225.8645fff7.akpm@linux-foundation.org>
 <20110818125849.GZ1972@redhat.com>
In-Reply-To: <20110818125849.GZ1972@redhat.com>
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

> But in this case we have a filesystem that can be read/written to from a
> normal context and also written to from an NMI context

I fixed (avoided) the problem of writing to the pstore filesystem in NMI
context in my other pstore patch in linux-next ("defer inserting OOPS entries in pstore").

So the remaining locking requirement in pstore is just to protect
the non-volatile backing store from simultaneous access.

-Tony



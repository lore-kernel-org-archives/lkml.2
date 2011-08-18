Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab1HRRZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 13:25:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab1HRRZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 13:25:22 -0400
Date: Thu, 18 Aug 2011 13:25:02 -0400
From: Don Zickus <dzickus@redhat.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: pstore: change mutex locking to spin_locks
Message-ID: <20110818172502.GF1972@redhat.com>
References: <4e4568eb10165cbab6@agluck-desktop.sc.intel.com>
 <20110817142225.8645fff7.akpm@linux-foundation.org>
 <20110818125849.GZ1972@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301EA4D7C88@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301EA4D7C88@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 09:33:17AM -0700, Luck, Tony wrote:
> > But in this case we have a filesystem that can be read/written to from a
> > normal context and also written to from an NMI context
> 
> I fixed (avoided) the problem of writing to the pstore filesystem in NMI
> context in my other pstore patch in linux-next ("defer inserting OOPS entries in pstore").

Ok, just found that patch.  That fixes one of the issues.  :-)

> 
> So the remaining locking requirement in pstore is just to protect
> the non-volatile backing store from simultaneous access.

Right.  It is still awkward to have userspace write to the pstore and then
be interrupted by an NMI who wants to write to the pstore without causing
deadlocks.  But I think we will get there.

Cheers,
Don

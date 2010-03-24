Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab0CXCQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 22:16:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40038 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab0CXCQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 22:16:16 -0400
To: holt@sgi.com
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Rafael Wysocki <rjw@novell.com>
Subject: Re: [patch 0/2] x86,pat: Reduce contention on the memtype_lock -V4
From: Andi Kleen <andi@firstfloor.org>
References: <20100324003608.811051277@gulag1.americas.sgi.com>
Date: Wed, 24 Mar 2010 03:16:14 +0100
In-Reply-To: <20100324003608.811051277@gulag1.americas.sgi.com> (holt@sgi.com's message of "Tue, 23 Mar 2010 19:36:08 -0500")
Message-ID: <87wrx2for5.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

holt@sgi.com writes:

> Tracking memtype on x86 uses a single global spin_lock for either reading
> or changing the memory type.  This includes changes made to page flags
> which is perfectly parallel.
>
> Part one of the patchset makes the page-based tracking use cmpxchg
> without a need for a lock.
>
> Part two of the patchset converts the spin_lock into a read/write lock.

I'm curious: in what workloads did you see contention?

For any scalability patches it would be always good to have a description
of the workload.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

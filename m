Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab1HZOkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 10:40:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab1HZOkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 10:40:01 -0400
Date: Fri, 26 Aug 2011 10:39:49 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com
Subject: Re: [V3][PATCH 0/6] x86, nmi: new NMI handling routines
Message-ID: <20110826143949.GX2067@redhat.com>
References: <1314290748-23569-1-git-send-email-dzickus@redhat.com>
 <1314351897.9377.2.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314351897.9377.2.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 11:44:57AM +0200, Peter Zijlstra wrote:
> On Thu, 2011-08-25 at 12:45 -0400, Don Zickus wrote:
> > I spent some time hacking and came up with this patch.  I tested it on my
> > core2quad machine trying to enable all the NMI handler I could, mainly
> > perf and kgdb (and oprofile too when perf was disabled).  Everything seems
> > to work correctly.  If people are ok with this approach, I'll try and test
> > this on more machines. 
> 
> Right, code looks OK, the only worry that remains is overhead, always
> running all handlers must cost..

Yeah nothing is free.  My only counter argument is I removed the case
statements in the handlers, so it speeds things up a tiny bit.  Also most
machines only seem to have perf and the arch_backtrace handler registered,
with modern intel boxes probably registering the ghes handler too.

There really isn't much there, at least currently.  I would break up the
handler more if I knew a quicker way to distinguish between something like
a self-IPI NMI vs. an on-chip NMI like perf.  Then again those NMIs
probably aren't latched differently unlike the external one sitting in the
IOAPIC(??).

Cheers,
Don

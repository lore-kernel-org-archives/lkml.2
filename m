Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab2CFGNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 01:13:38 -0500
Received: from mga14.intel.com ([143.182.124.37]:56249 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495Ab2CFGNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 01:13:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="115164450"
Subject: Re: [RFC patch] spindep: add cross cache lines checking
From: Alex Shi <alex.shi@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnd Bergmann <arnd@arndb.de>, tglx@linutronix.com,
        "mingo@redhat.com" <mingo@redhat.com>, hpa@zytor.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, andi.kleen@intel.com, gcc-help@gcc.gnu.org
In-Reply-To: <20120305104311.GA18556@elte.hu>
References: <1330917630.18835.44.camel@debian>
	 <1330917889.18835.46.camel@debian> <1330926234.18835.51.camel@debian>
	 <201203050941.56502.arnd@arndb.de>  <20120305104311.GA18556@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Mar 2012 14:13:34 +0800
Message-ID: <1331014414.18835.254.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-05 at 11:43 +0100, Ingo Molnar wrote:
> * Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > On Monday 05 March 2012, Alex Shi wrote:
> > > Subject: [PATCH] lockdep: add cross cache lines checking
> > > 
> > > Modern x86 CPU won't hold whole memory bus when executing 
> > > 'lock' prefixed instructions unless the instruction 
> > > destination is crossing 2 cache lines. If so, it is disaster 
> > > of system performance.
> > > 
> > > Actually if the lock is not in the 'packed' structure, gcc 
> > > places it safely under x86 arch. But seems add this checking 
> > > in CONFIG_DEBUG_LOCK_ALLOC is harmless.
> > 
> > Have you tried making this a compile-time check using 
> > __alignof__? I would say that any spinlock in a packed data 
> > structure is basically a bug, even more so on most other 
> > architectures besides x86.

I have one concern and one questions here:
concern: maybe the lock is in a well designed 'packed' struct, and it is
safe for cross lines issue. but __alignof__ will return 1;

struct abc{
	raw_spinlock_t lock1;
	char 		a;
	char		b;
}__attribute__((packed));

Since the lock is the first object of struct, usually it is well placed.

question: I am a idiot on gcc, I tried some parameters of gcc " --param
l1-cache-line-size=1  -mno-align-double" and can not make a cross lines
variable without 'packed' structure, but I still don't find a grantee
why gcc can avoid the cross line variable if it's not in 'packed'
structure? 

> agreed.
> 
> Thanks,
> 
> 	Ingo



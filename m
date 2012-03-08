Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab2CHCUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 21:20:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:19722 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456Ab2CHCUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 21:20:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="126403040"
Subject: Re: [RFC patch] spindep: add cross cache lines checking
From: Alex Shi <alex.shi@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnd Bergmann <arnd@arndb.de>, gcc@gcc.gnu.org, tglx@linutronix.de,
        "mingo@redhat.com" <mingo@redhat.com>, hpa@zytor.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, andi.kleen@intel.com, gcc-help@gcc.gnu.org
In-Reply-To: <20120307133937.GB12676@elte.hu>
References: <1330917630.18835.44.camel@debian>
	 <201203060932.45223.arnd@arndb.de> <1331108607.18835.343.camel@debian>
	 <201203071154.36059.arnd@arndb.de> <4F575F09.3010107@intel.com>
	 <20120307133937.GB12676@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Mar 2012 10:21:02 +0800
Message-ID: <1331173262.18835.347.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-07 at 14:39 +0100, Ingo Molnar wrote:
> * Alex Shi <alex.shi@intel.com> wrote:
> 
> > > I think the check should be (__alignof__(lock) < 
> > > __alignof__(rwlock_t)), otherwise it will still pass when 
> > > you have structure with attribute((packed,aligned(2)))
> > 
> > reasonable!
> > 
> > >> 1, it is alignof bug for default gcc on my fc15 and Ubuntu 11.10 etc?
> > >>
> > >> struct sub {
> > >>         int  raw_lock;
> > >>         char a;
> > >> };
> > >> struct foo {
> > >>         struct sub z;
> > >>         int slk;
> > >>         char y;
> > >> }__attribute__((packed));
> > >>
> > >> struct foo f1;
> > >>
> > >> __alignof__(f1.z.raw_lock) is 4, but its address actually can align on
> > >> one byte. 
> > > 
> > > That looks like correct behavior, because the alignment of 
> > > raw_lock inside of struct sub is still 4. But it does mean 
> > > that there can be cases where the compile-time check is not 
> > > sufficient, so we might want the run-time check as well, at 
> > > least under some config option.
> > 
> > what's your opinion of this, Ingo?
> 
> Dunno. How many real bugs have you found via this patch?

None. Guess stupid code was shot in lkml reviewing. But if the patch in,
it is helpful to block stupid code in developing. 
> 
> Thanks,
> 
> 	Ingo



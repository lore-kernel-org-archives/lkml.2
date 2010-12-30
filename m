Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab0L3JHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 04:07:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46439 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406Ab0L3JHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 04:07:04 -0500
Date: Thu, 30 Dec 2010 10:06:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Rientjes <rientjes@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2 3/6] x86, 64bit, numa: Put pgtable to local node
 memory
Message-ID: <20101230090648.GB7306@elte.hu>
References: <4D0C072D.1040201@kernel.org>
 <4D19320B.7030007@kernel.org>
 <4D1933D1.9020609@kernel.org>
 <4D1BC856.4010202@kernel.org>
 <4D1BC94C.5040100@zytor.com>
 <AANLkTikknHfA4TQw+SMH-EyJBHoNHXk8Rheq4=K4jNWA@mail.gmail.com>
 <alpine.DEB.2.00.1012291637270.6040@chino.kir.corp.google.com>
 <4D1BD928.50701@zytor.com>
 <alpine.DEB.2.00.1012291702180.7374@chino.kir.corp.google.com>
 <4D1BE615.4000700@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D1BE615.4000700@zytor.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 12/29/2010 05:07 PM, David Rientjes wrote:
> > On Wed, 29 Dec 2010, H. Peter Anvin wrote:
> > 
> >>> That's from f51bf3073a1 (x86, numa: Fake apicid and pxm mappings for NUMA 
> >>> emulation) and c1c3443c9c (x86, numa: Fake node-to-cpumask for NUMA 
> >>> emulation) in x86/numa.  Given the subject line, I think your patchset is 
> >>> targeted to the same branch so I'm not sure what's concerning?
> >>
> >> No, it's part of a much bigger patchset which doesn't have anything to
> >> do with NUMA.  That's the problem.
> >>
> >> In other words, I need a sane way to merge them and resolve the conflict.
> >
> > The two patches above from x86/numa that create the conflict should be 
> > dependent only on 4e76f4e67a (x86, numa: Avoid compiling NUMA emulation 
> > functions without CONFIG_NUMA_EMU), so cherry-pick them into x86/bootmem?
> 
> That would hurt more, I think.

x86/bootmem could be based on x86/numa - the latter is stable so it's not like we'll 
have to undo it from under x86/bootmem. We can then send it to Linus once x86/numa 
is upstream.

Btw., i suspect we want to use x86/memblock instead of x86/bootmem?

Thanks,

	Ingo

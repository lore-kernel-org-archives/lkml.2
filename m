Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab1FTQlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 12:41:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38688 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767Ab1FTQlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 12:41:18 -0400
Date: Mon, 20 Jun 2011 18:40:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ryan Mallon <rmallon@gmail.com>, Petr Tesarik <ptesarik@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] Enhance /dev/mem to allow read/write of arbitrary
 physical addresses
Message-ID: <20110620164045.GB10815@elte.hu>
References: <201106171038.25988.ptesarik@suse.cz>
 <20110617093032.GA19235@elte.hu>
 <4DFE7FF9.9070406@gmail.com>
 <4DFE89E0.5020509@zytor.com>
 <20110620074124.GB24716@elte.hu>
 <4DFF6E58.8090306@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFF6E58.8090306@zytor.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 06/20/2011 12:41 AM, Ingo Molnar wrote:
> > 
> > * H. Peter Anvin <hpa@zytor.com> wrote:
> > 
> >> There are some test drivers which really want /dev/mem to work.
> > 
> > Test drivers and test hardware with zero enumeration can use below 4G 
> > addresses just fine.
> >
> > Also, debugging is not an issue and some non-default kernel or boot 
> > option can enable any sort of device i guess, so my main worry isnt 
> > really security but that we should stand in the way of the apparent 
> > practice of *shipping* user-space drivers that use /dev/mem ...
> > 
> 
> We should either fix /dev/mem to work according to its 
> specification or rip it out.  The issue with test drivers is not 
> spurious... I ran into this one myself a few weeks ago while trying 
> to do a memory test (by limiting the amount of memory available to 
> the kernel).  This is something that is typically done on factory 
> floors, and it would be nice to be able to get those environments 
> over to using Linux.

There is no reason why they couldnt use a .config option or a boot 
option to get their weird stuff going, which weird stuff also happens 
to be useful.

What i'm somewhat against is having this enabled by default for weird 
stuff that also happens to be harmful - and the fact that it never 
worked over 4G physical gives us the perfect opportunity to do just 
that.

Thanks,

	Ingo

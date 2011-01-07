Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab1AGOWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 09:22:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37098 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161Ab1AGOWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 09:22:15 -0500
Date: Fri, 7 Jan 2011 15:22:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: unify "numa=" command line option handling
Message-ID: <20110107142203.GA12773@elte.hu>
References: <4D2603BF020000780002ACA7@vpn.id2.novell.com>
 <alpine.DEB.2.00.1101061235010.30820@chino.kir.corp.google.com>
 <4D26D3FD020000780002AED9@vpn.id2.novell.com>
 <alpine.DEB.2.00.1101070156050.19087@chino.kir.corp.google.com>
 <4D26F3AE020000780002AF5D@vpn.id2.novell.com>
 <20110107125722.GA23185@elte.hu>
 <4D272413020000780002B009@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D272413020000780002B009@vpn.id2.novell.com>
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


* Jan Beulich <JBeulich@novell.com> wrote:

> >>> On 07.01.11 at 13:57, Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Jan Beulich <JBeulich@novell.com> wrote:
> > 
> >> >>> On 07.01.11 at 10:58, David Rientjes <rientjes@google.com> wrote:
> >> > On Fri, 7 Jan 2011, Jan Beulich wrote:
> >> > 
> >> >> However, the problem my patch addresses has been long standing
> >> >> (I noted it with our .32 based kernel, but according to my looking at
> >> >> the code it would go back to at least .27), so I'd like to ask for it to
> >> >> be merged independently (and I should probably have copied stable
> >> >> too), unless (quite unlikely) Tejun's merge is intended to also be
> >> >> applied to stable kernels.
> >> >> 
> >> > 
> >> > I don't think this should be targeted to -stable since it's not a bugfix; 
> >> > this is adding a feature that allows you to disable acpi parsing of the 
> >> > SRAT on i386.
> >> 
> >> How is this not a bug fix if it allows a system to boot that previously
> >> didn't?
> > 
> > btw., that's an absolutely key piece of information that REALLY should have 
> > been 
> > included in the changelog of the first patch. It is more important than all 
> > of the 
> > changelog.
> 
> Quoting that text: "In order to be able to suppress the use of SRAT
> tables that 32-bit Linux can't deal with (possibly leading to a non-
> bootable system, without disabling ACPI altogether), move the
> "numa=" option handling to common code."
> 
> To me it says just that. And of course, not every system with a
> not understood SRAT would be yielded non-bootable, hence the
> wording "possibly leading to ...".


Your -stable comment above made it appear to me as if you knew about a specific 
system that crashed this way? As long as it's only theoretical i'm not sure it 
warrants a -stable backport.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab1AGM6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 07:58:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42434 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266Ab1AGM6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 07:58:35 -0500
Date: Fri, 7 Jan 2011 13:58:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Jan Beulich <JBeulich@novell.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: use PCI method for enabling AMD extended config
 space before MSR method
Message-ID: <20110107125818.GB23185@elte.hu>
References: <4D26028F020000780002AC8A@vpn.id2.novell.com>
 <20110106172004.GM4739@erda.amd.com>
 <20110106172834.GN4739@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110106172834.GN4739@erda.amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> On 06.01.11 18:20:04, Robert Richter wrote:
> > On 06.01.11 11:57:35, Jan Beulich wrote:
> > > While both methods should work equivalently well for the native case,
> > > the Xen Dom0 case can't reliably work with the MSR one, since there's
> > > no guarantee that the virtual CPUs it has available fully cover all
> > > necessary physical ones.
> > > 
> > > As per the suggestion of Robert Richter the patch only adds the PCI
> > > method, but leaves the MSR one as a fallback to cover new systems the
> > > PCI IDs of which may not have got added to the code base yet.
> > > 
> > > Signed-off-by: Jan Beulich <jbeulich@novell.com>
> > > Cc: Robert Richter <robert.richter@amd.com>
> > > Cc: Joerg Roedel <Joerg.Roedel@amd.com>
> > > Cc: Andreas Herrmann <Andreas.Herrmann3@amd.com>
> > > Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> > > 
> > > ---
> > >  arch/x86/include/asm/amd_nb.h |    7 ++++++
> > >  arch/x86/kernel/amd_nb.c      |    7 ++++++
> > >  arch/x86/kernel/aperture_64.c |   44 +++++++++++++++---------------------------
> > >  arch/x86/pci/amd_bus.c        |   30 ++++++++++++++++++++++++++++
> > >  4 files changed, 60 insertions(+), 28 deletions(-)
> 
> Btw, the patch should be relative to tip/x86/amd-nb as there would be
> conflicts otherwise due to other changes.

that's upstream meanwhile, so a patch against -git or -tip would suffice.

Thanks,

	Ingo

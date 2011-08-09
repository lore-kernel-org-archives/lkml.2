Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab1HIPDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:03:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44407 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab1HIPDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:03:17 -0400
Date: Tue, 9 Aug 2011 17:02:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bruno Friedmann <bruno@ioda-net.ch>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Mel Gorman <mgorman@suse.de>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Add reboot quirk for Dell Precision M4600
Message-ID: <20110809150224.GF28228@elte.hu>
References: <20110727125651.GH3010@suse.de>
 <20110806065635.GE13220@elte.hu>
 <20110806153003.GA1238@srcf.ucam.org>
 <4E40119A.5010803@zytor.com>
 <4E41197D.30209@ioda-net.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E41197D.30209@ioda-net.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Bruno Friedmann <bruno@ioda-net.ch> wrote:

> On 08/08/2011 06:40 PM, H. Peter Anvin wrote:
> > On 08/06/2011 10:30 AM, Matthew Garrett wrote:
> >> On Sat, Aug 06, 2011 at 08:56:35AM +0200, Ingo Molnar wrote:
> >>> Weird - ACPI is the default Windows method of reboot - how come it 
> >>> does not work on that box? Does Windows work around this specific 
> >>> machine (unlikely), or is our ACPI boot sequence not 100% compatible 
> >>> with the Windows method (more likely IMO)?
> >>
> >> The ACPI reboot method on these machines hits the keyboard controller 
> >> rather than PCI, which is unusual. What I suspect is that the write 
> >> triggers some SMM or EC code that's making assumptions about system 
> >> state, and we're not quite identical. Bouncing on the keyboard 
> >> controller from userspace with init=/bin/bash wedges in the same way.
> >>
> > 
> > I have a vague suspicion that Windows might have a meta-quirk for this
> > class of machines, i.e. if the ACPI reboot method, say, points at the
> > keyboard controller or points at the "PCI" reboot port then it actually
> > uses its own special-purpose routines rather than general routines.  It
> > would be extremely interesting to know if "reboot=kbd" works on these boxen.
> > 
> > 	-hpa
> > 
> 
> Test done with reboot=pci and unfortunately doesn't work.

Didn't hpa suggest reboot=kbd?

Thanks,

	Ingo

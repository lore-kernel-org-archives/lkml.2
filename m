Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab1DNLou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 07:44:50 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:47222 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab1DNLot convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 07:44:49 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zzbb2dK936eK9371O1432N98dKzz1202hzz8275bh8275dhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJN4MI-02-FKL-02
X-M-MSG: 
Subject: Re: [PATCH] x86: Clean up mwait_play_dead
From: Frank Arnold <frank.arnold@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Borislav Petkov <bp@amd64.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Frank Arnold <farnold@amd64.org>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110413174909.GB9619@elte.hu>
References: <1302711073-31985-1-git-send-email-farnold@amd64.org>
	 <4DA5D4D8.7000902@zytor.com> <20110413173634.GA1904@gere.osrc.amd.com>
	 <20110413174909.GB9619@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 13:44:41 +0200
Message-ID: <1302781481.13300.31.camel@mendozza.osrc.amd.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 13:49 -0400, Ingo Molnar wrote:
> * Borislav Petkov <bp@amd64.org> wrote:
> 
> > On Wed, Apr 13, 2011 at 09:52:40AM -0700, H. Peter Anvin wrote:
> > > On 04/13/2011 09:11 AM, Frank Arnold wrote:
> > > > From: Frank Arnold <frank.arnold@amd.com>
> > > > 
> > > > Commit 93789b32dbf355e70f18b17a82e8661677a7f7fb introduced
> > > > cpuinfo_x86 *c for brevity. It is used to check for the
> > > > mwait feature flag. The same can be done with a subsequent
> > > > check for clflsh and save us a second per-cpu pointer
> > > > dereference.
> > > > 
> > > > Signed-off-by: Frank Arnold <frank.arnold@amd.com>
> > > > Acked-by: Borislav Petkov <borislav.petkov@amd.com>
> > > > ---
> > > >  arch/x86/kernel/smpboot.c |    2 +-
> > > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > > 
> > > 
> > > This should be using this_cpu_has()... if that's not in the tree yet we
> > > should add it.
> > 
> > Looks like it is still in tip/x86/mm.
> 
> Yeah - that patch was sent at around the beginning of the merge window, so it 
> was too late for .39.
> 
> > We could either redo the patch properly when this_cpu_has() is merged or add 
> > the change against that branch.
> 
> Yeah - please do one against tip:master and we'll put it into the right topic 
> branch.

It's already fixed in tip:master with the proper use of this_cpu_has().
commit 349c004e3d31fda23ad225b61861be38047fff16

Sorry for the noise.

-- 
Frank.

Advanced Micro Devices GmbH
Sitz: Dornach, Gemeinde Aschheim,
Landkreis München Registergericht München,
HRB Nr. 43632 - WEEE Registrierungsnummer 129 19551
Geschäftsführer: Alberto Bozzo, Andrew Bowd



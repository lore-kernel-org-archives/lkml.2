Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935885Ab1KJRDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 12:03:44 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:9512
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935384Ab1KJRDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 12:03:42 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz9371K1432N98dKzz1202hzzz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,13,
Date: Thu, 10 Nov 2011 11:03:35 -0600
From: Scott Wood <scottwood@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
CC: Kyle Moffett <Kyle.D.Moffett@boeing.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, Baruch Siach <baruch@tkos.co.il>,
        Timur Tabi <B04825@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [RFC PATCH 08/17] powerpc/e500: Remove conditional "lwsync"
 substitution
Message-ID: <20111110170334.GF11983@schlenkerla.am.freescale.net>
References: <4E42AB6F.1050900@freescale.com>
 <1320883635-17194-9-git-send-email-Kyle.D.Moffett@boeing.com>
 <3937191C-A735-4668-8E80-9FB4B35E2F63@kernel.crashing.org>
 <20111110163100.GA11983@schlenkerla.am.freescale.net>
 <AC287A9B-0C8B-494E-95CD-A33014AECE22@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <AC287A9B-0C8B-494E-95CD-A33014AECE22@kernel.crashing.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 10:42:25AM -0600, Kumar Gala wrote:
> 
> On Nov 10, 2011, at 10:31 AM, Scott Wood wrote:
> 
> > On Thu, Nov 10, 2011 at 07:40:04AM -0600, Kumar Gala wrote:
> >> Nak, we can run an e500mc in a mode that is compatible with e500v1/v2.  I see no reason to change the support we have there.
> > 
> > What "mode" do you mean?  DCBZ32?  We don't support using that currently,
> > and I'd imagine the performance implication would be such that you'd
> > never want to do it unless it's the only way to make some piece of legacy
> > software work.
> 
> Correct, DCBZ32, we've had customers that go down this path.

For running legacy software, or for multiplatform Linux kernels?

And if you're willing to toss performance away for this goal, why do you
need lwsync? :-)

DCBZ32 is not a "mode that is compatible with v1/v2", BTW.  It only
affects cache block size (for dcbz/dcba only), not SPE versus FP, not
changes in power management, not changes in machine check handling, etc.

Using DCBZ32 for the kernel would also complicate switching the kernel to
dcbzl, to support enabling DCBZ32 for certain userspace apps (a more
likely use case) without making it systemwide.

-Scott


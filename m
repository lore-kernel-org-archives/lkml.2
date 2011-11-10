Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965140Ab1KJQbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 11:31:10 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:38534 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965117Ab1KJQbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 11:31:05 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz9371K1432N98dKzz1202hzz8275bhz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 10 Nov 2011 10:31:00 -0600
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
Message-ID: <20111110163100.GA11983@schlenkerla.am.freescale.net>
References: <4E42AB6F.1050900@freescale.com>
 <1320883635-17194-9-git-send-email-Kyle.D.Moffett@boeing.com>
 <3937191C-A735-4668-8E80-9FB4B35E2F63@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3937191C-A735-4668-8E80-9FB4B35E2F63@kernel.crashing.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 07:40:04AM -0600, Kumar Gala wrote:
> 
> On Nov 9, 2011, at 6:07 PM, Kyle Moffett wrote:
> 
> > As FreeScale e500 systems have different cacheline sizes from e500mc, it
> > is basically impossible for the kernel to support both in a single
> > system image at present.
> > 
> > Given that one is SPE-float and the other is classic-float, they are not
> > generally userspace-compatible either.
> > 
> > This patch updates the conditional to depend on whether the system is
> > actually targetting an "e500" or "e500mc" core and entirely removes the
> > unused sync-to-lwsync-replacement on e500v1/e500v2 systems.
> > 
> > Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
> > ---
> > arch/powerpc/include/asm/synch.h |   16 ++++------------
> > 1 files changed, 4 insertions(+), 12 deletions(-)
> 
> Nak, we can run an e500mc in a mode that is compatible with e500v1/v2.  I see no reason to change the support we have there.

What "mode" do you mean?  DCBZ32?  We don't support using that currently,
and I'd imagine the performance implication would be such that you'd
never want to do it unless it's the only way to make some piece of legacy
software work.

>  I see no reason to change the support we have there.

No reason to remove complexity that is not needed, and is not planned to
be needed?

-Scott


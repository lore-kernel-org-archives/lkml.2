Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab2HBKCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 06:02:33 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:39222 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751639Ab2HBKCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 06:02:31 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zz98dI9371I936eI1432Izz1202hzz8275bhz2dh2a8h668h839h944hd25hf0ah107ah)
Date: Thu, 2 Aug 2012 18:04:18 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Kumar Gala <galak@kernel.crashing.org>,
        "linuxppc-dev@lists.ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        Li Yang <leoli@freescale.com>
Subject: Re: [PATCH] powerpc/smp: Do not disable IPI interrupts during suspend
Message-ID: <20120802100418.GA13777@localhost.localdomain>
References: <1342788421-27648-1-git-send-email-chenhui.zhao@freescale.com>
 <5028672F-1873-4E45-AA23-4CA9F191BE77@kernel.crashing.org>
 <1343427631.21647.1.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1343427631.21647.1.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 28, 2012 at 08:20:31AM +1000, Benjamin Herrenschmidt wrote:
> On Fri, 2012-07-27 at 16:58 -0500, Kumar Gala wrote:
> > On Jul 20, 2012, at 7:47 AM, Zhao Chenhui wrote:
> > 
> > > During suspend, all interrupts including IPI will be disabled. In this case,
> > > the suspend process will hang in SMP. To prevent this, pass the flag
> > > IRQF_NO_SUSPEND when requesting IPI irq.
> > > 
> > > Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> > > Signed-off-by: Li Yang <leoli@freescale.com>
> > > ---
> > > arch/powerpc/kernel/smp.c |    2 +-
> > > 1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > BenH,
> > 
> > Can you ack?
> 
> No I'll merge it but not until it's been in next for a bit unless you
> have some strong emergency there, it's on my mental list of things to
> shovel into next after rc1.
> 
> Curiosity: didn't we use to disable all non-boot CPUs on suspend ?
> 
> Cheers,
> Ben.

Yes, we disabled all non-boot CPUs on suspend by calling disable_nonboot_cpus().
The disable_nonboot_cpus() needs IPIs to work. But prior to
calling disable_nonboot_cpus(), the IPIs are disabled in dpm_suspend_noirq().

-Chenhui


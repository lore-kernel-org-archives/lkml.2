Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045Ab2F0KUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 06:20:37 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:9970
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757009Ab2F0KUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 06:20:35 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1202hzz8275bhz2dh2a8h668h839h944hd25hf0ah)
Date: Wed, 27 Jun 2012 18:21:38 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <scottwood@freescale.com>,
        <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: Re: [PATCH v6 1/5] powerpc/85xx: implement hardware timebase sync
Message-ID: <20120627102138.GB10476@localhost.localdomain>
References: <1340706359-9455-1-git-send-email-chenhui.zhao@freescale.com>
 <1340748634.3732.27.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1340748634.3732.27.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 08:10:34AM +1000, Benjamin Herrenschmidt wrote:
> On Tue, 2012-06-26 at 18:25 +0800, Zhao Chenhui wrote:
> > Do hardware timebase sync. Firstly, stop all timebases, and transfer
> > the timebase value of the boot core to the other core. Finally,
> > start all timebases.
> > 
> > Only apply to dual-core chips, such as MPC8572, P2020, etc.
> > 
> > Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> > Signed-off-by: Li Yang <leoli@freescale.com>
> > ---
> > Changes for v6:
> >  * added 85xx_TB_SYNC
> >  * added isync() after set_tb()
> >  * removed extra entries from mpc85xx_smp_guts_ids
> 
> What's that CONFIG option for ?
> 
> Cheers,
> Ben.

This option is to guard the timebase sync routines. It is selected
when KEXEC or HOTPLUG_CPU is enabled on Freescale Book-E platforms.

-Chenhui


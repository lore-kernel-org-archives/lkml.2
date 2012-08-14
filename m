Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab2HNJ7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 05:59:04 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:56858
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752394Ab2HNJ7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 05:59:03 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I1432Izz1202hzz8275bhz2dh2a8h668h839h944hd25hf0ah107ah)
Date: Tue, 14 Aug 2012 17:58:59 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: <galak@kernel.crashing.org>
CC: Zhao Chenhui-B35336 <B35336@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Yang-R58472 <r58472@freescale.com>, <leoli@freescale.com>,
        <B04825@freescale.com>
Subject: Re: [PATCH 2/4] fsl_pmc: Add API to enable device as wakeup event
 source
Message-ID: <20120814095859.GA21028@localhost.localdomain>
References: <1344329006-10645-1-git-send-email-chenhui.zhao@freescale.com>
 <1344329006-10645-2-git-send-email-chenhui.zhao@freescale.com>
 <CAOZdJXXdgS5x2ZkuXb4wHckdqLzSM2xy-eYU3+28d_=JH3euxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAOZdJXXdgS5x2ZkuXb4wHckdqLzSM2xy-eYU3+28d_=JH3euxg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2012 at 08:19:43AM -0500, Tabi Timur-B04825 wrote:
> On Tue, Aug 7, 2012 at 3:43 AM, Zhao Chenhui <chenhui.zhao@freescale.com> wrote:
> 
> > +               return -EINVAL;
> > +
> > +       prop = of_get_property(clk_np, "fsl,pmcdr-mask", NULL);
> > +       if (!prop) {
> > +               ret = -EINVAL;
> > +               goto out;
> > +       }
> > +       pmcdr_mask = be32_to_cpup(prop);
> > +
> > +       if (enable)
> > +               /* clear to enable clock in low power mode */
> > +               clrbits32(&pmc_regs->pmcdr, pmcdr_mask);
> > +       else
> > +               setbits32(&pmc_regs->pmcdr, pmcdr_mask);
> > +
> > +out:
> > +       of_node_put(clk_np);
> > +       return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(mpc85xx_pmc_set_wake);
> 
> Use EXPORT_SYMBOL, not EXPORT_SYMBOL_GPL.
> 

Hi kumar,

Is that ok with upstream?

-Chenhui


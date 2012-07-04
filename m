Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030196Ab2GDD21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 23:28:27 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:15166
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751734Ab2GDD2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 23:28:24 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jul 2012 23:28:24 EDT
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I1432Izz1202hzz8275bhz2dh2a8h668h839h944hd25hf0ah)
Date: Wed, 4 Jul 2012 11:14:26 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: Tabi Timur-B04825 <B04825@freescale.com>
CC: Zhao Chenhui-B35336 <B35336@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>
Subject: Re: [PATCH v7 1/5] powerpc/85xx: implement hardware timebase sync
Message-ID: <20120704031426.GA6133@localhost.localdomain>
References: <1341310879-5468-1-git-send-email-chenhui.zhao@freescale.com>
 <CAOZdJXUeY-_mmBLoA25_g4eLqwHxYX4c_ECbU+KYqfM307THNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAOZdJXUeY-_mmBLoA25_g4eLqwHxYX4c_ECbU+KYqfM307THNQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 07:46:24AM -0500, Tabi Timur-B04825 wrote:
> On Tue, Jul 3, 2012 at 5:21 AM, Zhao Chenhui <chenhui.zhao@freescale.com> wrote:
> 
> > +       np = of_find_matching_node(NULL, mpc85xx_smp_guts_ids);
> > +       if (np) {
> > +               guts = of_iomap(np, 0);
> > +               of_node_put(np);
> > +               if (!guts) {
> > +                       pr_err("%s: Could not map guts node address\n",
> > +                                                               __func__);
> > +                       return;
> > +               }
> > +               smp_85xx_ops.give_timebase = mpc85xx_give_timebase;
> > +               smp_85xx_ops.take_timebase = mpc85xx_take_timebase;
> > +       }
> 
> I had this in mind:
> 
>                guts = of_iomap(np, 0);
>                of_node_put(np);
>                if (guts) {
>                        smp_85xx_ops.give_timebase = mpc85xx_give_timebase;
>                        smp_85xx_ops.take_timebase = mpc85xx_take_timebase;
>                 } else {
>                        pr_err("%s: Could not map guts node address\n",
>                                                                __func__);
>                }
> 
> That way, a missing GUTS node does not break everything.
> 

If the guts variable is NULL, it indicates there is error in dts or kernel.
We should fix the error, rather than ignore it.

Moreover, if smp_85xx_ops.give/take_timebase is NULL, kernel can not do the timebase sync.

-Chenhui


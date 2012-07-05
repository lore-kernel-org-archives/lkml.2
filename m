Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab2GEKYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 06:24:20 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:36293
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753476Ab2GEKYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 06:24:18 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1202hzzz2dh2a8h668h839h944hd25hf0ah107ah)
Date: Thu, 5 Jul 2012 18:25:29 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: Tabi Timur-B04825 <B04825@freescale.com>
CC: Zhao Chenhui-B35336 <B35336@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Yang-R58472 <r58472@freescale.com>, <leoli@freescale.com>
Subject: Re: [PATCH v7 1/5] powerpc/85xx: implement hardware timebase sync
Message-ID: <20120705102529.GA7982@localhost.localdomain>
References: <1341310879-5468-1-git-send-email-chenhui.zhao@freescale.com>
 <CAOZdJXUeY-_mmBLoA25_g4eLqwHxYX4c_ECbU+KYqfM307THNQ@mail.gmail.com>
 <20120704031426.GA6133@localhost.localdomain>
 <4FF3B5B6.8090400@freescale.com>
 <20120704034545.GA6196@localhost.localdomain>
 <4FF45F19.2080607@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FF45F19.2080607@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2012 at 10:19:54AM -0500, Tabi Timur-B04825 wrote:
> Zhao Chenhui wrote:
> > On Tue, Jul 03, 2012 at 10:17:12PM -0500, Tabi Timur-B04825 wrote:
> >> Zhao Chenhui wrote:
> >>> If the guts variable is NULL, it indicates there is error in dts or kernel.
> >>> We should fix the error, rather than ignore it.
> >>
> >> And that's why there's a warning message.  Crashing the kernel is not
> >> going to fix anything.
> >>
> >
> > This error likely crashes the kenel somewhere.
> 
> Can you test this, please?
> 
> The point I'm trying to make is that it's wrong to intentionally halt the 
> kernel unless you're sure that it's the best option.  A missing device 
> tree node is supposed to only disable a given feature, not break everything.
> 

I think there is some misunderstanding here.

	np = of_find_matching_node(NULL, mpc85xx_smp_guts_ids);
	if (np) {
		guts = of_iomap(np, 0);
		of_node_put(np);
		if (!guts) {
			pr_err("%s: Could not map guts node address\n",
								__func__);
			return;
		}
		smp_85xx_ops.give_timebase = mpc85xx_give_timebase;
		smp_85xx_ops.take_timebase = mpc85xx_take_timebase;
	}

If the guts node is missing, this code snippet will be skipped. If the guts node is existed,
the return value of of_iomap(), namely guts, will be tested. If it is NULL, it shows
that there is error in dts, or the ioremap() in of_iomap() failed. I think
these errors are fatal errors, so I print an error info and return.

-Chenhui
																													


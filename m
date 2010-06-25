Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab0FYOOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 10:14:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34446 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755759Ab0FYOOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 10:14:32 -0400
Date: Fri, 25 Jun 2010 16:14:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Corinna Schultz <cschultz@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       coschult@us.ibm.com, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RESEND] (revised) Calgary: increase max PHB number
Message-ID: <20100625141415.GA7007@elte.hu>
References: <20100621144150.2j0xuwksg4cwg84c@imap.linux.ibm.com>
 <20100624212647.GI15515@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624212647.GI15515@tux1.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4817]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Darrick J. Wong <djwong@us.ibm.com> wrote:

> Newer systems (x3950M2) can have 48 PHBs per chassis and 8 chassis, so bump the
> limits up and provide an explanation of the requirements for each class.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
> 
> diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
> index fb99f7e..967c646 100644
> --- a/arch/x86/kernel/pci-calgary_64.c
> +++ b/arch/x86/kernel/pci-calgary_64.c
> @@ -103,11 +103,14 @@ int use_calgary __read_mostly = 0;
>  #define PMR_SOFTSTOPFAULT	0x40000000
>  #define PMR_HARDSTOP		0x20000000
>  
> -#define MAX_NUM_OF_PHBS		8 /* how many PHBs in total? */
> -#define MAX_NUM_CHASSIS		8 /* max number of chassis */
> -/* MAX_PHB_BUS_NUM is the maximal possible dev->bus->number */
> -#define MAX_PHB_BUS_NUM		(MAX_NUM_OF_PHBS * MAX_NUM_CHASSIS * 2)
> -#define PHBS_PER_CALGARY	4
> +/*
> + * The maximum PHB bus number.
> + * x3950M2 (rare): 8 chassis, 48 PHBs per chassis = 384
> + * x3950M2: 4 chassis, 48 PHBs per chassis        = 192
> + * x3950 (PCIE): 8 chassis, 32 PHBs per chassis   = 256
> + * x3950 (PCIX): 8 chassis, 16 PHBs per chassis   = 128
> + */
> +#define MAX_PHB_BUS_NUM		384

Doesnt build:

arch/x86/kernel/pci-calgary_64.c: In function ?calgary_locate_bbars?:
arch/x86/kernel/pci-calgary_64.c:1107: error: ?PHBS_PER_CALGARY? undeclared (first use in this function)
arch/x86/kernel/pci-calgary_64.c:1107: error: (Each undeclared identifier is reported only once
arch/x86/kernel/pci-calgary_64.c:1107: error: for each function it appears in.)

i have added back the PHBS_PER_CALGARY line - that is still needed, right?

Thanks,

	Ingo

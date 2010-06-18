Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458Ab0FRJkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 05:40:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59704 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685Ab0FRJki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 05:40:38 -0400
Date: Fri, 18 Jun 2010 11:40:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Corinna Schultz <cschultz@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, coschult@us.ibm.com,
       akpm@linux-foundation.org, djwong <djwong@linux.vnet.ibm.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH RESEND] Calgary: increase max PHB number
Message-ID: <20100618094005.GC23977@elte.hu>
References: <20100615161528.wqx1w1y3ok08w88w@imap.linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100615161528.wqx1w1y3ok08w88w@imap.linux.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4233]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Corinna Schultz <cschultz@linux.vnet.ibm.com> wrote:

> Newer systems (x3950M2) can have 48 PHBs per chassis and 8 chassis,
> so bump the
> limits up and provide an explanation of the requirements for each class.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
> ---
> 
>  arch/x86/kernel/pci-calgary_64.c |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-calgary_64.c
> b/arch/x86/kernel/pci-calgary_64.c
> index e6ec8a2..4b7eb90 100644
> --- a/arch/x86/kernel/pci-calgary_64.c
> +++ b/arch/x86/kernel/pci-calgary_64.c
> @@ -102,10 +102,15 @@ int use_calgary __read_mostly = 0;
>  #define PMR_SOFTSTOPFAULT		 0x40000000
>  #define PMR_HARDSTOP		 		 0x20000000
> 
> -#define MAX_NUM_OF_PHBS		 		 8 /* how many PHBs in total? */
> -#define MAX_NUM_CHASSIS		 		 8 /* max number of chassis */
> -/* MAX_PHB_BUS_NUM is the maximal possible dev->bus->number */
> -#define MAX_PHB_BUS_NUM		 		 (MAX_NUM_OF_PHBS * MAX_NUM_CHASSIS * 2)
> +/*
> + * The maximum PHB bus number.
> + * x3950M2 (rare): 8 chassis, 48 PHBs per chassis = 384
> + * x3950M2: 4 chassis, 48 PHBs per chassis        = 192
> + * x3950 (PCIE): 8 chassis, 32 PHBs per chassis   = 256
> + * x3950 (PCIX): 8 chassis, 16 PHBs per chassis   = 128
> + */
> +#define MAX_PHB_BUS_NUM		 		 384
> +

Which tree is this against? Doesnt apply to .35-rc3:

 Hunk #1 FAILED at 102.
 1 out of 1 hunk FAILED -- rejects in file arch/x86/kernel/pci-calgary_64.c

Thanks,

	Ingo

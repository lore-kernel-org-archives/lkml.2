Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab1AQKSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 05:18:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42994 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033Ab1AQKSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 05:18:06 -0500
Date: Mon, 17 Jan 2011 11:17:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "Lu, Hongjiu" <hongjiu.lu@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH]x86: make relocatable kernel work with new binutils
 -resend
Message-ID: <20110117101756.GB26819@elte.hu>
References: <1295232361.1949.675.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295232361.1949.675.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Shaohua Li <shaohua.li@intel.com> wrote:

> @@ -142,6 +140,11 @@ SECTIONS
>  		CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
>  
>  		DATA_DATA
> +#ifdef CONFIG_X86_32
> +		jiffies = jiffies_64;
> +#else
> +		jiffies_64 = jiffies;
> +#endif

I suspect this needs a comment, as to the unsuspecting reader it looks like black 
magic :-)

Thanks,

	Ingo

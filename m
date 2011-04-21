Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab1DUNDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 09:03:30 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44183 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab1DUND2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 09:03:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to expand_upwards
Cc: kosaki.motohiro@jp.fujitsu.com,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>
In-Reply-To: <alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com>
References: <1303317178.2587.30.camel@mulgrave.site> <alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com>
Message-Id: <20110421220351.9180.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Thu, 21 Apr 2011 22:03:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
> --- a/arch/parisc/mm/init.c
> +++ b/arch/parisc/mm/init.c
> @@ -266,8 +266,10 @@ static void __init setup_bootmem(void)
>  	}
>  	memset(pfnnid_map, 0xff, sizeof(pfnnid_map));
>  
> -	for (i = 0; i < npmem_ranges; i++)
> +	for (i = 0; i < npmem_ranges; i++) {
> +		node_set_state(i, N_NORMAL_MEMORY);
>  		node_set_online(i);
> +	}
>  #endif


I'm surprised this one. If arch code doesn't initialized N_NORMAL_MEMORY,
(or N_HIGH_MEMORY. N_HIGH_MEMORY == N_NORMAL_MEMORY if CONFIG_HIGHMEM=n)
kswapd is created only at node0. wow.

The initialization must be necessary even if !NUMA, I think. ;-)
Probably we should have revisit all arch code when commit 9422ffba4a 
(Memoryless nodes: No need for kswapd) was introduced, at least.

Thank you David. and I'm sad this multi level unforunate mismatch....



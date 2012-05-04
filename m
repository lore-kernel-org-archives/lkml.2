Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760375Ab2EDWS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 18:18:28 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11765 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759941Ab2EDWS1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 18:18:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 04 May 2012 15:17:36 -0700
From: Diwakar Tundlam <dtundlam@nvidia.com>
To: "'Peter Zijlstra'" <a.p.zijlstra@chello.nl>
CC: "'Ingo Molnar'" <mingo@kernel.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Christoph Lameter'" <cl@gentwo.org>,
        "'Michael Neuling'" <mikey@neuling.org>,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        "'David Rientjes'" <rientjes@google.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Date: Fri, 4 May 2012 15:18:04 -0700
Subject: RE: [PATCH] sched: Enable arch-specific asym packing option in
 sched domain
Thread-Topic: [PATCH] sched: Enable arch-specific asym packing option in
 sched domain
Thread-Index: Ac0qQsWCFB4aJs0jQ+yuO+mEsyzFggAAEcSw
Message-ID: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF102@HQMAIL04.nvidia.com>
References: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF0FF@HQMAIL04.nvidia.com>
	 <1DD7BFEDD3147247B1355BEFEFE46652379C3DF101@HQMAIL04.nvidia.com>
 <1336169422.16236.1.camel@twins>
In-Reply-To: <1336169422.16236.1.camel@twins>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> A repost doesn't make it right to add sibling (SMT) properties to a package/socket and will still upset Power7.

Agreed. I only fixed the whitespace and commitId.

arch_sd_sibling_asym_packing() is already present under ifdef CONFIG_SMT.
I didn't touch that. I only added it to SD_CPU_INIT for all cpu's.
I assumed Power7 shouldn't use SD_CPU_INIT.

I don't understand Power7 arch to comment on impact.
Michael Neuling should review this carefully and advise.

Maybe I should define a separate weak symbol, say arch_sd_bias_to_lower_num_cpu()?
Then Power7 can define arch_sd_sibling_asym_packing() to be '1' and it will not
break all-cpu init.

We need this for Tegra's slight asymmetry with core0.

Thanks,
--Diwakar.

-----Original Message-----
From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl] 
Sent: Friday, May 04, 2012 3:10 PM
To: Diwakar Tundlam
Cc: 'Ingo Molnar'; 'Andrew Morton'; 'Christoph Lameter'; 'Michael Neuling'; 'Stephen Rothwell'; 'Benjamin Herrenschmidt'; 'David Rientjes'; 'linux-kernel@vger.kernel.org'; Peter De Schrijver
Subject: RE: [PATCH] sched: Enable arch-specific asym packing option in sched domain

On Fri, 2012-05-04 at 15:06 -0700, Diwakar Tundlam wrote:
> +                               | arch_sd_sibling_asym_packing()        \
>                                 | sd_balance_for_package_power()        \
>                                 | sd_power_saving_flags()               \
>                                 ,                                       \ 

A repost doesn't make it right to add sibling (SMT) properties to a package/socket and will still upset Power7.

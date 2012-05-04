Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760592Ab2EDW5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 18:57:14 -0400
Received: from ozlabs.org ([203.10.76.45]:33861 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760485Ab2EDW5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 18:57:12 -0400
From: Michael Neuling <mikey@neuling.org>
To: Diwakar Tundlam <dtundlam@nvidia.com>
cc: "'Peter Zijlstra'" <a.p.zijlstra@chello.nl>,
        "'Ingo Molnar'" <mingo@kernel.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Christoph Lameter'" <cl@gentwo.org>,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        "'David Rientjes'" <rientjes@google.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: Re: [PATCH] sched: Enable arch-specific asym packing option in sched domain
In-reply-to: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF102@HQMAIL04.nvidia.com>
References: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF0FF@HQMAIL04.nvidia.com> <1DD7BFEDD3147247B1355BEFEFE46652379C3DF101@HQMAIL04.nvidia.com> <1336169422.16236.1.camel@twins> <1DD7BFEDD3147247B1355BEFEFE46652379C3DF102@HQMAIL04.nvidia.com>
Comments: In-reply-to Diwakar Tundlam <dtundlam@nvidia.com>
   message dated "Fri, 04 May 2012 15:18:04 -0700."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.3.1
Date: Sat, 05 May 2012 08:47:52 +1000
Message-ID: <5568.1336171672@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Diwakar Tundlam <dtundlam@nvidia.com> wrote:

> >> A repost doesn't make it right to add sibling (SMT) properties to a package/socket and will still upset Power7.
> 
> Agreed. I only fixed the whitespace and commitId.
> 
> arch_sd_sibling_asym_packing() is already present under ifdef CONFIG_SMT.
> I didn't touch that. I only added it to SD_CPU_INIT for all cpu's.
> I assumed Power7 shouldn't use SD_CPU_INIT.

You are using sibling at the cpu level.  POWER7 sets this at the sibling
level and we don't really want it at the cpu level.

> I don't understand Power7 arch to comment on impact.
> Michael Neuling should review this carefully and advise.

Ask Peter said, it's broken for POWER7.  We don't want to set this at
the cpu level.

> Maybe I should define a separate weak symbol, say
> arch_sd_bias_to_lower_num_cpu()?  Then Power7 can define
> arch_sd_sibling_asym_packing() to be '1' and it will not break all-cpu
> init.

This sounds better but I'd follow the old name call it
arch_sd_cpu_asym_packing()

Mikey

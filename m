Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab0FYRTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 13:19:00 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50178 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756557Ab0FYRS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 13:18:59 -0400
Subject: Re: [PATCH 1/1] ARM: unwind - optimise linked-list searches for
 modules
From: Catalin Marinas <catalin.marinas@arm.com>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1276605998-19275-1-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1276605998-19275-1-git-send-email-ext-phil.2.carmody@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Fri, 25 Jun 2010 18:18:43 +0100
Message-ID: <1277486323.13134.82.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jun 2010 17:18:43.0643 (UTC) FILETIME=[768178B0:01CB148A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-15 at 13:46 +0100, Phil Carmody wrote:
> With several sections per module, and dozens of modules, the
> searches down the linked list would dominate the lookup time,
> dwarfing any savings from the binary search within the section.
> 
> A simple move-to-front optimisation exploits the commonality
> of the code paths taken, and in simple real-world tests reduces
> the number of steps in the search to barely more than 1.
> 
> Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
> ---
>  arch/arm/kernel/unwind.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
> index dd81a91..2e88abf 100644
> --- a/arch/arm/kernel/unwind.c
> +++ b/arch/arm/kernel/unwind.c
> @@ -146,6 +146,8 @@ static struct unwind_idx *unwind_find_idx(unsigned long addr)
>                             addr < table->end_addr) {
>                                 idx = search_index(addr, table->start,
>                                                    table->stop - 1);
> +                               /* MTF with 50 modules: 80 steps becomes ~1 */
> +                               list_move(&table->list, &unwind_tables);

That's a good optimisation. Could you please expand the "MTF" comment in
the code a bit more? Otherwise,

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

-- 
Catalin


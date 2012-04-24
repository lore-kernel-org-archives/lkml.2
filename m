Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab2DXGcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 02:32:39 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:18343 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2DXGci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 02:32:38 -0400
Date: Tue, 24 Apr 2012 08:32:36 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: yinghai@kernel.org, tj@kernel.org, mhocko@suse.cz, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: Weirdness in __alloc_bootmem_node_high
Message-ID: <20120424063236.GA23963@merkur.ravnborg.org>
References: <20120420194309.GA3689@merkur.ravnborg.org> <20120422.152210.1520263792125579554.davem@davemloft.net> <20120422200554.GA6385@merkur.ravnborg.org> <20120422.220054.1961736352806510855.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120422.220054.1961736352806510855.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2012 at 10:00:54PM -0400, David Miller wrote:
> 
> So here is a sparc64 conversion to NO_BOOTMEM.
> 
> Critically, I had to fix __alloc_bootmem_node to do what it promised
> to do.  Which is retry the allocation without the goal if doing so
> with the goal fails.
> 
> Otherwise all bootmem allocations with goal set to
> __pa(MAX_DMA_ADDRESS) fail on sparc64, because we set that to ~0 so
> effectively all such allocations evaluate roughly to "goal=~0,
> limit=~0" which can never succeed.
> 
> diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
> index db4e821..3763302 100644
> --- a/arch/sparc/Kconfig
> +++ b/arch/sparc/Kconfig
> @@ -109,6 +109,9 @@ config NEED_PER_CPU_EMBED_FIRST_CHUNK
>  config NEED_PER_CPU_PAGE_FIRST_CHUNK
>  	def_bool y if SPARC64
>  
> +config NO_BOOTMEM
> +	def_bool y if SPARC64

mm/Kconfig define NO_BOOTMEM so you can just add a "select NO_BOOTMEM"
to SPARC64.

	Sam

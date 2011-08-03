Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab1HCQ00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 12:26:26 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:35602 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751398Ab1HCQ0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 12:26:20 -0400
Date: Wed, 3 Aug 2011 17:17:45 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Tejun Heo <tj@kernel.org>
Cc: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, schwidefsky@de.ibm.com, liqin.chen@sunplusct.com,
        lethal@linux-sh.org, davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, mingo@redhat.com,
        linux-mips@linux-mips.org
Subject: Re: [PATCH 19/23] mips: Use HAVE_MEMBLOCK_NODE_MAP
Message-ID: <20110803161745.GA13266@linux-mips.org>
References: <1311694534-5161-1-git-send-email-tj@kernel.org>
 <1311694534-5161-20-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311694534-5161-20-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 05:35:30PM +0200, Tejun Heo wrote:

> mips used early_node_map[] just to prime free_area_init_nodes().  Now
> memblock can be used for the same purpose and early_node_map[] is
> scheduled to be dropped.  Use memblock instead.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: linux-mips@linux-mips.org
> ---
> Only compile tested.  Thanks.
> 
>  arch/mips/Kconfig                |    3 +++
>  arch/mips/kernel/setup.c         |    3 ++-
>  arch/mips/sgi-ip27/ip27-memory.c |    5 +++--
>  3 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index 653da62..368b2ec 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -24,6 +24,9 @@ config MIPS
>  	select GENERIC_IRQ_PROBE
>  	select GENERIC_IRQ_SHOW
>  	select HAVE_ARCH_JUMP_LABEL
> +	select HAVE_MEMBLOCK

This means <linux/memblock.h> will include <asm/memblock.h> which does
not exist for MIPS.  Did you accidentally not post this new file?

  Ralf

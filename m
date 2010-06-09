Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab0FIK2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:28:24 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:33672 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476Ab0FIK2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:28:22 -0400
Date: Wed, 9 Jun 2010 06:28:15 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 4/5] Removing dead CONFIG_SERIAL_TEXT_DEBUG
Message-ID: <20100609102815.GG7801@zod.rchland.ibm.com>
References: <cover.1275925219.git.siccegge@cs.fau.de> <ddcbd960ff300073939bb0c6f20a38118c0875d4.1275925219.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ddcbd960ff300073939bb0c6f20a38118c0875d4.1275925219.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 09, 2010 at 12:00:46PM +0200, Christoph Egger wrote:
>CONFIG_SERIAL_TEXT_DEBUG doesn't exist in Kconfig, therefore removing all
>references for it from the source code.
>
>Signed-off-by: Christoph Egger <siccegge@cs.fau.de>

It would be better to conver this to work with CONFIG_PPC_EARLY_DEBUG and
CONFIG_PPC_EARLY_DEBUG_40x.  I'd rather just leave this for now until we can
get it switched over.

josh

>---
> arch/powerpc/kernel/head_40x.S |   19 -------------------
> 1 files changed, 0 insertions(+), 19 deletions(-)
>
>diff --git a/arch/powerpc/kernel/head_40x.S b/arch/powerpc/kernel/head_40x.S
>index a90625f..1a10e4d 100644
>--- a/arch/powerpc/kernel/head_40x.S
>+++ b/arch/powerpc/kernel/head_40x.S
>@@ -939,25 +939,6 @@ initial_mmu:
> 	tlbwe	r4,r0,TLB_DATA		/* Load the data portion of the entry */
> 	tlbwe	r3,r0,TLB_TAG		/* Load the tag portion of the entry */
>
>-#if defined(CONFIG_SERIAL_TEXT_DEBUG) && defined(SERIAL_DEBUG_IO_BASE)
>-
>-	/* Load a TLB entry for the UART, so that ppc4xx_progress() can use
>-	 * the UARTs nice and early.  We use a 4k real==virtual mapping. */
>-
>-	lis	r3,SERIAL_DEBUG_IO_BASE@h
>-	ori	r3,r3,SERIAL_DEBUG_IO_BASE@l
>-	mr	r4,r3
>-	clrrwi	r4,r4,12
>-	ori	r4,r4,(TLB_WR|TLB_I|TLB_M|TLB_G)
>-
>-	clrrwi	r3,r3,12
>-	ori	r3,r3,(TLB_VALID | TLB_PAGESZ(PAGESZ_4K))
>-
>-	li	r0,0			/* TLB slot 0 */
>-	tlbwe	r4,r0,TLB_DATA
>-	tlbwe	r3,r0,TLB_TAG
>-#endif /* CONFIG_SERIAL_DEBUG_TEXT && SERIAL_DEBUG_IO_BASE */
>-
> 	isync
>
> 	/* Establish the exception vector base
>-- 
>1.6.3.3
>
>_______________________________________________
>Linuxppc-dev mailing list
>Linuxppc-dev@lists.ozlabs.org
>https://lists.ozlabs.org/listinfo/linuxppc-dev

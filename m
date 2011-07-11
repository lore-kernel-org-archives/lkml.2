Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab1GKTjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 15:39:19 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:41987
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964832Ab1GKTjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 15:39:12 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bhz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
Date: Mon, 11 Jul 2011 14:38:59 -0500
From: Scott Wood <scottwood@freescale.com>
To: Fabio Baltieri <fabio.baltieri@gmail.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Poonam Aggrwal <poonam.aggrwal@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] powerpc/85xx: fix mpic configuration in CAMP mode
Message-ID: <20110711143859.0e6c95d8@schlenkerla.am.freescale.net>
In-Reply-To: <CABkP77e6vLmLxk3wCP39GJ7+yKnJZFc7BPUZ1OkdA8d7KkBCiw@mail.gmail.com>
References: <CABkP77e6vLmLxk3wCP39GJ7+yKnJZFc7BPUZ1OkdA8d7KkBCiw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jul 2011 20:55:32 +0200
Fabio Baltieri <fabio.baltieri@gmail.com> wrote:

> Change the string to check for CAMP mode boot on MPC85xx (eg. P2020) to match
> the one in the corresponding dts files (p2020rdb_camp_core{0,1}.dts).
> 
> Without this fix the mpic is configured as in the SMP boot mode, which causes
> the first core to report a protected source interrupt error for devices
> of the other core and lock up.
> 
> Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
> ---
>  arch/powerpc/platforms/85xx/mpc85xx_rdb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
> b/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
> index 088f30b..a1e5e70 100644
> --- a/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
> +++ b/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
> @@ -58,7 +58,7 @@ void __init mpc85xx_rdb_pic_init(void)
>  		return;
>  	}
> 
> -	if (of_flat_dt_is_compatible(root, "fsl,85XXRDB-CAMP")) {
> +	if (of_flat_dt_is_compatible(root, "fsl,MPC85XXRDB-CAMP")) {
>  		mpic = mpic_alloc(np, r.start,
>  			MPIC_PRIMARY |
>  			MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS,

Shouldn't we be setting MPIC_SINGLE_DEST_CPU in this case (as we do for
the other case)?

Or just drop this and specify pic-no-reset in the mpic node.

-Scott


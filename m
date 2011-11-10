Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935769Ab1KJQrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 11:47:47 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:38780
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932644Ab1KJQrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 11:47:46 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bhz2dh2a8h668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 10 Nov 2011 10:47:41 -0600
From: Scott Wood <scottwood@freescale.com>
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Baruch Siach <baruch@tkos.co.il>, Timur Tabi <B04825@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Shaohui Xie <b21989@freescale.com>
Subject: Re: [RFC PATCH 16/17] powerpc/e500: Make
 __setup_cpu_{e200,e500,e500mc,e5500} optional
Message-ID: <20111110164741.GC11983@schlenkerla.am.freescale.net>
References: <4E42AB6F.1050900@freescale.com>
 <1320883635-17194-17-git-send-email-Kyle.D.Moffett@boeing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1320883635-17194-17-git-send-email-Kyle.D.Moffett@boeing.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 07:07:14PM -0500, Kyle Moffett wrote:
> Only build the setup functions when the corresponding entries are
> included in the CPU table.
> 
> Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
> ---
>  arch/powerpc/kernel/cpu_setup_fsl_booke.S |   14 +++++++++++++-
>  1 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/cpu_setup_fsl_booke.S b/arch/powerpc/kernel/cpu_setup_fsl_booke.S
> index 8053db0..77721b2 100644
> --- a/arch/powerpc/kernel/cpu_setup_fsl_booke.S
> +++ b/arch/powerpc/kernel/cpu_setup_fsl_booke.S
> @@ -17,6 +17,8 @@
>  #include <asm/cputable.h>
>  #include <asm/ppc_asm.h>
>  
> +#if defined(CONFIG_FSL_E500_V1_V2) || defined(CONFIG_FSL_E500MC) \
> +		|| defined(CONFIG_FSL_E5500)

This seems like the kind of thing that CONFIG_E500 should be retained
for.

-Scott


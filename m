Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab1KKQvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 11:51:46 -0500
Received: from mxout1.idt.com ([157.165.5.25]:51463 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab1KKQvp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 11:51:45 -0500
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] fsl-rio: fix compile error
Date: Fri, 11 Nov 2011 08:49:45 -0800
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E55202490DDA@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <1321019308-7785-1-git-send-email-Gang.Liu@freescale.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] fsl-rio: fix compile error
Thread-Index: AcygeLVarahD4eCCSnGEFlm8mc+YcAAGLG4w
References: <1321019308-7785-1-git-send-email-Gang.Liu@freescale.com>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Liu Gang <Gang.Liu@freescale.com>, <linuxppc-dev@lists.ozlabs.org>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <paul.gortmaker@windriver.com>, <r58472@freescale.com>,
        <B11780@freescale.com>, <r61911@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 8:48 AM Liu Gang <Gang.Liu@freescale.com> wrote:

> Sent: Friday, November 11, 2011 8:48 AM
> To: linuxppc-dev@lists.ozlabs.org; Bounine, Alexandre
> Cc: akpm@linux-foundation.org; linux-kernel@vger.kernel.org;
> paul.gortmaker@windriver.com; r58472@freescale.com;
> B11780@freescale.com; r61911@freescale.com; Liu Gang
> Subject: [PATCH] fsl-rio: fix compile error
> 
> The "#include <linux/module.h>" was replaced by "#include
> <linux/export.h>"
> in the patch "powerpc: various straight conversions from module.h -->
> export.h".
> This will cause the following compile problem:
> arch/powerpc/sysdev/fsl_rio.c: In function 'fsl_rio_mcheck_exception':
> arch/powerpc/sysdev/fsl_rio.c:296: error: implicit declaration of
> function 'search_exception_tables'.
> 
> The file fsl_rio.c needs the declaration of function
> "search_exception_tables"
> in the header file "linux/module.h".
> 
> Signed-off-by: Liu Gang <Gang.Liu@freescale.com>
> ---
>  arch/powerpc/sysdev/fsl_rio.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/sysdev/fsl_rio.c
> b/arch/powerpc/sysdev/fsl_rio.c
> index de170fd..22ffccd 100644
> --- a/arch/powerpc/sysdev/fsl_rio.c
> +++ b/arch/powerpc/sysdev/fsl_rio.c
> @@ -23,7 +23,7 @@
>   */
> 
>  #include <linux/init.h>
> -#include <linux/export.h>
> +#include <linux/module.h>
>  #include <linux/types.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/interrupt.h>
> --
> 1.7.3.1
> 


Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>


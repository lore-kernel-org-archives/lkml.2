Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab1IANaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 09:30:39 -0400
Received: from mxout1.idt.com ([157.165.5.25]:46704 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757313Ab1IANai convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 09:30:38 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] fsl-rio: Release rapidio port I/O region resource if portfailed to initialize
Date: Thu, 1 Sep 2011 06:29:55 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E5520210DF01@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <1314870744-27325-1-git-send-email-Gang.Liu@freescale.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] fsl-rio: Release rapidio port I/O region resource if portfailed to initialize
Thread-Index: AcxopTwamG4taYG7SimZlQMwq7I+AwABR0MQ
References: <1314870744-27325-1-git-send-email-Gang.Liu@freescale.com>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Liu Gang <Gang.Liu@freescale.com>, <linuxppc-dev@lists.ozlabs.org>
CC: <r58472@freescale.com>, <r61911@freescale.com>,
        <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <B11780@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 01, 2011 5:52 AM
Liu Gang <Gang.Liu@freescale.com> wrote:

> Subject: [PATCH] fsl-rio: Release rapidio port I/O region resource if
> portfailed to initialize
> 
...
> 
> Signed-off-by: Liu Gang <Gang.Liu@freescale.com>
> ---
>  arch/powerpc/sysdev/fsl_rio.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/powerpc/sysdev/fsl_rio.c
> b/arch/powerpc/sysdev/fsl_rio.c
> index c65f75a..22ffccd 100644
> --- a/arch/powerpc/sysdev/fsl_rio.c
> +++ b/arch/powerpc/sysdev/fsl_rio.c
> @@ -1608,6 +1608,7 @@ int fsl_rio_setup(struct platform_device *dev)
>  	return 0;
>  err:
>  	iounmap(priv->regs_win);
> +	release_resource(&port->iores);
>  err_res:
>  	kfree(priv);
>  err_priv:
> --
> 1.7.3.1

Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>


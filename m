Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab0GWD7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 23:59:51 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:39037
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753701Ab0GWD7t convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 23:59:49 -0400
X-SpamScore: 0
X-BigFish: VS0(z37d5nz1432Nzz1202hzzz2dh2a8h65h)
X-Spam-TCS-SCL: 4:0
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] RapidIO,powerpc/85xx: remove MCSR_MASK in fsl_rio
Date: Fri, 23 Jul 2010 11:59:39 +0800
Message-ID: <F9BD3E0A8083BE4ABAA94D7EDD7E3F630BCA95@zch01exm26.fsl.freescale.net>
In-Reply-To: <1279730810-24926-1-git-send-email-alexandre.bounine@idt.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] RapidIO,powerpc/85xx: remove MCSR_MASK in fsl_rio
Thread-Index: Acspnu2PLA4tubk8TSKCaMzgvd96HgAe5Aaw
References: <1279730810-24926-1-git-send-email-alexandre.bounine@idt.com>
From: Li Yang-R58472 <r58472@freescale.com>
To: "Kumar Gala" <galak@kernel.crashing.org>,
        "Alexandre Bounine" <alexandre.bounine@idt.com>,
        <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@ozlabs.org>
X-Reverse-DNS: az33egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Subject: [PATCH] RapidIO,powerpc/85xx: remove MCSR_MASK in fsl_rio
>
>Fixes compile problem caused by MCSR_MASK removal from book-E definitions.

Hi Alex,

Only with your patch, there will still be problem on SRIO platforms other than MPC85xx.

I have posted a patch series to fix this together with several compatibility issues a month before.

http://patchwork.ozlabs.org/patch/56135/
http://patchwork.ozlabs.org/patch/56136/
http://patchwork.ozlabs.org/patch/56138/
http://patchwork.ozlabs.org/patch/56137/


Can anyone pick the patch series quickly as currently there is a compile error when SRIO is enabled.

- Leo

>
>Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
>Cc: Kumar Gala <galak@kernel.crashing.org>
>Cc: Grant Likely <grant.likely@secretlab.ca>
>Cc: Matt Porter <mporter@kernel.crashing.org>
>---
> arch/powerpc/sysdev/fsl_rio.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
>index 30e1626..c58df58 100644
>--- a/arch/powerpc/sysdev/fsl_rio.c
>+++ b/arch/powerpc/sysdev/fsl_rio.c
>@@ -245,7 +245,7 @@ static int (*saved_mcheck_exception)(struct pt_regs
>*regs);  static int fsl_rio_mcheck_exception(struct pt_regs *regs)  {
> 	const struct exception_table_entry *entry = NULL;
>-	unsigned long reason = (mfspr(SPRN_MCSR) & MCSR_MASK);
>+	unsigned long reason = mfspr(SPRN_MCSR);
>
> 	if (reason & MCSR_BUS_RBERR) {
> 		reason = in_be32((u32 *)(rio_regs_win + RIO_LTLEDCSR));



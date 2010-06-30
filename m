Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab0F3U4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 16:56:31 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41333 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab0F3U43 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 16:56:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=r0N6AOAg+TSvY2kPQPahldj4iRU9oUoSLtHA7JXG2QU4CR9O5GBhxAtr2aY99qUPZd
         tFS0ZWRAb9cmOgiZhTpNxsBjCJ/e/DQ1ccP5rZ/U40q1SJ1KwN92hqpOoppZ0tkqSB7/
         UlQtsvPSK7a0bYqufEmscfAi98w1+mfZIbK6U=
MIME-Version: 1.0
In-Reply-To: <20100308191005.GE4324@amak.tundra.com>
References: <20100308191005.GE4324@amak.tundra.com>
From: Timur Tabi <timur.tabi@gmail.com>
Date: Wed, 30 Jun 2010 15:55:58 -0500
Message-ID: <AANLkTine3pc2Ai2Woj81Y9fS_KgGs1sIMb2NMR6G74ww@mail.gmail.com>
Subject: Re: [PATCH v2 5/7] powerpc/85xx: Add MChk handler for SRIO port
To: Alexandre Bounine <abounine@tundra.com>
Cc: mporter@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org, thomas.moll@sysgo.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 8, 2010 at 2:10 PM, Alexandre Bounine <abounine@tundra.com> wrote:
>
> From: Alexandre Bounine <alexandre.bounine@idt.com>
>
> Add Machine Check exception handling into RapidIO port driver
> for Freescale SoCs (MPC85xx).
>
> Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
> Tested-by: Thomas Moll <thomas.moll@sysgo.com>
...

> +static int fsl_rio_mcheck_exception(struct pt_regs *regs)
> +{
> +       const struct exception_table_entry *entry = NULL;
> +       unsigned long reason = (mfspr(SPRN_MCSR) & MCSR_MASK);

MCSR_MASK is not defined anywhere, so when I compile this code, I get this:

  CC      arch/powerpc/sysdev/fsl_rio.o
arch/powerpc/sysdev/fsl_rio.c: In function 'fsl_rio_mcheck_exception':
arch/powerpc/sysdev/fsl_rio.c:248: error: 'MCSR_MASK' undeclared
(first use in this function)
arch/powerpc/sysdev/fsl_rio.c:248: error: (Each undeclared identifier
is reported only once
arch/powerpc/sysdev/fsl_rio.c:248: error: for each function it appears in.)

-- 
Timur Tabi
Linux kernel developer at Freescale

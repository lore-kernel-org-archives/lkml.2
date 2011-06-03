Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab1FCI3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 04:29:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37844 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752Ab1FCI25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 04:28:57 -0400
Date: Fri, 3 Jun 2011 10:28:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x66, UV: Enable 64-bit ACPI MFCG support for SGI UV2
 platform
Message-ID: <20110603082845.GC16694@elte.hu>
References: <20110602195943.GA27079@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110602195943.GA27079@sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jack Steiner <steiner@sgi.com> wrote:

> Enable 64-bit ACPI MFCG support for SGI UV2 platform. The check is similar
> to the check on UV1. UV2 has a different oem_id string.
> 
> Signed-off-by: Jack Steiner <steiner@sgi.com>
> 
> 
> ---
>  arch/x86/pci/mmconfig-shared.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux/arch/x86/pci/mmconfig-shared.c
> ===================================================================
> --- linux.orig/arch/x86/pci/mmconfig-shared.c	2011-05-31 12:13:19.635285219 -0500
> +++ linux/arch/x86/pci/mmconfig-shared.c	2011-06-02 14:41:26.645034257 -0500
> @@ -519,7 +519,8 @@ static int __init acpi_mcfg_check_entry(
>  	if (cfg->address < 0xFFFFFFFF)
>  		return 0;
>  
> -	if (!strcmp(mcfg->header.oem_id, "SGI"))
> +	if (!strcmp(mcfg->header.oem_id, "SGI") ||
> +	    		!strcmp(mcfg->header.oem_id, "SGI2"))

Wouldnt strncmp(,,3) cover any future SGI3, SGI4 strings as well?

Thanks,

	Ingo

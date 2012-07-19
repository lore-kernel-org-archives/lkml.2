Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab2GSPdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 11:33:24 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:21101 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab2GSPdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 11:33:23 -0400
Subject: Re: [PATCH] PCDP: use early_ioremap/early_iounmap to access pcdp
 table
From: Khalid Aziz <khalid.aziz@hp.com>
To: Greg Pearson <greg.pearson@hp.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1342649974-6860-1-git-send-email-greg.pearson@hp.com>
References: <1342649974-6860-1-git-send-email-greg.pearson@hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Jul 2012 09:33:22 -0600
Message-ID: <1342712002.13917.112.camel@lyra>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-18 at 16:19 -0600, Greg Pearson wrote:
> --- a/drivers/firmware/pcdp.c
> +++ b/drivers/firmware/pcdp.c
> @@ -95,7 +95,7 @@ efi_setup_pcdp_console(char *cmdline)
>  	if (efi.hcdp == EFI_INVALID_TABLE_ADDR)
>  		return -ENODEV;
>  
> -	pcdp = ioremap(efi.hcdp, 4096);
> +	pcdp = early_ioremap(efi.hcdp, 4096);

While we are fixing this code up, mapping 4K blindly just does not feel
right to me. Trouble here is that the length of PCDP table is buried in
the header for PCDP table and we can not read it unless we map the table
in. We get the address for PCDP table from the EFI system table which
was mapped in earlier and pointers to various tables were extracted at
that point. So this is a chicken and egg problem. Any ideas if we can do
better than blindly mapping 4K?

-- 
Khalid Aziz <khalid.aziz@hp.com>


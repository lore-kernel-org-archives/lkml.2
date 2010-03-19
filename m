Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab0CSVpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 17:45:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37973 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab0CSVpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 17:45:46 -0400
Message-ID: <4BA3F088.8040203@zytor.com>
Date: Fri, 19 Mar 2010 14:45:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] arch/x86/kernel/head_32.S Warning: shift count out
 of range (32 is not between 0 and 31)
References: <4BA2A45B.6060004@googlemail.com>
In-Reply-To: <4BA2A45B.6060004@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2010 03:08 PM, René Bolldorf wrote:
> Signed-off-by: Rene Bolldorf <xsecute@googlemail.com>
> 
> diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
> index 37c3d4b..8bfba5e 100644
> --- a/arch/x86/kernel/head_32.S
> +++ b/arch/x86/kernel/head_32.S
> @@ -62,7 +62,7 @@
> 
>   /* Enough space to fit pagetables for the low memory linear map */
>   MAPPING_BEYOND_END = \
> -	PAGE_TABLE_SIZE(((1<<32) - __PAGE_OFFSET) >> PAGE_SHIFT) << PAGE_SHIFT
> +	PAGE_TABLE_SIZE(((1<<31) - __PAGE_OFFSET) >> PAGE_SHIFT) << PAGE_SHIFT
> 
>   /*
>    * Worst-case size of the kernel mapping we need to make:

NAK... this is in fact doubly wrong... the assembler handles this case
just fine -- it's a .S file after all -- and the result is wrong.

If you want to change it change it to 0x100000000.

	-hpa

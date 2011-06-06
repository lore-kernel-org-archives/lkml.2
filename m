Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab1FFOHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 10:07:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948Ab1FFOH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 10:07:29 -0400
Message-ID: <4DECDF03.4070003@redhat.com>
Date: Mon, 06 Jun 2011 10:06:59 -0400
From: Peter Jones <pjones@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Connor Hansen <cmdkhh@gmail.com>
CC: konrad@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iscsi_ibft_find unused variable i
References: <1307270109-28635-1-git-send-email-cmdkhh@gmail.com>
In-Reply-To: <1307270109-28635-1-git-send-email-cmdkhh@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2011 06:35 AM, Connor Hansen wrote:
> int i is only needed if CONFIG_ACPI is set
> so move it within ifdef so kernels without ACPI
> dont allocate space for nothing. Fixes warning too.
> 
> Signed-off-by: Connor Hansen <cmdkhh@gmail.com>

Reasonable enough.

Signed-off-by: Peter Jones <pjones@redhat.com>

> ---
>  drivers/firmware/iscsi_ibft_find.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/firmware/iscsi_ibft_find.c b/drivers/firmware/iscsi_ibft_find.c
> index f032e44..c2bfa50 100644
> --- a/drivers/firmware/iscsi_ibft_find.c
> +++ b/drivers/firmware/iscsi_ibft_find.c
> @@ -108,10 +108,10 @@ done:
>   */
>  unsigned long __init find_ibft_region(unsigned long *sizep)
>  {
> -	int i;
>  	ibft_addr = NULL;
>  
>  #ifdef CONFIG_ACPI
> +	int i;
>  	for (i = 0; i < ARRAY_SIZE(ibft_signs) && !ibft_addr; i++)
>  		acpi_table_parse(ibft_signs[i].sign, acpi_find_ibft);
>  #endif /* CONFIG_ACPI */


-- 
        Peter

Space, is big. Really big. You just won't believe how vastly hugely
mindbogglingly big it is. I mean you may think it's a long way down the
road to the chemist, but that's just peanuts to space.
		-- The Hitchhiker's Guide to the Galaxy

01234567890123456789012345678901234567890123456789012345678901234567890123456789

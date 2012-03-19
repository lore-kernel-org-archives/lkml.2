Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab2CSWMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 18:12:25 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:42927 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757347Ab2CSWMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 18:12:22 -0400
Date: Mon, 19 Mar 2012 23:11:34 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-acpi@vger.kernel.org
cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] ACPI, psargs: Fix small mem leaks on error paths
In-Reply-To: <alpine.LNX.2.00.1202050210060.30244@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1203192311280.9012@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1202050210060.30244@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On Sun, 5 Feb 2012, Jesper Juhl wrote:

> As far as I can see, there are two small mem leaks in error paths of
> 'acpi_ps_get_next_field()' where we neglect to free the memory
> previously allocated to 'field'.
> 
> I believe this patch should fix the leaks.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/acpi/acpica/psargs.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
>  Note: Compile tested only.
> 
> diff --git a/drivers/acpi/acpica/psargs.c b/drivers/acpi/acpica/psargs.c
> index 5ac36ab..a683d66 100644
> --- a/drivers/acpi/acpica/psargs.c
> +++ b/drivers/acpi/acpica/psargs.c
> @@ -618,6 +618,7 @@ static union acpi_parse_object *acpi_ps_get_next_field(struct acpi_parse_state
>  
>  				arg = acpi_ps_alloc_op(AML_INT_BYTELIST_OP);
>  				if (!arg) {
> +					acpi_ps_free_op(field);
>  					return_PTR(NULL);
>  				}
>  
> @@ -662,6 +663,7 @@ static union acpi_parse_object *acpi_ps_get_next_field(struct acpi_parse_state
>  		} else {
>  			arg = acpi_ps_alloc_op(AML_INT_NAMEPATH_OP);
>  			if (!arg) {
> +				acpi_ps_free_op(field);
>  				return_PTR(NULL);
>  			}
>  
> 

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.


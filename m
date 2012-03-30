Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260Ab2C3HMP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 03:12:15 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:46452 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819Ab2C3HLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 03:11:47 -0400
Message-ID: <4F755CAC.9070209@kernel.org>
Date: Fri, 30 Mar 2012 03:11:40 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.14
MIME-Version: 1.0
To: Bob Moore <robert.moore@intel.com>
CC: Jesper Juhl <jj@chaosbits.net>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH] ACPI, psargs: Fix small mem leaks on error paths
References: <alpine.LNX.2.00.1202050210060.30244@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1202050210060.30244@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob?

On 02/04/2012 08:12 PM, Jesper Juhl wrote:

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



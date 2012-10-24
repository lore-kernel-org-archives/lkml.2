Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161478Ab2JXWL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:11:28 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:35752 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161273Ab2JXWLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:11:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, Lin Ming <ming.m.lin@intel.com>,
        Bob Moore <robert.moore@intel.com>
Subject: Re: [PATCH] ACPICA: Don't leak next_walk_state in acpi_ds_call_control_method()
Date: Thu, 25 Oct 2012 00:15:20 +0200
Message-ID: <2295104.eQ6lcDpNzT@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <alpine.LNX.2.00.1210212233180.26319@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1210212233180.26319@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 of October 2012 22:35:46 Jesper Juhl wrote:
> If acpi_ds_create_walk_state() succeeds, but the call to
> ACPI_ALLOCATE_ZEROED() fails, then we'll return from the function
> without properly freeing 'next_walk_state'.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

This has to go through ACPICA upstream, but we'll get it from there eventually.

Thanks,
Rafael


> ---
>  drivers/acpi/acpica/dsmethod.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/acpica/dsmethod.c b/drivers/acpi/acpica/dsmethod.c
> index aa9a5d4..ade59a3 100644
> --- a/drivers/acpi/acpica/dsmethod.c
> +++ b/drivers/acpi/acpica/dsmethod.c
> @@ -378,7 +378,8 @@ acpi_ds_call_control_method(struct acpi_thread_state *thread,
>  	 */
>  	info = ACPI_ALLOCATE_ZEROED(sizeof(struct acpi_evaluate_info));
>  	if (!info) {
> -		return_ACPI_STATUS(AE_NO_MEMORY);
> +		status = AE_NO_MEMORY;
> +		goto cleanup;
>  	}
>  
>  	info->parameters = &this_walk_state->operands[0];
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

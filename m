Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab1APTsv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 14:48:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39869 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab1APTsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 14:48:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesper Juhl <jj@chaosbits.net>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] ACPI: Fix memory leak in acpi_ev_asynch_execute_gpe_method().
Date: Sun, 16 Jan 2011 20:48:29 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lin Ming <ming.m.lin@intel.com>
References: <alpine.LNX.2.00.1101162033531.13377@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1101162033531.13377@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101162048.29781.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 16, 2011, Jesper Juhl wrote:
> We will leak the memory allocated to 'local_gpe_event_info' if 
> 'acpi_ut_acquire_mutex()' fails or if 'acpi_ev_valid_gpe_event()' fails in 
> drivers/acpi/acpica/evgpe.c::acpi_ev_asynch_execute_gpe_method().
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Good catch!  How did you find it?

Reviewed-by: Rafael Wysocki <rjw@sisk.pl>

Len, please apply and push to Linus ASAP.

Thanks,
Rafael


> ---
>  evgpe.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/acpi/acpica/evgpe.c b/drivers/acpi/acpica/evgpe.c
> index 7c339d3..b6de1fb 100644
> --- a/drivers/acpi/acpica/evgpe.c
> +++ b/drivers/acpi/acpica/evgpe.c
> @@ -471,6 +471,7 @@ static void ACPI_SYSTEM_XFACE acpi_ev_asynch_execute_gpe_method(void *context)
>  
>  	status = acpi_ut_acquire_mutex(ACPI_MTX_EVENTS);
>  	if (ACPI_FAILURE(status)) {
> +		ACPI_FREE(local_gpe_event_info);
>  		return_VOID;
>  	}
>  
> @@ -478,6 +479,7 @@ static void ACPI_SYSTEM_XFACE acpi_ev_asynch_execute_gpe_method(void *context)
>  
>  	if (!acpi_ev_valid_gpe_event(gpe_event_info)) {
>  		status = acpi_ut_release_mutex(ACPI_MTX_EVENTS);
> +		ACPI_FREE(local_gpe_event_info);
>  		return_VOID;
>  	}
>  
> 
> 


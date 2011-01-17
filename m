Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab1AQBqr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 20:46:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:14051 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729Ab1AQBqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 20:46:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,331,1291622400"; 
   d="scan'208";a="877992783"
Subject: Re: [PATCH] ACPI: Fix memory leak in
 acpi_ev_asynch_execute_gpe_method().
From: Lin Ming <ming.m.lin@intel.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>
In-Reply-To: <alpine.LNX.2.00.1101162033531.13377@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101162033531.13377@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jan 2011 09:47:11 +0800
Message-ID: <1295228831.28388.84.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-17 at 03:37 +0800, Jesper Juhl wrote:
> We will leak the memory allocated to 'local_gpe_event_info' if 
> 'acpi_ut_acquire_mutex()' fails or if 'acpi_ev_valid_gpe_event()' fails in 
> drivers/acpi/acpica/evgpe.c::acpi_ev_asynch_execute_gpe_method().
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
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

Acked-by: Lin Ming <ming.m.lin@intel.com>

Thanks.



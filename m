Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab1GPXpI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 19:45:08 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:52180 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753033Ab1GPXpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 19:45:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=guWZn1ROjZHIxtXI4OppoaTNxfAm4xl06MLngrg4qmp0EET4gdpT7myfbhqBXNi06FXah1WFZjokMoiHhwpSXEDZAu2apA9BGYtHgXOCv703ZV4vMKXakSVnVQpVqQ5r;
Date: Sat, 16 Jul 2011 16:45:03 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Len Brown <lenb@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-acpi@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI: APEI build fix
Message-Id: <20110716164503.0ee2dc3d.rdunlap@xenotime.net>
In-Reply-To: <alpine.LFD.2.02.1107161815220.4339@x980>
References: <20110717000815.c83755be9598d34ac8431908@canb.auug.org.au>
	<20110716120304.83d79985.rdunlap@xenotime.net>
	<alpine.LFD.2.02.1107161815220.4339@x980>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jul 2011 18:16:20 -0400 (EDT) Len Brown wrote:

> From: Len Brown <len.brown@intel.com>
> 
> as GHES is optional...
> 
> When # CONFIG_ACPI_APEI_GHES is not set:
> 
> (.init.text+0x4c22): undefined reference to `ghes_disable'
> 
> Signed-off-by: Len Brown <len.brown@intel.com>

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  drivers/acpi/bus.c  |    2 --
>  include/acpi/apei.h |    4 ++++
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> index 43ce3b0..437ddbf 100644
> --- a/drivers/acpi/bus.c
> +++ b/drivers/acpi/bus.c
> @@ -544,10 +544,8 @@ static void acpi_bus_osc_support(void)
>  	capbuf[OSC_SUPPORT_TYPE] |= OSC_SB_PPC_OST_SUPPORT;
>  #endif
>  
> -#ifdef CONFIG_ACPI_APEI_GHES
>  	if (!ghes_disable)
>  		capbuf[OSC_SUPPORT_TYPE] |= OSC_SB_APEI_SUPPORT;
> -#endif
>  	if (ACPI_FAILURE(acpi_get_handle(NULL, "\\_SB", &handle)))
>  		return;
>  	if (ACPI_SUCCESS(acpi_run_osc(handle, &context))) {
> diff --git a/include/acpi/apei.h b/include/acpi/apei.h
> index d40bc55..51a527d 100644
> --- a/include/acpi/apei.h
> +++ b/include/acpi/apei.h
> @@ -18,7 +18,11 @@
>  
>  extern int hest_disable;
>  extern int erst_disable;
> +#ifdef CONFIG_ACPI_APEI_GHES
>  extern int ghes_disable;
> +#else
> +#define ghes_disable 1
> +#endif
>  
>  #ifdef CONFIG_ACPI_APEI
>  void __init acpi_hest_init(void);
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

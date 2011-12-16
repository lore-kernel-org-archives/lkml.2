Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759925Ab1LPAWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 19:22:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43002 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971Ab1LPAWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 19:22:39 -0500
From: Thomas Renninger <trenn@suse.de>
To: Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH 1/4] ACPI: EC: Add ec_get_handle()
Date: Fri, 16 Dec 2011 01:22:35 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5-5.99.12.5343e5f-desktop; KDE/4.4.4; x86_64; ; )
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
        Azael Avalos <coproscefalo@gmail.com>,
        platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
References: <1323972371-13189-1-git-send-email-seth.forshee@canonical.com> <1323972371-13189-2-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1323972371-13189-2-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201112160122.36100.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 December 2011 19:06:08 Seth Forshee wrote:
> toshiba_acpi needs to execute an AML method within the EC namespace
> to make hotkeys work on some platforms. Provide an interface to
> allow it to easily get a handle to the EC namespace for this purpose.
I first liked the idea of making the ec device more global for others
to access.
But thinkpad_acpi is doing the same already in another way.

I think best is to move the thinkpad implementation of getting
ACPI handles based on HIDs to osl.c and make it global.
I'll send patches.
Please review them carefully, they are only compile tested.

      Thomas

> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  drivers/acpi/ec.c    |   10 ++++++++++
>  include/linux/acpi.h |    1 +
>  2 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
> index b19a18d..e37615f 100644
> --- a/drivers/acpi/ec.c
> +++ b/drivers/acpi/ec.c
> @@ -445,6 +445,16 @@ int ec_transaction(u8 command,
>  
>  EXPORT_SYMBOL(ec_transaction);
>  
> +/* Get the handle to the EC device */
> +acpi_handle ec_get_handle(void)
> +{
> +	if (!first_ec)
> +		return NULL;
> +	return first_ec->handle;
> +}
> +
> +EXPORT_SYMBOL(ec_get_handle);
> +
>  void acpi_ec_block_transactions(void)
>  {
>  	struct acpi_ec *ec = first_ec;
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index 6001b4da..ecccbb7 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -151,6 +151,7 @@ extern int ec_write(u8 addr, u8 val);
>  extern int ec_transaction(u8 command,
>                            const u8 *wdata, unsigned wdata_len,
>                            u8 *rdata, unsigned rdata_len);
> +extern acpi_handle ec_get_handle(void);
>  
>  #if defined(CONFIG_ACPI_WMI) || defined(CONFIG_ACPI_WMI_MODULE)
>  
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


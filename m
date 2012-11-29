Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab2K2Sdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 13:33:46 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:24984 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab2K2Sdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 13:33:44 -0500
Message-ID: <1354213519.26955.447.camel@misato.fc.hp.com>
Subject: Re: [PATCH 1/5] ACPI dock: remove unnecessary newline from
 exception message
From: Toshi Kani <toshi.kani@hp.com>
To: Colin King <colin.king@canonical.com>
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 29 Nov 2012 11:25:19 -0700
In-Reply-To: <1354189996-14431-2-git-send-email-colin.king@canonical.com>
References: <1354189996-14431-1-git-send-email-colin.king@canonical.com>
	 <1354189996-14431-2-git-send-email-colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-29 at 11:53 +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> ACPI_EXCEPTION() already appends a newline, so there is no
> need for the failed _DCK messaged to include one too.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/acpi/dock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
> index 88eb143..a873c6b 100644
> --- a/drivers/acpi/dock.c
> +++ b/drivers/acpi/dock.c
> @@ -475,7 +475,7 @@ static void handle_dock(struct dock_station *ds, int dock)
>  	status = acpi_evaluate_object(ds->handle, "_DCK", &arg_list, &buffer);
>  	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND)
>  		ACPI_EXCEPTION((AE_INFO, status, "%s - failed to execute"
> -			" _DCK\n", (char *)name_buffer.pointer));
> +			" _DCK", (char *)name_buffer.pointer));

Hi Colin,

In Rafael's linux-pm tree, this message has been changed to the
following.  So, this patch is not necessary.

 if (ACPI_FAILURE(status) && status != AE_NOT_FOUND)
         acpi_handle_err(ds->handle, "Failed to execute _DCK (0x%x)\n",
                         status);

Thanks,
-Toshi


>  
>  	kfree(buffer.pointer);
>  	kfree(name_buffer.pointer);



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab0LIWlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 17:41:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42097 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab0LIWlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 17:41:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 2/3] ACPICA: Fix access width for reset vector
Date: Thu, 9 Dec 2010 23:41:06 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5+; KDE/4.4.4; x86_64; ; )
Cc: x86@kernel.org, hpa@zytor.com, linux-acpi@vger.kernel.org, lenb@kernel.org,
        linux-kernel@vger.kernel.org
References: <1291931204-5854-1-git-send-email-mjg@redhat.com> <1291931204-5854-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1291931204-5854-2-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201012092341.06913.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 09, 2010, Matthew Garrett wrote:
> Section 4.7.3.6 of the ACPI specification requires that the register width
> of the reset vector be 8 bits. Windows simply hardcodes the access to be
> a byte and ignores the width provided in the FADT, so make sure that we
> do the same.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
>  drivers/acpi/acpica/hwxface.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/acpica/hwxface.c b/drivers/acpi/acpica/hwxface.c
> index 50cc3be..c6a4e63 100644
> --- a/drivers/acpi/acpica/hwxface.c
> +++ b/drivers/acpi/acpica/hwxface.c
> @@ -82,12 +82,11 @@ acpi_status acpi_reset(void)
>  		/*
>  		 * For I/O space, write directly to the OSL. This bypasses the port
>  		 * validation mechanism, which may block a valid write to the reset
> -		 * register.
> +		 * register. Spec section 4.7.3.6 requires register width to be 8.
>  		 */
>  		status =
>  		    acpi_os_write_port((acpi_io_address) reset_reg->address,
> -				       acpi_gbl_FADT.reset_value,
> -				       reset_reg->bit_width);
> +				       acpi_gbl_FADT.reset_value, 8)
>  	} else {
>  		/* Write the reset value to the reset register */
>  
> 


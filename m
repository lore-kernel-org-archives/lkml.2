Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab2GJHkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 03:40:22 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54809 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab2GJHkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 03:40:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAH5vBdLJqoB7x_r-8USiduK1tYPrfrXzqhtzGmg8U9VdQHEnEg@mail.gmail.com>
References: <CAH5vBdLJqoB7x_r-8USiduK1tYPrfrXzqhtzGmg8U9VdQHEnEg@mail.gmail.com>
Date: Tue, 10 Jul 2012 00:40:16 -0700
Message-ID: <CAH5vBdKbiZTL_o3tKKk55oyuzyufaeiSr1PgXKrUj6FgPmFMmw@mail.gmail.com>
Subject: Re: acpi: remove unused LIST_HEAD(acpi_device_list) && more static analysis
From: cheng renquan <crquan@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 12:00 AM, cheng renquan <crquan@gmail.com> wrote:
> $ git diff HEAD -- drivers/acpi/scan.c
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 85cbfdc..7d26ae0 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -28,7 +28,7 @@ extern struct acpi_device *acpi_root;
>
>  static const char *dummy_hid = "device";
>
> -static LIST_HEAD(acpi_device_list);
>  static LIST_HEAD(acpi_bus_id_list);
>  DEFINE_MUTEX(acpi_device_lock);
>  LIST_HEAD(acpi_wakeup_device_list);

fortunately a later step of gcc optimization deleted that variable
so it doesn't consume space in the final vmlinux, only the really in-use
variable like the next acpi_bus_id_list consumed space;

$ eu-readelf -s drivers/acpi/scan.o |egrep '(acpi_device_list|acpi_bus_id_list)'
   35: 00000000000000b0     16 OBJECT  LOCAL  DEFAULT        3 acpi_bus_id_list

$ eu-readelf -s vmlinux |egrep '(acpi_device_list|acpi_bus_id_list)'
24029: ffffffff81a62bc0     16 OBJECT  LOCAL  DEFAULT       15 acpi_bus_id_list


anyway, we'd better to delete the acpi_device_list from the source;

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab1CaGle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 02:41:34 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:35776 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386Ab1CaGld (ORCPT
	<rfc822;groupwise-jlee@novell.com:4:1>);
	Thu, 31 Mar 2011 02:41:33 -0400
Message-Id: <4D94BCC7020000230002AA34@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Thu, 31 Mar 2011 00:41:27 -0600
From: "Joey Lee" <jlee@novell.com>
To: <randy.dunlap@oracle.com>
Cc: <torvalds@linux-foundation.org>, <mjg@redhat.com>,
        <linux-kernel@vger.kernel.org>, <platform-driver-x86@vger.kernel.org>
Subject: Re: [PATCH -rc1] msi-laptop: fix config-dependent build error
References: <AANLkTikwbY5mm10ZWg7B6XeSBkZXFqKcYVZfJCi2QGx_@mail.gmail.com>
 <20110330152022.9b3e6942.randy.dunlap@oracle.com>
In-Reply-To: <20110330152022.9b3e6942.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 三，2011-03-30 於 15:20 -0700，Randy Dunlap 提到：
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> The msi-laptop driver uses input_*() and sparse_keymap_*() interfaces.
> It should depend on the INPUT subsystem being present and select
> INPUT_SPARSEKMAP so that those interfaces are present.
> 
> ERROR: "input_free_device" [drivers/platform/x86/msi-laptop.ko] undefined!
> ERROR: "input_register_device" [drivers/platform/x86/msi-laptop.ko] undefined!
> ERROR: "sparse_keymap_setup" [drivers/platform/x86/msi-laptop.ko] undefined!
> ERROR: "input_allocate_device" [drivers/platform/x86/msi-laptop.ko] undefined!
> ERROR: "sparse_keymap_report_event" [drivers/platform/x86/msi-laptop.ko] undefined!
> ERROR: "input_unregister_device" [drivers/platform/x86/msi-laptop.ko] undefined!
> ERROR: "sparse_keymap_free" [drivers/platform/x86/msi-laptop.ko] undefined!
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: "Lee, Chun-Yi" <jlee@novell.com>
> ---
>  drivers/platform/x86/Kconfig |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- lnx-2639-rc1.orig/drivers/platform/x86/Kconfig
> +++ lnx-2639-rc1/drivers/platform/x86/Kconfig
> @@ -187,7 +187,8 @@ config MSI_LAPTOP
>  	depends on ACPI
>  	depends on BACKLIGHT_CLASS_DEVICE
>  	depends on RFKILL
> -	depends on SERIO_I8042
> +	depends on INPUT && SERIO_I8042
> +	select INPUT_SPARSEKMAP
>  	---help---
>  	  This is a driver for laptops built by MSI (MICRO-STAR
>  	  INTERNATIONAL):
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thank's, it's good to me!

Acked-by: "Lee, Chun-Yi" <jlee@novell.com>


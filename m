Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab2KTVKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 16:10:40 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:33579 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752206Ab2KTVKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 16:10:38 -0500
Message-ID: <1353445837.17819.20.camel@joe-AO722>
Subject: Re: [PATCH v6 1/5] ACPI: Add acpi_handle_<level>() interfaces
From: Joe Perches <joe@perches.com>
To: Toshi Kani <toshi.kani@hp.com>
Cc: linux-acpi@vger.kernel.org, rjw@sisk.pl, lenb@kernel.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, vijaymohan.pandarathil@hp.com
Date: Tue, 20 Nov 2012 13:10:37 -0800
In-Reply-To: <1353444294-25575-2-git-send-email-toshi.kani@hp.com>
References: <1353444294-25575-1-git-send-email-toshi.kani@hp.com>
	 <1353444294-25575-2-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-20 at 13:44 -0700, Toshi Kani wrote:
> This interface acquires the global namespace
> mutex and may not be called from interrupt context.
[]
> diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
[]
> +/**
> + * acpi_handle_printk: Print message with ACPI prefix and object path
> + *
> + * This function is called through acpi_handle_<level> macros and prints
> + * a message with ACPI prefix and object path.  This function acquires
> + * the global namespace mutex and may not be called from interrupt context.
> + */
> +void
> +acpi_handle_printk(const char *level, acpi_handle handle, const char *fmt, ...)
> +{
[]
> +	ret = acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
> +	if (ret == AE_OK)
> +		path = buffer.pointer;
> +	else
> +		path = "<n/a>";

Perhaps:
	if (in_interrupt() ||
	    acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer) != AE_OK)
		path = "<n/a>";
	else
		path = buffer.pointer;

so that any interrupt context still works, just
not printing the correct acpi_get_name;



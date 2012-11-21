Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab2KUBZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 20:25:46 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:5438 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab2KUBZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 20:25:45 -0500
Message-ID: <1353460648.10939.133.camel@misato.fc.hp.com>
Subject: Re: [PATCH v7 1/5] ACPI: Add acpi_handle_<level>() interfaces
From: Toshi Kani <toshi.kani@hp.com>
To: Joe Perches <joe@perches.com>, rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, linux-acpi@vger.kernel.org
Date: Tue, 20 Nov 2012 18:17:28 -0700
In-Reply-To: <1353456074.17819.43.camel@joe-AO722>
References: <1353454950-17010-1-git-send-email-toshi.kani@hp.com>
	 <1353454950-17010-2-git-send-email-toshi.kani@hp.com>
	 <1353456074.17819.43.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-20 at 16:01 -0800, Joe Perches wrote:
> On Tue, 2012-11-20 at 16:42 -0700, Toshi Kani wrote:
> > This patch introduces acpi_handle_<level>(), where <level> is
> > a kernel message level such as err/warn/info, to support improved
> > logging messages for ACPI, esp. hot-plug operations.
> > acpi_handle_<level>() appends "ACPI" prefix and ACPI object path
> > to the messages.  This improves diagnosis of hotplug operations
> > since an error message in a log file identifies an object that
> > caused an issue.  This interface acquires the global namespace
> > mutex and is not suitable for interrupt context.
> 
> Old commit log? Maybe edit out the unsuitable for interrupt
> to "shows n/a in interrupt"?

Hi Joe,

I changed the descriptions from "may not be called from interrupt
context" to "is not suitable for interrupt context".  But, I agree with
you that it is clear to state how the interface behaves in interrupt
context.  So, I will update the description to the following:

"This interface acquires the global namespace mutex to obtain an object
path.  In interrupt context, it shows the object path as <n/a>."


Hi Rafael,

Instead of sending the whole series again, I will only send an updated
patch 1/5 since it only updates its descriptions.  The updated patch
will be labeled as "[PATCH v7-1 1/5]".


Thanks,
-Toshi



> diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
[]
> +
> +/**
> + * acpi_handle_printk: Print message with ACPI prefix and object path
> + *
> + * This function is called through acpi_handle_<level> macros and
prints
> + * a message with ACPI prefix and object path.  This function
acquires
> + * the global namespace mutex and is not suitable for interrupt
context.

Old text here too?

> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
[]
> +/*
> + * acpi_handle_<level>: Print message with ACPI prefix and object
path
> + * 
> + * These interfaces acquire the global namespace mutex and are not
> + * suitable for interrupt context.

Here three?


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab0CSMZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 08:25:52 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:35638 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042Ab0CSMZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 08:25:51 -0400
Message-ID: <4BA36D49.7080703@bfs.de>
Date: Fri, 19 Mar 2010 13:25:45 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, Shaohua Li <shaohua.li@intel.com>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Chen Gong <gong.chen@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] acpi_pad: "processor_aggregator" name too long
References: <20100319114806.GN5331@bicker>
In-Reply-To: <20100319114806.GN5331@bicker>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dan Carpenter schrieb:
> cpi_device_class can only be 19 characters and a NULL terminator.
> 
> With the current name we get a buffer overflow in acpi_pad_add()
>         strcpy(acpi_device_class(device), ACPI_PROCESSOR_AGGREGATOR_CLASS);
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> Feel free to pick your own name if you don't like mine.  :)
> 
> 
> diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
> index 7e52295..2db89d9 100644
> --- a/drivers/acpi/acpi_pad.c
> +++ b/drivers/acpi/acpi_pad.c
> @@ -30,7 +30,7 @@
>  #include <acpi/acpi_bus.h>
>  #include <acpi/acpi_drivers.h>
>  
> -#define ACPI_PROCESSOR_AGGREGATOR_CLASS	"processor_aggregator"
> +#define ACPI_PROCESSOR_AGGREGATOR_CLASS	"proc_aggregator"
>  #define ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME "Processor Aggregator"
>  #define ACPI_PROCESSOR_AGGREGATOR_NOTIFY 0x80
>  static DEFINE_MUTEX(isolated_cpus_lock);


Hi Dan,
IMHO this does not solve the core problem. acpi should use kstrncpy or better a pointer.
The next guy that use "my_great_indentifier_is_longer_than_yours" will cause the same
problem.
But this is something that the acpi group needs to answer (fast).

re,
 wh


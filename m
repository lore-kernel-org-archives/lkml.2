Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab0CWQ0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 12:26:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38871 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075Ab0CWQ0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 12:26:12 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Dan Carpenter <error27@gmail.com>
Subject: Re: [patch] power_meter: acpi_device_class "power_meter_resource" too long
Date: Tue, 23 Mar 2010 17:26:07 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, "Darrick J. Wong" <djwong@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
       Lin Ming <ming.m.lin@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20100319114920.GP5331@bicker>
In-Reply-To: <20100319114920.GP5331@bicker>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003231726.07480.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 March 2010 12:49:20 Dan Carpenter wrote:
> acpi_device_class can only be 19 characters and a NULL terminator.
> 
> The current code has a buffer overflow in acpi_power_meter_add():
>        strcpy(acpi_device_class(device), ACPI_POWER_METER_CLASS);
Sounds as if it would be worth to add:
CC: stable@kernel.org
?
Same for processor_aggregator.

     Thomas
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> Feel free to change the name to anything you like.
> 
> diff --git a/drivers/acpi/power_meter.c b/drivers/acpi/power_meter.c
> index 834c5af..31baa1e 100644
> --- a/drivers/acpi/power_meter.c
> +++ b/drivers/acpi/power_meter.c
> @@ -34,7 +34,7 @@
>  #define ACPI_POWER_METER_NAME		"power_meter"
>  ACPI_MODULE_NAME(ACPI_POWER_METER_NAME);
>  #define ACPI_POWER_METER_DEVICE_NAME	"Power Meter"
> -#define ACPI_POWER_METER_CLASS		"power_meter_resource"
> +#define ACPI_POWER_METER_CLASS		"pwr_meter_resource"
>  
>  #define NUM_SENSORS			17
>  
> --

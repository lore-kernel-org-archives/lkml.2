Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab2GRV17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 17:27:59 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46833 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753394Ab2GRV16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 17:27:58 -0400
Message-ID: <1342646876.2215.6.camel@joe2Laptop>
Subject: Re: [PATCH 1/4] ACPI: Add acpi_pr_<level>() interfaces
From: Joe Perches <joe@perches.com>
To: Toshi Kani <toshi.kani@hp.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, prarit@redhat.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com
Date: Wed, 18 Jul 2012 14:27:56 -0700
In-Reply-To: <1342644027-19559-2-git-send-email-toshi.kani@hp.com>
References: <1342644027-19559-1-git-send-email-toshi.kani@hp.com>
	 <1342644027-19559-2-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-18 at 14:40 -0600, Toshi Kani wrote:
> This patch introduces acpi_pr_<level>(), where <level> is a message
> level such as err/warn/info, to support improved logging messages
> for ACPI, esp. in hotplug operations.

One more note:

> diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
[]
> @@ -454,3 +454,35 @@ acpi_evaluate_hotplug_ost(acpi_handle handle, u32 source_event,
[]
> +void
> +acpi_printk(const char *level, acpi_handle handle, const char *fmt, ...)
[]
> +	struct acpi_buffer buffer = {ACPI_ALLOCATE_BUFFER};
[]
> +	ret = acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
[]
> +	kfree(buffer.pointer);

There's a failure mode here because buffer.pointer
isn't guaranteed to be initialized or set to NULL.



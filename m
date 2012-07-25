Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125Ab2GYDqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:46:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42750 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932928Ab2GYDp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:45:59 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <500F6BE3.8060508@jp.fujitsu.com>
Date: Wed, 25 Jul 2012 12:45:39 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <lenb@kernel.org>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bhelgaas@google.com>,
        <liuj97@gmail.com>, <srivatsa.bhat@linux.vnet.ibm.com>,
        <prarit@redhat.com>, <imammedo@redhat.com>,
        <vijaymohan.pandarathil@hp.com>
Subject: Re: [PATCH 0/4] ACPI: hotplug messages improvement
References: <1342644027-19559-1-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1342644027-19559-1-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Toshi,

2012/07/19 5:40, Toshi Kani wrote:
> This patchset improves logging messages for ACPI CPU, Memory, and
> Container hotplug notify handlers.  The patchset introduces a set of
> new macro interfaces, acpi_pr_<level>(), and updates the notify
> handlers to use them.  acpi_pr_<level>() appends "ACPI" prefix and
> ACPI object path to the messages.  This improves diagnostics in
> hotplug operations since it identifies an object that caused an
> issue in a log file.
>

The log message looks good to me.
But I could not understand when to use it instead of pr_{warn, info, ...}
or ACPI_{WARNING, INFO, ...}. Do you have the policy?

> ---
> This patchset applies on top of the patch below.
> 
> [PATCH] ACPI: Add ACPI CPU hot-remove support
> http://marc.info/?l=linux-acpi&m=134098193327362&w=2
> 
> ---
> Toshi Kani (4):
>   ACPI: Add acpi_pr_<level>() interfaces
>   ACPI: Update CPU hotplug messages
>   ACPI: Update Memory hotplug messages
>   ACPI: Update Container hotplug messages

I think you need update other component, which are driver/acpi/{acpi_pad.c,
battery.c, button.c}. Do you have the plan to update them?

Thanks,
Yasuaki Ishimatsu

> ---
>   drivers/acpi/acpi_memhotplug.c  |   24 ++++++++++++------------
>   drivers/acpi/container.c        |    6 +++---
>   drivers/acpi/processor_driver.c |   36 +++++++++++++++++++++---------------
>   drivers/acpi/utils.c            |   32 ++++++++++++++++++++++++++++++++
>   include/acpi/acpi_bus.h         |   18 ++++++++++++++++++
>   5 files changed, 86 insertions(+), 30 deletions(-)
> 



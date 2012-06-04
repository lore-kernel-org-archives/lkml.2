Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab2FDWPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 18:15:40 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41414 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753746Ab2FDWPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 18:15:39 -0400
Message-ID: <1338848137.18442.2.camel@joe2Laptop>
Subject: Re: [PATCH 1/2] iommu: dmar: replace printks with appropriate pr_*()
From: Joe Perches <joe@perches.com>
To: Donald Dutile <ddutile@redhat.com>
Cc: dwmw2@infradead.org, iommu@lists.linux-foundation.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org, chrisw@redhat.com,
        suresh.b.siddha@intel.com
Date: Mon, 04 Jun 2012 15:15:37 -0700
In-Reply-To: <1338845342-12464-2-git-send-email-ddutile@redhat.com>
References: <1338845342-12464-1-git-send-email-ddutile@redhat.com>
	 <1338845342-12464-2-git-send-email-ddutile@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 17:29 -0400, Donald Dutile wrote:
> Replace printk(KERN_*  with pr_*() functions.

Please add
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
before any include and remove the embedded PREFIX
from each printk

> diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c

[]

>  			break;
>  		}
>  		pdev = pci_get_slot(bus, PCI_DEVFN(path->dev, path->fn));
>  		if (!pdev) {
> -			printk(KERN_WARNING PREFIX
> -			"Device scope device [%04x:%02x:%02x.%02x] not found\n",
> +			pr_warn(PREFIX "Device scope device"
> +				"[%04x:%02x:%02x.%02x] not found\n",
>  				segment, bus->number, path->dev, path->fn);

Please don't split any format string.  You removed
a space between the scope device and an open bracket.
It's OK for format strings to exceed 80 chars.



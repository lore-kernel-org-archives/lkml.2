Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab2KPVji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 16:39:38 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:49667 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674Ab2KPVjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 16:39:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
Cc: linux-acpi@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        wency@cn.fujitsu.com, lenb@kernel.org, toshi.kani@hp.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH v2 0/3] acpi: Introduce prepare_remove device operation
Date: Fri, 16 Nov 2012 22:43:59 +0100
Message-ID: <1446291.TgLDtXqY7q@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc5; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1352974970-6643-1-git-send-email-vasilis.liaskovitis@profitbricks.com>
References: <1352974970-6643-1-git-send-email-vasilis.liaskovitis@profitbricks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 15, 2012 11:22:47 AM Vasilis Liaskovitis wrote:
> As discussed in https://patchwork.kernel.org/patch/1581581/
> the driver core remove function needs to always succeed. This means we need
> to know that the device can be successfully removed before acpi_bus_trim / 
> acpi_bus_hot_remove_device are called. This can cause panics when OSPM-initiated
> eject or driver unbind of memory devices fails e.g with:
> 
> echo 1 >/sys/bus/pci/devices/PNP0C80:XX/eject
> echo "PNP0C80:XX" > /sys/bus/acpi/drivers/acpi_memhotplug/unbind
> 
> since the ACPI core goes ahead and ejects the device regardless of whether the
> the memory is still in use or not.

So the question is, does the ACPI core have to do that and if so, then why?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

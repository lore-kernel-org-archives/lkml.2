Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945940Ab2KNXIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 18:08:35 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:44541 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933195Ab2KNXIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 18:08:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>, linux-acpi@vger.kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, lenb@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC PATCH 0/3] acpi: Introduce prepare_remove device operation
Date: Thu, 15 Nov 2012 00:12:55 +0100
Message-ID: <1647704.U9gX6ykHyh@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc5; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20121112172046.GA4931@dhcp-192-168-178-175.profitbricks.localdomain>
References: <1352399371-8015-1-git-send-email-vasilis.liaskovitis@profitbricks.com> <50A07477.2050002@cn.fujitsu.com> <20121112172046.GA4931@dhcp-192-168-178-175.profitbricks.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 12, 2012 06:20:47 PM Vasilis Liaskovitis wrote:
> On Mon, Nov 12, 2012 at 12:00:55PM +0800, Wen Congyang wrote:
> > At 11/09/2012 02:29 AM, Vasilis Liaskovitis Wrote:
> > > As discussed in
> > > https://patchwork.kernel.org/patch/1581581/
> > > the driver core remove function needs to always succeed. This means we need
> > > to know that the device can be successfully removed before acpi_bus_trim / 
> > > acpi_bus_hot_remove_device are called. This can cause panics when OSPM-initiated
> > > eject (echo 1 > /sys/bus/acpi/devices/PNP/eject) of memory devices fails, since
> > > the ACPI core goes ahead and ejects the device regardless of whether the memory
> > > is still in use or not.
> > > 
> > > For this reason a new acpi_device operation called prepare_remove is introduced.
> > > This operation should be registered for acpi devices whose removal (from kernel
> > > perspective) can fail.  Memory devices fall in this category.
> > > 
> > > acpi_bus_hot_remove_device is changed to handle removal in 2 steps:
> > > - preparation for removal i.e. perform part of removal that can fail outside of
> > >   ACPI core. Should succeed for device and all its children.
> > > - if above step was successfull, proceed to actual ACPI removal
> > 
> > If we unbind the device from the driver, we still need to do preparation. But
> > you don't do it in your patch.
> 
> yes, driver_unbind breaks with the current patchset. I 'll try to fix and
> repost. However, I think this will require a new driver-core wide prepare_remove
> callback (not only acpi-specific). I am not sure that would be acceptable.

However, you can't break driver_unbind either.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

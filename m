Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933625Ab2JDVUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:20:01 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:59535 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933538Ab2JDVT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:19:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/4] ACPI: kill acpi_pci_root_start
Date: Thu, 04 Oct 2012 23:23:24 +0200
Message-ID: <16287303.8DVGGcjq5E@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.4.6-2.10-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1349305214-3241-1-git-send-email-yinghai@kernel.org>
References: <CAE9FiQWgvVqnTTeYFvxf1GxLcEEeRyN-uSKPdg3o69oCpm43sQ@mail.gmail.com> <1349305214-3241-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 of October 2012 16:00:10 Yinghai Lu wrote:
> Now acpi_pci_root_driver has two ops: .add and .start, aka acpi_pci_root_add
> and acpi_pci_root_start.
> 
> That is for hotplug handling: .add need to return early to make sure all
> acpi device could be created and added early. So .start could device_add
> pci device that are found in acpi_pci_root_add/pci_acpi_scan_root().
> 
> That is holding pci devics to be out of devices for while.
> 
> We could use bus notifier to handle hotplug case.
> 	CONFIG_HOTPLUG is enabled always now.
> Need to add drivers_autoprobe bit in acpi_device to hold attaching drivers
> for acpi_devices, so could make sure all acpi_devices get created at first.
> Then acpi_bus_attach() that is called from acpi_bus_add will attach driver
> for all acpi_devices that are just created.
> 
> That make the logic more simple: hotplug path handling just like booting path
> that drivers are attached after all acpi device get created.
> 
> At last we could remove all acpi_bus_start workaround.

Do I understand correctly that you just want to prevent acpi_pci_root_driver
from binding to the host bridge's struct acpi_device created while we're
walking the ACPI namespace?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

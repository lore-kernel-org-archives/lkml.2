Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934631Ab2LIXA2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 18:00:28 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:50202 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934604Ab2LIXAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 18:00:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 0/6] ACPI: Change the ACPI namespace scanning code ordering
Date: Sun, 09 Dec 2012 23:58:42 +0100
Message-ID: <8498184.VilrUmatxI@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc8; KDE/4.9.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patches change the ordering of the ACPI namespace scanning code
so that all struct acpi_device objects in the given scope are registered before
ACPI drivers are probed against them.  They also do some simplifications and
clarifications of the code made possible by this main change.

This is done for three basic reasons.  First, we need the boot ACPI namespace
scanning code to be as similar as reasonably possible to the hot-plug ACPI
namespace scanning code.  Second, the ordering of PCI devices enumeration
versus ACPI-backed platform devices registration needs to be such that the PCI
devices in the given scope are all registered first.  Finally, when we start to
actually manage ACPI device resources as appropriate (e.g. resolve resource
conflicts properly) we'll need all struct acpi_device nodes to be registered
before any "companion" physical nodes or ACPI drivers are bound to them.

The patches have been tested on Toshiba Portege R500 without breaking stuff
(I used some additional debug code to verify that the ordering of device
discovery had not been modified by them), but if you see any problems with
them regarding hot-plug, please let me know.

[1/6] - Separate adding ACPI device objects from probing ACPI drivers.
[2/6] - Change the ordering of PCI root bridge driver registration.
[3/6] - Make acpi_bus_add() and acpi_bus_start() visibly different.
[4/6] - Reduce the usage of struct acpi_bus_ops
[5/6] - Replace struct acpi_bus_ops with an enum type
[6/6] - Change the ordering of acpi_bus_check_add() to avoid unnecessary checks.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

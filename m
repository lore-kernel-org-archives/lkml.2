Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab2FRGdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 02:33:09 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43361 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab2FRGdG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:33:06 -0400
MIME-Version: 1.0
In-Reply-To: <1340000766-129148-1-git-send-email-ming.m.lin@intel.com>
References: <1340000766-129148-1-git-send-email-ming.m.lin@intel.com>
Date: Mon, 18 Jun 2012 14:32:47 +0800
X-Google-Sender-Auth: bkCg-UCT3mGKjPw3hmZIqivVMFE
Message-ID: <CAF1ivSa-6xwwASBLsCwv9YS=T1FRvu2+mH4z_=7cXzw=VhKQ1w@mail.gmail.com>
Subject: Re: [PATCH v5 00/12] SATA ZPODD support
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lu@amd.com>,
        Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        David Woodhouse <David.Woodhouse@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(The subject should be: [PATCH v5 00/12] SATA ZPODD support)

On Mon, Jun 18, 2012 at 2:25 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> Hi all,
>
> This is the v5 patches to add SATA ZPODD support, to try it:
> git pull git://git.kernel.org/pub/scm/linux/kernel/git/mlin/linux.git zpodd
>
> Holger and Mathtew,
> Patch 1 to Patch 4 are the libata acpi binding patches from you.
> I removed dock related code from your original version.
> Would you help to review?
>
> v5:
> - rebase to v3.5-rc3
> - fixed crash reported at https://lkml.org/lkml/2012/2/24/2 (Aaron Lu)
> - rename is_pci_ata to compat_pci_ata (Alan Cox)
>
> v4:
> https://lkml.org/lkml/2012/5/28/11
> - Includes libata acpi binding patches from Holger Macht and Matthew Garrett.
> - tell scsi layer device supports runtime power off
> - check support for device busy class events
>
> v3:
> https://lkml.org/lkml/2012/3/28/20
> - Split the ACPI D3Cold state support patches out
> - Adds "Device Attention" bit check
>
> v2:
> https://lkml.org/lkml/2012/3/1/61
> - _PR3 indicates D3Cold support
> - move can_power_off flag to pm_subsys_data
> - allow all combinations of power resource and device
> - split patches into smaller ones to make review easy
>
> v1:
> https://lkml.org/lkml/2012/2/13/86
>
>
> Aaron Lu (4):
>      libata: tell scsi layer device supports runtime power off
>      [SCSI] sr: check support for device busy class events
>      [SCSI] sr: support zero power ODD
>      [SCSI] sr: make sure ODD is in resumed state in block ioctl
>
> Holger Macht (2):
>      [SCSI]: add wrapper to access and set scsi_bus_type in struct acpi_bus_type
>      libata: use correct PCI devices
>
> Lin Ming (4):
>      libata-acpi: set acpi state for SATA port
>      libata-acpi: add ata port runtime D3Cold support
>      libata-acpi: register/unregister device to/from power resource
>      libata: detect Device Attention support
>
> Matthew Garrett (2):
>      libata: bind the Linux device tree to the ACPI device tree
>      libata: migrate ACPI code over to new bindings
>
>
>  drivers/acpi/glue.c        |    4 +-
>  drivers/acpi/power.c       |    2 +
>  drivers/ata/libata-acpi.c  |  389 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------
>  drivers/ata/libata-core.c  |    9 ++-
>  drivers/ata/libata-pmp.c   |    4 -
>  drivers/ata/libata-scsi.c  |    3 +
>  drivers/ata/libata.h       |   13 +--
>  drivers/ata/pata_acpi.c    |    4 +-
>  drivers/scsi/scsi_lib.c    |   17 ++++
>  drivers/scsi/sr.c          |  160 +++++++++++++++++++++++++++++++++++-
>  drivers/scsi/sr.h          |    3 +
>  include/linux/ata.h        |    1 +
>  include/linux/cdrom.h      |   43 ++++++++++
>  include/linux/libata.h     |    9 +--
>  include/scsi/scsi.h        |   10 +++
>  include/scsi/scsi_device.h |    2 +
>  16 files changed, 534 insertions(+), 139 deletions(-)

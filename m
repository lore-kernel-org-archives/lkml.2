Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab1CXMPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 08:15:17 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54150 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab1CXMPP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 08:15:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MxBW2EeeD1TxMIERTzu/KjXL/7xVG2KIDs6e1a+ASFi/YHvjcAfN1hhB51/LySRCuZ
         pzfFFOEG9joq4UL6MebaiwGHEfhFKM0yI/d7aBEClYRWz1CD2EIop8PWz2ksfr0YPNK0
         ydRVYhzU5r4kGNBCKRxweDNK1UM5+8GiUr9F8=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1103242007300.2677@boston.corp.fedex.com>
References: <Pine.LNX.4.64.1103242007300.2677@boston.corp.fedex.com>
Date: Thu, 24 Mar 2011 13:15:14 +0100
Message-ID: <AANLkTikxfnfE_j06Cu6L9MkT7mwUvJGKN1mbycR9cr+R@mail.gmail.com>
Subject: Re: Commit 9661e92c10a9775243c1ecb73373528ed8725a10: sysfs: cannot
 create duplicate filename '/devices/pci0000:00/0000:00:02.0/backlight/acpi_video0/device'
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Richard Purdie <rpurdie@rpsys.net>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Sedat Dilek <sedat.dilek@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 1:10 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>
>
> Commit 9661e92c10a9775243c1ecb73373528ed8725a10 causes this bug. Reverting
> it solves the problem.
>
> Notebook is Lenovo X201s.
>
> Thanks,
> Jeff
>
>
>
> ------------[ cut here ]------------
> WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0x8c/0x9e()
> Hardware name: 5413FGA
> sysfs: cannot create duplicate filename
> '/devices/pci0000:00/0000:00:02.0/backlight/acpi_video0/device'
> Modules linked in: i915(+) drm_kms_helper
> Pid: 2010, comm: modprobe Not tainted 2.6.38 #15
> Call Trace:
> [<ffffffff81032548>] ? warn_slowpath_common+0x78/0x8c
> [<ffffffff810325fb>] ? warn_slowpath_fmt+0x45/0x4a
> [<ffffffff810f70bc>] ? sysfs_add_one+0x8c/0x9e
> [<ffffffff810f7e21>] ? sysfs_do_create_link+0x100/0x1a7
> [<ffffffff8123c054>] ? acpi_video_device_lcd_get_level_current+0x47/0x10e
> [<ffffffff8123d076>] ? acpi_video_bus_add+0x961/0xc5b
> [<ffffffff810f7798>] ? sysfs_addrm_finish+0x29/0xc2
> [<ffffffff81219b7d>] ? acpi_device_probe+0x42/0x10d
> [<ffffffff8128a83a>] ? driver_probe_device+0xa8/0x138
> [<ffffffff8128a919>] ? __driver_attach+0x4f/0x6f
> [<ffffffff8128a8ca>] ? __driver_attach+0x0/0x6f
> [<ffffffff8128a0a4>] ? bus_for_each_dev+0x44/0x78
> [<ffffffff81289a52>] ? bus_add_driver+0xb9/0x201
> [<ffffffff8128ae45>] ? driver_register+0x90/0xf8
> [<ffffffff8123c698>] ? acpi_video_register+0x1b/0x34
> [<ffffffffa00104e0>] ? i915_driver_load+0xcb9/0xd99 [i915]
> [<ffffffff8127a112>] ? drm_get_minor+0x209/0x25b
> [<ffffffff8127bb79>] ? drm_get_pci_dev+0x14f/0x259
> [<ffffffff811f6ce8>] ? local_pci_probe+0x49/0x93
> [<ffffffff811f79ef>] ? pci_device_probe+0xbf/0xec
> [<ffffffff8128a6f9>] ? driver_sysfs_add+0x66/0x8d
> [<ffffffff8128a83a>] ? driver_probe_device+0xa8/0x138
> [<ffffffff8128a919>] ? __driver_attach+0x4f/0x6f
> [<ffffffff8128a8ca>] ? __driver_attach+0x0/0x6f
> [<ffffffff8128a0a4>] ? bus_for_each_dev+0x44/0x78
> [<ffffffff81289a52>] ? bus_add_driver+0xb9/0x201
> [<ffffffff8128ae45>] ? driver_register+0x90/0xf8
> [<ffffffff811f7c41>] ? __pci_register_driver+0x4e/0xc0
> [<ffffffffa0051000>] ? i915_init+0x0/0x8d [i915]
> [<ffffffffa0051000>] ? i915_init+0x0/0x8d [i915]
> [<ffffffff81000208>] ? do_one_initcall+0x78/0x131
> [<ffffffff8105bc32>] ? sys_init_module+0x97/0x1d5
> [<ffffffff814b8592>] ? system_call_fastpath+0x16/0x1b
> ---[ end trace 7ad4522ea6dca630 ]---
>
>
>
> commit 9661e92c10a9775243c1ecb73373528ed8725a10
> Author: Matthew Garrett <mjg@redhat.com>
> Date:   Tue Mar 22 16:30:25 2011 -0700
>
>    acpi: tie ACPI backlight devices to PCI devices if possible
>
>    Dual-GPU machines may provide more than one ACPI backlight interface.
>  Tie
>    the backlight device to the GPU in order to allow userspace to identify
>    the correct interface.
>
>    Signed-off-by: Matthew Garrett <mjg@redhat.com>
>    Cc: Richard Purdie <rpurdie@rpsys.net>
>    Cc: Chris Wilson <chris@chris-wilson.co.uk>
>    Cc: David Airlie <airlied@linux.ie>
>    Cc: Alex Deucher <alexdeucher@gmail.com>
>    Cc: Ben Skeggs <bskeggs@redhat.com>
>    Cc: Zhang Rui <rui.zhang@intel.com>
>    Cc: Len Brown <lenb@kernel.org>
>    Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
>    Tested-by: Sedat Dilek <sedat.dilek@googlemail.com>
>    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index a9eec8c..a18e497 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -782,6 +782,9 @@ static void acpi_video_device_find_cap(struct
> acpi_video_device *device)
>
>        if (acpi_video_backlight_support()) {
>                struct backlight_properties props;
> +               struct pci_dev *pdev;
> +               acpi_handle acpi_parent;
> +               struct device *parent = NULL;
>                int result;
>                static int count = 0;
>                char *name;
> @@ -794,10 +797,20 @@ static void acpi_video_device_find_cap(struct
> acpi_video_device *device)
>                        return;
>                count++;
>
> +               acpi_get_parent(device->dev->handle, &acpi_parent);
> +
> +               pdev = acpi_get_pci_dev(acpi_parent);
> +               if (pdev) {
> +                       parent = &pdev->dev;
> +                       pci_dev_put(pdev);
> +               }
> +
>                memset(&props, 0, sizeof(struct backlight_properties));
>                props.type = BACKLIGHT_FIRMWARE;
>                props.max_brightness = device->brightness->count - 3;
> -               device->backlight = backlight_device_register(name, NULL,
> device,
> +               device->backlight = backlight_device_register(name,
> +                                                             parent,
> +                                                             device,
>
>  &acpi_backlight_ops,
>                                                              &props);
>                kfree(name);

Same in -git14 for my E6400 with a GM45 integrated chipset. Mine though has
 always printed out the following warning

[Firmware Bug]: Duplicate ACPI video bus devices for the same VGA
controller, please try module parameter "video.allow_duplicates=1"if
the current driver doesn't work.

 which seems to have been previously discussed here

https://lkml.org/lkml/2011/3/4/1

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")

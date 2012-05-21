Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab2EUPVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:21:51 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47288 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab2EUPVs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:21:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAK=WgbaUuCNS_cuk5-VNBXUT+op5m_BxfnwNoT=CtE86zPLt+A@mail.gmail.com>
References: <1335388200-18504-1-git-send-email-sjur.brandeland@stericsson.com>
	<CAK=WgbYisX2A-DHZy6-AhFFTR3QuxJ0OcVaz+JcpzJOwxT3eWA@mail.gmail.com>
	<81C3A93C17462B4BBD7E272753C10579232F20847B@EXDCVYMBSTM005.EQ1STM.local>
	<CAK=WgbY8RpOfZT5qNtFKOHoE5TD9s7JeqGvXadaXoZ6a7m0r4Q@mail.gmail.com>
	<CAK=WgbaUuCNS_cuk5-VNBXUT+op5m_BxfnwNoT=CtE86zPLt+A@mail.gmail.com>
Date: Mon, 21 May 2012 17:21:46 +0200
Message-ID: <CAJK669bMZ1FKJbG6nh_rpm6EELAPDXQgxzck0JqtJ16TFf-bmA@mail.gmail.com>
Subject: Re: Remoteproc adaptations for ST-Ericsson modems
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you please check if the below helps ? this will also protects
> against premature invocation of rproc_get_by_name().

Sure this works for me. If you like you can add:
Tested-by: Sjur Brændeland <sjur.brandeland@stericsson.com>

But, are you sure you don't want to do use wait_for_completion_timeout()
so you don't risk to block the clients if firmware loading fails?


For reference the crach without this patch looks like this:
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:508 sysfs_add_one+0xb9/0xd4()
sysfs: cannot create duplicate filename '/devices/platform/foo.1/firmware/foo'
Modules linked in: virtio_rpmsg_bus remoteproc virtio_ring virtio
Call Trace:
6316f928:  [<6003536e>] warn_slowpath_common+0x86/0xb0
6316f958:  [<60189e2a>] strcat+0x0/0x28
6316f978:  [<600354d6>] warn_slowpath_fmt+0x94/0x96
6316f9a8:  [<6018505a>] ida_get_new_above+0x119/0x1dc
6316f9c0:  [<60035442>] warn_slowpath_fmt+0x0/0x96
6316f9d8:  [<60102c49>] sysfs_pathname+0x4f/0x57
6316f9f8:  [<60102c49>] sysfs_pathname+0x4f/0x57
6316fa18:  [<60102c49>] sysfs_pathname+0x4f/0x57
6316fa38:  [<60102c49>] sysfs_pathname+0x4f/0x57
6316fa58:  [<60103407>] sysfs_add_one+0xb9/0xd4
6316fa88:  [<6010366e>] create_dir+0x89/0xd9
6316fae8:  [<60103af6>] sysfs_create_dir+0x141/0x15f
6316faf8:  [<6018bc35>] vsnprintf+0x212/0x48b
6316fb08:  [<60185a01>] kobject_get+0x0/0x3a
6316fb28:  [<60185c87>] kobject_add_internal+0xe1/0x24b
6316fb68:  [<60186332>] kobject_add+0x110/0x124
6316fba8:  [<60186222>] kobject_add+0x0/0x124
6316fbc0:  [<6002c0f7>] unblock_signals+0x0/0x82
6316fbe8:  [<6002c2b7>] set_signals+0x29/0x3f
6316fbf0:  [<6002c0f7>] unblock_signals+0x0/0x82
6316fc18:  [<600a639b>] kmem_cache_alloc+0x9f/0xab
6316fc38:  [<6019ff09>] get_device_parent+0x1e0/0x210
6316fc68:  [<601a162d>] device_add+0x11e/0x6dd
6316fc90:  [<60053f82>] up_read+0x0/0x18
6316fc98:  [<600502f4>] prepare_to_wait+0x0/0x8d
6316fcd8:  [<601a879f>] _request_firmware_load+0x40/0x239
6316fd18:  [<601a93ae>] request_firmware+0xb5/0x107
6316fd48:  [<6006954a>] try_module_get+0x0/0x20
6316fd58:  [<6388ecab>] rproc_boot+0x141/0x3e2 [remoteproc]


Regards,
Sjur

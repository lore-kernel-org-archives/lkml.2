Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab1BAUdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 15:33:35 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52901 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab1BAUdb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 15:33:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=BE/5YpYAHsIqjzROlNeJPn1BbdrtIHHOxlcrmvuco17eiwuvydhzPDUtuoDMPBkM7i
         RHB5i0obeIQk0Ow9cVNnOQfOtW7KYumt4gXvByyxQ3niUBusiCutE49KPDGmLTrdJc/G
         UnydzgBoxk3jVsfL8SgoUN6BwJisLo5GWC9iI=
MIME-Version: 1.0
Date: Tue, 1 Feb 2011 21:33:29 +0100
X-Google-Sender-Auth: 7CzMKOHBlW-lCOtfr4aLaYe_s8o
Message-ID: <AANLkTin4gOnEMruLDM=TkNYsNf5S370WqbcDVJzT7_Z4@mail.gmail.com>
Subject: Early crash (was: Re: module: show version information for built-in
 modules in sysfs)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dmitry Torokhov <dtor@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 11:59, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/e94965ed5beb23c6fabf7ed31f625e66d7ff28de

>    module: show version information for built-in modules in sysfs
>
>    Currently only drivers that are built as modules have their versions
>    shown in /sys/module/<module_name>/version, but this information might
>    also be useful for built-in drivers as well. This especially important
>    for drivers that do not define any parameters - such drivers, if
>    built-in, are completely invisible from userspace.
>
>    This patch changes MODULE_VERSION() macro so that in case when we are
>    compiling built-in module, version information is stored in a separate
>    section. Kernel then uses this data to create 'version' sysfs attribute
>    in the same fashion it creates attributes for module parameters.

This commit causes the crash below on m68k (ARAnyM).
Reverting this commit and its dependency
3b90a5b292321b2acac3921f77046ae195aef53f
("module: fix linker error for MODULE_VERSION when !MODULE and CONFIG_SYSFS=n")
makes it boot again.

NET: Registered protocol family 16
Unable to handle kernel NULL pointer dereference at virtual address 0000002b
Oops: 00000000
Modules linked in:
PC: [<00141164>] kset_find_obj_hinted+0x5a/0xb6
SR: 2300  SP: 00c09ec8  a2: 00c07900
d0: 00000078    d1: 00c2ee90    d2: 00000000    d3: 00000000
d4: 00000000    d5: 00000000    a0: 00c2f700    a1: 00c2f701
Process swapper (pid: 1, task=00c07900)
Frame format=7 eff addr=0000002b ssw=0525 faddr=0000002b
wb 1 stat/addr/data: 0000 00000000 00000000
wb 2 stat/addr/data: 0000 00000000 00000000
wb 3 stat/addr/data: 0000 0000002b 00000000
push data: 00000000 00000000 00000000 00000000
Stack from 00c09f30:
        0000002b 002d853a 00310dac 0031214a 002dbff8 001411d0 00c2ee90 0000002b
        00000000 00310dc2 00c2ee90 0000002b 00c2ee50 00000000 002d853a 00310eb8
        0000002b 00000000 00000000 003291a8 00310e6c 00c1d8b8 002e6872 00170e00
        00c1d8b0 002e6872 003031f8 00000000 00000000 00303038 0031bec2 0031214a
        0031bf40 00303038 00000000 003291a4 000020f8 00000000 00000000 00000000
        00000000 00000000 00000000 003291a8 00002008 0031214a 0030baee 00310e6c
Call Trace: [<00310dac>] locate_module_kobject+0x0/0xc0
 [<0031214a>] __alloc_bootmem+0x0/0x1a
 [<001411d0>] kset_find_obj+0x10/0x18
 [<00310dc2>] locate_module_kobject+0x16/0xc0
 [<00310eb8>] param_sysfs_init+0x4c/0x1be
 [<00310e6c>] param_sysfs_init+0x0/0x1be
 [<00170e00>] vtconsole_init_device+0x3c/0x90
 [<0031bec2>] vtconsole_class_init+0x0/0xda
 [<0031214a>] __alloc_bootmem+0x0/0x1a
 [<0031bf40>] vtconsole_class_init+0x7e/0xda
 [<000020f8>] do_one_initcall+0xf0/0x186
 [<00002008>] do_one_initcall+0x0/0x186
 [<0031214a>] __alloc_bootmem+0x0/0x1a
 [<0030baee>] kernel_init+0x96/0x136
 [<00310e6c>] param_sysfs_init+0x0/0x1be
 [<0030ba58>] kernel_init+0x0/0x136
 [<0002794e>] printk+0x0/0x1a
 [<00002b52>] kernel_thread+0x3a/0x4e

Code: b288 672c 2053 4a88 6716 2248 2c4c 1019 <b01e> 6606 4a00 66f6
6002 9026 4a00 6722 47ed fffc 2a6b 0004 41eb 0004 b288 66d4
Disabling lock debugging due to kernel taint
Kernel panic - not syncing: Attempted to kill init!
Call Trace: [<0002745c>] panic+0x5a/0x1ba
 [<00028bd4>] exit_mm+0x0/0x102
 [<0011dfd6>] exit_sem+0x0/0x162
 [<0002f5f2>] exit_ptrace+0x0/0x106
 [<0002a274>] do_exit+0x6cc/0x6ce
 [<0002794e>] printk+0x0/0x1a
 [<000031de>] die_if_kernel+0x4e/0x52
 [<00006e8c>] send_fault_sig+0xd4/0x11e
 [<00006f80>] do_page_fault+0xaa/0x1c2
 [<000038b6>] buserr_c+0x192/0x6d8
 [<00100100>] mnt_xdr_dec_mountres+0xa2/0xb4
 [<00002542>] buserr+0x1e/0x24
 [<00310dac>] locate_module_kobject+0x0/0xc0
 [<0031214a>] __alloc_bootmem+0x0/0x1a
 [<001411d0>] kset_find_obj+0x10/0x18
 [<00310dc2>] locate_module_kobject+0x16/0xc0
 [<00310eb8>] param_sysfs_init+0x4c/0x1be
 [<00310e6c>] param_sysfs_init+0x0/0x1be
 [<00170e00>] vtconsole_init_device+0x3c/0x90
 [<0031bec2>] vtconsole_class_init+0x0/0xda
 [<0031214a>] __alloc_bootmem+0x0/0x1a
 [<0031bf40>] vtconsole_class_init+0x7e/0xda
 [<000020f8>] do_one_initcall+0xf0/0x186
 [<00002008>] do_one_initcall+0x0/0x186
 [<0031214a>] __alloc_bootmem+0x0/0x1a
 [<0030baee>] kernel_init+0x96/0x136
 [<00310e6c>] param_sysfs_init+0x0/0x1be
 [<0030ba58>] kernel_init+0x0/0x136
 [<0002794e>] printk+0x0/0x1a
 [<00002b52>] kernel_thread+0x3a/0x4e

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

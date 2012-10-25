Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935934Ab2JYRFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 13:05:50 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:55937 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935883Ab2JYRFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 13:05:48 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:1f05:1640:8180:e7c3:6ba0:d42]
In-Reply-To: <1351171217.5303.13.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1351059878-28795-1-git-send-email-olof@lixom.net>
	<1351098044-4586-1-git-send-email-olof@lixom.net>
	<1351171217.5303.13.camel@mfleming-mobl1.ger.corp.intel.com>
Date: Thu, 25 Oct 2012 10:05:47 -0700
Message-ID: <CAOesGMi-WeHe7XKVYh90GQ3Ko8BdQh2bFU6Gdi20UKySO+4dRQ@mail.gmail.com>
Subject: Re: [PATCH v3] x86: efi: Turn off efi_enabled after setup on mixed fw/kernel
From: Olof Johansson <olof@lixom.net>
To: Matt Fleming <matt@console-pimps.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, marko.kohtala@gmail.com,
        Matthew Garrett <mjg@redhat.com>,
        linux-efi <linux-efi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 6:20 AM, Matt Fleming <matt@console-pimps.org> wrote:
> On Wed, 2012-10-24 at 10:00 -0700, Olof Johansson wrote:
>> When 32-bit EFI is used with 64-bit kernel (or vice versa), turn off
>> efi_enabled once setup is done. Beyond setup, it is normally used to
>> determine if runtime services are available and we will have none.
>>
>> This will resolve issues stemming from efivars modprobe panicking on a
>> 32/64-bit setup, as well as some reboot issues on similar setups.
>>
>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=45991
>>
>> Reported-by: Marko Kohtala <marko.kohtala@gmail.com>
>> Reported-by: Maxim Kammerer <mk@dee.su>
>> Signed-off-by: Olof Johansson <olof@lixom.net>
>> Acked-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>> Cc: stable@kernel.org # 3.4 - 3.6
>> Cc: Matthew Garrett <mjg@redhat.com>
>> ---
>
> Running with this patch results in the following,
>
> [    3.486943] ------------[ cut here ]------------
> [    3.488455] WARNING: at /home/matt/src/kernels/linux-2.6/arch/x86/mm/ioremap.c:586 check_early_ioremap_leak+0x3b/0x50()
> [    3.490043] Hardware name: MacBook2,1
> [    3.491600] Debug warning: early ioremap leak of 1 areas detected.
> [    3.493156] Modules linked in:
> [    3.493973] usb 1-4: new high-speed USB device number 3 using ehci_hcd
> [    3.496340] Pid: 1, comm: swapper/0 Not tainted 3.7.0-rc1+ #26
> [    3.497949] Call Trace:
> [    3.499558]  [<ffffffff81d022ab>] ? check_early_ioremap_leak+0x3b/0x50
> [    3.501217]  [<ffffffff81032970>] warn_slowpath_common+0x85/0x9d
> [    3.502872]  [<ffffffff81d02270>] ? early_ioremap_debug_setup+0x12/0x12
> [    3.504516]  [<ffffffff81032a2b>] warn_slowpath_fmt+0x46/0x48
> [    3.506161]  [<ffffffff81cf89df>] ? mcheck_debugfs_init+0x3b/0x3b
> [    3.507790]  [<ffffffff81d022ab>] check_early_ioremap_leak+0x3b/0x50
> [    3.509418]  [<ffffffff8100023b>] do_one_initcall+0x7f/0x134
> [    3.511040]  [<ffffffff8163cc3c>] kernel_init+0x10c/0x275
> [    3.512638]  [<ffffffff81cef4c7>] ? loglevel+0x31/0x31
> [    3.514241]  [<ffffffff8163cb30>] ? rest_init+0x74/0x74
> [    3.515824]  [<ffffffff8165ca9c>] ret_from_fork+0x7c/0xb0
> [    3.517393]  [<ffffffff8163cb30>] ? rest_init+0x74/0x74
> [    3.518958] ---[ end trace afc7d1c216dac6e1 ]---
> [    3.520479] please boot with early_ioremap_debug and report the dmesg.
>
> because we're now leaking the mapping from efi_memmap_init().

Odd, I didn't see it here. Thanks for catching it.

> Maybe it should be handled like so?

Looks good, since the memory should still be reserved and not reused.

Acked-by: Olof Johansson <olof@lixom.net>
(or just amend the original patch)


-Olof

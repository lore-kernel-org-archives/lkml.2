Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab1DKRYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 13:24:13 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37512 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab1DKRYL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 13:24:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OF6C3LiJZLD1rSLYiF7mbN1PsO7802j+G8LdL21P74Tz74RWU6lcx5pehJeUdz+9Al
         WCK1kowehVLvkJumIjItVx7HkAJRgYaomytVA8L7e/kKB5dNp0mc1bsD5d5wVkwPzEUE
         B/I1HM//Z9zFxl/5aSXMukvHwJwuzbfCWp6Wk=
MIME-Version: 1.0
In-Reply-To: <op.vtr9glg23ri7v4@arend-laptop>
References: <1302291900-1902-1-git-send-email-zajec5@gmail.com>
	<op.vtr9glg23ri7v4@arend-laptop>
Date: Mon, 11 Apr 2011 19:24:09 +0200
Message-ID: <BANLkTimG7JOCCe2ozJkKOdtPfZka5jZSNQ@mail.gmail.com>
Subject: Re: [RFC][WAS:bcmai][PATCH V2] axi: add AXI bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/11 Arend van Spriel <arend@broadcom.com>:
> On Fri, 08 Apr 2011 21:45:00 +0200, Rafał Miłecki <zajec5@gmail.com> wrote:
>
>> Cc: Michael Büsch <mb@bu3sch.de>
>> Cc: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: George Kashperko <george@znau.edu.ua>
>> Cc: Arend van Spriel <arend@broadcom.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> <linux-arm-kernel@lists.infradead.org>
>> Cc: Russell King <rmk@arm.linux.org.uk>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: linuxdriverproject <devel@linuxdriverproject.org>
>> Cc: linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>> This is second try for introducing new bus driver.
>> V2: Rename to axi
>>    Use DEFINE_PCI_DEVICE_TABLE in bridge
>>    Make use of pr_fmt and pr_*
>>    Store core class
>>    Rename bridge to not b43 specific
>>    Replace magic 0x1000 with BCMAI_CORE_SIZE
>>    Remove some old "ssb" names and defines
>>    Move BCMAI_ADDR_BASE def
>>    Add drvdata field
>> TODO:
>> - Interrupts
>> - Reloading driver
>> ---
>>  drivers/Kconfig                           |    2 +
>>  drivers/Makefile                          |    1 +
>>  include/linux/mod_devicetable.h           |   17 ++
>>  scripts/mod/file2alias.c                  |   21 ++
>
> Hi Rafał,
>
> I tried to apply this patch, but it failed as well. I did the 4 files
> above manually and applied partial patch for the new files.
>
> When I load the module it seems to have succeeded once, but every insmod
> attempt I do now fails with following trace:
>
> Apr 11 16:43:43 arend-laptop kernel: [   61.249239] axi-pci-bridge
> 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> Apr 11 16:43:43 arend-laptop kernel: [   61.249312] Core 0 found:
> ChipCommon (manuf 0x4BF, id 0x800, rev 0x22, class 0x0)
> Apr 11 16:43:43 arend-laptop kernel: [   61.249339] Core 1 found: IEEE
> 802.11 (manuf 0x4BF, id 0x812, rev 0x17, class 0x0)
> Apr 11 16:43:43 arend-laptop kernel: [   61.249400] Core 2 found: PCIe
> (manuf 0x4BF, id 0x820, rev 0x0F, class 0x0)
> Apr 11 16:43:43 arend-laptop kernel: [   61.279913] Modules linked in:
> axi(+) binfmt_misc nouveau ttm drm_kms_helper drm i2c_algo_bit
> snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec
> snd_seq_midi snd_hwdep ppdev snd_rawmidi snd_pcm snd_seq_midi_event
> parport_pc snd_seq snd_timer snd_seq_device lp pcmcia snd uvcvideo
> soundcore snd_page_alloc dell_laptop videodev dell_wmi dcdbas
> sparse_keymap intel_ips yenta_socket video pcmcia_rsrc pcmcia_core parport
> intel_agp intel_gtt agpgart psmouse btusb bluetooth joydev serio_raw
> usbhid hid mmc_block ahci sdhci_pci firewire_ohci sdhci e1000e
> firewire_core mmc_core libahci crc_itu_t
> Apr 11 16:43:43 arend-laptop kernel: [   61.280052]
> Apr 11 16:43:43 arend-laptop kernel: [   61.280366] Pid: 2008, comm:
> insmod Not tainted 2.6.39-rc1-staging-next-09270-gb905e26 #1 Dell Inc.
> Latitude E6410/07XJP9
> Apr 11 16:43:43 arend-laptop kernel: [   61.281090] EIP: 0060:[<c0213d3d>]
> EFLAGS: 00010246 CPU: 1
> Apr 11 16:43:43 arend-laptop kernel: [   61.281812] EIP is at
> kfree+0x10d/0x120

Thank you Arend for testing.

What you see is some issue with kfree I do not understand. Please take
a look at:
"Crash with kfree(null) on MacBook? kobject_set_name_vargs"
https://lkml.org/lkml/2011/4/10/71

When I call dev_set_name result with new name for device, internal
implementation performs "kfree" on *old name*. Of course there was not
old name, so kfree is being called on * char pointing to NULL. On my
device it does not crash, but on yours and on Andy's it does.

We got suggestion to enable SLUB/SLAB debugging. Andy didn't try it
yet. Could you spend a moment trying to debug this?

-- 
Rafał

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab1DKQ7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 12:59:20 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1157 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab1DKQ7S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 12:59:18 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
cc: "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        =?utf-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        "Larry Finger" <Larry.Finger@lwfinger.net>,
        "George Kashperko" <george@znau.edu.ua>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Russell King" <rmk@arm.linux.org.uk>, "Arnd Bergmann" <arnd@arndb.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1302291900-1902-1-git-send-email-zajec5@gmail.com>
Subject: Re: [RFC][WAS:bcmai][PATCH V2] axi: add AXI bus driver
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Mon, 11 Apr 2011 18:59:02 +0200
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Organization: Broadcom
Message-ID: <op.vtr9glg23ri7v4@arend-laptop>
In-Reply-To: <1302291900-1902-1-git-send-email-zajec5@gmail.com>
User-Agent: Opera Mail/11.01 (Linux)
X-WSS-ID: 61BDEB803I89722236-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Apr 2011 21:45:00 +0200, Rafał Miłecki <zajec5@gmail.com> wrote:

> Cc: Michael Büsch <mb@bu3sch.de>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: George Kashperko <george@znau.edu.ua>
> Cc: Arend van Spriel <arend@broadcom.com>
> Cc: linux-arm-kernel@lists.infradead.org  
> <linux-arm-kernel@lists.infradead.org>
> Cc: Russell King <rmk@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: linuxdriverproject <devel@linuxdriverproject.org>
> Cc: linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> This is second try for introducing new bus driver.
> V2: Rename to axi
>     Use DEFINE_PCI_DEVICE_TABLE in bridge
>     Make use of pr_fmt and pr_*
>     Store core class
>     Rename bridge to not b43 specific
>     Replace magic 0x1000 with BCMAI_CORE_SIZE
>     Remove some old "ssb" names and defines
>     Move BCMAI_ADDR_BASE def
>     Add drvdata field
> TODO:
> - Interrupts
> - Reloading driver
> ---
>  drivers/Kconfig                           |    2 +
>  drivers/Makefile                          |    1 +
>  include/linux/mod_devicetable.h           |   17 ++
>  scripts/mod/file2alias.c                  |   21 ++

Hi Rafał,

I tried to apply this patch, but it failed as well. I did the 4 files
above manually and applied partial patch for the new files.

When I load the module it seems to have succeeded once, but every insmod
attempt I do now fails with following trace:

Apr 11 16:43:43 arend-laptop kernel: [   61.249239] axi-pci-bridge
0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Apr 11 16:43:43 arend-laptop kernel: [   61.249312] Core 0 found:
ChipCommon (manuf 0x4BF, id 0x800, rev 0x22, class 0x0)
Apr 11 16:43:43 arend-laptop kernel: [   61.249339] Core 1 found: IEEE
802.11 (manuf 0x4BF, id 0x812, rev 0x17, class 0x0)
Apr 11 16:43:43 arend-laptop kernel: [   61.249400] Core 2 found: PCIe
(manuf 0x4BF, id 0x820, rev 0x0F, class 0x0)
Apr 11 16:43:43 arend-laptop kernel: [   61.279913] Modules linked in:
axi(+) binfmt_misc nouveau ttm drm_kms_helper drm i2c_algo_bit
snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec
snd_seq_midi snd_hwdep ppdev snd_rawmidi snd_pcm snd_seq_midi_event
parport_pc snd_seq snd_timer snd_seq_device lp pcmcia snd uvcvideo
soundcore snd_page_alloc dell_laptop videodev dell_wmi dcdbas
sparse_keymap intel_ips yenta_socket video pcmcia_rsrc pcmcia_core parport
intel_agp intel_gtt agpgart psmouse btusb bluetooth joydev serio_raw
usbhid hid mmc_block ahci sdhci_pci firewire_ohci sdhci e1000e
firewire_core mmc_core libahci crc_itu_t
Apr 11 16:43:43 arend-laptop kernel: [   61.280052]
Apr 11 16:43:43 arend-laptop kernel: [   61.280366] Pid: 2008, comm:
insmod Not tainted 2.6.39-rc1-staging-next-09270-gb905e26 #1 Dell Inc.
Latitude E6410/07XJP9
Apr 11 16:43:43 arend-laptop kernel: [   61.281090] EIP: 0060:[<c0213d3d>]
EFLAGS: 00010246 CPU: 1
Apr 11 16:43:43 arend-laptop kernel: [   61.281812] EIP is at
kfree+0x10d/0x120
Apr 11 16:43:43 arend-laptop kernel: [   61.282523] EAX: 40000000 EBX:
f726bc40 ECX: f2ea6910 EDX: 0000002f
Apr 11 16:43:43 arend-laptop kernel: [   61.283234] ESI: f57d2d60 EDI:
00000000 EBP: f726bd70 ESP: f726bd4c
Apr 11 16:43:43 arend-laptop kernel: [   61.283947]  DS: 007b ES: 007b FS:
00d8 GS: 00e0 SS: 0068
Apr 11 16:43:43 arend-laptop kernel: [   61.286071]  f726bd98 f848be2a
f726bd70 c036dea3 f726bda0 00000007 f3aae18c f726bc40
Apr 11 16:43:43 arend-laptop kernel: [   61.286797]  f3aae000 f726bd80
c03642c4 f3aae16c 00000001 f726bd88 c0410639 f726bdb4
Apr 11 16:43:43 arend-laptop kernel: [   61.287522]  f848a326 f3aae184
f848be2a 00000000 00000000 f3aae184 00000000 f39eb800
Apr 11 16:43:43 arend-laptop kernel: [   61.288957]  [<c036dea3>] ?
kvasprintf+0x43/0x60
Apr 11 16:43:43 arend-laptop kernel: [   61.289660]  [<c03642c4>]
kobject_set_name_vargs+0x64/0x70
Apr 11 16:43:43 arend-laptop kernel: [   61.290357]  [<c0410639>]
dev_set_name+0x19/0x20
Apr 11 16:43:43 arend-laptop kernel: [   61.291050]  [<f848a326>]
axi_bus_register+0x106/0x220 [axi]
Apr 11 16:43:43 arend-laptop kernel: [   61.291738]  [<f848bd1a>]
axi_host_pci_probe+0xfa/0x168 [axi]
Apr 11 16:43:43 arend-laptop kernel: [   61.292419]  [<c0381497>]
local_pci_probe+0x47/0xb0
Apr 11 16:43:43 arend-laptop kernel: [   61.293091]  [<c0382388>]
pci_device_probe+0x68/0x90
Apr 11 16:43:43 arend-laptop kernel: [   61.293755]  [<c04138af>]
driver_probe_device+0x7f/0x190
Apr 11 16:43:43 arend-laptop kernel: [   61.294417]  [<c0413a41>]
__driver_attach+0x81/0x90
Apr 11 16:43:43 arend-laptop kernel: [   61.295070]  [<c0412ec3>]
bus_for_each_dev+0x53/0x80
Apr 11 16:43:43 arend-laptop kernel: [   61.295720]  [<c041372e>]
driver_attach+0x1e/0x20
Apr 11 16:43:43 arend-laptop kernel: [   61.296371]  [<c04139c0>] ?
driver_probe_device+0x190/0x190
Apr 11 16:43:43 arend-laptop kernel: [   61.297015]  [<c0413140>]
bus_add_driver+0xc0/0x240
Apr 11 16:43:43 arend-laptop kernel: [   61.297661]  [<c0382200>] ?
pci_dev_put+0x20/0x20
Apr 11 16:43:43 arend-laptop kernel: [   61.298308]  [<c041406a>]
driver_register+0x6a/0x130
Apr 11 16:43:43 arend-laptop kernel: [   61.298958]  [<c0412897>] ?
bus_put+0x17/0x20
Apr 11 16:43:43 arend-laptop kernel: [   61.299608]  [<c041306e>] ?
bus_create_file+0x3e/0x50
Apr 11 16:43:43 arend-laptop kernel: [   61.300259]  [<c03825c5>]
__pci_register_driver+0x45/0xb0
Apr 11 16:43:43 arend-laptop kernel: [   61.300900]  [<f848bbb5>]
axi_host_pci_register+0x25/0x30 [axi]
Apr 11 16:43:43 arend-laptop kernel: [   61.301539]  [<f83bb03f>]
axi_pci_bridge_init+0xd/0xf [axi]
Apr 11 16:43:43 arend-laptop kernel: [   61.302172]  [<f83bb01c>]
axi_modinit+0x1c/0x32 [axi]
Apr 11 16:43:43 arend-laptop kernel: [   61.302810]  [<c0101125>]
do_one_initcall+0x35/0x170
Apr 11 16:43:43 arend-laptop kernel: [   61.303445]  [<f83bb000>] ?
0xf83bafff
Apr 11 16:43:43 arend-laptop kernel: [   61.304078]  [<c0181e46>]
sys_init_module+0x116/0x1090
Apr 11 16:43:43 arend-laptop kernel: [   61.304716]  [<c05e3e5f>]
sysenter_do_call+0x12/0x28
Apr 11 16:43:43 arend-laptop kernel: [   61.307475] ---[ end trace
9219745721068e61 ]---

Is this what you indicate with reloading driver in the TODO remark? I
rebooted the system and power-cycled it but I still get this failure. I
did not futher look into this so hopefully you can enlighten me on this.

Gr. AvS
-- 
"The world is indeed comic, but the joke is on mankind." — H.P. Lovecraft


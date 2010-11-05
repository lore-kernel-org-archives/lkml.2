Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab0KEPR4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 11:17:56 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:47854 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab0KEPRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 11:17:54 -0400
Date: Fri, 5 Nov 2010 16:17:41 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] hwmon/adt7470 crash on module load (2.6.37-rc1)
Message-ID: <20101105161741.459be240@endymion.delvare>
In-Reply-To: <4CD4187F.1030305@oracle.com>
References: <20101104170929.f5198be3.randy.dunlap@oracle.com>
	<20101105094222.2bfbfb92@endymion.delvare>
	<4CD4187F.1030305@oracle.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Fri, 05 Nov 2010 07:45:19 -0700, Randy Dunlap wrote:
> On 11/05/10 01:42, Jean Delvare wrote:
> > Hi Randy,
> > 
> > On Thu, 4 Nov 2010 17:09:29 -0700, Randy Dunlap wrote:
> >> Nov  4 15:56:17 control kernel: [  173.105754] calling  adt7470_init+0x0/0x27 [adt7470] @ 4392
> >> Nov  4 15:56:18 [  173.113711] i2c-core: driver [adt7470] registered
> >> control kernel: [  173.122202] i2c i2c-15: found normal entry for adapter 15, addr 0x2c
> >> [  173.105754] c[  173.136181] i801_smbus 0000:00:1f.3: No response
> >> [  173.142478] i2c i2c-15: found normal entry for adapter 15, addr 0x2e
> >> Nov  4 15:56:18 [  173.151286] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
> > 
> > Do you have a device at address 0x2e on this I2C adapter, or not?
> 
> AFAIK I don't even have an I2C adapter.  or is there one in the intel chipset?

The "i2c-15" above suggests that you have at least 16 I2C adapters on
your system. There are many such adapters in graphics cards, TV cards
(both analog and digital) and on the mainboard as well. You can get a
list with:

# modprobe i2c-dev
# i2cdetect -l

But given the problem you've just reported, I expect the above command
to crash on 2.6.37-rc1. You could try it on 2.6.36 to at least give me a
rough idea of what I2C adapters are available on your system. This
would help me understand what's happening.

Do you have any DVB adapter in this machine?

> > Are you using the adt7470 driver on this system normally, or did you
> > build it in just for random testing purpose?
> 
> It's just random module testing.
> 
> >> [  173.156502] last sysfs file: /sys/module/hwmon/initstate
> >> [  173.156502] CPU 1 
> >> [  173.156502] Modules linked in: adt7470(+) ipt_MASQUERADE iptable_nat nf_nat af_packet nfsd lockd nfs_acl auth_rpcgss exportfs sco bridge stp llc bnep l2cap crc16 bluetooth rfkill sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 p4_clockmod freq_table speedstep_lib binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod kvm uinput mousedev joydev ppdev snd_intel8x0 snd_ac97_codec ac97_bus snd_seq snd_seq_device snd_pcm usbkbd snd_timer led_class usbmouse usbhid hid iTCO_wdt snd dcdbas iTCO_vendor_support sg sr_mod pcspkr i2c_i801 soundcore rtc_cmos cdrom parport_pc rng_core snd_page_alloc rtc_core tg3 rtc_lib parport 8250_pnp evdev mac_hid shpchp pci_hotplug unix ide_pci_generic ide_core ata_generic pata_acpi ata_piix sd_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ssb mmc_core pcmcia pcmcia_core firmware_cl
> >>  ass ehci_hcd usbcore nls_base i915 drm_kms_helper intel_agp button intel_gtt video thermal_sys hwmon output [last unloaded: ltc4245]
> >> [  173.156502] 
> >> [  173.156502] Pid: 22, comm: kworker/1:1 Not tainted 2.6.37-rc1 #12 0HH807/OptiPlex GX620               
> >> [  173.156502] RIP: 0010:[<ffffffff813ea532>]  [<ffffffff813ea532>] check_modem_status+0xe7/0x29c
> > 
> > Several drivers have a function named check_modem_status(), but adt7470 is
> > not one of them. I'm curious how we can get there if the crash is in
> > driver adt7470. Stack corruption maybe?
> > 
> >> [  173.308056] RSP: 0018:ffff88007c803e18  EFLAGS: 00010006
> >> [  173.308056] RAX: 6b6b6b6b6b6b6b6b RBX: ffffffff82a55400 RCX: 0000000000000100
> >> [  173.308056] RDX: 00000000260b260a RSI: 0000000000000028 RDI: 0000000000000006
> >> [  173.308056] RBP: ffff88007c803e58 R08: 0000000000000006 R09: 395099858027a0e6
> >>
> >> <locked up tight here>
> > 
> > Can we see the kernel config you're running?
> 
> Sure, it's attached.  It's close to allmodconfig, with a few kconfig
> options changed to =y instead of =m and some others (like debug and self-tests)
> disabled.

OK. I'll try this config on my system and see if I can reproduce your
problem. Likely not before tomorrow though, as I have more urgent
issues to deal with right now.

-- 
Jean Delvare

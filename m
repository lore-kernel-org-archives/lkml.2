Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab1HIOXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:23:41 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46773 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750722Ab1HIOXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:23:40 -0400
Date: Tue, 9 Aug 2011 10:23:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jesper Juhl <jj@chaosbits.net>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Crash when suspending Lenovo T510 laptop (2.6.39.3)
In-Reply-To: <alpine.LNX.2.00.1108091426090.17636@swampdragon.chaosbits.net>
Message-ID: <Pine.LNX.4.44L0.1108091021020.1949-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Aug 2011, Jesper Juhl wrote:

> Just happened again, this time with 3.0.1 :
> 
> [30377.372749] ------------[ cut here ]------------
> [30377.372779] WARNING: at drivers/net/e1000e/netdev.c:5235 __e1000_shutdown+0x43f/0x4c0 [e1000e]()
> [30377.372783] Hardware name: 4384GJG
> [30377.372786] Modules linked in: vboxnetadp vboxnetflt vboxdrv appletalk ipx p8022 psnap llc p8023 ipv6 snd_hda_codec_hdmi snd_hda_codec_conexant uvcvideo videodev media v4l2_compat_ioctl32 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm cpufreq_ondemand serio_raw arc4 snd_timer snd_page_alloc psmouse i915 drm_kms_helper sg msr drm acpi_cpufreq iwlagn i2c_algo_bit mac80211 freq_table video evdev e1000e firewire_ohci i2c_i801 battery mxm_wmi i2c_core cfg80211 mei(C) tpm_tis firewire_core iTCO_wdt ac iTCO_vendor_support tpm intel_agp crc_itu_t sdhci_pci sdhci mmc_core intel_ips intel_gtt tpm_bios thermal pcspkr wmi mperf processor button thinkpad_acpi rfkill snd soundcore nvram ext4 mbcache jbd2 crc16 sr_mod cdrom sd_mod usbhid hid ahci libahci libata ehci_hcd scsi_mod usbcore [last unloaded: vboxdrv]
> [30377.372876] Pid: 17558, comm: kworker/1:0 Tainted: G         C  3.0-ARCH #1
> [30377.372879] Call Trace:
> [30377.372895]  [<ffffffff8105c7bf>] warn_slowpath_common+0x7f/0xc0
> [30377.372898]  [<ffffffff8105c81a>] warn_slowpath_null+0x1a/0x20
> [30377.372902]  [<ffffffffa02603cf>] __e1000_shutdown+0x43f/0x4c0 [e1000e]
> [30377.372906]  [<ffffffffa0260489>] e1000_runtime_suspend+0x39/0x50 [e1000e]
> [30377.372911]  [<ffffffff81240b9d>] pci_pm_runtime_suspend+0x4d/0x100

It seems to me that this is a bug in the e1000e driver.  Therefore you 
should CC: the maintainer for that driver; that's who is most likely to 
be able to fix it.

Alan Stern


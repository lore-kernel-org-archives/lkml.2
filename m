Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934553Ab1KCT1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 15:27:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755022Ab1KCT1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 15:27:48 -0400
Date: Thu, 3 Nov 2011 15:27:43 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: pci_has_legacy_pm_support warning with 3.1+
Message-ID: <20111103192742.GA14216@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

We just got a report of someone tripping over a WARN_ON that has been in
the PCI code for quite a while (line 607 of drivers/pci/pci-driver.c).
I'm wondering if someone can make a bit more sense of it than I can and
maybe figure out which driver in question is doing something wrong.

:WARNING: at drivers/pci/pci-driver.c:607 pci_has_legacy_pm_support+0x40/0x70()
:Hardware name: 4174BH4
:Modules linked in: coretemp thinkpad_acpi cpufreq_stats fuse lockd ip6t_REJECT
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4
nf_defrag_ipv4 xt_state nf_conntrack vfat fat snd_hda_codec_hdmi
snd_hda_codec_conexant arc4 uvcvideo videodev media v4l2_compat_ioctl32 btusb
bluetooth microcode joydev snd_hda_intel snd_hda_codec snd_hwdep snd_seq
snd_seq_device snd_pcm iwlwifi mac80211 iTCO_wdt iTCO_vendor_support i2c_i801
cfg80211 snd_timer snd_page_alloc e1000e wmi rfkill snd soundcore uinput sunrpc
xts gf128mul dm_crypt btrfs zlib_deflate libcrc32c sdhci_pci sdhci mmc_core
i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: i2c_dev]
:Pid: 3331, comm: kworker/u:3 Not tainted 3.2.0-0.rc0.git4.1.fc17.x86_64 #1
:Call Trace:
: [<ffffffff8107ce3f>] warn_slowpath_common+0x7f/0xc0
: [<ffffffff813fac3b>] ? __device_suspend+0xab/0x2e0
: [<ffffffff8107ce9a>] warn_slowpath_null+0x1a/0x20
: [<ffffffff8132c710>] pci_has_legacy_pm_support+0x40/0x70
: [<ffffffff813fac3b>] ? __device_suspend+0xab/0x2e0
: [<ffffffff8132cd72>] pci_pm_suspend+0x42/0x130
: [<ffffffff813faad5>] pm_op+0x175/0x1c0
: [<ffffffff813fae29>] __device_suspend+0x299/0x2e0
: [<ffffffff813fb71f>] async_suspend+0x1f/0xa0
: [<ffffffff810ae348>] async_run_entry_fn+0x88/0x170
: [<ffffffff8109f013>] process_one_work+0x1d3/0x6d0
: [<ffffffff8109efb2>] ? process_one_work+0x172/0x6d0
: [<ffffffff810ae2c0>] ? async_schedule+0x20/0x20
: [<ffffffff8109f8ee>] worker_thread+0x15e/0x350
: [<ffffffff8109f790>] ? rescuer_thread+0x240/0x240
: [<ffffffff810a4f20>] kthread+0xb0/0xc0
: [<ffffffff8167f304>] kernel_thread_helper+0x4/0x10
: [<ffffffff81674c34>] ? retint_restore_args+0x13/0x13
: [<ffffffff810a4e70>] ? __init_kthread_worker+0x70/0x70
:ehci_hcd 0000:00:1d.0: PCI INT A disabled
: [<ffffffff8167f300>] ? gs_change+0x13/0x13

The full report (filed by abrtd) can be found here:
https://bugzilla.redhat.com/show_bug.cgi?id=751167

Thanks,
josh


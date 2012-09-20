Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab2ITMKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:10:52 -0400
Received: from tee.schottelius.org ([77.109.138.222]:51903 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754250Ab2ITMKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:10:49 -0400
Date: Thu, 20 Sep 2012 14:12:26 +0200
From: Nico Schottelius <nico-kernel20120920@schottelius.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: Nico Schottelius <nico-kernel20120920@schottelius.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: Out of memory on 3.5 kernels
Message-ID: <20120920121226.GA31797@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-kernel20120920@schottelius.org>,
	Arend van Spriel <arend@broadcom.com>,
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
References: <20120920060202.GB10758@schottelius.org>
 <alpine.DEB.2.00.1209192351440.30029@chino.kir.corp.google.com>
 <20120920073245.GA1327@schottelius.org>
 <505AC952.60501@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505AC952.60501@broadcom.com>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.5.4-1-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Arend,

just while running, I got the following brcmsmac related error:

[17336.572558] WARNING: at drivers/net/wireless/brcm80211/brcmsmac/main.c:7968 brcms_c_wait_for_tx_completion+0x99/0xb0 [brcmsmac]()
[17336.572562] Hardware name: MacBookAir4,2
[17336.572565] Modules linked in: sha256_generic snd_hda_codec_hdmi snd_hda_codec_cirrus ext4 jbd2 mbcache arc4 uvcvideo brcmsmac videobuf2_vmalloc videobuf2_memops cordic brcmutil btusb bluetooth i915 videobuf2_core mac80211 videodev crc16 acpi_cpufreq snd_hda_intel media i2c_algo_bit cfg80211 mperf drm_kms_helper snd_hda_codec rfkill joydev bcm5974 iTCO_wdt iTCO_vendor_support i2c_i801 intel_agp lpc_ich applesmc evdev microcode drm coretemp input_polldev pcspkr intel_gtt mfd_core i2c_core processor bcma snd_hwdep video button battery apple_bl mei ac snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_timer snd soundcore kvm_intel kvm nfs nfs_acl lockd auth_rpcgss sunrpc fscache autofs4 jfs xts gf128mul dm_crypt dm_mod sd_mod pata_acpi ata_generic hid_generic usb_storage hid_apple usbhid hid uhci_hcd aesni_intel aes_x86_64 aes_generic ghash_clmulni_intel cryptd crc32c_intel ata_piix libata scsi_mod ehci_hcd usbcore usb_common
[17336.572716] Pid: 27714, comm: kworker/u:1 Not tainted 3.5.4-1-ARCH #1
[17336.572719] Call Trace:
[17336.572734]  [<ffffffff81051a3f>] warn_slowpath_common+0x7f/0xc0
[17336.572743]  [<ffffffff81051a9a>] warn_slowpath_null+0x1a/0x20
[17336.572759]  [<ffffffffa063bd29>] brcms_c_wait_for_tx_completion+0x99/0xb0 [brcmsmac]
[17336.572769]  [<ffffffffa062e1bb>] brcms_ops_flush+0x3b/0x60 [brcmsmac]
[17336.572792]  [<ffffffffa04a2f69>] ieee80211_mgd_probe_ap_send+0xc9/0x230 [mac80211]
[17336.572809]  [<ffffffffa04a374f>] ieee80211_mgd_probe_ap.part.22+0x10f/0x130 [mac80211]
[17336.572823]  [<ffffffffa04a381d>] ieee80211_beacon_connection_loss_work+0xad/0x160 [mac80211]
[17336.572833]  [<ffffffff8106effa>] process_one_work+0x12a/0x440
[17336.572848]  [<ffffffffa04a3770>] ? ieee80211_mgd_probe_ap.part.22+0x130/0x130 [mac80211]
[17336.572857]  [<ffffffff8106f85e>] worker_thread+0x12e/0x2d0
[17336.572865]  [<ffffffff8106f730>] ? manage_workers.isra.26+0x1f0/0x1f0
[17336.572872]  [<ffffffff81074f73>] kthread+0x93/0xa0
[17336.572880]  [<ffffffff81486864>] kernel_thread_helper+0x4/0x10
[17336.572888]  [<ffffffff81074ee0>] ? kthread_freezable_should_stop+0x70/0x70
[17336.572894]  [<ffffffff81486860>] ? gs_change+0x13/0x13
[17336.572898] ---[ end trace 87315886d62eca54 ]---


Things are still running, though and slab is ~274 MiB.

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0

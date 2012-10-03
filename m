Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab2JCVX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 17:23:28 -0400
Received: from tee.schottelius.org ([77.109.138.222]:59651 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756223Ab2JCVXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 17:23:19 -0400
Date: Wed, 3 Oct 2012 23:23:11 +0200
From: Nico Schottelius <nico-kernel20120920@schottelius.org>
To: Nico Schottelius <nico-kernel20120920@schottelius.org>,
        David Rientjes <rientjes@google.com>,
        Arend van Spriel <arend@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Dave Kleikamp <shaggy@kernel.org>,
        jfs-discussion@lists.sourceforge.net
Subject: Re: Out of memory on 3.5 kernels
Message-ID: <20121003212311.GA14018@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-kernel20120920@schottelius.org>,
	David Rientjes <rientjes@google.com>,
	Arend van Spriel <arend@broadcom.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net
References: <505B1FA0.6030100@broadcom.com>
 <20120921194931.GA732@schottelius.org>
 <alpine.DEB.2.00.1209241538310.6356@chino.kir.corp.google.com>
 <20120926060653.GD16575@schottelius.org>
 <20120926085708.GA7839@schottelius.org>
 <20120927055208.GA25252@schottelius.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <20120927055208.GA25252@schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.5.4-1-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

does anyone of you have a clue so far what may be causing the huge
slab usage?

I've just found an interesting detail: umounting and cryptsetup
luksClosing frees up the used memory (not sure which one was freeing
up)

Attached are dmesg, slabtop output during the backup and after umounting.

Cheers,

Nico


-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0

--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg
Content-Transfer-Encoding: quoted-printable


[179480.129403] Pid: 21263, comm: kworker/1:1 Tainted: G        W    3.5.4-=
1-ARCH #1
[179480.129404] Call Trace:

[179480.129409]  [<ffffffff81051a3f>] warn_slowpath_common+0x7f/0xc0

[179480.129411]  [<ffffffff81051b36>] warn_slowpath_fmt+0x46/0x50

[179480.129418]  [<ffffffffa05389ba>] intel_dp_aux_ch+0xda/0x380 [i915]

[179480.129422]  [<ffffffffa0538eb5>] intel_dp_aux_native_read_retry+0xb5/0=
x140 [i915]

[179480.129427]  [<ffffffffa053a828>] intel_dp_detect+0x218/0x2a0 [i915]

[179480.129431]  [<ffffffffa019a622>] drm_helper_probe_single_connector_mod=
es+0x1a2/0x340 [drm_kms_helper]

[179480.129433]  [<ffffffffa0198030>] drm_fb_helper_probe_connector_modes.i=
sra.2+0x50/0x70 [drm_kms_helper]

[179480.129435]  [<ffffffffa01990b2>] drm_fb_helper_hotplug_event+0xc2/0x12=
0 [drm_kms_helper]

[179480.129440]  [<ffffffffa0548aac>] intel_fb_output_poll_changed+0x1c/0x2=
0 [i915]

[179480.129442]  [<ffffffffa0199be8>] output_poll_execute+0x198/0x1b0 [drm_=
kms_helper]

[179480.129445]  [<ffffffff8106effa>] process_one_work+0x12a/0x440

[179480.129447]  [<ffffffffa0199a50>] ? drm_helper_connector_dpms+0x130/0x1=
30 [drm_kms_helper]

[179480.129448]  [<ffffffff8106f85e>] worker_thread+0x12e/0x2d0

[179480.129450]  [<ffffffff8106f730>] ? manage_workers.isra.26+0x1f0/0x1f0

[179480.129452]  [<ffffffff81074f73>] kthread+0x93/0xa0

[179480.129455]  [<ffffffff81486864>] kernel_thread_helper+0x4/0x10

[179480.129456]  [<ffffffff81074ee0>] ? kthread_freezable_should_stop+0x70/=
0x70

[179480.129458]  [<ffffffff81486860>] ? gs_change+0x13/0x13
[179480.129459] ---[ end trace 52d31f5c575f718a ]---
[179480.222506] ------------[ cut here ]------------
[179480.222536] WARNING: at drivers/gpu/drm/i915/intel_dp.c:412 intel_dp_au=
x_ch+0xda/0x380 [i915]()
[179480.222537] Hardware name: MacBookAir4,2
[179480.222537] dp_aux_ch not started status 0xffffffff
[179480.222538] Modules linked in:
[179480.222539]  fuse
[179480.222539]  tun
[179480.222539]  snd_hda_codec_hdmi
[179480.222540]  snd_hda_codec_cirrus
[179480.222540]  ext4
[179480.222540]  jbd2
[179480.222541]  mbcache
[179480.222541]  btusb
[179480.222541]  bluetooth
[179480.222542]  joydev
[179480.222542]  uvcvideo
[179480.222542]  videobuf2_vmalloc
[179480.222543]  crc16
[179480.222543]  videobuf2_memops
[179480.222543]  videobuf2_core
[179480.222544]  videodev
[179480.222544]  bcm5974
[179480.222544]  media
[179480.222545]  arc4
[179480.222545]  brcmsmac
[179480.222545]  cordic
[179480.222545]  brcmutil
[179480.222546]  i915
[179480.222546]  mac80211
[179480.222547]  cfg80211
[179480.222547]  i2c_algo_bit
[179480.222548]  drm_kms_helper
[179480.222549]  rfkill
[179480.222549]  iTCO_wdt
[179480.222549]  drm
[179480.222550]  iTCO_vendor_support
[179480.222550]  snd_hda_intel
[179480.222551]  snd_hda_codec
[179480.222551]  lpc_ich
[179480.222552]  acpi_cpufreq
[179480.222552]  intel_agp
[179480.222553]  applesmc
[179480.222553]  microcode
[179480.222554]  coretemp
[179480.222554]  evdev
[179480.222554]  input_polldev
[179480.222555]  pcspkr
[179480.222555]  mfd_core
[179480.222556]  i2c_i801
[179480.222556]  bcma
[179480.222557]  snd_hwdep
[179480.222557]  mei
[179480.222557]  i2c_core
[179480.222558]  intel_gtt
[179480.222558]  mperf
[179480.222559]  video
[179480.222559]  ac
[179480.222560]  processor
[179480.222560]  battery
[179480.222561]  apple_bl
[179480.222561]  button
[179480.222562]  snd_pcm_oss
[179480.222562]  snd_mixer_oss
[179480.222563]  snd_pcm
[179480.222563]  snd_page_alloc
[179480.222564]  snd_timer
[179480.222564]  snd
[179480.222565]  soundcore
[179480.222565]  kvm_intel
[179480.222565]  kvm
[179480.222566]  nfs
[179480.222566]  nfs_acl
[179480.222567]  lockd
[179480.222567]  auth_rpcgss
[179480.222567]  sunrpc
[179480.222568]  fscache
[179480.222568]  autofs4
[179480.222569]  jfs
[179480.222569]  xts
[179480.222570]  gf128mul
[179480.222570]  dm_crypt
[179480.222571]  dm_mod
[179480.222571]  sd_mod
[179480.222571]  pata_acpi
[179480.222572]  ata_generic
[179480.222573]  hid_generic
[179480.222573]  usb_storage
[179480.222573]  hid_apple
[179480.222574]  usbhid
[179480.222574]  hid
[179480.222575]  aesni_intel
[179480.222575]  uhci_hcd
[179480.222576]  aes_x86_64
[179480.222576]  aes_generic
[179480.222576]  ghash_clmulni_intel
[179480.222577]  cryptd
[179480.222577]  ata_piix
[179480.222578]  crc32c_intel
[179480.222578]  libata
[179480.222579]  ehci_hcd
[179480.222579]  usbcore
[179480.222580]  scsi_mod
[179480.222580]  usb_common

[179480.222583] Pid: 21263, comm: kworker/1:1 Tainted: G        W    3.5.4-=
1-ARCH #1
[179480.222583] Call Trace:

[179480.222588]  [<ffffffff81051a3f>] warn_slowpath_common+0x7f/0xc0

[179480.222590]  [<ffffffff81051b36>] warn_slowpath_fmt+0x46/0x50

[179480.222596]  [<ffffffffa05389ba>] intel_dp_aux_ch+0xda/0x380 [i915]

[179480.222601]  [<ffffffffa0538eb5>] intel_dp_aux_native_read_retry+0xb5/0=
x140 [i915]

[179480.222604]  [<ffffffff81257911>] ? vsnprintf+0x461/0x600

[179480.222609]  [<ffffffffa0538f64>] intel_dp_get_dpcd+0x24/0x40 [i915]

[179480.222613]  [<ffffffffa053a665>] intel_dp_detect+0x55/0x2a0 [i915]

[179480.222617]  [<ffffffffa019a622>] drm_helper_probe_single_connector_mod=
es+0x1a2/0x340 [drm_kms_helper]

[179480.222619]  [<ffffffffa0198030>] drm_fb_helper_probe_connector_modes.i=
sra.2+0x50/0x70 [drm_kms_helper]

[179480.222622]  [<ffffffffa01990b2>] drm_fb_helper_hotplug_event+0xc2/0x12=
0 [drm_kms_helper]

[179480.222627]  [<ffffffffa0548aac>] intel_fb_output_poll_changed+0x1c/0x2=
0 [i915]

[179480.222629]  [<ffffffffa0199be8>] output_poll_execute+0x198/0x1b0 [drm_=
kms_helper]

[179480.222633]  [<ffffffff8106effa>] process_one_work+0x12a/0x440

[179480.222635]  [<ffffffffa0199a50>] ? drm_helper_connector_dpms+0x130/0x1=
30 [drm_kms_helper]

[179480.222637]  [<ffffffff8106f85e>] worker_thread+0x12e/0x2d0

[179480.222639]  [<ffffffff8106f730>] ? manage_workers.isra.26+0x1f0/0x1f0

[179480.222641]  [<ffffffff81074f73>] kthread+0x93/0xa0

[179480.222643]  [<ffffffff81486864>] kernel_thread_helper+0x4/0x10

[179480.222645]  [<ffffffff81074ee0>] ? kthread_freezable_should_stop+0x70/=
0x70

[179480.222646]  [<ffffffff81486860>] ? gs_change+0x13/0x13
[179480.222647] ---[ end trace 52d31f5c575f718b ]---
[179480.249135] ------------[ cut here ]------------
[179480.249168] WARNING: at drivers/gpu/drm/i915/intel_dp.c:412 intel_dp_au=
x_ch+0xda/0x380 [i915]()
[179480.249169] Hardware name: MacBookAir4,2
[179480.249170] dp_aux_ch not started status 0xffffffff
[179480.249170] Modules linked in:
[179480.249171]  fuse
[179480.249171]  tun
[179480.249171]  snd_hda_codec_hdmi
[179480.249172]  snd_hda_codec_cirrus
[179480.249172]  ext4
[179480.249172]  jbd2
[179480.249173]  mbcache
[179480.249173]  btusb
[179480.249173]  bluetooth
[179480.249174]  joydev
[179480.249174]  uvcvideo
[179480.249174]  videobuf2_vmalloc
[179480.249175]  crc16
[179480.249175]  videobuf2_memops
[179480.249175]  videobuf2_core
[179480.249176]  videodev
[179480.249176]  bcm5974
[179480.249176]  media
[179480.249176]  arc4
[179480.249177]  brcmsmac
[179480.249177]  cordic
[179480.249177]  brcmutil
[179480.249178]  i915
[179480.249178]  mac80211
[179480.249178]  cfg80211
[179480.249179]  i2c_algo_bit
[179480.249179]  drm_kms_helper
[179480.249180]  rfkill
[179480.249181]  iTCO_wdt
[179480.249181]  drm
[179480.249181]  iTCO_vendor_support
[179480.249182]  snd_hda_intel
[179480.249182]  snd_hda_codec
[179480.249183]  lpc_ich
[179480.249183]  acpi_cpufreq
[179480.249184]  intel_agp
[179480.249184]  applesmc
[179480.249185]  microcode
[179480.249185]  coretemp
[179480.249186]  evdev
[179480.249186]  input_polldev
[179480.249187]  pcspkr
[179480.249187]  mfd_core
[179480.249187]  i2c_i801
[179480.249188]  bcma
[179480.249188]  snd_hwdep
[179480.249189]  mei
[179480.249189]  i2c_core
[179480.249190]  intel_gtt
[179480.249190]  mperf
[179480.249191]  video
[179480.249191]  ac
[179480.249192]  processor
[179480.249192]  battery
[179480.249193]  apple_bl
[179480.249194]  button
[179480.249194]  snd_pcm_oss
[179480.249195]  snd_mixer_oss
[179480.249195]  snd_pcm
[179480.249196]  snd_page_alloc
[179480.249196]  snd_timer
[179480.249196]  snd
[179480.249197]  soundcore
[179480.249197]  kvm_intel
[179480.249198]  kvm
[179480.249198]  nfs
[179480.249198]  nfs_acl
[179480.249199]  lockd
[179480.249199]  auth_rpcgss
[179480.249200]  sunrpc
[179480.249200]  fscache
[179480.249201]  autofs4
[179480.249201]  jfs
[179480.249202]  xts
[179480.249202]  gf128mul
[179480.249203]  dm_crypt
[179480.249203]  dm_mod
[179480.249203]  sd_mod
[179480.249204]  pata_acpi
[179480.249204]  ata_generic
[179480.249205]  hid_generic
[179480.249205]  usb_storage
[179480.249206]  hid_apple
[179480.249206]  usbhid
[179480.249206]  hid
[179480.249207]  aesni_intel
[179480.249207]  uhci_hcd
[179480.249208]  aes_x86_64
[179480.249208]  aes_generic
[179480.249209]  ghash_clmulni_intel
[179480.249209]  cryptd
[179480.249209]  ata_piix
[179480.249210]  crc32c_intel
[179480.249211]  libata
[179480.249211]  ehci_hcd
[179480.249212]  usbcore
[179480.249212]  scsi_mod
[179480.249213]  usb_common

[179480.249215] Pid: 21263, comm: kworker/1:1 Tainted: G        W    3.5.4-=
1-ARCH #1
[179480.249215] Call Trace:

[179480.249221]  [<ffffffff81051a3f>] warn_slowpath_common+0x7f/0xc0

[179480.249223]  [<ffffffff81051b36>] warn_slowpath_fmt+0x46/0x50

[179480.249229]  [<ffffffffa05389ba>] intel_dp_aux_ch+0xda/0x380 [i915]

[179480.249233]  [<ffffffffa0538eb5>] intel_dp_aux_native_read_retry+0xb5/0=
x140 [i915]

[179480.249237]  [<ffffffff81257911>] ? vsnprintf+0x461/0x600

[179480.249241]  [<ffffffffa0538f64>] intel_dp_get_dpcd+0x24/0x40 [i915]

[179480.249245]  [<ffffffffa053a665>] intel_dp_detect+0x55/0x2a0 [i915]

[179480.249249]  [<ffffffffa019a622>] drm_helper_probe_single_connector_mod=
es+0x1a2/0x340 [drm_kms_helper]

[179480.249252]  [<ffffffffa0198030>] drm_fb_helper_probe_connector_modes.i=
sra.2+0x50/0x70 [drm_kms_helper]

[179480.249254]  [<ffffffffa01990b2>] drm_fb_helper_hotplug_event+0xc2/0x12=
0 [drm_kms_helper]

[179480.249259]  [<ffffffffa0548aac>] intel_fb_output_poll_changed+0x1c/0x2=
0 [i915]

[179480.249262]  [<ffffffffa0199be8>] output_poll_execute+0x198/0x1b0 [drm_=
kms_helper]

[179480.249265]  [<ffffffff8106effa>] process_one_work+0x12a/0x440

[179480.249267]  [<ffffffffa0199a50>] ? drm_helper_connector_dpms+0x130/0x1=
30 [drm_kms_helper]

[179480.249269]  [<ffffffff8106f85e>] worker_thread+0x12e/0x2d0

[179480.249271]  [<ffffffff8106f730>] ? manage_workers.isra.26+0x1f0/0x1f0

[179480.249273]  [<ffffffff81074f73>] kthread+0x93/0xa0

[179480.249275]  [<ffffffff81486864>] kernel_thread_helper+0x4/0x10

[179480.249277]  [<ffffffff81074ee0>] ? kthread_freezable_should_stop+0x70/=
0x70

[179480.249278]  [<ffffffff81486860>] ? gs_change+0x13/0x13
[179480.249279] ---[ end trace 52d31f5c575f718c ]---
[179480.275757] ------------[ cut here ]------------
[179480.275788] WARNING: at drivers/gpu/drm/i915/intel_dp.c:412 intel_dp_au=
x_ch+0xda/0x380 [i915]()
[179480.275789] Hardware name: MacBookAir4,2
[179480.275790] dp_aux_ch not started status 0xffffffff
[179480.275790] Modules linked in:
[179480.275791]  fuse
[179480.275791]  tun
[179480.275791]  snd_hda_codec_hdmi
[179480.275792]  snd_hda_codec_cirrus
[179480.275792]  ext4
[179480.275792]  jbd2
[179480.275793]  mbcache
[179480.275793]  btusb
[179480.275793]  bluetooth
[179480.275794]  joydev
[179480.275794]  uvcvideo
[179480.275794]  videobuf2_vmalloc
[179480.275795]  crc16
[179480.275795]  videobuf2_memops
[179480.275795]  videobuf2_core
[179480.275796]  videodev
[179480.275796]  bcm5974
[179480.275796]  media
[179480.275796]  arc4
[179480.275797]  brcmsmac
[179480.275797]  cordic
[179480.275797]  brcmutil
[179480.275798]  i915
[179480.275798]  mac80211
[179480.275799]  cfg80211
[179480.275799]  i2c_algo_bit
[179480.275800]  drm_kms_helper
[179480.275800]  rfkill
[179480.275801]  iTCO_wdt
[179480.275801]  drm
[179480.275802]  iTCO_vendor_support
[179480.275802]  snd_hda_intel
[179480.275803]  snd_hda_codec
[179480.275803]  lpc_ich
[179480.275803]  acpi_cpufreq
[179480.275804]  intel_agp
[179480.275804]  applesmc
[179480.275805]  microcode
[179480.275806]  coretemp
[179480.275806]  evdev
[179480.275807]  input_polldev
[179480.275807]  pcspkr
[179480.275807]  mfd_core
[179480.275808]  i2c_i801
[179480.275808]  bcma
[179480.275809]  snd_hwdep
[179480.275809]  mei
[179480.275810]  i2c_core
[179480.275810]  intel_gtt
[179480.275811]  mperf
[179480.275811]  video
[179480.275812]  ac
[179480.275812]  processor
[179480.275812]  battery
[179480.275813]  apple_bl
[179480.275813]  button
[179480.275814]  snd_pcm_oss
[179480.275815]  snd_mixer_oss
[179480.275815]  snd_pcm
[179480.275816]  snd_page_alloc
[179480.275816]  snd_timer
[179480.275817]  snd
[179480.275817]  soundcore
[179480.275818]  kvm_intel
[179480.275818]  kvm
[179480.275818]  nfs
[179480.275819]  nfs_acl
[179480.275819]  lockd
[179480.275820]  auth_rpcgss
[179480.275820]  sunrpc
[179480.275821]  fscache
[179480.275821]  autofs4
[179480.275822]  jfs
[179480.275823]  xts
[179480.275823]  gf128mul
[179480.275823]  dm_crypt
[179480.275824]  dm_mod
[179480.275824]  sd_mod
[179480.275825]  pata_acpi
[179480.275825]  ata_generic
[179480.275826]  hid_generic
[179480.275826]  usb_storage
[179480.275827]  hid_apple
[179480.275827]  usbhid
[179480.275827]  hid
[179480.275828]  aesni_intel
[179480.275828]  uhci_hcd
[179480.275829]  aes_x86_64
[179480.275829]  aes_generic
[179480.275830]  ghash_clmulni_intel
[179480.275830]  cryptd
[179480.275831]  ata_piix
[179480.275831]  crc32c_intel
[179480.275832]  libata
[179480.275832]  ehci_hcd
[179480.275833]  usbcore
[179480.275833]  scsi_mod
[179480.275834]  usb_common

[179480.275836] Pid: 21263, comm: kworker/1:1 Tainted: G        W    3.5.4-=
1-ARCH #1
[179480.275836] Call Trace:

[179480.275842]  [<ffffffff81051a3f>] warn_slowpath_common+0x7f/0xc0

[179480.275844]  [<ffffffff81051b36>] warn_slowpath_fmt+0x46/0x50

[179480.275850]  [<ffffffffa05389ba>] intel_dp_aux_ch+0xda/0x380 [i915]

[179480.275854]  [<ffffffffa0538eb5>] intel_dp_aux_native_read_retry+0xb5/0=
x140 [i915]

[179480.275858]  [<ffffffff81257911>] ? vsnprintf+0x461/0x600

[179480.275862]  [<ffffffffa0538f64>] intel_dp_get_dpcd+0x24/0x40 [i915]

[179480.275867]  [<ffffffffa053a665>] intel_dp_detect+0x55/0x2a0 [i915]

[179480.275870]  [<ffffffffa019a622>] drm_helper_probe_single_connector_mod=
es+0x1a2/0x340 [drm_kms_helper]

[179480.275873]  [<ffffffffa0198030>] drm_fb_helper_probe_connector_modes.i=
sra.2+0x50/0x70 [drm_kms_helper]

[179480.275875]  [<ffffffffa01990b2>] drm_fb_helper_hotplug_event+0xc2/0x12=
0 [drm_kms_helper]

[179480.275880]  [<ffffffffa0548aac>] intel_fb_output_poll_changed+0x1c/0x2=
0 [i915]

[179480.275883]  [<ffffffffa0199be8>] output_poll_execute+0x198/0x1b0 [drm_=
kms_helper]

[179480.275885]  [<ffffffff8106effa>] process_one_work+0x12a/0x440

[179480.275888]  [<ffffffffa0199a50>] ? drm_helper_connector_dpms+0x130/0x1=
30 [drm_kms_helper]

[179480.275889]  [<ffffffff8106f85e>] worker_thread+0x12e/0x2d0

[179480.275891]  [<ffffffff8106f730>] ? manage_workers.isra.26+0x1f0/0x1f0

[179480.275892]  [<ffffffff81074f73>] kthread+0x93/0xa0

[179480.275894]  [<ffffffff81486864>] kernel_thread_helper+0x4/0x10

[179480.275896]  [<ffffffff81074ee0>] ? kthread_freezable_should_stop+0x70/=
0x70

[179480.275897]  [<ffffffff81486860>] ? gs_change+0x13/0x13
[179480.275898] ---[ end trace 52d31f5c575f718d ]---
[179480.435507] ------------[ cut here ]------------
[179480.435539] WARNING: at drivers/gpu/drm/i915/intel_dp.c:412 intel_dp_au=
x_ch+0xda/0x380 [i915]()
[179480.435540] Hardware name: MacBookAir4,2
[179480.435540] dp_aux_ch not started status 0xffffffff
[179480.435541] Modules linked in:
[179480.435541]  fuse
[179480.435542]  tun
[179480.435542]  snd_hda_codec_hdmi
[179480.435543]  snd_hda_codec_cirrus
[179480.435543]  ext4
[179480.435543]  jbd2
[179480.435544]  mbcache
[179480.435544]  btusb
[179480.435544]  bluetooth
[179480.435545]  joydev
[179480.435545]  uvcvideo
[179480.435545]  videobuf2_vmalloc
[179480.435546]  crc16
[179480.435546]  videobuf2_memops
[179480.435546]  videobuf2_core
[179480.435547]  videodev
[179480.435547]  bcm5974
[179480.435547]  media
[179480.435547]  arc4
[179480.435548]  brcmsmac
[179480.435548]  cordic
[179480.435548]  brcmutil
[179480.435549]  i915
[179480.435549]  mac80211
[179480.435550]  cfg80211
[179480.435550]  i2c_algo_bit
[179480.435551]  drm_kms_helper
[179480.435551]  rfkill
[179480.435552]  iTCO_wdt
[179480.435552]  drm
[179480.435552]  iTCO_vendor_support
[179480.435553]  snd_hda_intel
[179480.435554]  snd_hda_codec
[179480.435554]  lpc_ich
[179480.435555]  acpi_cpufreq
[179480.435555]  intel_agp
[179480.435556]  applesmc
[179480.435556]  microcode
[179480.435557]  coretemp
[179480.435557]  evdev
[179480.435557]  input_polldev
[179480.435558]  pcspkr
[179480.435558]  mfd_core
[179480.435559]  i2c_i801
[179480.435559]  bcma
[179480.435560]  snd_hwdep
[179480.435560]  mei
[179480.435561]  i2c_core
[179480.435561]  intel_gtt
[179480.435562]  mperf
[179480.435562]  video
[179480.435563]  ac
[179480.435563]  processor
[179480.435563]  battery
[179480.435564]  apple_bl
[179480.435564]  button
[179480.435565]  snd_pcm_oss
[179480.435565]  snd_mixer_oss
[179480.435566]  snd_pcm
[179480.435566]  snd_page_alloc
[179480.435567]  snd_timer
[179480.435567]  snd
[179480.435568]  soundcore
[179480.435568]  kvm_intel
[179480.435568]  kvm
[179480.435569]  nfs
[179480.435569]  nfs_acl
[179480.435570]  lockd
[179480.435570]  auth_rpcgss
[179480.435571]  sunrpc
[179480.435571]  fscache
[179480.435572]  autofs4
[179480.435572]  jfs
[179480.435573]  xts
[179480.435573]  gf128mul
[179480.435573]  dm_crypt
[179480.435574]  dm_mod
[179480.435574]  sd_mod
[179480.435575]  pata_acpi
[179480.435575]  ata_generic
[179480.435576]  hid_generic
[179480.435576]  usb_storage
[179480.435577]  hid_apple
[179480.435577]  usbhid
[179480.435577]  hid
[179480.435578]  aesni_intel
[179480.435578]  uhci_hcd
[179480.435579]  aes_x86_64
[179480.435580]  aes_generic
[179480.435580]  ghash_clmulni_intel
[179480.435580]  cryptd
[179480.435581]  ata_piix
[179480.435581]  crc32c_intel
[179480.435582]  libata
[179480.435583]  ehci_hcd
[179480.435583]  usbcore
[179480.435584]  scsi_mod
[179480.435584]  usb_common

[179480.435586] Pid: 21263, comm: kworker/1:1 Tainted: G        W    3.5.4-=
1-ARCH #1
[179480.435587] Call Trace:

[179480.435592]  [<ffffffff81051a3f>] warn_slowpath_common+0x7f/0xc0

[179480.435594]  [<ffffffff81051b36>] warn_slowpath_fmt+0x46/0x50

[179480.435600]  [<ffffffffa05389ba>] intel_dp_aux_ch+0xda/0x380 [i915]

[179480.435604]  [<ffffffffa0538eb5>] intel_dp_aux_native_read_retry+0xb5/0=
x140 [i915]

[179480.435607]  [<ffffffff81257911>] ? vsnprintf+0x461/0x600

[179480.435612]  [<ffffffffa0538f64>] intel_dp_get_dpcd+0x24/0x40 [i915]

[179480.435617]  [<ffffffffa053a665>] intel_dp_detect+0x55/0x2a0 [i915]

[179480.435620]  [<ffffffffa019a622>] drm_helper_probe_single_connector_mod=
es+0x1a2/0x340 [drm_kms_helper]

[179480.435623]  [<ffffffffa0198030>] drm_fb_helper_probe_connector_modes.i=
sra.2+0x50/0x70 [drm_kms_helper]

[179480.435625]  [<ffffffffa01990b2>] drm_fb_helper_hotplug_event+0xc2/0x12=
0 [drm_kms_helper]

[179480.435630]  [<ffffffffa0548aac>] intel_fb_output_poll_changed+0x1c/0x2=
0 [i915]

[179480.435633]  [<ffffffffa0199be8>] output_poll_execute+0x198/0x1b0 [drm_=
kms_helper]

[179480.435636]  [<ffffffff8106effa>] process_one_work+0x12a/0x440

[179480.435638]  [<ffffffffa0199a50>] ? drm_helper_connector_dpms+0x130/0x1=
30 [drm_kms_helper]

[179480.435640]  [<ffffffff8106f85e>] worker_thread+0x12e/0x2d0

[179480.435641]  [<ffffffff8106f730>] ? manage_workers.isra.26+0x1f0/0x1f0

[179480.435643]  [<ffffffff81074f73>] kthread+0x93/0xa0

[179480.435645]  [<ffffffff81486864>] kernel_thread_helper+0x4/0x10

[179480.435647]  [<ffffffff81074ee0>] ? kthread_freezable_should_stop+0x70/=
0x70

[179480.435648]  [<ffffffff81486860>] ? gs_change+0x13/0x13
[179480.435649] ---[ end trace 52d31f5c575f718e ]---
[179480.462134] ------------[ cut here ]------------
[179480.462165] WARNING: at drivers/gpu/drm/i915/intel_dp.c:412 intel_dp_au=
x_ch+0xda/0x380 [i915]()
[179480.462166] Hardware name: MacBookAir4,2
[179480.462167] dp_aux_ch not started status 0xffffffff
[179480.462168] Modules linked in:
[179480.462168]  fuse
[179480.462169]  tun
[179480.462169]  snd_hda_codec_hdmi
[179480.462169]  snd_hda_codec_cirrus
[179480.462170]  ext4
[179480.462170]  jbd2
[179480.462170]  mbcache
[179480.462171]  btusb
[179480.462171]  bluetooth
[179480.462171]  joydev
[179480.462172]  uvcvideo
[179480.462172]  videobuf2_vmalloc
[179480.462172]  crc16
[179480.462173]  videobuf2_memops
[179480.462173]  videobuf2_core
[179480.462173]  videodev
[179480.462173]  bcm5974
[179480.462174]  media
[179480.462174]  arc4
[179480.462175]  brcmsmac
[179480.462175]  cordic
[179480.462175]  brcmutil
[179480.462175]  i915
[179480.462176]  mac80211
[179480.462177]  cfg80211
[179480.462177]  i2c_algo_bit
[179480.462178]  drm_kms_helper
[179480.462178]  rfkill
[179480.462179]  iTCO_wdt
[179480.462179]  drm
[179480.462180]  iTCO_vendor_support
[179480.462180]  snd_hda_intel
[179480.462181]  snd_hda_codec
[179480.462181]  lpc_ich
[179480.462182]  acpi_cpufreq
[179480.462182]  intel_agp
[179480.462183]  applesmc
[179480.462183]  microcode
[179480.462184]  coretemp
[179480.462184]  evdev
[179480.462185]  input_polldev
[179480.462185]  pcspkr
[179480.462185]  mfd_core
[179480.462186]  i2c_i801
[179480.462186]  bcma
[179480.462187]  snd_hwdep
[179480.462187]  mei
[179480.462188]  i2c_core
[179480.462188]  intel_gtt
[179480.462189]  mperf
[179480.462189]  video
[179480.462189]  ac
[179480.462190]  processor
[179480.462190]  battery
[179480.462191]  apple_bl
[179480.462192]  button
[179480.462192]  snd_pcm_oss
[179480.462193]  snd_mixer_oss
[179480.462193]  snd_pcm
[179480.462194]  snd_page_alloc
[179480.462194]  snd_timer
[179480.462194]  snd
[179480.462195]  soundcore
[179480.462195]  kvm_intel
[179480.462196]  kvm
[179480.462196]  nfs
[179480.462196]  nfs_acl
[179480.462197]  lockd
[179480.462197]  auth_rpcgss
[179480.462198]  sunrpc
[179480.462198]  fscache
[179480.462199]  autofs4
[179480.462199]  jfs
[179480.462200]  xts
[179480.462201]  gf128mul
[179480.462201]  dm_crypt
[179480.462201]  dm_mod
[179480.462202]  sd_mod
[179480.462202]  pata_acpi
[179480.462203]  ata_generic
[179480.462203]  hid_generic
[179480.462204]  usb_storage
[179480.462204]  hid_apple
[179480.462204]  usbhid
[179480.462205]  hid
[179480.462205]  aesni_intel
[179480.462206]  uhci_hcd
[179480.462206]  aes_x86_64
[179480.462207]  aes_generic
[179480.462207]  ghash_clmulni_intel
[179480.462208]  cryptd
[179480.462208]  ata_piix
[179480.462209]  crc32c_intel
[179480.462209]  libata
[179480.462210]  ehci_hcd
[179480.462210]  usbcore
[179480.462210]  scsi_mod
[179480.462211]  usb_common

[179480.462213] Pid: 21263, comm: kworker/1:1 Tainted: G        W    3.5.4-=
1-ARCH #1
[179480.462214] Call Trace:

[179480.462220]  [<ffffffff81051a3f>] warn_slowpath_common+0x7f/0xc0

[179480.462222]  [<ffffffff81051b36>] warn_slowpath_fmt+0x46/0x50

[179480.462228]  [<ffffffffa05389ba>] intel_dp_aux_ch+0xda/0x380 [i915]

[179480.462232]  [<ffffffffa0538eb5>] intel_dp_aux_native_read_retry+0xb5/0=
x140 [i915]

[179480.462236]  [<ffffffff81257911>] ? vsnprintf+0x461/0x600

[179480.462240]  [<ffffffffa0538f64>] intel_dp_get_dpcd+0x24/0x40 [i915]

[179480.462244]  [<ffffffffa053a665>] intel_dp_detect+0x55/0x2a0 [i915]

[179480.462248]  [<ffffffffa019a622>] drm_helper_probe_single_connector_mod=
es+0x1a2/0x340 [drm_kms_helper]

[179480.462251]  [<ffffffffa0198030>] drm_fb_helper_probe_connector_modes.i=
sra.2+0x50/0x70 [drm_kms_helper]

[179480.462253]  [<ffffffffa01990b2>] drm_fb_helper_hotplug_event+0xc2/0x12=
0 [drm_kms_helper]

[179480.462258]  [<ffffffffa0548aac>] intel_fb_output_poll_changed+0x1c/0x2=
0 [i915]

[179480.462260]  [<ffffffffa0199be8>] output_poll_execute+0x198/0x1b0 [drm_=
kms_helper]

[179480.462263]  [<ffffffff8106effa>] process_one_work+0x12a/0x440

[179480.462265]  [<ffffffffa0199a50>] ? drm_helper_connector_dpms+0x130/0x1=
30 [drm_kms_helper]

[179480.462267]  [<ffffffff8106f85e>] worker_thread+0x12e/0x2d0

[179480.462269]  [<ffffffff8106f730>] ? manage_workers.isra.26+0x1f0/0x1f0

[179480.462271]  [<ffffffff81074f73>] kthread+0x93/0xa0

[179480.462273]  [<ffffffff81486864>] kernel_thread_helper+0x4/0x10

[179480.462274]  [<ffffffff81074ee0>] ? kthread_freezable_should_stop+0x70/=
0x70

[179480.462276]  [<ffffffff81486860>] ? gs_change+0x13/0x13
[179480.462277] ---[ end trace 52d31f5c575f718f ]---
[179480.488772] ------------[ cut here ]------------
[179480.488802] WARNING: at drivers/gpu/drm/i915/intel_dp.c:412 intel_dp_au=
x_ch+0xda/0x380 [i915]()
[179480.488803] Hardware name: MacBookAir4,2
[179480.488804] dp_aux_ch not started status 0xffffffff
[179480.488804] Modules linked in:
[179480.488805]  fuse
[179480.488805]  tun
[179480.488806]  snd_hda_codec_hdmi
[179480.488806]  snd_hda_codec_cirrus
[179480.488806]  ext4
[179480.488807]  jbd2
[179480.488807]  mbcache
[179480.488807]  btusb
[179480.488808]  bluetooth
[179480.488808]  joydev
[179480.488808]  uvcvideo
[179480.488809]  videobuf2_vmalloc
[179480.488809]  crc16
[179480.488809]  videobuf2_memops
[179480.488810]  videobuf2_core
[179480.488810]  videodev
[179480.488810]  bcm5974
[179480.488810]  media
[179480.488811]  arc4
[179480.488811]  brcmsmac
[179480.488811]  cordic
[179480.488812]  brcmutil
[179480.488812]  i915
[179480.488812]  mac80211
[179480.488813]  cfg80211
[179480.488813]  i2c_algo_bit
[179480.488814]  drm_kms_helper
[179480.488814]  rfkill
[179480.488815]  iTCO_wdt
[179480.488815]  drm
[179480.488816]  iTCO_vendor_support
[179480.488816]  snd_hda_intel
[179480.488817]  snd_hda_codec
[179480.488817]  lpc_ich
[179480.488818]  acpi_cpufreq
[179480.488818]  intel_agp
[179480.488819]  applesmc
[179480.488819]  microcode
[179480.488820]  coretemp
[179480.488820]  evdev
[179480.488821]  input_polldev
[179480.488821]  pcspkr
[179480.488821]  mfd_core
[179480.488822]  i2c_i801
[179480.488822]  bcma
[179480.488823]  snd_hwdep
[179480.488823]  mei
[179480.488824]  i2c_core
[179480.488824]  intel_gtt
[179480.488825]  mperf
[179480.488825]  video
[179480.488826]  ac
[179480.488826]  processor
[179480.488827]  battery
[179480.488827]  apple_bl
[179480.488828]  button
[179480.488828]  snd_pcm_oss
[179480.488829]  snd_mixer_oss
[179480.488829]  snd_pcm
[179480.488830]  snd_page_alloc
[179480.488830]  snd_timer
[179480.488831]  snd
[179480.488831]  soundcore
[179480.488832]  kvm_intel
[179480.488832]  kvm
[179480.488833]  nfs
[179480.488833]  nfs_acl
[179480.488833]  lockd
[179480.488834]  auth_rpcgss
[179480.488834]  sunrpc
[179480.488835]  fscache
[179480.488835]  autofs4
[179480.488836]  jfs
[179480.488836]  xts
[179480.488837]  gf128mul
[179480.488837]  dm_crypt
[179480.488838]  dm_mod
[179480.488838]  sd_mod
[179480.488838]  pata_acpi
[179480.488839]  ata_generic
[179480.488840]  hid_generic
[179480.488840]  usb_storage
[179480.488840]  hid_apple
[179480.488841]  usbhid
[179480.488841]  hid
[179480.488842]  aesni_intel
[179480.488842]  uhci_hcd
[179480.488843]  aes_x86_64
[179480.488843]  aes_generic
[179480.488844]  ghash_clmulni_intel
[179480.488844]  cryptd
[179480.488844]  ata_piix
[179480.488845]  crc32c_intel
[179480.488845]  libata
[179480.488846]  ehci_hcd
[179480.488846]  usbcore
[179480.488847]  scsi_mod
[179480.488847]  usb_common

[179480.488850] Pid: 21263, comm: kworker/1:1 Tainted: G        W    3.5.4-=
1-ARCH #1
[179480.488850] Call Trace:

[179480.488855]  [<ffffffff81051a3f>] warn_slowpath_common+0x7f/0xc0

[179480.488857]  [<ffffffff81051b36>] warn_slowpath_fmt+0x46/0x50

[179480.488863]  [<ffffffffa05389ba>] intel_dp_aux_ch+0xda/0x380 [i915]

[179480.488868]  [<ffffffffa0538eb5>] intel_dp_aux_native_read_retry+0xb5/0=
x140 [i915]

[179480.488871]  [<ffffffff81257911>] ? vsnprintf+0x461/0x600

[179480.488876]  [<ffffffffa0538f64>] intel_dp_get_dpcd+0x24/0x40 [i915]

[179480.488880]  [<ffffffffa053a665>] intel_dp_detect+0x55/0x2a0 [i915]

[179480.488884]  [<ffffffffa019a622>] drm_helper_probe_single_connector_mod=
es+0x1a2/0x340 [drm_kms_helper]

[179480.488886]  [<ffffffffa0198030>] drm_fb_helper_probe_connector_modes.i=
sra.2+0x50/0x70 [drm_kms_helper]

[179480.488888]  [<ffffffffa01990b2>] drm_fb_helper_hotplug_event+0xc2/0x12=
0 [drm_kms_helper]

[179480.488893]  [<ffffffffa0548aac>] intel_fb_output_poll_changed+0x1c/0x2=
0 [i915]

[179480.488895]  [<ffffffffa0199be8>] output_poll_execute+0x198/0x1b0 [drm_=
kms_helper]

[179480.488898]  [<ffffffff8106effa>] process_one_work+0x12a/0x440

[179480.488900]  [<ffffffffa0199a50>] ? drm_helper_connector_dpms+0x130/0x1=
30 [drm_kms_helper]

[179480.488902]  [<ffffffff8106f85e>] worker_thread+0x12e/0x2d0

[179480.488903]  [<ffffffff8106f730>] ? manage_workers.isra.26+0x1f0/0x1f0

[179480.488905]  [<ffffffff81074f73>] kthread+0x93/0xa0

[179480.488908]  [<ffffffff81486864>] kernel_thread_helper+0x4/0x10

[179480.488909]  [<ffffffff81074ee0>] ? kthread_freezable_should_stop+0x70/=
0x70

[179480.488910]  [<ffffffff81486860>] ? gs_change+0x13/0x13
[179480.488911] ---[ end trace 52d31f5c575f7190 ]---
[179480.515388] ------------[ cut here ]------------
[179480.515418] WARNING: at drivers/gpu/drm/i915/intel_dp.c:412 intel_dp_au=
x_ch+0xda/0x380 [i915]()
[179480.515419] Hardware name: MacBookAir4,2
[179480.515419] dp_aux_ch not started status 0xffffffff
[179480.515420] Modules linked in:
[179480.515420]  fuse
[179480.515421]  tun
[179480.515421]  snd_hda_codec_hdmi
[179480.515422]  snd_hda_codec_cirrus
[179480.515422]  ext4
[179480.515422]  jbd2
[179480.515423]  mbcache
[179480.515423]  btusb
[179480.515423]  bluetooth
[179480.515424]  joydev
[179480.515424]  uvcvideo
[179480.515424]  videobuf2_vmalloc
[179480.515425]  crc16
[179480.515425]  videobuf2_memops
[179480.515425]  videobuf2_core
[179480.515426]  videodev
[179480.515426]  bcm5974
[179480.515426]  media
[179480.515426]  arc4
[179480.515427]  brcmsmac
[179480.515427]  cordic
[179480.515427]  brcmutil
[179480.515428]  i915
[179480.515428]  mac80211
[179480.515429]  cfg80211
[179480.515429]  i2c_algo_bit
[179480.515430]  drm_kms_helper
[179480.515430]  rfkill
[179480.515431]  iTCO_wdt
[179480.515431]  drm
[179480.515432]  iTCO_vendor_support
[179480.515432]  snd_hda_intel
[179480.515433]  snd_hda_codec
[179480.515433]  lpc_ich
[179480.515434]  acpi_cpufreq
[179480.515434]  intel_agp
[179480.515435]  applesmc
[179480.515436]  microcode
[179480.515436]  coretemp
[179480.515437]  evdev
[179480.515437]  input_polldev
[179480.515437]  pcspkr
[179480.515438]  mfd_core
[179480.515438]  i2c_i801
[179480.515439]  bcma
[179480.515439]  snd_hwdep
[179480.515439]  mei
[179480.515440]  i2c_core
[179480.515441]  intel_gtt
[179480.515441]  mperf
[179480.515441]  video
[179480.515442]  ac
[179480.515442]  processor
[179480.515443]  battery
[179480.515443]  apple_bl
[179480.515444]  button
[179480.515444]  snd_pcm_oss
[179480.515445]  snd_mixer_oss
[179480.515445]  snd_pcm
[179480.515446]  snd_page_alloc
[179480.515446]  snd_timer
[179480.515447]  snd
[179480.515447]  soundcore
[179480.515448]  kvm_intel
[179480.515448]  kvm
[179480.515448]  nfs
[179480.515449]  nfs_acl
[179480.515449]  lockd
[179480.515450]  auth_rpcgss
[179480.515450]  sunrpc
[179480.515451]  fscache
[179480.515451]  autofs4
[179480.515452]  jfs
[179480.515452]  xts
[179480.515453]  gf128mul
[179480.515453]  dm_crypt
[179480.515454]  dm_mod
[179480.515454]  sd_mod
[179480.515454]  pata_acpi
[179480.515455]  ata_generic
[179480.515455]  hid_generic
[179480.515456]  usb_storage
[179480.515456]  hid_apple
[179480.515457]  usbhid
[179480.515457]  hid
[179480.515457]  aesni_intel
[179480.515458]  uhci_hcd
[179480.515458]  aes_x86_64
[179480.515459]  aes_generic
[179480.515460]  ghash_clmulni_intel
[179480.515460]  cryptd
[179480.515461]  ata_piix
[179480.515461]  crc32c_intel
[179480.515462]  libata
[179480.515462]  ehci_hcd
[179480.515463]  usbcore
[179480.515463]  scsi_mod
[179480.515464]  usb_common

[179480.515466] Pid: 21263, comm: kworker/1:1 Tainted: G        W    3.5.4-=
1-ARCH #1
[179480.515466] Call Trace:

[179480.515472]  [<ffffffff81051a3f>] warn_slowpath_common+0x7f/0xc0

[179480.515474]  [<ffffffff81051b36>] warn_slowpath_fmt+0x46/0x50

[179480.515480]  [<ffffffffa05389ba>] intel_dp_aux_ch+0xda/0x380 [i915]

[179480.515485]  [<ffffffffa0538eb5>] intel_dp_aux_native_read_retry+0xb5/0=
x140 [i915]

[179480.515488]  [<ffffffff81257911>] ? vsnprintf+0x461/0x600

[179480.515492]  [<ffffffffa0538f64>] intel_dp_get_dpcd+0x24/0x40 [i915]

[179480.515497]  [<ffffffffa053a665>] intel_dp_detect+0x55/0x2a0 [i915]

[179480.515500]  [<ffffffffa019a622>] drm_helper_probe_single_connector_mod=
es+0x1a2/0x340 [drm_kms_helper]

[179480.515503]  [<ffffffffa0198030>] drm_fb_helper_probe_connector_modes.i=
sra.2+0x50/0x70 [drm_kms_helper]

[179480.515505]  [<ffffffffa01990b2>] drm_fb_helper_hotplug_event+0xc2/0x12=
0 [drm_kms_helper]

[179480.515509]  [<ffffffffa0548aac>] intel_fb_output_poll_changed+0x1c/0x2=
0 [i915]

[179480.515511]  [<ffffffffa0199be8>] output_poll_execute+0x198/0x1b0 [drm_=
kms_helper]

[179480.515514]  [<ffffffff8106effa>] process_one_work+0x12a/0x440

[179480.515516]  [<ffffffffa0199a50>] ? drm_helper_connector_dpms+0x130/0x1=
30 [drm_kms_helper]

[179480.515518]  [<ffffffff8106f85e>] worker_thread+0x12e/0x2d0

[179480.515520]  [<ffffffff8106f730>] ? manage_workers.isra.26+0x1f0/0x1f0

[179480.515521]  [<ffffffff81074f73>] kthread+0x93/0xa0

[179480.515523]  [<ffffffff81486864>] kernel_thread_helper+0x4/0x10

[179480.515525]  [<ffffffff81074ee0>] ? kthread_freezable_should_stop+0x70/=
0x70

[179480.515526]  [<ffffffff81486860>] ? gs_change+0x13/0x13
[179480.515527] ---[ end trace 52d31f5c575f7191 ]---
[179480.542013] ------------[ cut here ]------------
[179480.542043] WARNING: at drivers/gpu/drm/i915/intel_dp.c:412 intel_dp_au=
x_ch+0xda/0x380 [i915]()
[179480.542043] Hardware name: MacBookAir4,2
[179480.542044] dp_aux_ch not started status 0xffffffff
[179480.542045] Modules linked in:
[179480.542045]  fuse
[179480.542046]  tun
[179480.542046]  snd_hda_codec_hdmi
[179480.542046]  snd_hda_codec_cirrus
[179480.542047]  ext4
[179480.542047]  jbd2
[179480.542047]  mbcache
[179480.542048]  btusb
[179480.542048]  bluetooth
[179480.542048]  joydev
[179480.542049]  uvcvideo
[179480.542049]  videobuf2_vmalloc
[179480.542049]  crc16
[179480.542050]  videobuf2_memops
[179480.542050]  videobuf2_core
[179480.542050]  videodev
[179480.542050]  bcm5974
[179480.542051]  media
[179480.542051]  arc4
[179480.542051]  brcmsmac
[179480.542052]  cordic
[179480.542052]  brcmutil
[179480.542052]  i915
[179480.542053]  mac80211
[179480.542054]  cfg80211
[179480.542054]  i2c_algo_bit
[179480.542055]  drm_kms_helper
[179480.542055]  rfkill
[179480.542056]  iTCO_wdt
[179480.542056]  drm
[179480.542057]  iTCO_vendor_support
[179480.542057]  snd_hda_intel
[179480.542058]  snd_hda_codec
[179480.542058]  lpc_ich
[179480.542058]  acpi_cpufreq
[179480.542059]  intel_agp
[179480.542060]  applesmc
[179480.542060]  microcode
[179480.542061]  coretemp
[179480.542061]  evdev
[179480.542061]  input_polldev
[179480.542062]  pcspkr
[179480.542062]  mfd_core
[179480.542063]  i2c_i801
[179480.542063]  bcma
[179480.542063]  snd_hwdep
[179480.542064]  mei
[179480.542065]  i2c_core
[179480.542065]  intel_gtt
[179480.542066]  mperf
[179480.542066]  video
[179480.542066]  ac
[179480.542067]  processor
[179480.542067]  battery
[179480.542068]  apple_bl
[179480.542068]  button
[179480.542069]  snd_pcm_oss
[179480.542069]  snd_mixer_oss
[179480.542070]  snd_pcm
[179480.542070]  snd_page_alloc
[179480.542071]  snd_timer
[179480.542071]  snd
[179480.542072]  soundcore
[179480.542072]  kvm_intel
[179480.542073]  kvm
[179480.542073]  nfs
[179480.542074]  nfs_acl
[179480.542074]  lockd
[179480.542075]  auth_rpcgss
[179480.542075]  sunrpc
[179480.542076]  fscache
[179480.542076]  autofs4
[179480.542077]  jfs
[179480.542077]  xts
[179480.542078]  gf128mul
[179480.542078]  dm_crypt
[179480.542079]  dm_mod
[179480.542079]  sd_mod
[179480.542080]  pata_acpi
[179480.542080]  ata_generic
[179480.542081]  hid_generic
[179480.542082]  usb_storage
[179480.542082]  hid_apple
[179480.542082]  usbhid
[179480.542083]  hid
[179480.542083]  aesni_intel
[179480.542084]  uhci_hcd
[179480.542084]  aes_x86_64
[179480.542085]  aes_generic
[179480.542085]  ghash_clmulni_intel
[179480.542085]  cryptd
[179480.542086]  ata_piix
[179480.542086]  crc32c_intel
[179480.542087]  libata
[179480.542087]  ehci_hcd
[179480.542088]  usbcore
[179480.542088]  scsi_mod
[179480.542089]  usb_common

[179480.542091] Pid: 21263, comm: kworker/1:1 Tainted: G        W    3.5.4-=
1-ARCH #1
[179480.542092] Call Trace:

[179480.542097]  [<ffffffff81051a3f>] warn_slowpath_common+0x7f/0xc0

[179480.542099]  [<ffffffff81051b36>] warn_slowpath_fmt+0x46/0x50

[179480.542105]  [<ffffffffa05389ba>] intel_dp_aux_ch+0xda/0x380 [i915]

[179480.542110]  [<ffffffffa0538eb5>] intel_dp_aux_native_read_retry+0xb5/0=
x140 [i915]

[179480.542113]  [<ffffffff81257911>] ? vsnprintf+0x461/0x600

[179480.542117]  [<ffffffffa0538f64>] intel_dp_get_dpcd+0x24/0x40 [i915]

[179480.542122]  [<ffffffffa053a665>] intel_dp_detect+0x55/0x2a0 [i915]

[179480.542125]  [<ffffffffa019a622>] drm_helper_probe_single_connector_mod=
es+0x1a2/0x340 [drm_kms_helper]

[179480.542128]  [<ffffffffa0198030>] drm_fb_helper_probe_connector_modes.i=
sra.2+0x50/0x70 [drm_kms_helper]

[179480.542130]  [<ffffffffa01990b2>] drm_fb_helper_hotplug_event+0xc2/0x12=
0 [drm_kms_helper]

[179480.542134]  [<ffffffffa0548aac>] intel_fb_output_poll_changed+0x1c/0x2=
0 [i915]

[179480.542136]  [<ffffffffa0199be8>] output_poll_execute+0x198/0x1b0 [drm_=
kms_helper]

[179480.542139]  [<ffffffff8106effa>] process_one_work+0x12a/0x440

[179480.542141]  [<ffffffffa0199a50>] ? drm_helper_connector_dpms+0x130/0x1=
30 [drm_kms_helper]

[179480.542142]  [<ffffffff8106f85e>] worker_thread+0x12e/0x2d0

[179480.542144]  [<ffffffff8106f730>] ? manage_workers.isra.26+0x1f0/0x1f0

[179480.542146]  [<ffffffff81074f73>] kthread+0x93/0xa0

[179480.542148]  [<ffffffff81486864>] kernel_thread_helper+0x4/0x10

[179480.542149]  [<ffffffff81074ee0>] ? kthread_freezable_should_stop+0x70/=
0x70

[179480.542151]  [<ffffffff81486860>] ? gs_change+0x13/0x13
[179480.542151] ---[ end trace 52d31f5c575f7192 ]---
[179480.568638] ------------[ cut here ]------------
[179480.568668] WARNING: at drivers/gpu/drm/i915/intel_dp.c:412 intel_dp_au=
x_ch+0xda/0x380 [i915]()
[179480.568669] Hardware name: MacBookAir4,2
[179480.568670] dp_aux_ch not started status 0xffffffff
[179480.568670] Modules linked in:
[179480.568671]  fuse
[179480.568671]  tun
[179480.568671]  snd_hda_codec_hdmi
[179480.568672]  snd_hda_codec_cirrus
[179480.568672]  ext4
[179480.568672]  jbd2
[179480.568673]  mbcache
[179480.568673]  btusb
[179480.568673]  bluetooth
[179480.568674]  joydev
[179480.568674]  uvcvideo
[179480.568674]  videobuf2_vmalloc
[179480.568675]  crc16
[179480.568675]  videobuf2_memops
[179480.568675]  videobuf2_core
[179480.568676]  videodev
[179480.568676]  bcm5974
[179480.568676]  media
[179480.568676]  arc4
[179480.568677]  brcmsmac
[179480.568677]  cordic
[179480.568677]  brcmutil
[179480.568678]  i915
[179480.568678]  mac80211
[179480.568678]  cfg80211
[179480.568679]  i2c_algo_bit
[179480.568679]  drm_kms_helper
[179480.568680]  rfkill
[179480.568681]  iTCO_wdt
[179480.568681]  drm
[179480.568682]  iTCO_vendor_support
[179480.568682]  snd_hda_intel
[179480.568683]  snd_hda_codec
[179480.568683]  lpc_ich
[179480.568684]  acpi_cpufreq
[179480.568684]  intel_agp
[179480.568685]  applesmc
[179480.568685]  microcode
[179480.568686]  coretemp
[179480.568686]  evdev
[179480.568687]  input_polldev
[179480.568687]  pcspkr
[179480.568688]  mfd_core
[179480.568688]  i2c_i801
[179480.568688]  bcma
[179480.568689]  snd_hwdep
[179480.568689]  mei
[179480.568690]  i2c_core
[179480.568691]  intel_gtt
[179480.568691]  mperf
[179480.568692]  video
[179480.568692]  ac
[179480.568693]  processor
[179480.568693]  battery
[179480.568694]  apple_bl
[179480.568694]  button
[179480.568695]  snd_pcm_oss
[179480.568695]  snd_mixer_oss
[179480.568696]  snd_pcm
[179480.568696]  snd_page_alloc
[179480.568697]  snd_timer
[179480.568697]  snd
[179480.568698]  soundcore
[179480.568698]  kvm_intel
[179480.568699]  kvm
[179480.568699]  nfs
[179480.568699]  nfs_acl
[179480.568700]  lockd
[179480.568700]  auth_rpcgss
[179480.568701]  sunrpc
[179480.568701]  fscache
[179480.568702]  autofs4
[179480.568702]  jfs
[179480.568703]  xts
[179480.568703]  gf128mul
[179480.568704]  dm_crypt
[179480.568704]  dm_mod
[179480.568704]  sd_mod
[179480.568705]  pata_acpi
[179480.568705]  ata_generic
[179480.568706]  hid_generic
[179480.568707]  usb_storage
[179480.568707]  hid_apple
[179480.568707]  usbhid
[179480.568708]  hid
[179480.568708]  aesni_intel
[179480.568709]  uhci_hcd
[179480.568709]  aes_x86_64
[179480.568710]  aes_generic
[179480.568710]  ghash_clmulni_intel
[179480.568711]  cryptd
[179480.568711]  ata_piix
[179480.568711]  crc32c_intel
[179480.568712]  libata
[179480.568713]  ehci_hcd
[179480.568713]  usbcore
[179480.568713]  scsi_mod
[179480.568714]  usb_common

[179480.568716] Pid: 21263, comm: kworker/1:1 Tainted: G        W    3.5.4-=
1-ARCH #1
[179480.568717] Call Trace:

[179480.568722]  [<ffffffff81051a3f>] warn_slowpath_common+0x7f/0xc0

[179480.568724]  [<ffffffff81051b36>] warn_slowpath_fmt+0x46/0x50

[179480.568730]  [<ffffffffa05389ba>] intel_dp_aux_ch+0xda/0x380 [i915]

[179480.568735]  [<ffffffffa0538eb5>] intel_dp_aux_native_read_retry+0xb5/0=
x140 [i915]

[179480.568739]  [<ffffffff81257911>] ? vsnprintf+0x461/0x600

[179480.568743]  [<ffffffffa0538f64>] intel_dp_get_dpcd+0x24/0x40 [i915]

[179480.568747]  [<ffffffffa053a665>] intel_dp_detect+0x55/0x2a0 [i915]

[179480.568751]  [<ffffffffa019a622>] drm_helper_probe_single_connector_mod=
es+0x1a2/0x340 [drm_kms_helper]

[179480.568753]  [<ffffffffa0198030>] drm_fb_helper_probe_connector_modes.i=
sra.2+0x50/0x70 [drm_kms_helper]

[179480.568755]  [<ffffffffa01990b2>] drm_fb_helper_hotplug_event+0xc2/0x12=
0 [drm_kms_helper]

[179480.568760]  [<ffffffffa0548aac>] intel_fb_output_poll_changed+0x1c/0x2=
0 [i915]

[179480.568762]  [<ffffffffa0199be8>] output_poll_execute+0x198/0x1b0 [drm_=
kms_helper]

[179480.568764]  [<ffffffff8106effa>] process_one_work+0x12a/0x440

[179480.568766]  [<ffffffffa0199a50>] ? drm_helper_connector_dpms+0x130/0x1=
30 [drm_kms_helper]

[179480.568768]  [<ffffffff8106f85e>] worker_thread+0x12e/0x2d0

[179480.568770]  [<ffffffff8106f730>] ? manage_workers.isra.26+0x1f0/0x1f0

[179480.568772]  [<ffffffff81074f73>] kthread+0x93/0xa0

[179480.568774]  [<ffffffff81486864>] kernel_thread_helper+0x4/0x10

[179480.568775]  [<ffffffff81074ee0>] ? kthread_freezable_should_stop+0x70/=
0x70

[179480.568777]  [<ffffffff81486860>] ? gs_change+0x13/0x13
[179480.568778] ---[ end trace 52d31f5c575f7193 ]---
[179480.735112] PM: suspend of devices complete after 1316.399 msecs
[179480.735285] PM: late suspend of devices complete after 0.170 msecs
[179480.748666] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[179480.761897] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[179480.788383] PM: noirq suspend of devices complete after 53.177 msecs
[179480.788628] ACPI: Preparing to enter system sleep state S3
[179480.815000] PM: Saving platform NVS memory
[179480.815339] Disabling non-boot CPUs ...
[179480.918118] CPU 1 is now offline
[179480.941378] ------------[ cut here ]------------
[179480.941414] WARNING: at drivers/gpu/drm/i915/intel_dp.c:412 intel_dp_au=
x_ch+0xda/0x380 [i915]()
[179480.941415] Hardware name: MacBookAir4,2
[179480.941416] dp_aux_ch not started status 0xffffffff
[179480.941416] Modules linked in:
[179480.941417]  fuse
[179480.941418]  tun
[179480.941418]  snd_hda_codec_hdmi
[179480.941419]  snd_hda_codec_cirrus
[179480.941419]  ext4
[179480.941419]  jbd2
[179480.941420]  mbcache
[179480.941420]  btusb
[179480.941421]  bluetooth
[179480.941421]  joydev
[179480.941422]  uvcvideo
[179480.941422]  videobuf2_vmalloc
[179480.941423]  crc16
[179480.941423]  videobuf2_memops
[179480.941424]  videobuf2_core
[179480.941424]  videodev
[179480.941424]  bcm5974
[179480.941425]  media
[179480.941425]  arc4
[179480.941425]  brcmsmac
[179480.941426]  cordic
[179480.941426]  brcmutil
[179480.941426]  i915
[179480.941427]  mac80211
[179480.941428]  cfg80211
[179480.941428]  i2c_algo_bit
[179480.941429]  drm_kms_helper
[179480.941429]  rfkill
[179480.941430]  iTCO_wdt
[179480.941431]  drm
[179480.941431]  iTCO_vendor_support
[179480.941432]  snd_hda_intel
[179480.941432]  snd_hda_codec
[179480.941433]  lpc_ich
[179480.941433]  acpi_cpufreq
[179480.941434]  intel_agp
[179480.941434]  applesmc
[179480.941435]  microcode
[179480.941435]  coretemp
[179480.941436]  evdev
[179480.941436]  input_polldev
[179480.941437]  pcspkr
[179480.941437]  mfd_core
[179480.941438]  i2c_i801
[179480.941438]  bcma
[179480.941438]  snd_hwdep
[179480.941439]  mei
[179480.941440]  i2c_core
[179480.941440]  intel_gtt
[179480.941441]  mperf
[179480.941441]  video
[179480.941442]  ac
[179480.941442]  processor
[179480.941443]  battery
[179480.941443]  apple_bl
[179480.941444]  button
[179480.941444]  snd_pcm_oss
[179480.941445]  snd_mixer_oss
[179480.941445]  snd_pcm
[179480.941446]  snd_page_alloc
[179480.941446]  snd_timer
[179480.941447]  snd
[179480.941447]  soundcore
[179480.941447]  kvm_intel
[179480.941448]  kvm
[179480.941448]  nfs
[179480.941449]  nfs_acl
[179480.941449]  lockd
[179480.941450]  auth_rpcgss
[179480.941450]  sunrpc
[179480.941451]  fscache
[179480.941451]  autofs4
[179480.941452]  jfs
[179480.941452]  xts
[179480.941453]  gf128mul
[179480.941453]  dm_crypt
[179480.941454]  dm_mod
[179480.941454]  sd_mod
[179480.941454]  pata_acpi
[179480.941455]  ata_generic
[179480.941456]  hid_generic
[179480.941456]  usb_storage
[179480.941457]  hid_apple
[179480.941457]  usbhid
[179480.941458]  hid
[179480.941458]  aesni_intel
[179480.941459]  uhci_hcd
[179480.941459]  aes_x86_64
[179480.941460]  aes_generic
[179480.941460]  ghash_clmulni_intel
[179480.941460]  cryptd
[179480.941461]  ata_piix
[179480.941461]  crc32c_intel
[179480.941462]  libata
[179480.941470]  ehci_hcd
[179480.941471]  usbcore
[179480.941471]  scsi_mod
[179480.941471]  usb_common

[179480.941474] Pid: 21263, comm: kworker/1:1 Tainted: G        W    3.5.4-=
1-ARCH #1
[179480.941475] Call Trace:

[179480.941480]  [<ffffffff81051a3f>] warn_slowpath_common+0x7f/0xc0

[179480.941481]  [<ffffffff81051b36>] warn_slowpath_fmt+0x46/0x50

[179480.941487]  [<ffffffffa05389ba>] intel_dp_aux_ch+0xda/0x380 [i915]

[179480.941491]  [<ffffffffa0538d08>] intel_dp_aux_native_write+0xa8/0xf0 [=
i915]

[179480.941495]  [<ffffffffa0538d6e>] intel_dp_aux_native_write_1+0x1e/0x20=
 [i915]

[179480.941498]  [<ffffffffa05395a3>] intel_dp_sink_dpms+0x33/0x90 [i915]

[179480.941501]  [<ffffffffa0539be8>] intel_dp_prepare+0x28/0x40 [i915]

[179480.941504]  [<ffffffffa019a0f2>] drm_crtc_helper_set_mode+0x452/0x500 =
[drm_kms_helper]

[179480.941507]  [<ffffffffa019b1b9>] drm_crtc_helper_set_config+0x9f9/0xb1=
0 [drm_kms_helper]

[179480.941511]  [<ffffffff8147ba8e>] ? __mutex_lock_slowpath+0x24e/0x340

[179480.941513]  [<ffffffffa0198c68>] drm_fb_helper_set_par+0x78/0x100 [drm=
_kms_helper]

[179480.941515]  [<ffffffffa0198e6b>] drm_fb_helper_single_fb_probe+0x17b/0=
x300 [drm_kms_helper]

[179480.941517]  [<ffffffffa01990cd>] drm_fb_helper_hotplug_event+0xdd/0x12=
0 [drm_kms_helper]

[179480.941521]  [<ffffffffa0548aac>] intel_fb_output_poll_changed+0x1c/0x2=
0 [i915]

[179480.941523]  [<ffffffffa0199be8>] output_poll_execute+0x198/0x1b0 [drm_=
kms_helper]

[179480.941526]  [<ffffffff8106effa>] process_one_work+0x12a/0x440

[179480.941528]  [<ffffffffa0199a50>] ? drm_helper_connector_dpms+0x130/0x1=
30 [drm_kms_helper]

[179480.941530]  [<ffffffff8106f85e>] worker_thread+0x12e/0x2d0

[179480.941531]  [<ffffffff8106f730>] ? manage_workers.isra.26+0x1f0/0x1f0

[179480.941533]  [<ffffffff81074f73>] kthread+0x93/0xa0

[179480.941536]  [<ffffffff81486864>] kernel_thread_helper+0x4/0x10

[179480.941537]  [<ffffffff81074ee0>] ? kthread_freezable_should_stop+0x70/=
0x70

[179480.941538]  [<ffffffff81486860>] ? gs_change+0x13/0x13
[179480.941539] ---[ end trace 52d31f5c575f7194 ]---
[179480.968009] ------------[ cut here ]------------
[179480.968041] WARNING: at drivers/gpu/drm/i915/intel_dp.c:412 intel_dp_au=
x_ch+0xda/0x380 [i915]()
[179480.968042] Hardware name: MacBookAir4,2
[179480.968043] dp_aux_ch not started status 0xffffffff
[179480.968043] Modules linked in:
[179480.968044]  fuse
[179480.968044]  tun
[179480.968045]  snd_hda_codec_hdmi
[179480.968045]  snd_hda_codec_cirrus
[179480.968045]  ext4
[179480.968046]  jbd2
[179480.968046]  mbcache
[179480.968046]  btusb
[179480.968047]  bluetooth
[179480.968047]  joydev
[179480.968047]  uvcvideo
[179480.968048]  videobuf2_vmalloc
[179480.968048]  crc16
[179480.968048]  videobuf2_memops
[179480.968049]  videobuf2_core
[179480.968049]  videodev
[179480.968049]  bcm5974
[179480.968049]  media
[179480.968050]  arc4
[179480.968050]  brcmsmac
[179480.968050]  cordic
[179480.968051]  brcmutil
[179480.968051]  i915
[179480.968051]  mac80211
[179480.968052]  cfg80211
[179480.968052]  i2c_algo_bit
[179480.968053]  drm_kms_helper
[179480.968053]  rfkill
[179480.968054]  iTCO_wdt
[179480.968054]  drm
[179480.968055]  iTCO_vendor_support
[179480.968055]  snd_hda_intel
[179480.968056]  snd_hda_codec
[179480.968056]  lpc_ich
[179480.968057]  acpi_cpufreq
[179480.968057]  intel_agp
[179480.968058]  applesmc
[179480.968058]  microcode
[179480.968059]  coretemp
[179480.968059]  evdev
[179480.968060]  input_polldev
[179480.968060]  pcspkr
[179480.968061]  mfd_core
[179480.968061]  i2c_i801
[179480.968061]  bcma
[179480.968062]  snd_hwdep
[179480.968062]  mei
[179480.968063]  i2c_core
[179480.968063]  intel_gtt
[179480.968064]  mperf
[179480.968064]  video
[179480.968065]  ac
[179480.968065]  processor
[179480.968066]  battery
[179480.968066]  apple_bl
[179480.968067]  button
[179480.968067]  snd_pcm_oss
[179480.968068]  snd_mixer_oss
[179480.968068]  snd_pcm
[179480.968069]  snd_page_alloc
[179480.968069]  snd_timer
[179480.968070]  snd
[179480.968070]  soundcore
[179480.968070]  kvm_intel
[179480.968071]  kvm
[179480.968072]  nfs
[179480.968072]  nfs_acl
[179480.968073]  lockd
[179480.968073]  auth_rpcgss
[179480.968074]  sunrpc
[179480.968074]  fscache
[179480.968075]  autofs4
[179480.968075]  jfs
[179480.968076]  xts
[179480.968076]  gf128mul
[179480.968076]  dm_crypt
[179480.968077]  dm_mod
[179480.968077]  sd_mod
[179480.968078]  pata_acpi
[179480.968078]  ata_generic
[179480.968079]  hid_generic
[179480.968080]  usb_storage
[179480.968080]  hid_apple
[179480.968080]  usbhid
[179480.968081]  hid
[179480.968081]  aesni_intel
[179480.968082]  uhci_hcd
[179480.968082]  aes_x86_64
[179480.968083]  aes_generic
[179480.968083]  ghash_clmulni_intel
[179480.968084]  cryptd
[179480.968084]  ata_piix
[179480.968085]  crc32c_intel
[179480.968085]  libata
[179480.968085]  ehci_hcd
[179480.968086]  usbcore
[179480.968086]  scsi_mod
[179480.968087]  usb_common

[179480.968089] Pid: 21263, comm: kworker/1:1 Tainted: G        W    3.5.4-=
1-ARCH #1
[179480.968090] Call Trace:

[179480.968096]  [<ffffffff81051a3f>] warn_slowpath_common+0x7f/0xc0

[179480.968098]  [<ffffffff81051b36>] warn_slowpath_fmt+0x46/0x50

[179480.968104]  [<ffffffffa05389ba>] intel_dp_aux_ch+0xda/0x380 [i915]

[179480.968108]  [<ffffffffa0538d08>] intel_dp_aux_native_write+0xa8/0xf0 [=
i915]

[179480.968112]  [<ffffffffa0538d6e>] intel_dp_aux_native_write_1+0x1e/0x20=
 [i915]

[179480.968116]  [<ffffffffa05395a3>] intel_dp_sink_dpms+0x33/0x90 [i915]

[179480.968120]  [<ffffffffa0539be8>] intel_dp_prepare+0x28/0x40 [i915]

[179480.968123]  [<ffffffffa019a0f2>] drm_crtc_helper_set_mode+0x452/0x500 =
[drm_kms_helper]

[179480.968127]  [<ffffffffa019b1b9>] drm_crtc_helper_set_config+0x9f9/0xb1=
0 [drm_kms_helper]

[179480.968131]  [<ffffffff8147ba8e>] ? __mutex_lock_slowpath+0x24e/0x340

[179480.968134]  [<ffffffffa0198c68>] drm_fb_helper_set_par+0x78/0x100 [drm=
_kms_helper]

[179480.968136]  [<ffffffffa0198e6b>] drm_fb_helper_single_fb_probe+0x17b/0=
x300 [drm_kms_helper]

[179480.968138]  [<ffffffffa01990cd>] drm_fb_helper_hotplug_event+0xdd/0x12=
0 [drm_kms_helper]

[179480.968143]  [<ffffffffa0548aac>] intel_fb_output_poll_changed+0x1c/0x2=
0 [i915]

[179480.968145]  [<ffffffffa0199be8>] output_poll_execute+0x198/0x1b0 [drm_=
kms_helper]

[179480.968147]  [<ffffffff8106effa>] process_one_work+0x12a/0x440

[179480.968149]  [<ffffffffa0199a50>] ? drm_helper_connector_dpms+0x130/0x1=
30 [drm_kms_helper]

[179480.968151]  [<ffffffff8106f85e>] worker_thread+0x12e/0x2d0

[179480.968153]  [<ffffffff8106f730>] ? manage_workers.isra.26+0x1f0/0x1f0

[179480.968154]  [<ffffffff81074f73>] kthread+0x93/0xa0

[179480.968157]  [<ffffffff81486864>] kernel_thread_helper+0x4/0x10

[179480.968158]  [<ffffffff81074ee0>] ? kthread_freezable_should_stop+0x70/=
0x70

[179480.968159]  [<ffffffff81486860>] ? gs_change+0x13/0x13
[179480.968160] ---[ end trace 52d31f5c575f7195 ]---
[179480.994633] ------------[ cut here ]------------
[179480.994665] WARNING: at drivers/gpu/drm/i915/intel_dp.c:412 intel_dp_au=
x_ch+0xda/0x380 [i915]()
[179480.994666] Hardware name: MacBookAir4,2
[179480.994667] dp_aux_ch not started status 0xffffffff
[179480.994667] Modules linked in:
[179480.994668]  fuse
[179480.994668]  tun
[179480.994668]  snd_hda_codec_hdmi
[179480.994669]  snd_hda_codec_cirrus
[179480.994669]  ext4
[179480.994669]  jbd2
[179480.994670]  mbcache
[179480.994670]  btusb
[179480.994670]  bluetooth
[179480.994671]  joydev
[179480.994671]  uvcvideo
[179480.994671]  videobuf2_vmalloc
[179480.994672]  crc16
[179480.994672]  videobuf2_memops
[179480.994672]  videobuf2_core
[179480.994673]  videodev
[179480.994673]  bcm5974
[179480.994673]  media
[179480.994673]  arc4
[179480.994674]  brcmsmac
[179480.994674]  cordic
[179480.994674]  brcmutil
[179480.994675]  i915
[179480.994675]  mac80211
[179480.994675]  cfg80211
[179480.994676]  i2c_algo_bit
[179480.994676]  drm_kms_helper
[179480.994677]  rfkill
[179480.994677]  iTCO_wdt
[179480.994678]  drm
[179480.994678]  iTCO_vendor_support
[179480.994679]  snd_hda_intel
[179480.994679]  snd_hda_codec
[179480.994679]  lpc_ich
[179480.994680]  acpi_cpufreq
[179480.994680]  intel_agp
[179480.994681]  applesmc
[179480.994681]  microcode
[179480.994682]  coretemp
[179480.994682]  evdev
[179480.994683]  input_polldev
[179480.994683]  pcspkr
[179480.994684]  mfd_core
[179480.994684]  i2c_i801
[179480.994685]  bcma
[179480.994685]  snd_hwdep
[179480.994685]  mei
[179480.994686]  i2c_core
[179480.994686]  intel_gtt
[179480.994687]  mperf
[179480.994687]  video
[179480.994688]  ac
[179480.994689]  processor
[179480.994689]  battery
[179480.994690]  apple_bl
[179480.994690]  button
[179480.994691]  snd_pcm_oss
[179480.994691]  snd_mixer_oss
[179480.994692]  snd_pcm
[179480.994692]  snd_page_alloc
[179480.994693]  snd_timer
[179480.994693]  snd
[179480.994694]  soundcore
[179480.994694]  kvm_intel
[179480.994694]  kvm
[179480.994695]  nfs
[179480.994695]  nfs_acl
[179480.994696]  lockd
[179480.994696]  auth_rpcgss
[179480.994697]  sunrpc
[179480.994697]  fscache
[179480.994698]  autofs4
[179480.994698]  jfs
[179480.994698]  xts
[179480.994699]  gf128mul
[179480.994699]  dm_crypt
[179480.994700]  dm_mod
[179480.994700]  sd_mod
[179480.994701]  pata_acpi
[179480.994701]  ata_generic
[179480.994702]  hid_generic
[179480.994702]  usb_storage
[179480.994703]  hid_apple
[179480.994703]  usbhid
[179480.994703]  hid
[179480.994704]  aesni_intel
[179480.994704]  uhci_hcd
[179480.994705]  aes_x86_64
[179480.994705]  aes_generic
[179480.994706]  ghash_clmulni_intel
[179480.994706]  cryptd
[179480.994706]  ata_piix
[179480.994707]  crc32c_intel
[179480.994707]  libata
[179480.994708]  ehci_hcd
[179480.994708]  usbcore
[179480.994709]  scsi_mod
[179480.994709]  usb_common

[179480.994711] Pid: 21263, comm: kworker/1:1 Tainted: G        W    3.5.4-=
1-ARCH #1
[179480.994712] Call Trace:

[179480.994718]  [<ffffffff81051a3f>] warn_slowpath_common+0x7f/0xc0

[179480.994720]  [<ffffffff81051b36>] warn_slowpath_fmt+0x46/0x50

[179480.994725]  [<ffffffffa05389ba>] intel_dp_aux_ch+0xda/0x380 [i915]

[179480.994730]  [<ffffffffa0538d08>] intel_dp_aux_native_write+0xa8/0xf0 [=
i915]

[179480.994733]  [<ffffffffa0538d6e>] intel_dp_aux_native_write_1+0x1e/0x20=
 [i915]

[179480.994737]  [<ffffffffa05395a3>] intel_dp_sink_dpms+0x33/0x90 [i915]

[179480.994741]  [<ffffffffa0539be8>] intel_dp_prepare+0x28/0x40 [i915]

[179480.994745]  [<ffffffffa019a0f2>] drm_crtc_helper_set_mode+0x452/0x500 =
[drm_kms_helper]

[179480.994748]  [<ffffffffa019b1b9>] drm_crtc_helper_set_config+0x9f9/0xb1=
0 [drm_kms_helper]

[179480.994752]  [<ffffffff8147ba8e>] ? __mutex_lock_slowpath+0x24e/0x340

[179480.994755]  [<ffffffffa0198c68>] drm_fb_helper_set_par+0x78/0x100 [drm=
_kms_helper]

[179480.994758]  [<ffffffffa0198e6b>] drm_fb_helper_single_fb_probe+0x17b/0=
x300 [drm_kms_helper]

[179480.994760]  [<ffffffffa01990cd>] drm_fb_helper_hotplug_event+0xdd/0x12=
0 [drm_kms_helper]

[179480.994765]  [<ffffffffa0548aac>] intel_fb_output_poll_changed+0x1c/0x2=
0 [i915]

[179480.994767]  [<ffffffffa0199be8>] output_poll_execute+0x198/0x1b0 [drm_=
kms_helper]

[179480.994770]  [<ffffffff8106effa>] process_one_work+0x12a/0x440

[179480.994772]  [<ffffffffa0199a50>] ? drm_helper_connector_dpms+0x130/0x1=
30 [drm_kms_helper]

[179480.994774]  [<ffffffff8106f85e>] worker_thread+0x12e/0x2d0

[179480.994776]  [<ffffffff8106f730>] ? manage_workers.isra.26+0x1f0/0x1f0

[179480.994778]  [<ffffffff81074f73>] kthread+0x93/0xa0

[179480.994780]  [<ffffffff81486864>] kernel_thread_helper+0x4/0x10

[179480.994781]  [<ffffffff81074ee0>] ? kthread_freezable_should_stop+0x70/=
0x70

[179480.994783]  [<ffffffff81486860>] ? gs_change+0x13/0x13
[179480.994783] ---[ end trace 52d31f5c575f7196 ]---
[179481.021282] CPU 2 is now offline
[179481.124424] CPU 3 is now offline
[179481.124761] Extended CMOS year: 2000
[179481.126224] ACPI: Low-level resume complete
[179481.126265] PM: Restoring platform NVS memory
[179481.126581] Extended CMOS year: 2000
[179481.126622] Enabling non-boot CPUs ...
[179481.130081] Booting Node 0 Processor 1 APIC 0x2
[179481.148877] CPU1 is up
[179481.155713] Booting Node 0 Processor 2 APIC 0x1
[179481.170181] CPU2 is up
[179481.171516] Booting Node 0 Processor 3 APIC 0x3
[179481.187581] CPU3 is up
[179481.192537] ACPI: Waking up from system sleep state S3
[179481.692302] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[179481.692585] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[179481.693230] PM: noirq resume of devices complete after 1.144 msecs
[179481.693338] PM: early resume of devices complete after 0.085 msecs
[179481.693403] i915 0000:00:02.0: setting latency timer to 64
[179481.693435] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[179481.693454] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[179481.693466] usb usb3: root hub lost power or was reset
[179481.693485] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[179481.693530] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[179481.693563] usb usb4: root hub lost power or was reset
[179481.693568] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[179481.693589] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[179481.693619] ata_piix 0000:00:1f.2: setting latency timer to 64
[179481.694339] mei 0000:00:16.0: wd: failed to find the client
[179481.744691] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[179481.764852] bcm5974: bad trackpad package, length: 8
[179481.765863] bcm5974: bad trackpad package, length: 8
[179481.772912] bcm5974: bad trackpad package, length: 8
[179481.773911] bcm5974: bad trackpad package, length: 8
[179481.775884] bcm5974: bad trackpad package, length: 8
[179481.776900] bcm5974: bad trackpad package, length: 8
[179481.777824] bcm5974: bad trackpad package, length: 8
[179481.778892] bcm5974: bad trackpad package, length: 8
[179481.780864] bcm5974: bad trackpad package, length: 8
[179482.713807] ata2.00: failed to resume link (SControl 0)
[179483.033314] ata1.01: failed to resume link (SControl 0)
[179483.186454] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[179483.186465] ata1.01: SATA link down (SStatus 0 SControl 0)
[179483.193303] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filte=
red out
[179483.200063] ata1.00: configured for UDMA/133
[179483.234439] sd 0:0:0:0: [sda] Starting disk
[179483.735522] ata2.01: failed to resume link (SControl 0)
[179483.747043] ata2.00: SATA link down (SStatus 4 SControl 0)
[179483.747057] ata2.01: SATA link down (SStatus 0 SControl 0)
[179483.763454] ieee80211 phy0: brcms_ops_config: change power-save mode: f=
alse (implement)
[179483.764446] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[179483.764448] ieee80211 phy0: changing basic rates failed: -22
[179483.764449] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: thr=
eshold 0, hys 0  (implement)
[179483.764450] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[179483.764451] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[179483.768783] wlan0: deauthenticated from 0c:b0:5d:9c:37:12 (Reason: 7)
[179483.788802] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[179483.788807] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 1 (implement)
[179483.788808] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[179483.800360] cfg80211: Calling CRDA to update world regulatory domain
[179484.160426] PM: resume of devices complete after 2470.932 msecs
[179484.161471] PM: Finishing wakeup.
[179484.161471] Restarting tasks ... done.
[179484.213942] video LNXVIDEO:00: Restoring backlight state
[179484.602504] systemd-journald[194]: Compressed data object 928 -> 632
[179486.831353] wlan0: authenticate with 0c:b0:5d:9c:37:12
[179486.831368] ieee80211 phy0: changing basic rates failed: -52
[179486.831376] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[179486.832741] EXT4-fs (sda4): re-mounted. Opts: commit=3D600
[179486.833192] wlan0: authenticated
[179486.833965] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[179486.837962] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=3D0x411 s=
tatus=3D0 aid=3D3)
[179486.838618] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[179486.838623] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[179486.838625] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[179486.839052] wlan0: associated
[179491.925933] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[184934.305916] EXT4-fs (sda4): re-mounted. Opts: commit=3D0
[184934.836761] PM: Syncing filesystems ... done.
[184934.889042] PM: Preparing system for mem sleep
[184935.976380] Freezing user space processes ... (elapsed 0.01 seconds) do=
ne.
[184935.989236] Freezing remaining freezable tasks ... (elapsed 0.01 second=
s) done.
[184936.002633] PM: Entering mem sleep
[184936.002657] Suspending console(s) (use no_console_suspend to debug)
[184936.011107] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[184936.012345] sd 0:0:0:0: [sda] Stopping disk
[184937.603444] PM: suspend of devices complete after 1603.079 msecs
[184937.603611] PM: late suspend of devices complete after 0.165 msecs
[184937.616972] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[184937.630208] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[184937.656712] PM: noirq suspend of devices complete after 53.177 msecs
[184937.656957] ACPI: Preparing to enter system sleep state S3
[184937.683343] PM: Saving platform NVS memory
[184937.683679] Disabling non-boot CPUs ...
[184937.786441] CPU 1 is now offline
[184937.889615] CPU 2 is now offline
[184937.992771] CPU 3 is now offline
[184937.993101] Extended CMOS year: 2000
[184937.994556] ACPI: Low-level resume complete
[184937.994597] PM: Restoring platform NVS memory
[184937.994912] Extended CMOS year: 2000
[184937.994954] Enabling non-boot CPUs ...
[184938.001812] Booting Node 0 Processor 1 APIC 0x2
[184938.017413] CPU1 is up
[184938.022515] Booting Node 0 Processor 2 APIC 0x1
[184938.042106] CPU2 is up
[184938.043129] Booting Node 0 Processor 3 APIC 0x3
[184938.059657] CPU3 is up
[184938.064644] ACPI: Waking up from system sleep state S3
[184938.916740] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[184938.917017] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[184938.917633] PM: noirq resume of devices complete after 1.093 msecs
[184938.917730] PM: early resume of devices complete after 0.075 msecs
[184938.917763] i915 0000:00:02.0: setting latency timer to 64
[184938.917788] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[184938.917805] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[184938.917812] usb usb3: root hub lost power or was reset
[184938.917832] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[184938.917893] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[184938.917901] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[184938.917923] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[184938.917929] usb usb4: root hub lost power or was reset
[184938.917946] ata_piix 0000:00:1f.2: setting latency timer to 64
[184938.918556] mei 0000:00:16.0: wd: failed to find the client
[184938.957286] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[184938.990224] bcm5974: bad trackpad package, length: 8
[184938.992209] bcm5974: bad trackpad package, length: 8
[184938.993212] bcm5974: bad trackpad package, length: 8
[184938.994206] bcm5974: bad trackpad package, length: 8
[184938.995171] bcm5974: bad trackpad package, length: 8
[184939.938251] ata2.00: failed to resume link (SControl 0)
[184940.257743] ata1.01: failed to resume link (SControl 0)
[184940.410911] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[184940.410923] ata1.01: SATA link down (SStatus 0 SControl 0)
[184940.417738] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filte=
red out
[184940.424499] ata1.00: configured for UDMA/133
[184940.458855] sd 0:0:0:0: [sda] Starting disk
[184940.959972] ata2.01: failed to resume link (SControl 0)
[184940.971478] ata2.00: SATA link down (SStatus 4 SControl 0)
[184940.971500] ata2.01: SATA link down (SStatus 0 SControl 0)
[184940.988094] ieee80211 phy0: brcms_ops_config: change power-save mode: f=
alse (implement)
[184940.989084] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[184940.989086] ieee80211 phy0: changing basic rates failed: -22
[184940.989087] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: thr=
eshold 0, hys 0  (implement)
[184940.989088] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[184940.989089] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[184940.989290] PM: resume of devices complete after 2074.790 msecs
[184940.989681] PM: Finishing wakeup.
[184940.989682] Restarting tasks ... done.
[184941.048562] video LNXVIDEO:00: Restoring backlight state
[184941.086357] wlan0: deauthenticated from 0c:b0:5d:9c:37:12 (Reason: 7)
[184941.129627] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[184941.129634] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 1 (implement)
[184941.129636] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[184941.167252] cfg80211: Calling CRDA for country: CH
[184942.464780] EXT4-fs (sda4): re-mounted. Opts: commit=3D0
[184943.659618] EXT4-fs (sda4): re-mounted. Opts: commit=3D0
[184944.176296] wlan0: authenticate with 0c:b0:5d:9c:37:12
[184944.185503] ieee80211 phy0: changing basic rates failed: -52
[184944.185525] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[184944.187463] wlan0: authenticated
[184944.188262] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[184944.193494] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=3D0x411 s=
tatus=3D0 aid=3D2)
[184944.194136] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[184944.194153] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[184944.194162] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[184944.195066] wlan0: associated
[184948.639766] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[189670.531370] usb 2-1.2: new full-speed USB device number 4 using ehci_hcd
[189670.710852] input: Wacom Bamboo 16FG 4x5 Pen as /devices/pci0000:00/000=
0:00:1d.7/usb2/2-1/2-1.2/2-1.2:1.0/input/input15
[189670.713586] input: Wacom Bamboo 16FG 4x5 Finger as /devices/pci0000:00/=
0000:00:1d.7/usb2/2-1/2-1.2/2-1.2:1.1/input/input16
[189670.713671] usbcore: registered new interface driver wacom
[193264.528749] CPU1: Core temperature above threshold, cpu clock throttled=
 (total events =3D 22326)
[193264.528751] CPU3: Core temperature above threshold, cpu clock throttled=
 (total events =3D 22326)
[193264.528753] CPU3: Package temperature above threshold, cpu clock thrott=
led (total events =3D 23121)
[193264.528768] CPU1: Package temperature above threshold, cpu clock thrott=
led (total events =3D 23121)
[193264.528781] CPU2: Package temperature above threshold, cpu clock thrott=
led (total events =3D 23121)
[193264.528782] CPU0: Package temperature above threshold, cpu clock thrott=
led (total events =3D 23121)
[193264.530723] CPU3: Core temperature/speed normal
[193264.530724] CPU1: Core temperature/speed normal
[193264.530726] CPU0: Package temperature/speed normal
[193264.530727] CPU2: Package temperature/speed normal
[193264.530728] CPU1: Package temperature/speed normal
[193264.530734] CPU3: Package temperature/speed normal
[193657.504185] CPU2: Package power limit notification (total events =3D 1)
[193657.504187] CPU3: Package power limit notification (total events =3D 1)
[193657.504189] CPU0: Package power limit notification (total events =3D 1)
[193657.504191] CPU1: Package power limit notification (total events =3D 1)
[193657.515156] CPU1: Package power limit normal
[193657.515157] CPU3: Package power limit normal
[193657.515159] CPU0: Package power limit normal
[193657.515161] CPU2: Package power limit normal
[198839.429358] CPU1: Core temperature above threshold, cpu clock throttled=
 (total events =3D 22638)
[198839.429360] CPU3: Core temperature above threshold, cpu clock throttled=
 (total events =3D 22638)
[198839.429362] CPU2: Package temperature above threshold, cpu clock thrott=
led (total events =3D 23516)
[198839.429363] CPU3: Package temperature above threshold, cpu clock thrott=
led (total events =3D 23516)
[198839.429366] CPU0: Package temperature above threshold, cpu clock thrott=
led (total events =3D 23516)
[198839.429371] CPU1: Package temperature above threshold, cpu clock thrott=
led (total events =3D 23516)
[198839.439334] CPU1: Core temperature/speed normal
[198839.439336] CPU3: Core temperature/speed normal
[198839.439337] CPU2: Package temperature/speed normal
[198839.439338] CPU3: Package temperature/speed normal
[198839.439341] CPU0: Package temperature/speed normal
[198839.439347] CPU1: Package temperature/speed normal
[201862.161922] CPU1: Core temperature above threshold, cpu clock throttled=
 (total events =3D 24938)
[201862.161924] CPU3: Core temperature above threshold, cpu clock throttled=
 (total events =3D 24938)
[201862.161926] CPU0: Package temperature above threshold, cpu clock thrott=
led (total events =3D 26104)
[201862.161928] CPU2: Package temperature above threshold, cpu clock thrott=
led (total events =3D 26104)
[201862.161929] CPU3: Package temperature above threshold, cpu clock thrott=
led (total events =3D 26104)
[201862.161935] CPU1: Package temperature above threshold, cpu clock thrott=
led (total events =3D 26104)
[201862.162930] CPU2: Package temperature/speed normal
[201862.162931] CPU3: Core temperature/speed normal
[201862.162932] CPU1: Core temperature/speed normal
[201862.162933] CPU3: Package temperature/speed normal
[201862.162936] CPU0: Package temperature/speed normal
[201862.162937] CPU1: Package temperature/speed normal
[203120.340849] EXT4-fs (sda4): re-mounted. Opts: commit=3D600
[203121.537741] usb 2-1.2: USB disconnect, device number 4
[203121.543459] wacom 2-1.2:1.1: wacom_sys_irq - usb_submit_urb failed with=
 result -19
[203234.504286] CPU3: Core temperature above threshold, cpu clock throttled=
 (total events =3D 26557)
[203234.504290] CPU2: Package temperature above threshold, cpu clock thrott=
led (total events =3D 28707)
[203234.504291] CPU1: Core temperature above threshold, cpu clock throttled=
 (total events =3D 26557)
[203234.504293] CPU0: Package temperature above threshold, cpu clock thrott=
led (total events =3D 28707)
[203234.504295] CPU1: Package temperature above threshold, cpu clock thrott=
led (total events =3D 28707)
[203234.504300] CPU3: Package temperature above threshold, cpu clock thrott=
led (total events =3D 28707)
[203234.505300] CPU3: Core temperature/speed normal
[203234.505301] CPU1: Core temperature/speed normal
[203234.505302] CPU0: Package temperature/speed normal
[203234.505303] CPU2: Package temperature/speed normal
[203234.505304] CPU1: Package temperature/speed normal
[203234.505309] CPU3: Package temperature/speed normal
[204815.706378] systemd-journald[194]: Data hash table of /run/log/journal/=
430f5d56a9288edc7eca1b05000004e3/system.journal has a fill level at 75.0 (3=
3019 of 44024 items, 15486976 file size, 469 bytes per hash table item), su=
ggesting rotation.
[204815.706384] systemd-journald[194]: Journal header limits reached or hea=
der out-of-date, rotating.
[204815.706386] systemd-journald[194]: Rotating...
[204815.706959] systemd-journald[194]: Reserving 44024 entries in hash tabl=
e.
[204815.710239] systemd-journald[194]: Vacuuming...
[207246.155279] CPU2: Core temperature above threshold, cpu clock throttled=
 (total events =3D 3971)
[207246.155280] CPU0: Core temperature above threshold, cpu clock throttled=
 (total events =3D 3971)
[207246.155282] CPU1: Package temperature above threshold, cpu clock thrott=
led (total events =3D 29895)
[207246.155284] CPU3: Package temperature above threshold, cpu clock thrott=
led (total events =3D 29895)
[207246.155285] CPU0: Package temperature above threshold, cpu clock thrott=
led (total events =3D 29895)
[207246.155291] CPU2: Package temperature above threshold, cpu clock thrott=
led (total events =3D 29895)
[207246.156268] CPU2: Core temperature/speed normal
[207246.156269] CPU0: Core temperature/speed normal
[207246.156270] CPU3: Package temperature/speed normal
[207246.156271] CPU1: Package temperature/speed normal
[207246.156272] CPU0: Package temperature/speed normal
[207246.156276] CPU2: Package temperature/speed normal
[209156.873521] EXT4-fs (sda4): re-mounted. Opts: commit=3D0
[227104.496047] CPU3: Core temperature above threshold, cpu clock throttled=
 (total events =3D 28153)
[227104.496048] CPU1: Core temperature above threshold, cpu clock throttled=
 (total events =3D 28153)
[227104.496051] CPU0: Package temperature above threshold, cpu clock thrott=
led (total events =3D 31050)
[227104.496052] CPU2: Package temperature above threshold, cpu clock thrott=
led (total events =3D 31050)
[227104.496053] CPU1: Package temperature above threshold, cpu clock thrott=
led (total events =3D 31050)
[227104.496061] CPU3: Package temperature above threshold, cpu clock thrott=
led (total events =3D 31050)
[227104.497067] CPU1: Core temperature/speed normal
[227104.497068] CPU0: Package temperature/speed normal
[227104.497069] CPU3: Core temperature/speed normal
[227104.497070] CPU2: Package temperature/speed normal
[227104.497071] CPU3: Package temperature/speed normal
[227104.497076] CPU1: Package temperature/speed normal
[227404.585449] CPU2: Package temperature above threshold, cpu clock thrott=
led (total events =3D 34371)
[227404.585453] CPU1: Core temperature above threshold, cpu clock throttled=
 (total events =3D 30588)
[227404.585455] CPU3: Core temperature above threshold, cpu clock throttled=
 (total events =3D 30588)
[227404.585457] CPU0: Package temperature above threshold, cpu clock thrott=
led (total events =3D 34371)
[227404.585458] CPU1: Package temperature above threshold, cpu clock thrott=
led (total events =3D 34371)
[227404.585460] CPU3: Package temperature above threshold, cpu clock thrott=
led (total events =3D 34371)
[227404.586442] CPU3: Core temperature/speed normal
[227404.586444] CPU1: Core temperature/speed normal
[227404.586446] CPU2: Package temperature/speed normal
[227404.586448] CPU0: Package temperature/speed normal
[227404.586449] CPU1: Package temperature/speed normal
[227404.586458] CPU3: Package temperature/speed normal
[227704.276411] CPU3: Core temperature above threshold, cpu clock throttled=
 (total events =3D 39780)
[227704.276414] CPU0: Package temperature above threshold, cpu clock thrott=
led (total events =3D 48283)
[227704.276415] CPU2: Package temperature above threshold, cpu clock thrott=
led (total events =3D 48283)
[227704.276417] CPU1: Core temperature above threshold, cpu clock throttled=
 (total events =3D 39780)
[227704.276419] CPU1: Package temperature above threshold, cpu clock thrott=
led (total events =3D 48283)
[227704.276423] CPU3: Package temperature above threshold, cpu clock thrott=
led (total events =3D 48283)
[227704.277443] CPU3: Core temperature/speed normal
[227704.277444] CPU1: Core temperature/speed normal
[227704.277445] CPU2: Package temperature/speed normal
[227704.277446] CPU1: Package temperature/speed normal
[227704.277447] CPU0: Package temperature/speed normal
[227704.277452] CPU3: Package temperature/speed normal
[227707.512381] CPU2: Core temperature above threshold, cpu clock throttled=
 (total events =3D 11837)
[227707.512382] CPU0: Core temperature above threshold, cpu clock throttled=
 (total events =3D 11837)
[227707.513346] CPU2: Core temperature/speed normal
[227707.513349] CPU0: Core temperature/speed normal
[227807.329292] usb 2-1.2: new full-speed USB device number 5 using ehci_hcd
[227807.434560] input: Wacom Bamboo 16FG 4x5 Pen as /devices/pci0000:00/000=
0:00:1d.7/usb2/2-1/2-1.2/2-1.2:1.0/input/input17
[227807.436497] input: Wacom Bamboo 16FG 4x5 Finger as /devices/pci0000:00/=
0000:00:1d.7/usb2/2-1/2-1.2/2-1.2:1.1/input/input18
[262109.672289] usb 2-1.2: USB disconnect, device number 5
[262109.675253] wacom 2-1.2:1.1: wacom_sys_irq - usb_submit_urb failed with=
 result -19
[262111.416972] EXT4-fs (sda4): re-mounted. Opts: commit=3D600
[262114.961629] EXT4-fs (sda4): re-mounted. Opts: commit=3D0
[262115.307626] PM: Syncing filesystems ... done.
[262115.325707] PM: Preparing system for mem sleep
[262118.341264] Freezing user space processes ... (elapsed 0.01 seconds) do=
ne.
[262118.352209] Freezing remaining freezable tasks ... (elapsed 0.01 second=
s) done.
[262118.365601] PM: Entering mem sleep
[262118.365619] Suspending console(s) (use no_console_suspend to debug)
[262118.374145] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[262118.375387] sd 0:0:0:0: [sda] Stopping disk
[262119.773400] PM: suspend of devices complete after 1409.775 msecs
[262119.773558] PM: late suspend of devices complete after 0.156 msecs
[262119.786909] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[262119.800150] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[262119.826654] PM: noirq suspend of devices complete after 53.171 msecs
[262119.826899] ACPI: Preparing to enter system sleep state S3
[262119.853281] PM: Saving platform NVS memory
[262119.853632] Disabling non-boot CPUs ...
[262119.956393] CPU 1 is now offline
[262120.059537] CPU 2 is now offline
[262120.162704] CPU 3 is now offline
[262120.163030] Extended CMOS year: 2000
[262120.164488] ACPI: Low-level resume complete
[262120.164530] PM: Restoring platform NVS memory
[262120.164843] Extended CMOS year: 2000
[262120.164884] Enabling non-boot CPUs ...
[262120.168343] Booting Node 0 Processor 1 APIC 0x2
[262120.184011] CPU1 is up
[262120.191540] Booting Node 0 Processor 2 APIC 0x1
[262120.205912] CPU2 is up
[262120.206590] Booting Node 0 Processor 3 APIC 0x3
[262120.222180] CPU3 is up
[262120.227135] ACPI: Waking up from system sleep state S3
[262120.727243] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[262120.727526] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[262120.728163] PM: noirq resume of devices complete after 1.135 msecs
[262120.728271] PM: early resume of devices complete after 0.085 msecs
[262120.728301] i915 0000:00:02.0: setting latency timer to 64
[262120.728344] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[262120.728372] usb usb3: root hub lost power or was reset
[262120.728374] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[262120.728393] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[262120.728466] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[262120.728476] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[262120.728505] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[262120.728525] ata_piix 0000:00:1f.2: setting latency timer to 64
[262120.728529] usb usb4: root hub lost power or was reset
[262120.729300] mei 0000:00:16.0: wd: failed to find the client
[262120.778694] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[262120.800736] bcm5974: bad trackpad package, length: 8
[262121.748674] ata2.00: failed to resume link (SControl 0)
[262122.068248] ata1.01: failed to resume link (SControl 0)
[262122.221412] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[262122.221424] ata1.01: SATA link down (SStatus 0 SControl 0)
[262122.228241] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filte=
red out
[262122.235003] ata1.00: configured for UDMA/133
[262122.269299] sd 0:0:0:0: [sda] Starting disk
[262122.770486] ata2.01: failed to resume link (SControl 0)
[262122.781989] ata2.00: SATA link down (SStatus 4 SControl 0)
[262122.782010] ata2.01: SATA link down (SStatus 0 SControl 0)
[262122.798571] ieee80211 phy0: brcms_ops_config: change power-save mode: f=
alse (implement)
[262122.799572] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[262122.799575] ieee80211 phy0: changing basic rates failed: -22
[262122.799576] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: thr=
eshold 0, hys 0  (implement)
[262122.799577] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[262122.799578] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[262122.799765] PM: resume of devices complete after 2074.719 msecs
[262122.800134] PM: Finishing wakeup.
[262122.800135] Restarting tasks ... done.
[262122.819953] video LNXVIDEO:00: Restoring backlight state
[262122.880332] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[262122.880338] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 1 (implement)
[262122.880339] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[262122.896940] cfg80211: Calling CRDA to update world regulatory domain
[262125.551750] wlan0: authenticate with d4:a0:2a:98:a6:a0
[262125.551787] ieee80211 phy0: changing basic rates failed: -52
[262125.551809] wlan0: direct probe to d4:a0:2a:98:a6:a0 (try 1/3)
[262125.752464] wlan0: direct probe to d4:a0:2a:98:a6:a0 (try 2/3)
[262125.955435] wlan0: send auth to d4:a0:2a:98:a6:a0 (try 3/3)
[262125.957009] wlan0: authenticated
[262125.958826] wlan0: associate with d4:a0:2a:98:a6:a0 (try 1/3)
[262125.962709] wlan0: RX AssocResp from d4:a0:2a:98:a6:a0 (capab=3D0x431 s=
tatus=3D0 aid=3D7)
[262125.963222] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[262125.963232] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[262125.963237] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[262125.963251] wlan0: associated
[262126.393890] EXT4-fs (sda4): re-mounted. Opts: commit=3D600
[262132.047751] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[262145.814877] wlan0: deauthenticated from d4:a0:2a:98:a6:a0 (Reason: 2)
[262145.821446] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[262145.821464] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 1 (implement)
[262145.821469] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[262145.831180] cfg80211: Calling CRDA to update world regulatory domain
[262147.786017] wlan0: authenticate with d4:a0:2a:98:b8:cf
[262147.786070] wlan0: direct probe to d4:a0:2a:98:b8:cf (try 1/3)
[262147.987779] wlan0: send auth to d4:a0:2a:98:b8:cf (try 2/3)
[262147.988598] wlan0: authenticated
[262147.991152] wlan0: associate with d4:a0:2a:98:b8:cf (try 1/3)
[262147.992963] wlan0: RX AssocResp from d4:a0:2a:98:b8:cf (capab=3D0x11 st=
atus=3D0 aid=3D16)
[262147.993470] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[262147.993480] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[262147.993485] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[262147.994279] wlan0: associated
[262150.675880] EXT4-fs (sda4): re-mounted. Opts: commit=3D0
[262153.418861] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[262447.394461] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 36
[264813.574544] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 36
[269019.117829] EXT4-fs (sda4): re-mounted. Opts: commit=3D600
[269083.240288] EXT4-fs (sda4): re-mounted. Opts: commit=3D0
[269823.422875] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 36
[269823.427741] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 36
[269823.433030] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 36
[270681.945037] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 36
[272512.884852] wlan0: deauthenticating from d4:a0:2a:98:b8:cf by local cho=
ice (reason=3D3)
[272512.890476] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[272512.890492] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 1 (implement)
[272512.890497] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[272512.891227] wlan0: authenticate with d4:a0:2a:98:b8:cf
[272512.891265] wlan0: send auth to d4:a0:2a:98:b8:cf (try 1/3)
[272512.893319] wlan0: authenticated
[272512.893733] wlan0: associate with d4:a0:2a:98:b8:cf (try 1/3)
[272512.897925] wlan0: RX AssocResp from d4:a0:2a:98:b8:cf (capab=3D0x11 st=
atus=3D0 aid=3D16)
[272512.898396] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[272512.898401] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[272512.898404] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[272512.898723] wlan0: associated
[272517.705150] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[273629.459806] EXT4-fs (sda4): re-mounted. Opts: commit=3D600
[273654.216314] EXT4-fs (sda4): re-mounted. Opts: commit=3D0
[278843.360173] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 36
[278996.217630] CPU1: Core temperature above threshold, cpu clock throttled=
 (total events =3D 40251)
[278996.217631] CPU3: Core temperature above threshold, cpu clock throttled=
 (total events =3D 40251)
[278996.217634] CPU3: Package temperature above threshold, cpu clock thrott=
led (total events =3D 49101)
[278996.217645] CPU1: Package temperature above threshold, cpu clock thrott=
led (total events =3D 49101)
[278996.217658] CPU2: Package temperature above threshold, cpu clock thrott=
led (total events =3D 49101)
[278996.217659] CPU0: Package temperature above threshold, cpu clock thrott=
led (total events =3D 49101)
[278996.218576] CPU1: Core temperature/speed normal
[278996.218577] CPU3: Core temperature/speed normal
[278996.218578] CPU3: Package temperature/speed normal
[278996.218579] CPU1: Package temperature/speed normal
[278996.218607] CPU0: Package temperature/speed normal
[278996.218608] CPU2: Package temperature/speed normal
[280884.967987] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 36
[281837.742687] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 36
[283481.559916] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 36
[287795.183581] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 36
[287957.474452] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 36
[291480.699936] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 36
[291480.700048] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 36
[291593.621547] CPU2: Package power limit notification (total events =3D 4)
[291593.621549] CPU0: Package power limit notification (total events =3D 4)
[291593.621552] CPU3: Package power limit notification (total events =3D 4)
[291593.621554] CPU1: Package power limit notification (total events =3D 4)
[291593.626234] CPU2: Package power limit normal
[291593.626237] CPU1: Package power limit normal
[291593.626238] CPU3: Package power limit normal
[291593.626240] CPU0: Package power limit normal
[291967.563727] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 36
[291967.583420] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 36
[291967.603894] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 36
[293969.859842] EXT4-fs (sda4): re-mounted. Opts: commit=3D600
[293970.425480] EXT4-fs (sda4): re-mounted. Opts: commit=3D0
[293970.811384] PM: Syncing filesystems ... done.
[293970.832921] PM: Preparing system for mem sleep
[293973.071829] Freezing user space processes ... (elapsed 0.01 seconds) do=
ne.
[293973.082776] Freezing remaining freezable tasks ... (elapsed 0.01 second=
s) done.
[293973.096182] PM: Entering mem sleep
[293973.096200] Suspending console(s) (use no_console_suspend to debug)
[293973.104725] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[293973.105957] sd 0:0:0:0: [sda] Stopping disk
[293974.597148] PM: suspend of devices complete after 1503.082 msecs
[293974.597307] PM: late suspend of devices complete after 0.157 msecs
[293974.610661] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[293974.623896] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[293974.650398] PM: noirq suspend of devices complete after 53.171 msecs
[293974.650642] ACPI: Preparing to enter system sleep state S3
[293974.677027] PM: Saving platform NVS memory
[293974.677443] Disabling non-boot CPUs ...
[293974.780128] CPU 1 is now offline
[293974.886595] CPU 2 is now offline
[293974.989790] CPU 3 is now offline
[293974.990128] Extended CMOS year: 2000
[293974.991587] ACPI: Low-level resume complete
[293974.991629] PM: Restoring platform NVS memory
[293974.991944] Extended CMOS year: 2000
[293974.991986] Enabling non-boot CPUs ...
[293974.998845] Booting Node 0 Processor 1 APIC 0x2
[293975.014025] CPU1 is up
[293975.021450] Booting Node 0 Processor 2 APIC 0x1
[293975.035670] CPU2 is up
[293975.036328] Booting Node 0 Processor 3 APIC 0x3
[293975.051871] CPU3 is up
[293975.057085] ACPI: Waking up from system sleep state S3
[293975.557647] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[293975.557931] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[293975.558575] PM: noirq resume of devices complete after 1.144 msecs
[293975.558683] PM: early resume of devices complete after 0.085 msecs
[293975.558751] i915 0000:00:02.0: setting latency timer to 64
[293975.558769] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[293975.558782] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[293975.558803] usb usb3: root hub lost power or was reset
[293975.558811] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[293975.558848] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[293975.558876] usb usb4: root hub lost power or was reset
[293975.558888] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[293975.558890] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[293975.558901] ata_piix 0000:00:1f.2: setting latency timer to 64
[293975.559700] mei 0000:00:16.0: wd: failed to find the client
[293975.609491] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[293976.579140] ata2.00: failed to resume link (SControl 0)
[293976.898662] ata1.01: failed to resume link (SControl 0)
[293977.051816] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[293977.051828] ata1.01: SATA link down (SStatus 0 SControl 0)
[293977.058648] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filte=
red out
[293977.065406] ata1.00: configured for UDMA/133
[293977.099702] sd 0:0:0:0: [sda] Starting disk
[293977.600893] ata2.01: failed to resume link (SControl 0)
[293977.612390] ata2.00: SATA link down (SStatus 4 SControl 0)
[293977.612411] ata2.01: SATA link down (SStatus 0 SControl 0)
[293977.628730] ieee80211 phy0: brcms_ops_config: change power-save mode: f=
alse (implement)
[293977.629742] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[293977.629744] ieee80211 phy0: changing basic rates failed: -22
[293977.629745] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: thr=
eshold 0, hys 0  (implement)
[293977.629746] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[293977.629747] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[293977.629929] PM: resume of devices complete after 2074.475 msecs
[293977.630308] PM: Finishing wakeup.
[293977.630309] Restarting tasks ... done.
[293977.664128] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[293977.664171] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 1 (implement)
[293977.664212] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[293977.667436] cfg80211: Calling CRDA for country: CH
[293977.686571] video LNXVIDEO:00: Restoring backlight state
[293980.209464] EXT4-fs (sda4): re-mounted. Opts: commit=3D600
[294102.614860] wlan0: authenticate with 04:46:65:8b:88:32
[294102.614882] ieee80211 phy0: changing basic rates failed: -52
[294102.614889] wlan0: send auth to 04:46:65:8b:88:32 (try 1/3)
[294102.616440] wlan0: authenticated
[294102.619194] wlan0: associate with 04:46:65:8b:88:32 (try 1/3)
[294102.622372] wlan0: RX AssocResp from 04:46:65:8b:88:32 (capab=3D0x411 s=
tatus=3D0 aid=3D1)
[294102.623054] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[294102.623073] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[294102.623087] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[294102.623891] wlan0: associated
[294118.193951] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[294962.921640] wlan0: deauthenticating from 04:46:65:8b:88:32 by local cho=
ice (reason=3D3)
[294962.927252] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[294962.927271] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 1 (implement)
[294962.927276] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[294962.928008] cfg80211: Calling CRDA to update world regulatory domain
[294962.930736] wlan0: authenticate with 04:46:65:8b:88:32
[294962.930775] ieee80211 phy0: changing basic rates failed: -52
[294962.930798] wlan0: send auth to 04:46:65:8b:88:32 (try 1/3)
[294962.933586] wlan0: authenticated
[294962.937463] wlan0: associate with 04:46:65:8b:88:32 (try 1/3)
[294962.940687] wlan0: RX AssocResp from 04:46:65:8b:88:32 (capab=3D0x411 s=
tatus=3D0 aid=3D1)
[294962.941200] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[294962.941205] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[294962.941207] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[294962.941214] wlan0: associated
[294967.530334] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[295193.198036] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[295193.198055] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 1 (implement)
[295193.198060] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[295193.201108] cfg80211: Calling CRDA to update world regulatory domain
[295236.105107] wlan0: authenticate with 04:46:65:8b:88:32
[295236.114645] ieee80211 phy0: changing basic rates failed: -52
[295236.114665] wlan0: send auth to 04:46:65:8b:88:32 (try 1/3)
[295236.116294] wlan0: authenticated
[295236.117394] wlan0: associate with 04:46:65:8b:88:32 (try 1/3)
[295236.120549] wlan0: RX AssocResp from 04:46:65:8b:88:32 (capab=3D0x411 s=
tatus=3D0 aid=3D1)
[295236.121136] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[295236.121145] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[295236.121150] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[295236.121984] wlan0: associated
[295240.594947] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[295738.068292] EXT4-fs (sda4): re-mounted. Opts: commit=3D0
[295738.380204] PM: Syncing filesystems ... done.
[295738.400866] PM: Preparing system for mem sleep
[295738.839066] Freezing user space processes ... (elapsed 0.01 seconds) do=
ne.
[295738.853067] Freezing remaining freezable tasks ... (elapsed 0.01 second=
s) done.
[295738.866460] PM: Entering mem sleep
[295738.866482] Suspending console(s) (use no_console_suspend to debug)
[295738.875008] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[295738.876267] sd 0:0:0:0: [sda] Stopping disk
[295740.517231] PM: suspend of devices complete after 1653.098 msecs
[295740.517386] PM: late suspend of devices complete after 0.153 msecs
[295740.530766] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[295740.543979] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[295740.570474] PM: noirq suspend of devices complete after 53.176 msecs
[295740.570718] ACPI: Preparing to enter system sleep state S3
[295740.597099] PM: Saving platform NVS memory
[295740.597427] Disabling non-boot CPUs ...
[295740.700209] CPU 1 is now offline
[295740.803357] CPU 2 is now offline
[295740.804993] CPU 3 is now offline
[295740.805234] Extended CMOS year: 2000
[295740.806699] ACPI: Low-level resume complete
[295740.806740] PM: Restoring platform NVS memory
[295740.807054] Extended CMOS year: 2000
[295740.807095] Enabling non-boot CPUs ...
[295740.813956] Booting Node 0 Processor 1 APIC 0x2
[295740.829063] CPU1 is up
[295740.833750] Booting Node 0 Processor 2 APIC 0x1
[295740.847824] CPU2 is up
[295740.847922] Booting Node 0 Processor 3 APIC 0x3
[295740.863403] CPU3 is up
[295740.868392] ACPI: Waking up from system sleep state S3
[295741.371224] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[295741.371506] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[295741.372143] PM: noirq resume of devices complete after 1.134 msecs
[295741.372257] PM: early resume of devices complete after 0.090 msecs
[295741.372306] i915 0000:00:02.0: setting latency timer to 64
[295741.372333] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[295741.372337] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[295741.372363] usb usb3: root hub lost power or was reset
[295741.372372] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[295741.372404] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[295741.372420] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[295741.372437] usb usb4: root hub lost power or was reset
[295741.372446] ata_piix 0000:00:1f.2: setting latency timer to 64
[295741.372454] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[295741.373236] mei 0000:00:16.0: wd: failed to find the client
[295741.420241] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[295741.443690] bcm5974: bad trackpad package, length: 34
[295741.444687] bcm5974: bad trackpad package, length: 8
[295741.452640] bcm5974: bad trackpad package, length: 8
[295741.453677] bcm5974: bad trackpad package, length: 8
[295741.454632] bcm5974: bad trackpad package, length: 8
[295742.392724] ata2.00: failed to resume link (SControl 0)
[295742.712224] ata1.01: failed to resume link (SControl 0)
[295742.865382] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[295742.865393] ata1.01: SATA link down (SStatus 0 SControl 0)
[295742.872217] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filte=
red out
[295742.878978] ata1.00: configured for UDMA/133
[295742.913378] sd 0:0:0:0: [sda] Starting disk
[295743.414470] ata2.01: failed to resume link (SControl 0)
[295743.425963] ata2.00: SATA link down (SStatus 4 SControl 0)
[295743.425985] ata2.01: SATA link down (SStatus 0 SControl 0)
[295743.442400] ieee80211 phy0: brcms_ops_config: change power-save mode: f=
alse (implement)
[295743.443391] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[295743.443393] ieee80211 phy0: changing basic rates failed: -22
[295743.443394] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: thr=
eshold 0, hys 0  (implement)
[295743.443395] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[295743.443396] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[295743.443597] PM: resume of devices complete after 2074.568 msecs
[295743.450106] PM: Finishing wakeup.
[295743.450107] Restarting tasks ... done.
[295743.510223] video LNXVIDEO:00: Restoring backlight state
[295743.561591] EXT4-fs (sda4): re-mounted. Opts: commit=3D0
[295743.717347] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[295743.717353] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 1 (implement)
[295743.717355] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[295743.730576] cfg80211: Calling CRDA for country: CH
[295744.732638] EXT4-fs (sda4): re-mounted. Opts: commit=3D0
[295745.713416] wlan0: authenticate with 0c:b0:5d:9c:37:12
[295745.713442] ieee80211 phy0: changing basic rates failed: -52
[295745.713449] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[295745.715523] wlan0: authenticated
[295745.717479] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[295745.722386] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=3D0x411 s=
tatus=3D0 aid=3D1)
[295745.722926] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[295745.722936] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[295745.722940] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[295745.723745] wlan0: associated
[295750.541576] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[300387.264433] EXT4-fs (sda4): re-mounted. Opts: commit=3D600
[301864.279661] CPU3: Core temperature above threshold, cpu clock throttled=
 (total events =3D 40475)
[301864.279663] CPU1: Core temperature above threshold, cpu clock throttled=
 (total events =3D 40475)
[301864.279665] CPU2: Package temperature above threshold, cpu clock thrott=
led (total events =3D 49642)
[301864.279667] CPU0: Package temperature above threshold, cpu clock thrott=
led (total events =3D 49642)
[301864.279668] CPU1: Package temperature above threshold, cpu clock thrott=
led (total events =3D 49642)
[301864.279674] CPU3: Package temperature above threshold, cpu clock thrott=
led (total events =3D 49642)
[301864.281645] CPU3: Core temperature/speed normal
[301864.281646] CPU1: Core temperature/speed normal
[301864.281648] CPU2: Package temperature/speed normal
[301864.281649] CPU1: Package temperature/speed normal
[301864.281651] CPU0: Package temperature/speed normal
[301864.281655] CPU3: Package temperature/speed normal
[302084.743996] EXT4-fs (sda4): re-mounted. Opts: commit=3D0
[302085.428855] PM: Syncing filesystems ... done.
[302085.438019] PM: Preparing system for mem sleep
[302088.151453] Freezing user space processes ... (elapsed 0.01 seconds) do=
ne.
[302088.162407] Freezing remaining freezable tasks ... (elapsed 0.01 second=
s) done.
[302088.175816] PM: Entering mem sleep
[302088.175834] Suspending console(s) (use no_console_suspend to debug)
[302088.184349] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[302088.185592] sd 0:0:0:0: [sda] Stopping disk
[302089.779937] PM: suspend of devices complete after 1606.405 msecs
[302089.780101] PM: late suspend of devices complete after 0.160 msecs
[302089.793460] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[302089.806701] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[302089.833205] PM: noirq suspend of devices complete after 53.183 msecs
[302089.833449] ACPI: Preparing to enter system sleep state S3
[302089.859834] PM: Saving platform NVS memory
[302089.860301] Disabling non-boot CPUs ...
[302089.962935] CPU 1 is now offline
[302090.069406] CPU 2 is now offline
[302090.172593] CPU 3 is now offline
[302090.172917] Extended CMOS year: 2000
[302090.174372] ACPI: Low-level resume complete
[302090.174413] PM: Restoring platform NVS memory
[302090.174729] Extended CMOS year: 2000
[302090.174770] Enabling non-boot CPUs ...
[302090.178229] Booting Node 0 Processor 1 APIC 0x2
[302090.193428] CPU1 is up
[302090.197903] Booting Node 0 Processor 2 APIC 0x1
[302090.211965] CPU2 is up
[302090.212068] Booting Node 0 Processor 3 APIC 0x3
[302090.227403] CPU3 is up
[302090.232357] ACPI: Waking up from system sleep state S3
[302090.733793] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[302090.734076] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[302090.734720] PM: noirq resume of devices complete after 1.143 msecs
[302090.734828] PM: early resume of devices complete after 0.085 msecs
[302090.734890] i915 0000:00:02.0: setting latency timer to 64
[302090.734907] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[302090.734935] usb usb3: root hub lost power or was reset
[302090.734943] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[302090.734955] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[302090.735019] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[302090.735036] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[302090.735045] usb usb4: root hub lost power or was reset
[302090.735068] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[302090.735080] ata_piix 0000:00:1f.2: setting latency timer to 64
[302090.735758] mei 0000:00:16.0: wd: failed to find the client
[302090.791883] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[302090.808275] bcm5974: bad trackpad package, length: 8
[302091.755306] ata2.00: failed to resume link (SControl 0)
[302092.074804] ata1.01: failed to resume link (SControl 0)
[302092.227985] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[302092.227997] ata1.01: SATA link down (SStatus 0 SControl 0)
[302092.234792] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filte=
red out
[302092.241582] ata1.00: configured for UDMA/133
[302092.275940] sd 0:0:0:0: [sda] Starting disk
[302092.777044] ata2.01: failed to resume link (SControl 0)
[302092.788528] ata2.00: SATA link down (SStatus 4 SControl 0)
[302092.788548] ata2.01: SATA link down (SStatus 0 SControl 0)
[302092.805014] ieee80211 phy0: brcms_ops_config: change power-save mode: f=
alse (implement)
[302092.806006] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[302092.806008] ieee80211 phy0: changing basic rates failed: -22
[302092.806009] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: thr=
eshold 0, hys 0  (implement)
[302092.806010] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[302092.806011] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[302092.806213] PM: resume of devices complete after 2074.615 msecs
[302092.812831] PM: Finishing wakeup.
[302092.812832] Restarting tasks ... done.
[302092.844728] video LNXVIDEO:00: Restoring backlight state
[302092.916759] wlan0: deauthenticated from 0c:b0:5d:9c:37:12 (Reason: 7)
[302092.920375] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[302092.920388] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 1 (implement)
[302092.920394] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[302092.932540] cfg80211: Calling CRDA to update world regulatory domain
[302094.246535] EXT4-fs (sda4): re-mounted. Opts: commit=3D600
[302094.867587] wlan0: authenticate with 0c:b0:5d:9c:37:12
[302094.877665] ieee80211 phy0: changing basic rates failed: -52
[302094.877690] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[302094.880583] wlan0: authenticated
[302094.883769] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[302094.891590] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=3D0x411 s=
tatus=3D0 aid=3D1)
[302094.892129] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[302094.892139] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[302094.892144] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[302094.892945] wlan0: associated
[302099.561025] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[302457.649180] EXT4-fs (sda4): re-mounted. Opts: commit=3D0
[302457.988696] PM: Syncing filesystems ... done.
[302457.996619] PM: Preparing system for mem sleep
[302458.595607] Freezing user space processes ... (elapsed 0.01 seconds) do=
ne.
[302458.609601] Freezing remaining freezable tasks ... (elapsed 0.01 second=
s) done.
[302458.622996] PM: Entering mem sleep
[302458.623017] Suspending console(s) (use no_console_suspend to debug)
[302458.631498] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[302458.632838] sd 0:0:0:0: [sda] Stopping disk
[302460.277074] PM: suspend of devices complete after 1656.423 msecs
[302460.277241] PM: late suspend of devices complete after 0.164 msecs
[302460.290601] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[302460.303835] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[302460.330334] PM: noirq suspend of devices complete after 53.179 msecs
[302460.330578] ACPI: Preparing to enter system sleep state S3
[302460.356957] PM: Saving platform NVS memory
[302460.357240] Disabling non-boot CPUs ...
[302460.460070] CPU 1 is now offline
[302460.563259] CPU 2 is now offline
[302460.666377] CPU 3 is now offline
[302460.666716] Extended CMOS year: 2000
[302460.668169] ACPI: Low-level resume complete
[302460.668210] PM: Restoring platform NVS memory
[302460.668525] Extended CMOS year: 2000
[302460.668567] Enabling non-boot CPUs ...
[302460.675424] Booting Node 0 Processor 1 APIC 0x2
[302460.690153] CPU1 is up
[302460.694386] Booting Node 0 Processor 2 APIC 0x1
[302460.713290] CPU2 is up
[302460.713773] Booting Node 0 Processor 3 APIC 0x3
[302460.728602] CPU3 is up
[302460.733517] ACPI: Waking up from system sleep state S3
[302461.593690] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[302461.593966] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[302461.594581] PM: noirq resume of devices complete after 1.092 msecs
[302461.594678] PM: early resume of devices complete after 0.075 msecs
[302461.594731] i915 0000:00:02.0: setting latency timer to 64
[302461.594768] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[302461.594799] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[302461.594812] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[302461.594826] usb usb3: root hub lost power or was reset
[302461.594867] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[302461.594888] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[302461.594892] usb usb4: root hub lost power or was reset
[302461.594909] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[302461.594931] ata_piix 0000:00:1f.2: setting latency timer to 64
[302461.595624] mei 0000:00:16.0: wd: failed to find the client
[302461.599893] Extended CMOS year: 2000
[302461.640942] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[302461.668224] bcm5974: bad trackpad package, length: 8
[302461.692221] bcm5974: bad trackpad package, length: 8
[302461.693157] bcm5974: bad trackpad package, length: 8
[302461.694189] bcm5974: bad trackpad package, length: 8
[302462.615188] ata2.00: failed to resume link (SControl 0)
[302462.934655] ata1.01: failed to resume link (SControl 0)
[302463.087845] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[302463.087856] ata1.01: SATA link down (SStatus 0 SControl 0)
[302463.094682] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filte=
red out
[302463.101440] ata1.00: configured for UDMA/133
[302463.135769] sd 0:0:0:0: [sda] Starting disk
[302463.636929] ata2.01: failed to resume link (SControl 0)
[302463.648425] ata2.00: SATA link down (SStatus 4 SControl 0)
[302463.648446] ata2.01: SATA link down (SStatus 0 SControl 0)
[302463.664927] ieee80211 phy0: brcms_ops_config: change power-save mode: f=
alse (implement)
[302463.665918] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[302463.665921] ieee80211 phy0: changing basic rates failed: -22
[302463.665922] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: thr=
eshold 0, hys 0  (implement)
[302463.665923] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[302463.665924] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[302463.666092] PM: resume of devices complete after 2074.644 msecs
[302463.670140] wlan0: deauthenticated from 0c:b0:5d:9c:37:12 (Reason: 7)
[302463.672695] PM: Finishing wakeup.
[302463.672696] Restarting tasks ... done.
[302463.682713] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[302463.684050] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 1 (implement)
[302463.685354] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[302463.693756] cfg80211: Calling CRDA for country: CH
[302463.716304] video LNXVIDEO:00: Restoring backlight state
[302463.744923] EXT4-fs (sda4): re-mounted. Opts: commit=3D0
[302465.019330] EXT4-fs (sda4): re-mounted. Opts: commit=3D0
[302465.641051] wlan0: authenticate with 0c:b0:5d:9c:37:12
[302465.650984] ieee80211 phy0: changing basic rates failed: -52
[302465.651011] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[302465.652947] wlan0: authenticated
[302465.653749] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[302465.658684] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=3D0x411 s=
tatus=3D0 aid=3D1)
[302465.659228] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[302465.659238] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[302465.659243] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[302465.660044] wlan0: associated
[302470.507413] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[303764.031117] EXT4-fs (sda4): re-mounted. Opts: commit=3D600
[303766.309699] EXT4-fs (sda4): re-mounted. Opts: commit=3D0
[303766.635045] PM: Syncing filesystems ... done.
[303766.642697] PM: Preparing system for mem sleep
[303769.422073] Freezing user space processes ... (elapsed 0.01 seconds) do=
ne.
[303769.433018] Freezing remaining freezable tasks ... (elapsed 0.01 second=
s) done.
[303769.446416] PM: Entering mem sleep
[303769.446434] Suspending console(s) (use no_console_suspend to debug)
[303769.454964] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[303769.456236] sd 0:0:0:0: [sda] Stopping disk
[303771.093841] PM: suspend of devices complete after 1649.769 msecs
[303771.093997] PM: late suspend of devices complete after 0.153 msecs
[303771.107356] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[303771.120583] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[303771.147087] PM: noirq suspend of devices complete after 53.169 msecs
[303771.147332] ACPI: Preparing to enter system sleep state S3
[303771.173720] PM: Saving platform NVS memory
[303771.174015] Disabling non-boot CPUs ...
[303771.276798] CPU 1 is now offline
[303771.379969] CPU 2 is now offline
[303771.483133] CPU 3 is now offline
[303771.483461] Extended CMOS year: 2000
[303771.484916] ACPI: Low-level resume complete
[303771.484958] PM: Restoring platform NVS memory
[303771.485274] Extended CMOS year: 2000
[303771.485315] Enabling non-boot CPUs ...
[303771.492154] Booting Node 0 Processor 1 APIC 0x2
[303771.507695] CPU1 is up
[303771.515214] Booting Node 0 Processor 2 APIC 0x1
[303771.529242] CPU2 is up
[303771.530506] Booting Node 0 Processor 3 APIC 0x3
[303771.545985] CPU3 is up
[303771.551149] ACPI: Waking up from system sleep state S3
[303772.054329] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[303772.054611] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[303772.055257] PM: noirq resume of devices complete after 1.143 msecs
[303772.055372] PM: early resume of devices complete after 0.089 msecs
[303772.055433] i915 0000:00:02.0: setting latency timer to 64
[303772.055458] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[303772.055468] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[303772.055490] usb usb3: root hub lost power or was reset
[303772.055500] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[303772.055534] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[303772.055565] usb usb4: root hub lost power or was reset
[303772.055573] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[303772.055584] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[303772.055601] ata_piix 0000:00:1f.2: setting latency timer to 64
[303772.056238] mei 0000:00:16.0: wd: failed to find the client
[303772.107096] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[303772.193284] Extended CMOS year: 2000
[303773.075841] ata2.00: failed to resume link (SControl 0)
[303773.395346] ata1.01: failed to resume link (SControl 0)
[303773.548472] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[303773.548483] ata1.01: SATA link down (SStatus 0 SControl 0)
[303773.555335] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filte=
red out
[303773.562091] ata1.00: configured for UDMA/133
[303773.596331] sd 0:0:0:0: [sda] Starting disk
[303774.097585] ata2.01: failed to resume link (SControl 0)
[303774.109077] ata2.00: SATA link down (SStatus 4 SControl 0)
[303774.109099] ata2.01: SATA link down (SStatus 0 SControl 0)
[303774.125686] ieee80211 phy0: brcms_ops_config: change power-save mode: f=
alse (implement)
[303774.126677] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[303774.126679] ieee80211 phy0: changing basic rates failed: -22
[303774.126681] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: thr=
eshold 0, hys 0  (implement)
[303774.126682] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[303774.126682] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[303774.126854] PM: resume of devices complete after 2074.711 msecs
[303774.133244] PM: Finishing wakeup.
[303774.133245] Restarting tasks ... done.
[303774.153462] video LNXVIDEO:00: Restoring backlight state
[303774.403971] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[303774.403988] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 1 (implement)
[303774.403993] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[303774.414006] cfg80211: Calling CRDA for country: CH
[303775.504286] EXT4-fs (sda4): re-mounted. Opts: commit=3D600
[303776.382771] wlan0: authenticate with 04:46:65:8b:88:32
[303776.382782] ieee80211 phy0: changing basic rates failed: -52
[303776.382788] wlan0: send auth to 04:46:65:8b:88:32 (try 1/3)
[303776.384982] wlan0: authenticated
[303776.387356] wlan0: associate with 04:46:65:8b:88:32 (try 1/3)
[303776.395403] wlan0: RX AssocResp from 04:46:65:8b:88:32 (capab=3D0x411 s=
tatus=3D0 aid=3D1)
[303776.396032] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[303776.396035] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[303776.396036] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[303776.396041] wlan0: associated
[303786.000909] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[306957.098398] EXT4-fs (sda4): re-mounted. Opts: commit=3D0
[306957.447895] PM: Syncing filesystems ... done.
[306957.454362] PM: Preparing system for mem sleep
[306958.069408] Freezing user space processes ... (elapsed 0.01 seconds) do=
ne.
[306958.083420] Freezing remaining freezable tasks ... (elapsed 0.01 second=
s) done.
[306958.096820] PM: Entering mem sleep
[306958.096839] Suspending console(s) (use no_console_suspend to debug)
[306958.105320] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[306958.106570] sd 0:0:0:0: [sda] Stopping disk
[306959.740905] PM: suspend of devices complete after 1646.434 msecs
[306959.741072] PM: late suspend of devices complete after 0.158 msecs
[306959.754434] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[306959.767652] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[306959.794161] PM: noirq suspend of devices complete after 53.158 msecs
[306959.794405] ACPI: Preparing to enter system sleep state S3
[306959.820792] PM: Saving platform NVS memory
[306959.821100] Disabling non-boot CPUs ...
[306959.923902] CPU 1 is now offline
[306960.030382] CPU 2 is now offline
[306960.136862] CPU 3 is now offline
[306960.137188] Extended CMOS year: 2000
[306960.138648] ACPI: Low-level resume complete
[306960.138689] PM: Restoring platform NVS memory
[306960.139005] Extended CMOS year: 2000
[306960.139046] Enabling non-boot CPUs ...
[306960.145911] Booting Node 0 Processor 1 APIC 0x2
[306960.161161] CPU1 is up
[306960.168549] Booting Node 0 Processor 2 APIC 0x1
[306960.182858] CPU2 is up
[306960.184094] Booting Node 0 Processor 3 APIC 0x3
[306960.200258] CPU3 is up
[306960.205236] ACPI: Waking up from system sleep state S3
[306960.711401] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[306960.711683] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[306960.712325] PM: noirq resume of devices complete after 1.139 msecs
[306960.712439] PM: early resume of devices complete after 0.089 msecs
[306960.712488] i915 0000:00:02.0: setting latency timer to 64
[306960.712507] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[306960.712534] usb usb3: root hub lost power or was reset
[306960.712543] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[306960.712556] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[306960.712594] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[306960.712600] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[306960.712628] usb usb4: root hub lost power or was reset
[306960.712639] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[306960.712653] ata_piix 0000:00:1f.2: setting latency timer to 64
[306960.713411] mei 0000:00:16.0: wd: failed to find the client
[306960.757951] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[306960.848947] Extended CMOS year: 2000
[306961.732893] ata2.00: failed to resume link (SControl 0)
[306962.052382] ata1.01: failed to resume link (SControl 0)
[306962.205556] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[306962.205567] ata1.01: SATA link down (SStatus 0 SControl 0)
[306962.212398] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filte=
red out
[306962.219158] ata1.00: configured for UDMA/133
[306962.252905] sd 0:0:0:0: [sda] Starting disk
[306962.754644] ata2.01: failed to resume link (SControl 0)
[306962.766142] ata2.00: SATA link down (SStatus 4 SControl 0)
[306962.766163] ata2.01: SATA link down (SStatus 0 SControl 0)
[306962.782601] ieee80211 phy0: brcms_ops_config: change power-save mode: f=
alse (implement)
[306962.783591] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[306962.783593] ieee80211 phy0: changing basic rates failed: -22
[306962.783594] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: thr=
eshold 0, hys 0  (implement)
[306962.783595] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[306962.783596] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[306962.783792] PM: resume of devices complete after 2074.579 msecs
[306962.790169] PM: Finishing wakeup.
[306962.790170] Restarting tasks ... done.
[306962.799825] video LNXVIDEO:00: Restoring backlight state
[306962.868576] EXT4-fs (sda4): re-mounted. Opts: commit=3D0
[306963.078467] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[306963.078477] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 1 (implement)
[306963.078479] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[306963.090841] cfg80211: Calling CRDA to update world regulatory domain
[306964.212580] EXT4-fs (sda4): re-mounted. Opts: commit=3D0
[306965.074734] wlan0: authenticate with d4:a0:2a:98:b8:cf
[306965.074771] wlan0: send auth to d4:a0:2a:98:b8:cf (try 1/3)
[306965.075414] wlan0: authenticated
[306965.077665] wlan0: associate with d4:a0:2a:98:b8:cf (try 1/3)
[306965.079476] wlan0: RX AssocResp from d4:a0:2a:98:b8:cf (capab=3D0x11 st=
atus=3D0 aid=3D52)
[306965.079942] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[306965.079945] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[306965.079946] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[306965.079950] wlan0: associated
[306972.082228] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[306985.091219] wlan0: deauthenticated from d4:a0:2a:98:b8:cf (Reason: 2)
[306985.093439] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[306985.093456] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 1 (implement)
[306985.093461] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[306985.103103] cfg80211: Calling CRDA to update world regulatory domain
[306987.058984] wlan0: authenticate with d4:a0:2a:98:a6:a0
[306987.059005] ieee80211 phy0: changing basic rates failed: -52
[306987.059013] wlan0: direct probe to d4:a0:2a:98:a6:a0 (try 1/3)
[306987.259703] wlan0: direct probe to d4:a0:2a:98:a6:a0 (try 2/3)
[306987.462720] wlan0: direct probe to d4:a0:2a:98:a6:a0 (try 3/3)
[306987.665714] wlan0: authentication with d4:a0:2a:98:a6:a0 timed out
[306999.894000] wlan0: authenticate with d4:a0:2a:98:a6:a0
[306999.894029] ieee80211 phy0: changing basic rates failed: -52
[306999.894045] wlan0: send auth to d4:a0:2a:98:a6:a0 (try 1/3)
[306999.896451] wlan0: authenticated
[306999.896622] wlan0: associate with d4:a0:2a:98:a6:a0 (try 1/3)
[306999.900457] wlan0: RX AssocResp from d4:a0:2a:98:a6:a0 (capab=3D0x431 s=
tatus=3D0 aid=3D20)
[306999.900965] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[306999.900974] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[306999.900979] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[306999.900992] wlan0: associated
[307003.062622] wlan0: deauthenticated from d4:a0:2a:98:a6:a0 (Reason: 15)
[307003.063757] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[307003.063774] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 0 (implement)
[307003.063780] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[307003.064359] cfg80211: Calling CRDA to update world regulatory domain
[307005.418844] wlan0: authenticate with d4:a0:2a:9a:f6:ef
[307005.418860] wlan0: direct probe to d4:a0:2a:9a:f6:ef (try 1/3)
[307005.621056] wlan0: direct probe to d4:a0:2a:9a:f6:ef (try 2/3)
[307005.824078] wlan0: direct probe to d4:a0:2a:9a:f6:ef (try 3/3)
[307006.027087] wlan0: authentication with d4:a0:2a:9a:f6:ef timed out
[307018.249960] wlan0: authenticate with d4:a0:2a:9a:c1:ef
[307018.250003] wlan0: direct probe to d4:a0:2a:9a:c1:ef (try 1/3)
[307018.451034] wlan0: direct probe to d4:a0:2a:9a:c1:ef (try 2/3)
[307018.654055] wlan0: direct probe to d4:a0:2a:9a:c1:ef (try 3/3)
[307018.857071] wlan0: authentication with d4:a0:2a:9a:c1:ef timed out
[307031.092654] wlan0: authenticate with d4:a0:2a:9a:f6:e0
[307031.092684] ieee80211 phy0: changing basic rates failed: -52
[307031.092702] wlan0: direct probe to d4:a0:2a:9a:f6:e0 (try 1/3)
[307031.294340] wlan0: direct probe to d4:a0:2a:9a:f6:e0 (try 2/3)
[307031.497349] wlan0: direct probe to d4:a0:2a:9a:f6:e0 (try 3/3)
[307031.700366] wlan0: authentication with d4:a0:2a:9a:f6:e0 timed out
[307043.921868] wlan0: authenticate with d4:a0:2a:9a:f6:e0
[307043.921882] ieee80211 phy0: changing basic rates failed: -52
[307043.921890] wlan0: direct probe to d4:a0:2a:9a:f6:e0 (try 1/3)
[307044.124321] wlan0: direct probe to d4:a0:2a:9a:f6:e0 (try 2/3)
[307044.327290] wlan0: direct probe to d4:a0:2a:9a:f6:e0 (try 3/3)
[307044.530305] wlan0: authentication with d4:a0:2a:9a:f6:e0 timed out
[307056.762051] wlan0: authenticate with d4:a0:2a:9a:c1:ef
[307056.762076] wlan0: send auth to d4:a0:2a:9a:c1:ef (try 1/3)
[307056.762751] wlan0: authenticated
[307056.764628] wlan0: associate with d4:a0:2a:9a:c1:ef (try 1/3)
[307056.766403] wlan0: RX AssocResp from d4:a0:2a:9a:c1:ef (capab=3D0x11 st=
atus=3D0 aid=3D15)
[307056.766908] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[307056.766917] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[307056.766922] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[307056.767712] wlan0: associated
[307061.283125] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[309281.914310] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 36
[310396.966990] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 36
[310396.967685] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 36
[311229.369742] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 36
[311438.715353] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 36
[311438.715413] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 36
[312661.933089] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[312661.933106] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 1 (implement)
[312661.933112] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[312661.952566] cfg80211: Calling CRDA to update world regulatory domain
[312663.926309] wlan0: authenticate with d4:a0:2a:98:a6:af
[312663.926349] wlan0: direct probe to d4:a0:2a:98:a6:af (try 1/3)
[312664.126319] wlan0: direct probe to d4:a0:2a:98:a6:af (try 2/3)
[312664.329327] wlan0: send auth to d4:a0:2a:98:a6:af (try 3/3)
[312664.330043] wlan0: authenticated
[312664.332681] wlan0: associate with d4:a0:2a:98:a6:af (try 1/3)
[312664.334626] wlan0: RX AssocResp from d4:a0:2a:98:a6:af (capab=3D0x11 st=
atus=3D0 aid=3D12)
[312664.335149] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[312664.335158] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[312664.335163] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[312664.335176] wlan0: associated
[312668.526341] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[313155.829726] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 44
[313155.829778] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 44
[315731.380570] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 44
[315731.380618] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 44
[317678.856063] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 44
[319139.400404] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 44
[319139.400944] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 44
[321049.166432] EXT4-fs (sda4): re-mounted. Opts: commit=3D600
[321049.442824] PM: Syncing filesystems ... done.
[321049.448418] PM: Preparing system for mem sleep
[321051.939178] Freezing user space processes ... (elapsed 0.01 seconds) do=
ne.
[321051.950137] Freezing remaining freezable tasks ... (elapsed 0.01 second=
s) done.
[321051.963539] PM: Entering mem sleep
[321051.963561] Suspending console(s) (use no_console_suspend to debug)
[321051.972035] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[321051.973275] sd 0:0:0:0: [sda] Stopping disk
[321053.298075] PM: suspend of devices complete after 1336.403 msecs
[321053.298242] PM: late suspend of devices complete after 0.165 msecs
[321053.311603] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[321053.324846] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[321053.351351] PM: noirq suspend of devices complete after 53.180 msecs
[321053.351595] ACPI: Preparing to enter system sleep state S3
[321053.377981] PM: Saving platform NVS memory
[321053.378629] Disabling non-boot CPUs ...
[321053.481081] CPU 1 is now offline
[321053.584238] CPU 2 is now offline
[321053.585854] CPU 3 is now offline
[321053.586193] Extended CMOS year: 2000
[321053.587652] ACPI: Low-level resume complete
[321053.587693] PM: Restoring platform NVS memory
[321053.588008] Extended CMOS year: 2000
[321053.588049] Enabling non-boot CPUs ...
[321053.588131] Booting Node 0 Processor 1 APIC 0x2
[321053.604067] CPU1 is up
[321053.608260] Booting Node 0 Processor 2 APIC 0x1
[321053.627260] CPU2 is up
[321053.627730] Booting Node 0 Processor 3 APIC 0x3
[321053.643884] CPU3 is up
[321053.648829] ACPI: Waking up from system sleep state S3
[321054.518199] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[321054.518475] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[321054.519100] PM: noirq resume of devices complete after 1.104 msecs
[321054.519197] PM: early resume of devices complete after 0.075 msecs
[321054.519228] i915 0000:00:02.0: setting latency timer to 64
[321054.519264] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[321054.519294] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[321054.519308] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[321054.519320] usb usb3: root hub lost power or was reset
[321054.519342] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[321054.519374] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[321054.519375] usb usb4: root hub lost power or was reset
[321054.519380] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[321054.519394] ata_piix 0000:00:1f.2: setting latency timer to 64
[321054.520103] mei 0000:00:16.0: wd: failed to find the client
[321054.524020] Extended CMOS year: 2000
[321054.559084] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[321054.591712] bcm5974: bad trackpad package, length: 8
[321054.592699] bcm5974: bad trackpad package, length: 8
[321054.594700] bcm5974: bad trackpad package, length: 8
[321054.610736] bcm5974: bad trackpad package, length: 8
[321054.611677] bcm5974: bad trackpad package, length: 8
[321054.612673] bcm5974: bad trackpad package, length: 8
[321054.614691] bcm5974: bad trackpad package, length: 8
[321055.539701] ata2.00: failed to resume link (SControl 0)
[321055.859207] ata1.01: failed to resume link (SControl 0)
[321056.012366] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[321056.012378] ata1.01: SATA link down (SStatus 0 SControl 0)
[321056.019201] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filte=
red out
[321056.025965] ata1.00: configured for UDMA/133
[321056.060314] sd 0:0:0:0: [sda] Starting disk
[321056.561367] ata2.01: failed to resume link (SControl 0)
[321056.572872] ata2.00: SATA link down (SStatus 4 SControl 0)
[321056.572886] ata2.01: SATA link down (SStatus 0 SControl 0)
[321056.589360] ieee80211 phy0: brcms_ops_config: change power-save mode: f=
alse (implement)
[321056.590374] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[321056.590377] ieee80211 phy0: changing basic rates failed: -22
[321056.590379] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: thr=
eshold 0, hys 0  (implement)
[321056.590380] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[321056.590381] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[321056.590539] PM: resume of devices complete after 2074.571 msecs
[321056.608017] PM: Finishing wakeup.
[321056.608018] Restarting tasks ... done.
[321056.631254] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[321056.632413] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 1 (implement)
[321056.633617] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[321056.637976] cfg80211: Calling CRDA to update world regulatory domain
[321056.700984] EXT4-fs (sda4): re-mounted. Opts: commit=3D0
[321056.709638] video LNXVIDEO:00: Restoring backlight state
[321059.009575] EXT4-fs (sda4): re-mounted. Opts: commit=3D0
[321059.616037] wlan0: authenticate with 0c:b0:5d:9c:37:12
[321059.616076] ieee80211 phy0: changing basic rates failed: -52
[321059.616095] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[321059.816327] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 2/3)
[321059.818307] wlan0: authenticated
[321059.819707] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[321059.825995] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=3D0x411 s=
tatus=3D0 aid=3D1)
[321059.826556] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[321059.826566] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[321059.826571] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[321059.827361] wlan0: associated
[321064.253568] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[321096.938158] [drm:intel_dp_complete_link_train] *ERROR* failed to train =
DP, aborting
[321404.593705] wlan0: deauthenticating from 0c:b0:5d:9c:37:12 by local cho=
ice (reason=3D3)
[321404.598546] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[321404.598562] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 1 (implement)
[321404.598568] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[321404.599266] cfg80211: Calling CRDA for country: CH
[321404.602179] wlan0: authenticate with 0c:b0:5d:9c:37:12
[321404.602225] ieee80211 phy0: changing basic rates failed: -52
[321404.602250] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[321404.604117] wlan0: authenticated
[321404.605054] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[321404.611624] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=3D0x411 s=
tatus=3D0 aid=3D1)
[321404.612205] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[321404.612210] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[321404.612212] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[321404.612218] wlan0: associated
[321409.300348] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[321465.400251] wlan0: deauthenticating from 0c:b0:5d:9c:37:12 by local cho=
ice (reason=3D3)
[321465.407118] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[321465.407138] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 1 (implement)
[321465.407144] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[321465.407735] cfg80211: Calling CRDA to update world regulatory domain
[321465.413636] wlan0: authenticate with 0c:b0:5d:9c:37:12
[321465.413677] ieee80211 phy0: changing basic rates failed: -52
[321465.413702] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[321465.415633] wlan0: authenticated
[321465.416853] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[321465.422330] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=3D0x411 s=
tatus=3D0 aid=3D1)
[321465.422845] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[321465.422849] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[321465.422851] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[321465.422856] wlan0: associated
[321475.161584] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[321591.762727] wlan0: deauthenticating from 0c:b0:5d:9c:37:12 by local cho=
ice (reason=3D3)
[321591.766614] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[321591.766631] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 1 (implement)
[321591.766636] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[321591.770480] cfg80211: Calling CRDA to update world regulatory domain
[321598.869997] cfg80211: Calling CRDA to update world regulatory domain
[321598.880097] bcma: Found chip with id 0xA8D8, rev 0x01 and package 0x08
[321598.880131] bcma: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev =
0x22, class 0x0)
[321598.880158] bcma: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev=
 0x17, class 0x0)
[321598.880219] bcma: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x0F, =
class 0x0)
[321598.939160] bcma: Bus registered
[321598.954600] brcmsmac bcma0:0: mfg 4bf core 812 rev 23 class 0 irq 17
[321598.963099] ieee80211 phy0: Selected rate control algorithm 'minstrel_h=
t'
[321598.982641] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[321598.982652] ieee80211 phy0: brcms_ops_config: change power-save mode: f=
alse (implement)
[321598.983928] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[321602.139284] wlan0: authenticate with 0c:b0:5d:9c:37:12
[321602.139325] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[321602.142376] wlan0: authenticated
[321602.143609] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[321602.148428] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=3D0x411 s=
tatus=3D0 aid=3D1)
[321602.148994] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[321602.149004] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[321602.149008] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[321602.149739] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[321602.149855] wlan0: associated
[321606.443758] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[341361.882439] usb 2-1.2: new high-speed USB device number 6 using ehci_hcd
[341361.981447] usb-storage 2-1.2:1.0: Quirks match for vid 1058 pid 0704: =
8000
[341361.981495] scsi3 : usb-storage 2-1.2:1.0
[341362.981769] scsi 3:0:0:0: Direct-Access     WD       5000BMV External 1=
=2E75 PQ: 0 ANSI: 4
[341362.982811] sd 3:0:0:0: [sdc] 976773168 512-byte logical blocks: (500 G=
B/465 GiB)
[341362.983528] sd 3:0:0:0: [sdc] Write Protect is off
[341362.983543] sd 3:0:0:0: [sdc] Mode Sense: 23 00 00 00
[341362.984144] sd 3:0:0:0: [sdc] No Caching mode page present
[341362.984155] sd 3:0:0:0: [sdc] Assuming drive cache: write through
[341362.986807] sd 3:0:0:0: [sdc] No Caching mode page present
[341362.986819] sd 3:0:0:0: [sdc] Assuming drive cache: write through
[341363.019184]  sdc: unknown partition table
[341363.021451] sd 3:0:0:0: [sdc] No Caching mode page present
[341363.021460] sd 3:0:0:0: [sdc] Assuming drive cache: write through
[341363.021466] sd 3:0:0:0: [sdc] Attached SCSI disk
[360487.251425] systemd-journald[194]: Data hash table of /run/log/journal/=
430f5d56a9288edc7eca1b05000004e3/system.journal has a fill level at 75.0 (3=
3022 of 44024 items, 13131776 file size, 397 bytes per hash table item), su=
ggesting rotation.
[360487.251431] systemd-journald[194]: Journal header limits reached or hea=
der out-of-date, rotating.
[360487.251434] systemd-journald[194]: Rotating...
[360487.251520] systemd-journald[194]: Reserving 44024 entries in hash tabl=
e.
[360487.255176] systemd-journald[194]: Vacuuming...
[384094.171486] usb 2-1.2: USB disconnect, device number 6
[384095.895939] EXT4-fs (sda4): re-mounted. Opts: commit=3D600
[384103.105853] EXT4-fs (sda4): re-mounted. Opts: commit=3D0
[384103.490584] PM: Syncing filesystems ... done.
[384103.502358] PM: Preparing system for mem sleep
[384106.081542] Freezing user space processes ... (elapsed 0.01 seconds) do=
ne.
[384106.095164] Freezing remaining freezable tasks ... (elapsed 0.01 second=
s) done.
[384106.108545] PM: Entering mem sleep
[384106.108565] Suspending console(s) (use no_console_suspend to debug)
[384106.117134] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[384106.118389] sd 0:0:0:0: [sda] Stopping disk
[384107.539642] PM: suspend of devices complete after 1433.101 msecs
[384107.539804] PM: late suspend of devices complete after 0.153 msecs
[384107.553155] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[384107.566386] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[384107.592893] PM: noirq suspend of devices complete after 53.168 msecs
[384107.593137] ACPI: Preparing to enter system sleep state S3
[384107.622848] PM: Saving platform NVS memory
[384107.623525] Disabling non-boot CPUs ...
[384107.725940] CPU 1 is now offline
[384107.829112] CPU 2 is now offline
[384107.830773] CPU 3 is now offline
[384107.831114] Extended CMOS year: 2000
[384107.832568] ACPI: Low-level resume complete
[384107.832609] PM: Restoring platform NVS memory
[384107.832925] Extended CMOS year: 2000
[384107.832966] Enabling non-boot CPUs ...
[384107.836422] Booting Node 0 Processor 1 APIC 0x2
[384107.851706] CPU1 is up
[384107.856011] Booting Node 0 Processor 2 APIC 0x1
[384107.875414] CPU2 is up
[384107.875961] Booting Node 0 Processor 3 APIC 0x3
[384107.891307] CPU3 is up
[384107.896251] ACPI: Waking up from system sleep state S3
[384108.400280] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[384108.400562] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[384108.401207] PM: noirq resume of devices complete after 1.143 msecs
[384108.401315] PM: early resume of devices complete after 0.085 msecs
[384108.401346] i915 0000:00:02.0: setting latency timer to 64
[384108.401403] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[384108.401452] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[384108.401464] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[384108.401478] usb usb3: root hub lost power or was reset
[384108.401504] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[384108.401534] usb usb4: root hub lost power or was reset
[384108.401537] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[384108.401558] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[384108.401564] ata_piix 0000:00:1f.2: setting latency timer to 64
[384108.402216] mei 0000:00:16.0: wd: failed to find the client
[384108.452160] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[384108.473836] bcm5974: bad trackpad package, length: 8
[384108.481802] bcm5974: bad trackpad package, length: 8
[384108.483847] bcm5974: bad trackpad package, length: 8
[384108.484815] bcm5974: bad trackpad package, length: 8
[384108.485810] bcm5974: bad trackpad package, length: 8
[384108.486795] bcm5974: bad trackpad package, length: 8
[384108.488766] bcm5974: bad trackpad package, length: 8
[384108.520720] bcm5974: bad trackpad package, length: 8
[384108.521708] bcm5974: bad trackpad package, length: 8
[384108.526660] Extended CMOS year: 2000
[384109.421791] ata2.00: failed to resume link (SControl 0)
[384109.741289] ata1.01: failed to resume link (SControl 0)
[384109.894450] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[384109.894462] ata1.01: SATA link down (SStatus 0 SControl 0)
[384109.901285] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filte=
red out
[384109.908047] ata1.00: configured for UDMA/133
[384109.942284] sd 0:0:0:0: [sda] Starting disk
[384110.443546] ata2.01: failed to resume link (SControl 0)
[384110.455032] ata2.00: SATA link down (SStatus 4 SControl 0)
[384110.455046] ata2.01: SATA link down (SStatus 0 SControl 0)
[384110.471688] ieee80211 phy0: brcms_ops_config: change power-save mode: f=
alse (implement)
[384110.472678] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[384110.472680] ieee80211 phy0: changing basic rates failed: -22
[384110.472681] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: thr=
eshold 0, hys 0  (implement)
[384110.472682] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[384110.472683] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[384110.472823] PM: resume of devices complete after 2074.742 msecs
[384110.479220] PM: Finishing wakeup.
[384110.479221] Restarting tasks ... done.
[384110.502872] video LNXVIDEO:00: Restoring backlight state
[384110.603189] ------------[ cut here ]------------
[384110.603217] WARNING: at drivers/net/wireless/brcm80211/brcmsmac/main.c:=
7968 brcms_c_wait_for_tx_completion+0x99/0xb0 [brcmsmac]()
[384110.603221] Hardware name: MacBookAir4,2
[384110.603224] Modules linked in: sha256_generic brcmsmac cordic brcmutil =
bcma mac80211 cfg80211 snd_seq snd_seq_device wacom fuse tun snd_hda_codec_=
hdmi snd_hda_codec_cirrus ext4 jbd2 mbcache btusb bluetooth joydev uvcvideo=
 videobuf2_vmalloc crc16 videobuf2_memops videobuf2_core videodev bcm5974 m=
edia arc4 i915 i2c_algo_bit drm_kms_helper rfkill iTCO_wdt drm iTCO_vendor_=
support snd_hda_intel snd_hda_codec lpc_ich acpi_cpufreq intel_agp applesmc=
 microcode coretemp evdev input_polldev pcspkr mfd_core i2c_i801 snd_hwdep =
mei i2c_core intel_gtt mperf video ac processor battery apple_bl button snd=
_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_timer snd soundcore kvm_i=
ntel kvm nfs nfs_acl lockd auth_rpcgss sunrpc fscache autofs4 jfs xts gf128=
mul dm_crypt dm_mod sd_mod pata_acpi ata_generic hid_generic usb_storage hi=
d_apple usbhid hid aesni_intel uhci_hcd aes_x86_64 aes_generic ghash_clmuln=
i_intel cryptd ata_piix crc32c_intel libata ehci_hcd usbcore scsi_mod usb_c=
ommon [last unloaded: cordic]
[384110.603302] Pid: 13794, comm: kworker/u:8 Tainted: G        W    3.5.4-=
1-ARCH #1
[384110.603303] Call Trace:
[384110.603308]  [<ffffffff81051a3f>] warn_slowpath_common+0x7f/0xc0
[384110.603310]  [<ffffffff81051a9a>] warn_slowpath_null+0x1a/0x20
[384110.603314]  [<ffffffffa0490d29>] brcms_c_wait_for_tx_completion+0x99/0=
xb0 [brcmsmac]
[384110.603317]  [<ffffffffa04831bb>] brcms_ops_flush+0x3b/0x60 [brcmsmac]
[384110.603324]  [<ffffffffa06c4f69>] ieee80211_mgd_probe_ap_send+0xc9/0x23=
0 [mac80211]
[384110.603329]  [<ffffffffa06c574f>] ieee80211_mgd_probe_ap.part.22+0x10f/=
0x130 [mac80211]
[384110.603333]  [<ffffffffa06c58fe>] ieee80211_sta_monitor_work+0x2e/0x30 =
[mac80211]
[384110.603336]  [<ffffffff8106effa>] process_one_work+0x12a/0x440
[384110.603340]  [<ffffffffa06c58d0>] ? ieee80211_beacon_connection_loss_wo=
rk+0x160/0x160 [mac80211]
[384110.603342]  [<ffffffff8106f85e>] worker_thread+0x12e/0x2d0
[384110.603345]  [<ffffffff8106f730>] ? manage_workers.isra.26+0x1f0/0x1f0
[384110.603347]  [<ffffffff81074f73>] kthread+0x93/0xa0
[384110.603350]  [<ffffffff81486864>] kernel_thread_helper+0x4/0x10
[384110.603352]  [<ffffffff81074ee0>] ? kthread_freezable_should_stop+0x70/=
0x70
[384110.603354]  [<ffffffff81486860>] ? gs_change+0x13/0x13
[384110.603355] ---[ end trace 52d31f5c575f7197 ]---
[384110.614581] systemd-journald[194]: Compressed data object 996 -> 672
[384110.743023] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[384110.743029] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 1 (implement)
[384110.743030] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[384110.753054] cfg80211: Calling CRDA for country: CH
[384112.755080] EXT4-fs (sda4): re-mounted. Opts: commit=3D600
[384113.638920] wlan0: authenticate with d4:a0:2a:98:a6:af
[384113.638936] wlan0: direct probe to d4:a0:2a:98:a6:af (try 1/3)
[384113.841525] wlan0: direct probe to d4:a0:2a:98:a6:af (try 2/3)
[384114.044474] wlan0: send auth to d4:a0:2a:98:a6:af (try 3/3)
[384114.046204] wlan0: authenticated
[384114.047837] wlan0: associate with d4:a0:2a:98:a6:af (try 1/3)
[384114.049552] wlan0: RX AssocResp from d4:a0:2a:98:a6:af (capab=3D0x11 st=
atus=3D0 aid=3D18)
[384114.050039] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[384114.050043] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[384114.050044] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[384114.050313] wlan0: associated
[384119.741532] EXT4-fs (sda4): re-mounted. Opts: commit=3D0
[384120.847460] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[385246.504053] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 44
[385246.541226] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 44
[386442.556417] ieee80211 phy0: START: tid 1 is not agg'able
[386981.357880] ieee80211 phy0: START: tid 2 is not agg'able
[387280.967322] ieee80211 phy0: START: tid 1 is not agg'able
[391742.989121] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 44
[391742.991497] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 44
[392114.674092] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 44
[393029.743976] ieee80211 phy0: START: tid 1 is not agg'able
[393412.922686] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 44
[393412.968992] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 44
[393530.602349] CPU1: Core temperature above threshold, cpu clock throttled=
 (total events =3D 40859)
[393530.602350] CPU3: Core temperature above threshold, cpu clock throttled=
 (total events =3D 40859)
[393530.602353] CPU3: Package temperature above threshold, cpu clock thrott=
led (total events =3D 50128)
[393530.602365] CPU1: Package temperature above threshold, cpu clock thrott=
led (total events =3D 50128)
[393530.602378] CPU2: Package temperature above threshold, cpu clock thrott=
led (total events =3D 50128)
[393530.602380] CPU0: Package temperature above threshold, cpu clock thrott=
led (total events =3D 50128)
[393530.603309] CPU1: Core temperature/speed normal
[393530.603309] CPU3: Core temperature/speed normal
[393530.603312] CPU2: Package temperature/speed normal
[393530.603314] CPU3: Package temperature/speed normal
[393530.603315] CPU0: Package temperature/speed normal
[393530.603318] CPU1: Package temperature/speed normal
[393629.841825] ieee80211 phy0: START: tid 1 is not agg'able
[395035.794493] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 44
[395035.794551] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 44
[395360.369739] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 44
[395360.378033] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 44
[395522.654959] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 44
[396124.728835] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 44
[396124.728892] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 44
[396658.696612] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 44
[396658.698911] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 44
[397145.526098] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 44
[397145.562644] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 44
[397517.190660] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 44
[397578.567153] ieee80211 phy0: START: tid 1 is not agg'able
[398700.301617] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 44
[398815.488396] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx s=
uppressed, illegal channel possibly 44
[398870.171347] EXT4-fs (sda4): re-mounted. Opts: commit=3D600
[398870.580391] EXT4-fs (sda4): re-mounted. Opts: commit=3D0
[398870.903376] PM: Syncing filesystems ... done.
[398870.904178] PM: Preparing system for mem sleep
[398873.420219] Freezing user space processes ... (elapsed 0.01 seconds) do=
ne.
[398873.431142] Freezing remaining freezable tasks ... (elapsed 0.01 second=
s) done.
[398873.444526] PM: Entering mem sleep
[398873.444545] Suspending console(s) (use no_console_suspend to debug)
[398873.453109] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[398873.454389] sd 0:0:0:0: [sda] Stopping disk
[398874.855673] PM: suspend of devices complete after 1413.126 msecs
[398874.855828] PM: late suspend of devices complete after 0.153 msecs
[398874.869174] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[398874.882412] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[398874.908918] PM: noirq suspend of devices complete after 53.164 msecs
[398874.909161] ACPI: Preparing to enter system sleep state S3
[398874.935540] PM: Saving platform NVS memory
[398874.935954] Disabling non-boot CPUs ...
[398875.038646] CPU 1 is now offline
[398875.145135] CPU 2 is now offline
[398875.248326] CPU 3 is now offline
[398875.248637] Extended CMOS year: 2000
[398875.250096] ACPI: Low-level resume complete
[398875.250137] PM: Restoring platform NVS memory
[398875.250452] Extended CMOS year: 2000
[398875.250493] Enabling non-boot CPUs ...
[398875.257325] Booting Node 0 Processor 1 APIC 0x2
[398875.272576] CPU1 is up
[398875.279970] Booting Node 0 Processor 2 APIC 0x1
[398875.294402] CPU2 is up
[398875.295061] Booting Node 0 Processor 3 APIC 0x3
[398875.310474] CPU3 is up
[398875.315441] ACPI: Waking up from system sleep state S3
[398875.816162] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[398875.816443] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[398875.817087] PM: noirq resume of devices complete after 1.140 msecs
[398875.817196] PM: early resume of devices complete after 0.086 msecs
[398875.817258] i915 0000:00:02.0: setting latency timer to 64
[398875.817306] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[398875.817389] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[398875.817403] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[398875.817418] usb usb3: root hub lost power or was reset
[398875.817450] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[398875.817468] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[398875.817474] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[398875.817480] usb usb4: root hub lost power or was reset
[398875.817508] ata_piix 0000:00:1f.2: setting latency timer to 64
[398875.818193] mei 0000:00:16.0: wd: failed to find the client
[398875.861289] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[398875.890744] bcm5974: bad trackpad package, length: 8
[398875.948121] Extended CMOS year: 2000
[398876.837677] ata2.00: failed to resume link (SControl 0)
[398877.157169] ata1.01: failed to resume link (SControl 0)
[398877.310312] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[398877.310323] ata1.01: SATA link down (SStatus 0 SControl 0)
[398877.317166] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filte=
red out
[398877.323922] ata1.00: configured for UDMA/133
[398877.358182] sd 0:0:0:0: [sda] Starting disk
[398877.859420] ata2.01: failed to resume link (SControl 0)
[398877.870910] ata2.00: SATA link down (SStatus 4 SControl 0)
[398877.870924] ata2.01: SATA link down (SStatus 0 SControl 0)
[398877.887294] ieee80211 phy0: brcms_ops_config: change power-save mode: f=
alse (implement)
[398877.888298] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[398877.888300] ieee80211 phy0: changing basic rates failed: -22
[398877.888302] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: thr=
eshold 0, hys 0  (implement)
[398877.888303] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[398877.888303] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[398877.888403] PM: resume of devices complete after 2074.435 msecs
[398877.894781] PM: Finishing wakeup.
[398877.894782] Restarting tasks ... done.
[398877.935910] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[398877.937078] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 1 (implement)
[398877.938276] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[398877.942229] video LNXVIDEO:00: Restoring backlight state
[398877.943677] cfg80211: Calling CRDA to update world regulatory domain
[398880.476295] EXT4-fs (sda4): re-mounted. Opts: commit=3D600
[398881.160307] wlan0: authenticate with 0c:b0:5d:9c:37:12
[398881.160336] ieee80211 phy0: changing basic rates failed: -52
[398881.160354] wlan0: direct probe to 0c:b0:5d:9c:37:12 (try 1/3)
[398881.360582] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 2/3)
[398881.363483] wlan0: authenticated
[398881.363907] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[398881.566873] wlan0: associate with 0c:b0:5d:9c:37:12 (try 2/3)
[398881.571797] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=3D0x411 s=
tatus=3D0 aid=3D1)
[398881.572326] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[398881.572337] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[398881.572341] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[398881.572356] wlan0: associated
[398884.676493] wlan0: deauthenticated from 0c:b0:5d:9c:37:12 (Reason: 2)
[398884.678823] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[398884.678843] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 0 (implement)
[398884.678849] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[398884.679470] cfg80211: Calling CRDA to update world regulatory domain
[398887.027446] wlan0: authenticate with c8:6c:87:a9:df:a9
[398887.027466] wlan0: send auth to c8:6c:87:a9:df:a9 (try 1/3)
[398887.031222] wlan0: authenticated
[398887.031770] wlan0: associate with c8:6c:87:a9:df:a9 (try 1/3)
[398887.234779] wlan0: associate with c8:6c:87:a9:df:a9 (try 2/3)
[398887.437717] wlan0: associate with c8:6c:87:a9:df:a9 (try 3/3)
[398887.640775] wlan0: association with c8:6c:87:a9:df:a9 timed out
[398899.857812] wlan0: authenticate with 0c:b0:5d:9c:37:12
[398899.857845] ieee80211 phy0: changing basic rates failed: -52
[398899.857864] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[398899.859768] wlan0: authenticated
[398899.861716] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[398899.866633] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=3D0x411 s=
tatus=3D0 aid=3D1)
[398899.867158] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[398899.867168] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[398899.867173] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[398899.867186] wlan0: associated
[398902.971671] wlan0: deauthenticated from 0c:b0:5d:9c:37:12 (Reason: 2)
[398902.973565] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[398902.973582] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 0 (implement)
[398902.973588] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[398902.974183] cfg80211: Calling CRDA for country: CH
[398904.907833] wlan0: authenticate with 0c:b0:5d:9c:37:12
[398904.917654] ieee80211 phy0: changing basic rates failed: -52
[398904.917680] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[398904.920758] wlan0: authenticated
[398904.923843] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[398904.927242] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=3D0x411 s=
tatus=3D0 aid=3D1)
[398904.927866] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[398904.927877] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[398904.927882] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[398904.927895] wlan0: associated
[398908.031388] wlan0: deauthenticated from 0c:b0:5d:9c:37:12 (Reason: 2)
[398908.032555] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[398908.032573] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 0 (implement)
[398908.032578] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[398908.033176] cfg80211: Calling CRDA to update world regulatory domain
[398910.381064] wlan0: authenticate with c8:6c:87:a9:df:a9
[398910.381079] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 1/3)
[398910.581608] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 2/3)
[398910.784669] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 3/3)
[398910.987661] wlan0: authentication with c8:6c:87:a9:df:a9 timed out
[398923.199378] wlan0: authenticate with c8:6c:87:a9:df:a9
[398923.209156] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 1/3)
[398923.411596] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 2/3)
[398923.614653] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 3/3)
[398923.817627] wlan0: authentication with c8:6c:87:a9:df:a9 timed out
[398936.041166] wlan0: authenticate with 0c:b0:5d:9c:37:12
[398936.041180] ieee80211 phy0: changing basic rates failed: -52
[398936.041188] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[398936.043123] wlan0: authenticated
[398936.045320] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[398936.050304] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=3D0x411 s=
tatus=3D0 aid=3D1)
[398936.050828] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[398936.050839] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[398936.050844] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[398936.051643] wlan0: associated
[398939.155256] wlan0: deauthenticated from 0c:b0:5d:9c:37:12 (Reason: 2)
[398939.157101] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[398939.157118] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 0 (implement)
[398939.157123] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[398939.157736] cfg80211: Calling CRDA for country: CH
[398941.094608] wlan0: authenticate with 0c:b0:5d:9c:37:12
[398941.104438] ieee80211 phy0: changing basic rates failed: -52
[398941.104469] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[398941.107554] wlan0: authenticated
[398941.110763] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[398941.114181] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=3D0x411 s=
tatus=3D0 aid=3D1)
[398941.114714] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[398941.114724] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[398941.114729] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[398941.115586] wlan0: associated
[398944.217708] wlan0: deauthenticated from 0c:b0:5d:9c:37:12 (Reason: 2)
[398944.219199] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[398944.219217] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 0 (implement)
[398944.219222] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[398944.219832] cfg80211: Calling CRDA to update world regulatory domain
[398946.567917] wlan0: authenticate with c8:6c:87:a9:df:a9
[398946.567966] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 1/3)
[398946.768530] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 2/3)
[398946.971544] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 3/3)
[398947.174562] wlan0: authentication with c8:6c:87:a9:df:a9 timed out
[398959.386257] wlan0: authenticate with c8:6c:87:a9:df:a9
[398959.396029] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 1/3)
[398959.598519] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 2/3)
[398959.801527] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 3/3)
[398960.004543] wlan0: authentication with c8:6c:87:a9:df:a9 timed out
[398965.503509] wlan0: authenticate with c8:6c:87:a9:df:a9
[398965.513110] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 1/3)
[398965.715637] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 2/3)
[398965.918653] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 3/3)
[398966.121669] wlan0: authentication with c8:6c:87:a9:df:a9 timed out
[398978.344950] wlan0: authenticate with 0c:b0:5d:9c:37:12
[398978.344964] ieee80211 phy0: changing basic rates failed: -52
[398978.344973] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[398978.346890] wlan0: authenticated
[398978.349300] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[398978.354189] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=3D0x411 s=
tatus=3D0 aid=3D1)
[398978.354858] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[398978.354869] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[398978.354874] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[398978.355686] wlan0: associated
[398981.457885] wlan0: deauthenticated from 0c:b0:5d:9c:37:12 (Reason: 2)
[398981.461155] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[398981.461175] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 0 (implement)
[398981.461181] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[398981.461780] cfg80211: Calling CRDA to update world regulatory domain
[398983.395659] wlan0: authenticate with 0c:b0:5d:9c:37:12
[398983.405234] ieee80211 phy0: changing basic rates failed: -52
[398983.405259] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[398983.410154] wlan0: authenticated
[398983.411420] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[398983.414854] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=3D0x411 s=
tatus=3D0 aid=3D1)
[398983.415540] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[398983.415551] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[398983.415556] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[398983.416372] wlan0: associated
[398986.518348] wlan0: deauthenticated from 0c:b0:5d:9c:37:12 (Reason: 2)
[398986.519312] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[398986.519329] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 0 (implement)
[398986.519336] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[398986.519983] cfg80211: Calling CRDA for country: CH
[398988.865329] wlan0: authenticate with c8:6c:87:a9:df:a9
[398988.865345] wlan0: send auth to c8:6c:87:a9:df:a9 (try 1/3)
[398988.866626] wlan0: authenticated
[398988.869518] wlan0: associate with c8:6c:87:a9:df:a9 (try 1/3)
[398988.887055] wlan0: RX AssocResp from c8:6c:87:a9:df:a9 (capab=3D0x431 s=
tatus=3D0 aid=3D2)
[398988.887873] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[398988.887880] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[398988.887883] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[398988.888437] wlan0: associated
[398996.360590] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[405452.541265] EXT4-fs (sda4): re-mounted. Opts: commit=3D0
[407910.033190] CPU3: Core temperature above threshold, cpu clock throttled=
 (total events =3D 44439)
[407910.033192] CPU1: Core temperature above threshold, cpu clock throttled=
 (total events =3D 44439)
[407910.033194] CPU0: Package temperature above threshold, cpu clock thrott=
led (total events =3D 56340)
[407910.033195] CPU2: Package temperature above threshold, cpu clock thrott=
led (total events =3D 56340)
[407910.033196] CPU1: Package temperature above threshold, cpu clock thrott=
led (total events =3D 56340)
[407910.033204] CPU3: Package temperature above threshold, cpu clock thrott=
led (total events =3D 56340)
[407910.034209] CPU2: Package temperature/speed normal
[407910.034211] CPU1: Core temperature/speed normal
[407910.034212] CPU3: Core temperature/speed normal
[407910.034213] CPU0: Package temperature/speed normal
[407910.034214] CPU1: Package temperature/speed normal
[407910.034216] CPU3: Package temperature/speed normal
[408209.588399] CPU3: Core temperature above threshold, cpu clock throttled=
 (total events =3D 46927)
[408209.588401] CPU1: Core temperature above threshold, cpu clock throttled=
 (total events =3D 46927)
[408209.588405] CPU2: Package temperature above threshold, cpu clock thrott=
led (total events =3D 59989)
[408209.588407] CPU0: Package temperature above threshold, cpu clock thrott=
led (total events =3D 59989)
[408209.588409] CPU1: Package temperature above threshold, cpu clock thrott=
led (total events =3D 59989)
[408209.588417] CPU3: Package temperature above threshold, cpu clock thrott=
led (total events =3D 59989)
[408209.590430] CPU2: Package temperature/speed normal
[408209.590432] CPU1: Core temperature/speed normal
[408209.590434] CPU3: Core temperature/speed normal
[408209.590435] CPU0: Package temperature/speed normal
[408209.590437] CPU1: Package temperature/speed normal
[408209.590441] CPU3: Package temperature/speed normal
[408820.668128] CPU1: Core temperature above threshold, cpu clock throttled=
 (total events =3D 47474)
[408820.668131] CPU3: Core temperature above threshold, cpu clock throttled=
 (total events =3D 47474)
[408820.668134] CPU2: Package temperature above threshold, cpu clock thrott=
led (total events =3D 60846)
[408820.668136] CPU0: Package temperature above threshold, cpu clock thrott=
led (total events =3D 60846)
[408820.668138] CPU3: Package temperature above threshold, cpu clock thrott=
led (total events =3D 60846)
[408820.668146] CPU1: Package temperature above threshold, cpu clock thrott=
led (total events =3D 60846)
[408820.669102] CPU3: Core temperature/speed normal
[408820.669103] CPU1: Core temperature/speed normal
[408820.669105] CPU2: Package temperature/speed normal
[408820.669107] CPU1: Package temperature/speed normal
[408820.669108] CPU0: Package temperature/speed normal
[408820.669114] CPU3: Package temperature/speed normal
[409796.254348] CPU3: Core temperature above threshold, cpu clock throttled=
 (total events =3D 49176)
[409796.254352] CPU2: Package temperature above threshold, cpu clock thrott=
led (total events =3D 62908)
[409796.254353] CPU0: Package temperature above threshold, cpu clock thrott=
led (total events =3D 62908)
[409796.254355] CPU1: Core temperature above threshold, cpu clock throttled=
 (total events =3D 49176)
[409796.254359] CPU1: Package temperature above threshold, cpu clock thrott=
led (total events =3D 62908)
[409796.254365] CPU3: Package temperature above threshold, cpu clock thrott=
led (total events =3D 62908)
[409796.255362] CPU3: Core temperature/speed normal
[409796.255363] CPU1: Core temperature/speed normal
[409796.255364] CPU0: Package temperature/speed normal
[409796.255366] CPU2: Package temperature/speed normal
[409796.255366] CPU1: Package temperature/speed normal
[409796.255372] CPU3: Package temperature/speed normal
[410095.917401] CPU3: Core temperature above threshold, cpu clock throttled=
 (total events =3D 51854)
[410095.917403] CPU1: Core temperature above threshold, cpu clock throttled=
 (total events =3D 51854)
[410095.917407] CPU2: Package temperature above threshold, cpu clock thrott=
led (total events =3D 66019)
[410095.917409] CPU0: Package temperature above threshold, cpu clock thrott=
led (total events =3D 66019)
[410095.917410] CPU1: Package temperature above threshold, cpu clock thrott=
led (total events =3D 66019)
[410095.917419] CPU3: Package temperature above threshold, cpu clock thrott=
led (total events =3D 66019)
[410095.918420] CPU1: Core temperature/speed normal
[410095.918422] CPU3: Core temperature/speed normal
[410095.918424] CPU2: Package temperature/speed normal
[410095.918426] CPU0: Package temperature/speed normal
[410095.918427] CPU3: Package temperature/speed normal
[410095.918434] CPU1: Package temperature/speed normal
[410096.081153] CPU2: Core temperature above threshold, cpu clock throttled=
 (total events =3D 18247)
[410096.081155] CPU0: Core temperature above threshold, cpu clock throttled=
 (total events =3D 18247)
[410096.083161] CPU2: Core temperature/speed normal
[410096.083163] CPU0: Core temperature/speed normal
[410698.615094] wlan0: deauthenticating from c8:6c:87:a9:df:a9 by local cho=
ice (reason=3D3)
[410698.620827] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[410698.620848] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 1 (implement)
[410698.620853] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[410698.621593] cfg80211: Calling CRDA to update world regulatory domain
[410698.623034] wlan0: authenticate with c8:6c:87:a9:df:a9
[410698.623088] wlan0: send auth to c8:6c:87:a9:df:a9 (try 1/3)
[410698.624249] wlan0: authenticated
[410698.627279] wlan0: associate with c8:6c:87:a9:df:a9 (try 1/3)
[410698.628777] wlan0: RX AssocResp from c8:6c:87:a9:df:a9 (capab=3D0x431 s=
tatus=3D0 aid=3D2)
[410698.629679] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[410698.629689] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[410698.629694] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[410698.630492] wlan0: associated
[410707.073704] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[410707.716682] wlan0: deauthenticating from c8:6c:87:a9:df:a9 by local cho=
ice (reason=3D3)
[410707.723382] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[410707.723401] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 1 (implement)
[410707.723406] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[410707.724157] cfg80211: Calling CRDA to update world regulatory domain
[410709.664338] wlan0: authenticate with c8:6c:87:a9:df:a9
[410709.673916] wlan0: send auth to c8:6c:87:a9:df:a9 (try 1/3)
[410709.675168] wlan0: authenticated
[410709.676743] wlan0: associate with c8:6c:87:a9:df:a9 (try 1/3)
[410709.678300] wlan0: RX AssocResp from c8:6c:87:a9:df:a9 (capab=3D0x431 s=
tatus=3D0 aid=3D2)
[410709.679190] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[410709.679199] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[410709.679204] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[410709.680047] wlan0: associated
[410718.096285] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[410727.714510] wlan0: deauthenticating from c8:6c:87:a9:df:a9 by local cho=
ice (reason=3D3)
[410727.718834] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[410727.718852] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 1 (implement)
[410727.718857] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[410727.719598] cfg80211: Calling CRDA for country: CH
[410730.067328] wlan0: authenticate with 0c:b0:5d:9c:37:12
[410730.067346] ieee80211 phy0: changing basic rates failed: -52
[410730.067352] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[410730.069274] wlan0: authenticated
[410730.071618] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[410730.074935] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=3D0x411 s=
tatus=3D0 aid=3D2)
[410730.075552] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[410730.075555] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[410730.075557] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[410730.075832] wlan0: associated
[410739.003273] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[410747.628437] wlan0: deauthenticating from 0c:b0:5d:9c:37:12 by local cho=
ice (reason=3D3)
[410747.634237] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disas=
sociated
[410747.634253] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled false, count 1 (implement)
[410747.634259] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fa=
lse (implement)
[410747.635032] wlan0: authenticate with 0c:b0:5d:9c:37:12
[410747.635053] ieee80211 phy0: changing basic rates failed: -52
[410747.635065] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[410747.636932] wlan0: authenticated
[410747.638444] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[410747.641753] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=3D0x411 s=
tatus=3D0 aid=3D2)
[410747.642348] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: assoc=
iated
[410747.642357] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 0 (implement)
[410747.642362] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tr=
ue (implement)
[410747.643136] wlan0: associated
[410752.369575] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: =
enabled true, count 1 (implement)
[410800.012561] usb 2-1.2: new high-speed USB device number 7 using ehci_hcd
[410800.111613] usb-storage 2-1.2:1.0: Quirks match for vid 1058 pid 0704: =
8000
[410800.111635] scsi4 : usb-storage 2-1.2:1.0
[410801.112088] scsi 4:0:0:0: Direct-Access     WD       5000BMV External 1=
=2E75 PQ: 0 ANSI: 4
[410801.113471] sd 4:0:0:0: [sdc] 976773168 512-byte logical blocks: (500 G=
B/465 GiB)
[410801.114198] sd 4:0:0:0: [sdc] Write Protect is off
[410801.114213] sd 4:0:0:0: [sdc] Mode Sense: 23 00 00 00
[410801.114848] sd 4:0:0:0: [sdc] No Caching mode page present
[410801.114860] sd 4:0:0:0: [sdc] Assuming drive cache: write through
[410801.117091] sd 4:0:0:0: [sdc] No Caching mode page present
[410801.117102] sd 4:0:0:0: [sdc] Assuming drive cache: write through
[410801.144839]  sdc: unknown partition table
[410801.147082] sd 4:0:0:0: [sdc] No Caching mode page present
[410801.147092] sd 4:0:0:0: [sdc] Assuming drive cache: write through
[410801.147098] sd 4:0:0:0: [sdc] Attached SCSI disk
[411966.676397] offlineimap invoked oom-killer: gfp_mask=3D0xd0, order=3D1,=
 oom_adj=3D0, oom_score_adj=3D0
[411966.676400] offlineimap cpuset=3D/ mems_allowed=3D0
[411966.676403] Pid: 12057, comm: offlineimap Tainted: G        W    3.5.4-=
1-ARCH #1
[411966.676404] Call Trace:
[411966.676411]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d=
/0xb0
[411966.676415]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[411966.676420]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[411966.676425]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[411966.676430]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[411966.676433]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[411966.676437]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[411966.676442]  [<ffffffff81140ea9>] ? handle_mm_fault+0x259/0x320
[411966.676447]  [<ffffffff8104f72b>] copy_process.part.21+0xeb/0x1530
[411966.676451]  [<ffffffff81050cf5>] do_fork+0x135/0x3a0
[411966.676455]  [<ffffffff810adc92>] ? sys_futex+0x102/0x190
[411966.676459]  [<ffffffff8101dd18>] sys_clone+0x28/0x30
[411966.676462]  [<ffffffff814856f3>] stub_clone+0x13/0x20
[411966.676466]  [<ffffffff814853ed>] ? system_call_fastpath+0x1a/0x1f
[411966.676468] Mem-Info:
[411966.676470] Node 0 DMA per-cpu:
[411966.676472] CPU    0: hi:    0, btch:   1 usd:   0
[411966.676474] CPU    1: hi:    0, btch:   1 usd:   0
[411966.676476] CPU    2: hi:    0, btch:   1 usd:   0
[411966.676478] CPU    3: hi:    0, btch:   1 usd:   0
[411966.676479] Node 0 DMA32 per-cpu:
[411966.676482] CPU    0: hi:  186, btch:  31 usd:   1
[411966.676484] CPU    1: hi:  186, btch:  31 usd:   0
[411966.676485] CPU    2: hi:  186, btch:  31 usd:  53
[411966.676487] CPU    3: hi:  186, btch:  31 usd:   4
[411966.676488] Node 0 Normal per-cpu:
[411966.676490] CPU    0: hi:  186, btch:  31 usd:   0
[411966.676492] CPU    1: hi:  186, btch:  31 usd:   0
[411966.676493] CPU    2: hi:  186, btch:  31 usd:   0
[411966.676495] CPU    3: hi:  186, btch:  31 usd:   0
[411966.676499] active_anon:446020 inactive_anon:95043 isolated_anon:0
 active_file:300 inactive_file:226 isolated_file:20
 unevictable:3637 dirty:4 writeback:76 unstable:0
 free:24285 slab_reclaimable:383071 slab_unreclaimable:7603
 mapped:2008 shmem:125620 pagetables:8721 bounce:0
[411966.676501] Node 0 DMA free:15856kB min:260kB low:324kB high:388kB acti=
ve_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable=
:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirt=
y:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:32kB slab_unrecla=
imable:8kB kernel_stack:8kB pagetables:0kB unstable:0kB bounce:0kB writebac=
k_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[411966.676505] lowmem_reserve[]: 0 2137 3899 3899
[411966.676508] Node 0 DMA32 free:50872kB min:36900kB low:46124kB high:5534=
8kB active_anon:741152kB inactive_anon:99144kB active_file:1144kB inactive_=
file:848kB unevictable:4124kB isolated(anon):0kB isolated(file):80kB presen=
t:2188752kB mlocked:36kB dirty:12kB writeback:284kB mapped:876kB shmem:1246=
80kB slab_reclaimable:1270884kB slab_unreclaimable:6780kB kernel_stack:688k=
B pagetables:2176kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned=
:5233 all_unreclaimable? yes
[411966.676512] lowmem_reserve[]: 0 0 1762 1762
[411966.676515] Node 0 Normal free:30412kB min:30416kB low:38020kB high:456=
24kB active_anon:1042928kB inactive_anon:281028kB active_file:56kB inactive=
_file:56kB unevictable:10424kB isolated(anon):0kB isolated(file):0kB presen=
t:1804320kB mlocked:10424kB dirty:4kB writeback:20kB mapped:7156kB shmem:37=
7800kB slab_reclaimable:261368kB slab_unreclaimable:23624kB kernel_stack:30=
08kB pagetables:32708kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_sca=
nned:5750 all_unreclaimable? yes
[411966.676519] lowmem_reserve[]: 0 0 0 0
[411966.676521] Node 0 DMA: 2*4kB 2*8kB 0*16kB 3*32kB 2*64kB 2*128kB 2*256k=
B 1*512kB 2*1024kB 2*2048kB 2*4096kB =3D 15864kB
[411966.676527] Node 0 DMA32: 11842*4kB 371*8kB 32*16kB 0*32kB 0*64kB 0*128=
kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =3D 50848kB
[411966.676533] Node 0 Normal: 3313*4kB 1123*8kB 389*16kB 0*32kB 1*64kB 0*1=
28kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB =3D 30572kB
[411966.676539] 127046 total pagecache pages
[411966.676540] 0 pages in swap cache
[411966.676541] Swap cache stats: add 0, delete 0, find 0/0
[411966.676542] Free swap  =3D 0kB
[411966.676543] Total swap =3D 0kB
[411966.685758] 1048048 pages RAM
[411966.685761] 57533 pages reserved
[411966.685762] 97430 pages shared
[411966.685763] 935117 pages non-shared
[411966.685765] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score=
_adj name
[411966.685773] [  191]     0   191     6555      410   3     -17         -=
1000 systemd-udevd
[411966.685776] [  194]     0   194    74642     6846   3       0          =
   0 systemd-journal
[411966.685780] [  301]     0   301     3302      311   2       0          =
   0 crond
[411966.685782] [  302]     0   302    17693      684   2       0          =
   0 cupsd
[411966.685785] [  304]     0   304    10502      326   1     -17         -=
1000 sshd
[411966.685787] [  305]    81   305     4433      322   0     -13          =
-900 dbus-daemon
[411966.685790] [  309]     0   309     6512      239   1       0          =
   0 systemd-logind
[411966.685793] [  315]     0   315    15747      318   2       0          =
   0 login
[411966.685796] [  316]     0   316     2031      193   0       0          =
   0 agetty
[411966.685798] [  317]     0   317     2031      189   0       0          =
   0 agetty
[411966.685800] [  319]     0   319     2031      191   1       0          =
   0 agetty
[411966.685803] [  320]     0   320     2031      192   1       0          =
   0 agetty
[411966.685805] [  321]     0   321     2031      191   1       0          =
   0 agetty
[411966.685808] [  325]     0   325    51901      562   3       0          =
   0 colord
[411966.685811] [  341]     0   341   123526     1044   1       0          =
   0 colord-sane
[411966.685813] [  395]     0   395     3092      205   2       0          =
   0 master
[411966.685816] [  399]    73   399    16380      410   1       0          =
   0 qmgr
[411966.685819] [  420]  1000   420     3423      283   2       0          =
   0 restart-x
[411966.685822] [  431]  1000   431     3423      298   3       0          =
   0 startx
[411966.685825] [  448]  1000   448     3966      147   3       0          =
   0 xinit
[411966.685827] [  449]  1000   449    92096     4518   1       0          =
   0 X
[411966.685830] [  470]  1000   470    24058      796   1       0          =
   0 i3
[411966.685832] [  477]  1000   477     6062      210   2       0          =
   0 unclutter
[411966.685835] [  480]  1000   480     6004      116   2       0          =
   0 dispad
[411966.685838] [  481]  1000   481    36623    12497   3       0          =
   0 urxvtd
[411966.685841] [  484]  1000   484     8068      476   1       0          =
   0 xbindkeys
[411966.685843] [  495]  1000   495     8155      656   2       0          =
   0 zsh
[411966.685845] [  505]  1000   505     8155      661   3       0          =
   0 zsh
[411966.685847] [  512]     0   512     8481      277   3       0          =
   0 sudo
[411966.685850] [  513]     0   513     6933      483   0       0          =
   0 zsh
[411966.685852] [  543]     0   543     7404      239   3       0          =
   0 wpa_supplicant
[411966.685855] [  659]  1000   659     9860     1868   2       0          =
   0 zsh
[411966.685857] [  772]  1000   772     4494       95   3       0          =
   0 dbus-launch
[411966.685859] [  773]  1000   773     4379      252   3       0          =
   0 dbus-daemon
[411966.685861] [ 1575]  1000  1575    10065     2058   1       0          =
   0 zsh
[411966.685863] [ 1959]  1000  1959     8748      756   1       0          =
   0 zsh
[411966.685865] [ 2835]  1000  2835    40320      829   3       0          =
   0 kdeinit4
[411966.685868] [ 2837]  1000  2837    48444      818   1       0          =
   0 klauncher
[411966.685871] [ 2841]  1000  2841   109726     1965   1       0          =
   0 kded4
[411966.685873] [ 2858]  1000  2858   238338     2687   2       0          =
   0 knotify4
[411966.685875] [ 2863]     0  2863    54958     1172   2       0          =
   0 upowerd
[411966.685878] [ 2868]     0  2868    46649      317   1     -13          =
-900 polkitd
[411966.685880] [ 2895]     0  2895    48362      445   1       0          =
   0 udisks-daemon
[411966.685882] [ 2904]     0  2904    11353      123   1       0          =
   0 udisks-daemon
[411966.685885] [ 6623]  1000  6623     8891      901   2       0          =
   0 zsh
[411966.685888] [ 8723]  1000  8723     8785      784   3       0          =
   0 zsh
[411966.685891] [14485]  1000 14485     8773      772   1       0          =
   0 zsh
[411966.685893] [30479]     0 30479     8481      278   1       0          =
   0 sudo
[411966.685895] [30480]     0 30480     6933      490   1       0          =
   0 zsh
[411966.685898] [ 1816]  1000  1816     8773      758   2       0          =
   0 zsh
[411966.685900] [ 2064]  1000  2064     9797     1778   3       0          =
   0 zsh
[411966.685903] [ 3202]  1000  3202     9839     1855   1       0          =
   0 zsh
[411966.685905] [13775]  1000 13775     8155      679   1       0          =
   0 zsh
[411966.685908] [13783]     0 13783     8481      279   2       0          =
   0 sudo
[411966.685910] [13784]     0 13784     6933      485   2       0          =
   0 zsh
[411966.685913] [14763]  1000 14763     8914      907   1       0          =
   0 zsh
[411966.685915] [29947]  1000 29947     5163      271   0       0          =
   0 zsh
[411966.685917] [29950]  1000 29950   164246    42567   0       0          =
   0 chromium
[411966.685920] [29952]  1000 29952    64978     1253   0       0          =
   0 chromium
[411966.685923] [29953]  1000 29953     1588      137   0       0          =
   0 chromium-sandbo
[411966.685925] [29954]  1000 29954    70030     1322   0       0          =
   0 chromium
[411966.685926] [29960]  1000 29960    34745      443   0       0          =
   0 nacl_helper_boo
[411966.685928] [29961]  1000 29961    76177     1211   0       0          =
   0 chromium
[411966.685930] [29990]  1000 29990   218552     5185   1       4          =
 300 chromium
[411966.685932] [29997]  1000 29997   227279    17931   2       4          =
 300 chromium
[411966.685933] [30004]  1000 30004   218991     5295   3       4          =
 300 chromium
[411966.685935] [20018]     0 20018     2136      155   1       0          =
   0 dhcpcd
[411966.685938] [20887]  1000 20887     9334     1324   2       0          =
   0 zsh
[411966.685941] [23649]  1000 23649    63938      841   1       0          =
   0 dconf-service
[411966.685944] [25961]  1000 25961    14690      782   1       0          =
   0 mutt
[411966.685947] [13576]     0 13576     4494       95   0       0          =
   0 dbus-launch
[411966.685949] [13577]     0 13577     4320      177   2       0          =
   0 dbus-daemon
[411966.685952] [15475]  1000 15475     9224     1221   1       0          =
   0 zsh
[411966.685955] [16635]  1000 16635     8845      865   0       0          =
   0 zsh
[411966.685957] [16929]  1000 16929     8716      706   0       0          =
   0 zsh
[411966.685960] [16982]  1000 16982    15494     1079   0       0          =
   0 mutt
[411966.685963] [17215]  1000 17215    10328     2341   1       0          =
   0 zsh
[411966.685966] [18001]  1000 18001     8769      774   2       0          =
   0 zsh
[411966.685968] [19150]  1000 19150    10512     2525   3       0          =
   0 zsh
[411966.685971] [19271]  1000 19271     8892      907   0       0          =
   0 zsh
[411966.685973] [21316]  1000 21316     8812      816   2       0          =
   0 zsh
[411966.685976] [21373]  1000 21373     8155      661   3       0          =
   0 zsh
[411966.685979] [21389]  1000 21389     8785      789   1       0          =
   0 zsh
[411966.685982] [21617]  1000 21617     8769      776   1       0          =
   0 zsh
[411966.685984] [22183]  1000 22183    14901     1011   2       0          =
   0 mutt
[411966.685986] [23190]  1000 23190     8291      691   0       0          =
   0 vim
[411966.685988] [23191]  1000 23191     8291      607   2       0          =
   0 vim
[411966.685989] [23198]  1000 23198    10210     2220   3       0          =
   0 zsh
[411966.685991] [23246]  1000 23246     8743      744   0       0          =
   0 zsh
[411966.685993] [23266]  1000 23266     8730     1471   1       0          =
   0 python3
[411966.685995] [23269]  1000 23269     8290      592   0       0          =
   0 vim
[411966.685996] [32120]  1000 32120    16392     1965   1       0          =
   0 mutt
[411966.685998] [ 5745]  1000  5745     9866     1861   2       0          =
   0 zsh
[411966.686000] [ 5944]  1000  5944     9776     1769   3       0          =
   0 zsh
[411966.686002] [ 8651]  1000  8651    10239     2247   2       0          =
   0 zsh
[411966.686003] [10927]  1000 10927     8891      906   3       0          =
   0 zsh
[411966.686005] [13485]  1000 13485     8773      770   2       0          =
   0 zsh
[411966.686007] [13492]  1000 13492    14788      883   3       0          =
   0 mutt
[411966.686009] [13504]  1000 13504    19180      525   3       0          =
   0 i3bar
[411966.686010] [13505]  1000 13505     8066      597   1       0          =
   0 i3status
[411966.686012] [13897]  1000 13897    10964     2962   1       0          =
   0 zsh
[411966.686014] [18368]  1000 18368    15875     1450   2       0          =
   0 mutt
[411966.686015] [25693]  1000 25693     8806      807   3       0          =
   0 zsh
[411966.686017] [12076]  1000 12076     9025     1040   3       0          =
   0 zsh
[411966.686019] [13526]  1000 13526     9782     1792   3       0          =
   0 zsh
[411966.686020] [20336]  1000 20336    10171     2195   2       0          =
   0 zsh
[411966.686023] [20496]  1000 20496     8805      817   0       0          =
   0 zsh
[411966.686024] [22068]  1000 22068     8830      840   0       0          =
   0 zsh
[411966.686026] [32613]  1000 32613    14756      830   3       0          =
   0 mutt
[411966.686028] [25473]  1000 25473     8337      663   1       0          =
   0 vim
[411966.686030] [25480]  1000 25480     9031     1040   3       0          =
   0 zsh
[411966.686031] [26043]  1000 26043     2650      200   2       0          =
   0 ping
[411966.686033] [29752]  1000 29752     8205      918   1       0          =
   0 mosh-client
[411966.686035] [30789]  1000 30789     8765      779   2       0          =
   0 zsh
[411966.686036] [31242]  1000 31242    10062     2086   3       0          =
   0 zsh
[411966.686038] [ 3498]     0  3498     4755     2630   1       0          =
   0 atop
[411966.686041] [ 5927]  1000  5927   347693    42492   1       4          =
 300 chromium
[411966.686042] [ 5991]  1000  5991   226988    10559   1       4          =
 300 chromium
[411966.686044] [ 6011]  1000  6011   222892     6669   1       4          =
 300 chromium
[411966.686046] [ 6103]  1000  6103   242157    23699   1       4          =
 300 chromium
[411966.686047] [ 7830]  1000  7830   225890     9573   3       4          =
 300 chromium
[411966.686049] [ 7915]  1000  7915     8773      775   2       0          =
   0 zsh
[411966.686051] [12787]  1000 12787     9835     1837   3       0          =
   0 zsh
[411966.686052] [19881]  1000 19881     8794      807   2       0          =
   0 zsh
[411966.686054] [26144]  1000 26144   225043     9710   3       4          =
 300 chromium
[411966.686056] [30808]  1000 30808     8155      679   2       0          =
   0 zsh
[411966.686058] [ 2155]  1000  2155     8155      680   2       0          =
   0 zsh
[411966.686059] [ 2681]  1000  2681     4459      503   0       0          =
   0 man
[411966.686061] [ 2692]  1000  2692     2781      255   3       0          =
   0 less
[411966.686063] [ 3315]  1000  3315     4406     1851   3       0          =
   0 atop
[411966.686065] [ 3641]  1000  3641     8285      658   3       0          =
   0 vim
[411966.686066] [ 4252]  1000  4252     8835      831   2       0          =
   0 zsh
[411966.686068] [ 4452]  1000  4452   227004     9314   3       4          =
 300 chromium
[411966.686070] [ 4824]  1000  4824     8176      704   2       0          =
   0 zsh
[411966.686072] [ 6094]  1000  6094     9005      333   0       0          =
   0 ssh
[411966.686074] [ 6096]  1000  6096     8970      209   3       0          =
   0 ssh
[411966.686075] [ 6098]  1000  6098     8970      309   2       0          =
   0 ssh
[411966.686077] [ 8760]  1000  8760   222833     6855   3       4          =
 300 chromium
[411966.686079] [ 8769]  1000  8769     3424      269   0       0          =
   0 nz.sh
[411966.686080] [ 8771]  1000  8771     8347      731   3       0          =
   0 vim
[411966.686082] [ 8888]  1000  8888    44968      294   3       0          =
   0 evinced
[411966.686084] [ 8896]  1000  8896   129425    14841   1       0          =
   0 evince
[411966.686086] [ 9016]  1000  9016   140685    11780   0       0          =
   0 evince
[411966.686087] [ 9084]  1000  9084   247497    29178   3       4          =
 300 chromium
[411966.686089] [ 9146]  1000  9146     8286      637   2       0          =
   0 vim
[411966.686091] [ 9150]  1000  9150     8769      771   0       0          =
   0 zsh
[411966.686092] [ 9158]  1000  9158     8286      608   1       0          =
   0 vim
[411966.686094] [ 9178]  1000  9178   228820    12491   1       4          =
 300 chromium
[411966.686096] [ 9234]  1000  9234   224790     8669   1       4          =
 300 chromium
[411966.686097] [ 9255]  1000  9255   227614    11580   2       4          =
 300 chromium
[411966.686099] [ 9263]  1000  9263   227627    15325   3       4          =
 300 chromium
[411966.686101] [10008]  1000 10008     8769      784   1       0          =
   0 zsh
[411966.686103] [11133]     0 11133     8481      281   0       0          =
   0 sudo
[411966.686105] [11137]     0 11137     3457      299   1       0          =
   0 ccollect
[411966.686107] [11142]     0 11142     3457      206   0       0          =
   0 ccollect
[411966.686109] [11143]     0 11143     3457      148   0       0          =
   0 ccollect
[411966.686111] [11144]     0 11144     2919      224   3       0          =
   0 awk
[411966.686113] [11196]     0 11196     2107      749   3       0          =
   0 rm
[411966.686115] [11239]    73 11239    16333      355   1       0          =
   0 pickup
[411966.686117] [11506]  1000 11506   223148     8149   1       4          =
 300 chromium
[411966.686119] [11517]  1000 11517     8748      765   0       0          =
   0 zsh
[411966.686120] [11525]  1000 11525   226740     9601   3       4          =
 300 chromium
[411966.686122] [11576]  1000 11576     8288      602   2       0          =
   0 vim
[411966.686124] [11588]  1000 11588   230261    13777   3       4          =
 300 chromium
[411966.686126] [11639]     0 11639     5899      275   3       0          =
   0 vpnc
[411966.686128] [11794]  1000 11794   227790    11355   3       4          =
 300 chromium
[411966.686129] [11805]  1000 11805   225046     7738   2       4          =
 300 chromium
[411966.686132] [12050]     0 12050     9169      395   2       0          =
   0 crond
[411966.686133] [12053]  1000 12053     2937      211   3       0          =
   0 sh
[411966.686135] [12055]  1000 12055   153597     2441   3       0          =
   0 offlineimap
[411966.686137] Out of memory: Kill process 5927 (chromium) score 343 or sa=
crifice child
[411966.686144] Killed process 5927 (chromium) total-vm:1390772kB, anon-rss=
:168816kB, file-rss:1152kB
[411966.689061] offlineimap invoked oom-killer: gfp_mask=3D0xd0, order=3D1,=
 oom_adj=3D0, oom_score_adj=3D0
[411966.689064] offlineimap cpuset=3D/ mems_allowed=3D0
[411966.689067] Pid: 12057, comm: offlineimap Tainted: G        W    3.5.4-=
1-ARCH #1
[411966.689068] Call Trace:
[411966.689073]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d=
/0xb0
[411966.689077]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[411966.689081]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[411966.689086]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[411966.689090]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[411966.689092]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[411966.689095]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[411966.689099]  [<ffffffff81140ea9>] ? handle_mm_fault+0x259/0x320
[411966.689102]  [<ffffffff8104f72b>] copy_process.part.21+0xeb/0x1530
[411966.689104]  [<ffffffff81050cf5>] do_fork+0x135/0x3a0
[411966.689107]  [<ffffffff810adc92>] ? sys_futex+0x102/0x190
[411966.689110]  [<ffffffff8101dd18>] sys_clone+0x28/0x30
[411966.689112]  [<ffffffff814856f3>] stub_clone+0x13/0x20
[411966.689115]  [<ffffffff814853ed>] ? system_call_fastpath+0x1a/0x1f
[411966.689117] Mem-Info:
[411966.689118] Node 0 DMA per-cpu:
[411966.689120] CPU    0: hi:    0, btch:   1 usd:   0
[411966.689121] CPU    1: hi:    0, btch:   1 usd:   0
[411966.689122] CPU    2: hi:    0, btch:   1 usd:   0
[411966.689124] CPU    3: hi:    0, btch:   1 usd:   0
[411966.689124] Node 0 DMA32 per-cpu:
[411966.689126] CPU    0: hi:  186, btch:  31 usd:  29
[411966.689127] CPU    1: hi:  186, btch:  31 usd:  65
[411966.689129] CPU    2: hi:  186, btch:  31 usd:  99
[411966.689130] CPU    3: hi:  186, btch:  31 usd:  89
[411966.689131] Node 0 Normal per-cpu:
[411966.689132] CPU    0: hi:  186, btch:  31 usd:   0
[411966.689133] CPU    1: hi:  186, btch:  31 usd:   0
[411966.689134] CPU    2: hi:  186, btch:  31 usd:   5
[411966.689135] CPU    3: hi:  186, btch:  31 usd:   0
[411966.689139] active_anon:446020 inactive_anon:95043 isolated_anon:0
 active_file:251 inactive_file:210 isolated_file:20
 unevictable:3637 dirty:4 writeback:21 unstable:0
 free:24223 slab_reclaimable:383071 slab_unreclaimable:7603
 mapped:2008 shmem:125620 pagetables:8721 bounce:0
[411966.689141] Node 0 DMA free:15856kB min:260kB low:324kB high:388kB acti=
ve_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable=
:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirt=
y:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:32kB slab_unrecla=
imable:8kB kernel_stack:8kB pagetables:0kB unstable:0kB bounce:0kB writebac=
k_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[411966.689145] lowmem_reserve[]: 0 2137 3899 3899
[411966.689147] Node 0 DMA32 free:50624kB min:36900kB low:46124kB high:5534=
8kB active_anon:741152kB inactive_anon:99144kB active_file:948kB inactive_f=
ile:784kB unevictable:4124kB isolated(anon):0kB isolated(file):80kB present=
:2188752kB mlocked:36kB dirty:12kB writeback:64kB mapped:876kB shmem:124680=
kB slab_reclaimable:1270884kB slab_unreclaimable:6780kB kernel_stack:688kB =
pagetables:2176kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:6=
481 all_unreclaimable? yes
[411966.689152] lowmem_reserve[]: 0 0 1762 1762
[411966.689154] Node 0 Normal free:30412kB min:30416kB low:38020kB high:456=
24kB active_anon:1042928kB inactive_anon:281028kB active_file:56kB inactive=
_file:56kB unevictable:10424kB isolated(anon):0kB isolated(file):0kB presen=
t:1804320kB mlocked:10424kB dirty:4kB writeback:20kB mapped:7156kB shmem:37=
7800kB slab_reclaimable:261368kB slab_unreclaimable:23624kB kernel_stack:30=
08kB pagetables:32708kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_sca=
nned:7156 all_unreclaimable? yes
[411966.689158] lowmem_reserve[]: 0 0 0 0
[411966.689160] Node 0 DMA: 2*4kB 2*8kB 0*16kB 3*32kB 2*64kB 2*128kB 2*256k=
B 1*512kB 2*1024kB 2*2048kB 2*4096kB =3D 15864kB
[411966.689167] Node 0 DMA32: 11811*4kB 371*8kB 1*16kB 0*32kB 0*64kB 0*128k=
B 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =3D 50228kB
[411966.689172] Node 0 Normal: 3282*4kB 1123*8kB 389*16kB 0*32kB 1*64kB 0*1=
28kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB =3D 30448kB
[411966.689178] 126991 total pagecache pages
[411966.689179] 0 pages in swap cache
[411966.689181] Swap cache stats: add 0, delete 0, find 0/0
[411966.689181] Free swap  =3D 0kB
[411966.689182] Total swap =3D 0kB
[411966.701035] 1048048 pages RAM
[411966.701037] 57533 pages reserved
[411966.701038] 93030 pages shared
[411966.701039] 916883 pages non-shared
[411966.701041] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score=
_adj name
[411966.701048] [  191]     0   191     6555      410   3     -17         -=
1000 systemd-udevd
[411966.701050] [  194]     0   194    74640     3678   1       0          =
   0 systemd-journal
[411966.701053] [  301]     0   301     3302      311   2       0          =
   0 crond
[411966.701056] [  302]     0   302    17693      684   2       0          =
   0 cupsd
[411966.701058] [  304]     0   304    10502      326   1     -17         -=
1000 sshd
[411966.701061] [  305]    81   305     4433      322   0     -13          =
-900 dbus-daemon
[411966.701064] [  309]     0   309     6512      239   1       0          =
   0 systemd-logind
[411966.701066] [  315]     0   315    15747      318   2       0          =
   0 login
[411966.701069] [  316]     0   316     2031      193   0       0          =
   0 agetty
[411966.701072] [  317]     0   317     2031      189   0       0          =
   0 agetty
[411966.701075] [  319]     0   319     2031      191   1       0          =
   0 agetty
[411966.701077] [  320]     0   320     2031      192   1       0          =
   0 agetty
[411966.701080] [  321]     0   321     2031      191   1       0          =
   0 agetty
[411966.701083] [  325]     0   325    51901      562   3       0          =
   0 colord
[411966.701085] [  341]     0   341   123526     1044   1       0          =
   0 colord-sane
[411966.701087] [  395]     0   395     3092      205   2       0          =
   0 master
[411966.701090] [  399]    73   399    16380      410   1       0          =
   0 qmgr
[411966.701093] [  420]  1000   420     3423      283   2       0          =
   0 restart-x
[411966.701095] [  431]  1000   431     3423      298   3       0          =
   0 startx
[411966.701097] [  448]  1000   448     3966      147   3       0          =
   0 xinit
[411966.701100] [  449]  1000   449    92096     4518   1       0          =
   0 X
[411966.701102] [  470]  1000   470    24058      796   1       0          =
   0 i3
[411966.701105] [  477]  1000   477     6062      210   2       0          =
   0 unclutter
[411966.701107] [  480]  1000   480     6004      164   2       0          =
   0 dispad
[411966.701109] [  481]  1000   481    36623    12497   0       0          =
   0 urxvtd
[411966.701112] [  484]  1000   484     8068      476   1       0          =
   0 xbindkeys
[411966.701115] [  495]  1000   495     8155      656   2       0          =
   0 zsh
[411966.701117] [  505]  1000   505     8155      661   3       0          =
   0 zsh
[411966.701119] [  512]     0   512     8481      277   3       0          =
   0 sudo
[411966.701122] [  513]     0   513     6933      483   0       0          =
   0 zsh
[411966.701124] [  543]     0   543     7404      239   3       0          =
   0 wpa_supplicant
[411966.701126] [  659]  1000   659     9860     1868   2       0          =
   0 zsh
[411966.701129] [  772]  1000   772     4494       95   3       0          =
   0 dbus-launch
[411966.701131] [  773]  1000   773     4379      252   3       0          =
   0 dbus-daemon
[411966.701134] [ 1575]  1000  1575    10065     2058   1       0          =
   0 zsh
[411966.701137] [ 1959]  1000  1959     8748      756   1       0          =
   0 zsh
[411966.701139] [ 2835]  1000  2835    40320      829   3       0          =
   0 kdeinit4
[411966.701141] [ 2837]  1000  2837    48444      818   1       0          =
   0 klauncher
[411966.701144] [ 2841]  1000  2841   109726     1965   1       0          =
   0 kded4
[411966.701146] [ 2858]  1000  2858   238338     2687   2       0          =
   0 knotify4
[411966.701148] [ 2863]     0  2863    54958     1172   2       0          =
   0 upowerd
[411966.701150] [ 2868]     0  2868    46649      317   1     -13          =
-900 polkitd
[411966.701153] [ 2895]     0  2895    48362      445   1       0          =
   0 udisks-daemon
[411966.701155] [ 2904]     0  2904    11353      123   1       0          =
   0 udisks-daemon
[411966.701157] [ 6623]  1000  6623     8891      901   2       0          =
   0 zsh
[411966.701160] [ 8723]  1000  8723     8785      784   3       0          =
   0 zsh
[411966.701162] [14485]  1000 14485     8773      772   1       0          =
   0 zsh
[411966.701165] [30479]     0 30479     8481      278   1       0          =
   0 sudo
[411966.701168] [30480]     0 30480     6933      490   1       0          =
   0 zsh
[411966.701171] [ 1816]  1000  1816     8773      758   2       0          =
   0 zsh
[411966.701173] [ 2064]  1000  2064     9797     1778   3       0          =
   0 zsh
[411966.701176] [ 3202]  1000  3202     9839     1855   1       0          =
   0 zsh
[411966.701179] [13775]  1000 13775     8155      679   1       0          =
   0 zsh
[411966.701182] [13783]     0 13783     8481      279   2       0          =
   0 sudo
[411966.701184] [13784]     0 13784     6933      485   2       0          =
   0 zsh
[411966.701187] [14763]  1000 14763     8914      907   1       0          =
   0 zsh
[411966.701190] [29947]  1000 29947     5163      271   0       0          =
   0 zsh
[411966.701192] [29950]  1000 29950   164246    42554   0       0          =
   0 chromium
[411966.701195] [29952]  1000 29952    64978     1253   0       0          =
   0 chromium
[411966.701198] [29953]  1000 29953     1588      137   0       0          =
   0 chromium-sandbo
[411966.701200] [29954]  1000 29954    70030     1322   0       0          =
   0 chromium
[411966.701202] [29960]  1000 29960    34745      443   0       0          =
   0 nacl_helper_boo
[411966.701203] [29961]  1000 29961    76177     1211   0       0          =
   0 chromium
[411966.701205] [29990]  1000 29990   218552     5185   1       4          =
 300 chromium
[411966.701207] [29997]  1000 29997   227279    17931   2       4          =
 300 chromium
[411966.701209] [30004]  1000 30004   218991     5295   3       4          =
 300 chromium
[411966.701210] [20018]     0 20018     2136      155   1       0          =
   0 dhcpcd
[411966.701212] [20887]  1000 20887     9334     1324   2       0          =
   0 zsh
[411966.701214] [23649]  1000 23649    63938      841   1       0          =
   0 dconf-service
[411966.701215] [25961]  1000 25961    14690      782   1       0          =
   0 mutt
[411966.701217] [13576]     0 13576     4494       95   0       0          =
   0 dbus-launch
[411966.701219] [13577]     0 13577     4320      177   2       0          =
   0 dbus-daemon
[411966.701220] [15475]  1000 15475     9224     1221   1       0          =
   0 zsh
[411966.701222] [16635]  1000 16635     8845      865   0       0          =
   0 zsh
[411966.701224] [16929]  1000 16929     8716      706   0       0          =
   0 zsh
[411966.701226] [16982]  1000 16982    15494     1079   0       0          =
   0 mutt
[411966.701227] [17215]  1000 17215    10328     2341   1       0          =
   0 zsh
[411966.701229] [18001]  1000 18001     8769      774   2       0          =
   0 zsh
[411966.701231] [19150]  1000 19150    10512     2525   3       0          =
   0 zsh
[411966.701232] [19271]  1000 19271     8892      907   0       0          =
   0 zsh
[411966.701234] [21316]  1000 21316     8812      816   2       0          =
   0 zsh
[411966.701236] [21373]  1000 21373     8155      661   3       0          =
   0 zsh
[411966.701237] [21389]  1000 21389     8785      789   1       0          =
   0 zsh
[411966.701239] [21617]  1000 21617     8769      776   1       0          =
   0 zsh
[411966.701241] [22183]  1000 22183    14901     1011   2       0          =
   0 mutt
[411966.701242] [23190]  1000 23190     8291      691   0       0          =
   0 vim
[411966.701244] [23191]  1000 23191     8291      607   2       0          =
   0 vim
[411966.701246] [23198]  1000 23198    10210     2220   3       0          =
   0 zsh
[411966.701247] [23246]  1000 23246     8743      744   0       0          =
   0 zsh
[411966.701249] [23266]  1000 23266     8730     1471   1       0          =
   0 python3
[411966.701251] [23269]  1000 23269     8290      592   0       0          =
   0 vim
[411966.701253] [32120]  1000 32120    16392     1965   1       0          =
   0 mutt
[411966.701254] [ 5745]  1000  5745     9866     1861   2       0          =
   0 zsh
[411966.701256] [ 5944]  1000  5944     9776     1769   3       0          =
   0 zsh
[411966.701258] [ 8651]  1000  8651    10239     2247   2       0          =
   0 zsh
[411966.701260] [10927]  1000 10927     8891      906   3       0          =
   0 zsh
[411966.701262] [13485]  1000 13485     8773      770   2       0          =
   0 zsh
[411966.701264] [13492]  1000 13492    14788      883   3       0          =
   0 mutt
[411966.701265] [13504]  1000 13504    19180      525   3       0          =
   0 i3bar
[411966.701267] [13505]  1000 13505     8066      597   1       0          =
   0 i3status
[411966.701269] [13897]  1000 13897    10964     2962   1       0          =
   0 zsh
[411966.701271] [18368]  1000 18368    15875     1450   2       0          =
   0 mutt
[411966.701272] [25693]  1000 25693     8806      807   3       0          =
   0 zsh
[411966.701274] [12076]  1000 12076     9025     1040   3       0          =
   0 zsh
[411966.701276] [13526]  1000 13526     9782     1792   3       0          =
   0 zsh
[411966.701277] [20336]  1000 20336    10171     2195   2       0          =
   0 zsh
[411966.701279] [20496]  1000 20496     8805      817   0       0          =
   0 zsh
[411966.701281] [22068]  1000 22068     8830      840   0       0          =
   0 zsh
[411966.701282] [32613]  1000 32613    14756      830   3       0          =
   0 mutt
[411966.701285] [25473]  1000 25473     8337      663   1       0          =
   0 vim
[411966.701287] [25480]  1000 25480     9031     1040   3       0          =
   0 zsh
[411966.701288] [26043]  1000 26043     2650      198   2       0          =
   0 ping
[411966.701290] [29752]  1000 29752     8205      918   1       0          =
   0 mosh-client
[411966.701292] [30789]  1000 30789     8765      779   2       0          =
   0 zsh
[411966.701294] [31242]  1000 31242    10062     2086   3       0          =
   0 zsh
[411966.701295] [ 3498]     0  3498     4755     2630   1       0          =
   0 atop
[411966.701298] [ 5991]  1000  5991   226988    10559   1       4          =
 300 chromium
[411966.701299] [ 6011]  1000  6011   222892     6669   1       4          =
 300 chromium
[411966.701301] [ 6103]  1000  6103   242157    23699   1       4          =
 300 chromium
[411966.701303] [ 7830]  1000  7830   225890     9573   3       4          =
 300 chromium
[411966.701304] [ 7915]  1000  7915     8773      775   2       0          =
   0 zsh
[411966.701306] [12787]  1000 12787     9835     1837   3       0          =
   0 zsh
[411966.701308] [19881]  1000 19881     8794      807   2       0          =
   0 zsh
[411966.701309] [26144]  1000 26144   225043     9710   3       4          =
 300 chromium
[411966.701311] [30808]  1000 30808     8155      679   2       0          =
   0 zsh
[411966.701313] [ 2155]  1000  2155     8155      680   2       0          =
   0 zsh
[411966.701314] [ 2681]  1000  2681     4459      503   0       0          =
   0 man
[411966.701316] [ 2692]  1000  2692     2781      255   3       0          =
   0 less
[411966.701318] [ 3315]  1000  3315     4406     1851   3       0          =
   0 atop
[411966.701319] [ 3641]  1000  3641     8285      658   3       0          =
   0 vim
[411966.701321] [ 4252]  1000  4252     8835      831   2       0          =
   0 zsh
[411966.701323] [ 4452]  1000  4452   227004     9314   3       4          =
 300 chromium
[411966.701324] [ 4824]  1000  4824     8176      704   2       0          =
   0 zsh
[411966.701327] [ 6094]  1000  6094     9005      333   0       0          =
   0 ssh
[411966.701329] [ 6096]  1000  6096     8970      209   3       0          =
   0 ssh
[411966.701330] [ 6098]  1000  6098     8970      309   2       0          =
   0 ssh
[411966.701332] [ 8760]  1000  8760   222833     6855   3       4          =
 300 chromium
[411966.701334] [ 8769]  1000  8769     3424      269   0       0          =
   0 nz.sh
[411966.701336] [ 8771]  1000  8771     8347      731   3       0          =
   0 vim
[411966.701338] [ 8888]  1000  8888    44968      294   3       0          =
   0 evinced
[411966.701340] [ 8896]  1000  8896   129425    14841   1       0          =
   0 evince
[411966.701341] [ 9016]  1000  9016   140685    11780   0       0          =
   0 evince
[411966.701343] [ 9084]  1000  9084   247497    29178   3       4          =
 300 chromium
[411966.701345] [ 9146]  1000  9146     8286      637   2       0          =
   0 vim
[411966.701346] [ 9150]  1000  9150     8769      771   0       0          =
   0 zsh
[411966.701348] [ 9158]  1000  9158     8286      608   1       0          =
   0 vim
[411966.701350] [ 9178]  1000  9178   228820    12491   1       4          =
 300 chromium
[411966.701351] [ 9234]  1000  9234   224790     8669   1       4          =
 300 chromium
[411966.701353] [ 9255]  1000  9255   227614    11626   0       4          =
 300 chromium
[411966.701355] [ 9263]  1000  9263   227627    15324   3       4          =
 300 chromium
[411966.701357] [10008]  1000 10008     8769      784   1       0          =
   0 zsh
[411966.701359] [11133]     0 11133     8481      281   0       0          =
   0 sudo
[411966.701361] [11137]     0 11137     3457      299   1       0          =
   0 ccollect
[411966.701363] [11142]     0 11142     3457      206   0       0          =
   0 ccollect
[411966.701365] [11143]     0 11143     3457      148   0       0          =
   0 ccollect
[411966.701366] [11144]     0 11144     2919      224   3       0          =
   0 awk
[411966.701368] [11196]     0 11196     2107      749   1       0          =
   0 rm
[411966.701370] [11239]    73 11239    16333      355   1       0          =
   0 pickup
[411966.701372] [11506]  1000 11506   223148     8149   1       4          =
 300 chromium
[411966.701374] [11517]  1000 11517     8748      765   0       0          =
   0 zsh
[411966.701376] [11525]  1000 11525   226740     9601   3       4          =
 300 chromium
[411966.701378] [11576]  1000 11576     8288      602   2       0          =
   0 vim
[411966.701380] [11588]  1000 11588   230261    13777   3       4          =
 300 chromium
[411966.701382] [11639]     0 11639     5899      275   3       0          =
   0 vpnc
[411966.701384] [11794]  1000 11794   227790    11355   3       4          =
 300 chromium
[411966.701385] [11805]  1000 11805   225046     7738   2       4          =
 300 chromium
[411966.701388] [12050]     0 12050     9169      395   2       0          =
   0 crond
[411966.701389] [12053]  1000 12053     2937      211   3       0          =
   0 sh
[411966.701391] [12055]  1000 12055   153597     2412   3       0          =
   0 offlineimap
[411966.701393] Out of memory: Kill process 9084 (chromium) score 329 or sa=
crifice child
[411966.701396] Killed process 9084 (chromium) total-vm:989988kB, anon-rss:=
115296kB, file-rss:1416kB
[412243.830247] crond invoked oom-killer: gfp_mask=3D0xd0, order=3D1, oom_a=
dj=3D0, oom_score_adj=3D0
[412243.830252] crond cpuset=3D/ mems_allowed=3D0
[412243.830255] Pid: 12535, comm: crond Tainted: G        W    3.5.4-1-ARCH=
 #1
[412243.830257] Call Trace:
[412243.830264]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d=
/0xb0
[412243.830270]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[412243.830275]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[412243.830280]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[412243.830285]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[412243.830288]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[412243.830292]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[412243.830297]  [<ffffffff81140ea9>] ? handle_mm_fault+0x259/0x320
[412243.830301]  [<ffffffff8104f72b>] copy_process.part.21+0xeb/0x1530
[412243.830306]  [<ffffffff811646ef>] ? kmem_cache_alloc+0x13f/0x150
[412243.830309]  [<ffffffff811646ef>] ? kmem_cache_alloc+0x13f/0x150
[412243.830314]  [<ffffffff81205716>] ? security_file_alloc+0x16/0x20
[412243.830317]  [<ffffffff81050cf5>] do_fork+0x135/0x3a0
[412243.830321]  [<ffffffff81182da3>] ? do_pipe_flags+0xc3/0x120
[412243.830325]  [<ffffffff8101dd18>] sys_clone+0x28/0x30
[412243.830328]  [<ffffffff814856f3>] stub_clone+0x13/0x20
[412243.830332]  [<ffffffff814853ed>] ? system_call_fastpath+0x1a/0x1f
[412243.830334] Mem-Info:
[412243.830335] Node 0 DMA per-cpu:
[412243.830338] CPU    0: hi:    0, btch:   1 usd:   0
[412243.830340] CPU    1: hi:    0, btch:   1 usd:   0
[412243.830342] CPU    2: hi:    0, btch:   1 usd:   0
[412243.830343] CPU    3: hi:    0, btch:   1 usd:   0
[412243.830345] Node 0 DMA32 per-cpu:
[412243.830347] CPU    0: hi:  186, btch:  31 usd:   0
[412243.830349] CPU    1: hi:  186, btch:  31 usd:  36
[412243.830351] CPU    2: hi:  186, btch:  31 usd:   0
[412243.830353] CPU    3: hi:  186, btch:  31 usd:   0
[412243.830354] Node 0 Normal per-cpu:
[412243.830357] CPU    0: hi:  186, btch:  31 usd:  30
[412243.830359] CPU    1: hi:  186, btch:  31 usd:   1
[412243.830360] CPU    2: hi:  186, btch:  31 usd:   0
[412243.830362] CPU    3: hi:  186, btch:  31 usd:   0
[412243.830367] active_anon:380673 inactive_anon:92757 isolated_anon:0
 active_file:57 inactive_file:236 isolated_file:0
 unevictable:3637 dirty:10 writeback:55 unstable:0
 free:22789 slab_reclaimable:453356 slab_unreclaimable:7570
 mapped:1881 shmem:125669 pagetables:8094 bounce:0
[412243.830371] Node 0 DMA free:15856kB min:260kB low:324kB high:388kB acti=
ve_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable=
:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirt=
y:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:32kB slab_unrecla=
imable:0kB kernel_stack:16kB pagetables:0kB unstable:0kB bounce:0kB writeba=
ck_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[412243.830376] lowmem_reserve[]: 0 2137 3899 3899
[412243.830381] Node 0 DMA32 free:44928kB min:36900kB low:46124kB high:5534=
8kB active_anon:574120kB inactive_anon:98628kB active_file:228kB inactive_f=
ile:904kB unevictable:4124kB isolated(anon):0kB isolated(file):0kB present:=
2188752kB mlocked:36kB dirty:36kB writeback:220kB mapped:252kB shmem:124668=
kB slab_reclaimable:1445812kB slab_unreclaimable:6684kB kernel_stack:656kB =
pagetables:1768kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:2=
091 all_unreclaimable? yes
[412243.830387] lowmem_reserve[]: 0 0 1762 1762
[412243.830390] Node 0 Normal free:30372kB min:30416kB low:38020kB high:456=
24kB active_anon:948572kB inactive_anon:272400kB active_file:0kB inactive_f=
ile:40kB unevictable:10424kB isolated(anon):0kB isolated(file):0kB present:=
1804320kB mlocked:10424kB dirty:4kB writeback:0kB mapped:7272kB shmem:37800=
8kB slab_reclaimable:367580kB slab_unreclaimable:23596kB kernel_stack:2552k=
B pagetables:30608kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanne=
d:2880 all_unreclaimable? yes
[412243.830396] lowmem_reserve[]: 0 0 0 0
[412243.830400] Node 0 DMA: 2*4kB 1*8kB 0*16kB 3*32kB 2*64kB 2*128kB 2*256k=
B 1*512kB 2*1024kB 2*2048kB 2*4096kB =3D 15856kB
[412243.830410] Node 0 DMA32: 11260*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB =
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =3D 45040kB
[412243.830419] Node 0 Normal: 2782*4kB 1267*8kB 444*16kB 3*32kB 0*64kB 0*1=
28kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB =3D 30512kB
[412243.830428] 126972 total pagecache pages
[412243.830430] 0 pages in swap cache
[412243.830432] Swap cache stats: add 0, delete 0, find 0/0
[412243.830433] Free swap  =3D 0kB
[412243.830435] Total swap =3D 0kB
[412243.842110] 1048048 pages RAM
[412243.842112] 57533 pages reserved
[412243.842113] 86556 pages shared
[412243.842115] 939953 pages non-shared
[412243.842116] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score=
_adj name
[412243.842124] [  191]     0   191     6555      410   3     -17         -=
1000 systemd-udevd
[412243.842127] [  194]     0   194    74640     1955   3       0          =
   0 systemd-journal
[412243.842130] [  301]     0   301     3302      312   0       0          =
   0 crond
[412243.842133] [  302]     0   302    17693      684   2       0          =
   0 cupsd
[412243.842136] [  304]     0   304    10502      326   1     -17         -=
1000 sshd
[412243.842138] [  305]    81   305     4433      317   1     -13          =
-900 dbus-daemon
[412243.842141] [  309]     0   309     6512      239   1       0          =
   0 systemd-logind
[412243.842144] [  315]     0   315    15747      318   2       0          =
   0 login
[412243.842146] [  316]     0   316     2031      193   0       0          =
   0 agetty
[412243.842149] [  317]     0   317     2031      189   0       0          =
   0 agetty
[412243.842152] [  319]     0   319     2031      191   1       0          =
   0 agetty
[412243.842154] [  320]     0   320     2031      192   1       0          =
   0 agetty
[412243.842157] [  321]     0   321     2031      191   1       0          =
   0 agetty
[412243.842159] [  325]     0   325    51901      562   3       0          =
   0 colord
[412243.842162] [  341]     0   341   123526     1044   1       0          =
   0 colord-sane
[412243.842165] [  395]     0   395     3092      211   3       0          =
   0 master
[412243.842167] [  399]    73   399    16380      393   1       0          =
   0 qmgr
[412243.842170] [  420]  1000   420     3423      283   2       0          =
   0 restart-x
[412243.842173] [  431]  1000   431     3423      298   3       0          =
   0 startx
[412243.842175] [  448]  1000   448     3966      147   3       0          =
   0 xinit
[412243.842178] [  449]  1000   449    92101     4509   3       0          =
   0 X
[412243.842181] [  470]  1000   470    24058      797   1       0          =
   0 i3
[412243.842183] [  477]  1000   477     6062      184   1       0          =
   0 unclutter
[412243.842186] [  480]  1000   480     6004      151   1       0          =
   0 dispad
[412243.842188] [  481]  1000   481    36623    12499   1       0          =
   0 urxvtd
[412243.842191] [  484]  1000   484     8068      476   1       0          =
   0 xbindkeys
[412243.842194] [  495]  1000   495     8155      656   2       0          =
   0 zsh
[412243.842196] [  505]  1000   505     8155      661   3       0          =
   0 zsh
[412243.842199] [  512]     0   512     8481      277   3       0          =
   0 sudo
[412243.842202] [  513]     0   513     6933      483   0       0          =
   0 zsh
[412243.842204] [  543]     0   543     7404      239   1       0          =
   0 wpa_supplicant
[412243.842207] [  659]  1000   659     9860     1868   2       0          =
   0 zsh
[412243.842210] [  772]  1000   772     4494       95   3       0          =
   0 dbus-launch
[412243.842212] [  773]  1000   773     4379      252   3       0          =
   0 dbus-daemon
[412243.842215] [ 1575]  1000  1575    10065     2058   1       0          =
   0 zsh
[412243.842217] [ 1959]  1000  1959     8748      756   1       0          =
   0 zsh
[412243.842220] [ 2835]  1000  2835    40320      829   3       0          =
   0 kdeinit4
[412243.842222] [ 2837]  1000  2837    48444      818   1       0          =
   0 klauncher
[412243.842225] [ 2841]  1000  2841   109726     1964   3       0          =
   0 kded4
[412243.842228] [ 2858]  1000  2858   238338     2685   2       0          =
   0 knotify4
[412243.842231] [ 2863]     0  2863    54958     1184   1       0          =
   0 upowerd
[412243.842233] [ 2868]     0  2868    46649      335   3     -13          =
-900 polkitd
[412243.842236] [ 2895]     0  2895    48362      445   1       0          =
   0 udisks-daemon
[412243.842238] [ 2904]     0  2904    11353      123   1       0          =
   0 udisks-daemon
[412243.842241] [ 6623]  1000  6623     8891      901   2       0          =
   0 zsh
[412243.842243] [ 8723]  1000  8723     8785      784   3       0          =
   0 zsh
[412243.842245] [14485]  1000 14485     8773      772   1       0          =
   0 zsh
[412243.842248] [30479]     0 30479     8481      278   1       0          =
   0 sudo
[412243.842251] [30480]     0 30480     6933      490   1       0          =
   0 zsh
[412243.842253] [ 1816]  1000  1816     8773      758   2       0          =
   0 zsh
[412243.842256] [ 2064]  1000  2064     9797     1778   3       0          =
   0 zsh
[412243.842259] [ 3202]  1000  3202     9839     1855   1       0          =
   0 zsh
[412243.842261] [13775]  1000 13775     8155      679   1       0          =
   0 zsh
[412243.842263] [13783]     0 13783     8481      279   2       0          =
   0 sudo
[412243.842266] [13784]     0 13784     6933      485   2       0          =
   0 zsh
[412243.842269] [14763]  1000 14763     8914      907   1       0          =
   0 zsh
[412243.842271] [29947]  1000 29947     5163      271   0       0          =
   0 zsh
[412243.842274] [29950]  1000 29950   164139    42432   1       0          =
   0 chromium
[412243.842276] [29952]  1000 29952    64978     1253   0       0          =
   0 chromium
[412243.842278] [29953]  1000 29953     1588      137   0       0          =
   0 chromium-sandbo
[412243.842280] [29954]  1000 29954    70030     1322   0       0          =
   0 chromium
[412243.842283] [29960]  1000 29960    34745      443   0       0          =
   0 nacl_helper_boo
[412243.842285] [29961]  1000 29961    76177     1192   3       0          =
   0 chromium
[412243.842287] [29990]  1000 29990   218552     5137   2       4          =
 300 chromium
[412243.842290] [29997]  1000 29997   227279    15041   3       4          =
 300 chromium
[412243.842293] [30004]  1000 30004   218991     5345   3       4          =
 300 chromium
[412243.842295] [20018]     0 20018     2136      155   1       0          =
   0 dhcpcd
[412243.842297] [20887]  1000 20887     9334     1324   2       0          =
   0 zsh
[412243.842300] [23649]  1000 23649    63938      841   1       0          =
   0 dconf-service
[412243.842302] [25961]  1000 25961    14690      761   2       0          =
   0 mutt
[412243.842304] [13576]     0 13576     4494       95   0       0          =
   0 dbus-launch
[412243.842307] [13577]     0 13577     4320      177   2       0          =
   0 dbus-daemon
[412243.842310] [15475]  1000 15475     9224     1221   1       0          =
   0 zsh
[412243.842313] [16635]  1000 16635     8845      865   0       0          =
   0 zsh
[412243.842315] [16929]  1000 16929     8716      706   0       0          =
   0 zsh
[412243.842318] [16982]  1000 16982    15494     1066   1       0          =
   0 mutt
[412243.842320] [17215]  1000 17215    10328     2341   1       0          =
   0 zsh
[412243.842323] [18001]  1000 18001     8769      774   2       0          =
   0 zsh
[412243.842326] [19150]  1000 19150    10512     2525   3       0          =
   0 zsh
[412243.842328] [19271]  1000 19271     8892      907   0       0          =
   0 zsh
[412243.842330] [21316]  1000 21316     8812      816   2       0          =
   0 zsh
[412243.842334] [21373]  1000 21373     8155      661   3       0          =
   0 zsh
[412243.842336] [21389]  1000 21389     8785      789   1       0          =
   0 zsh
[412243.842339] [21617]  1000 21617     8769      776   1       0          =
   0 zsh
[412243.842341] [22183]  1000 22183    14901      990   2       0          =
   0 mutt
[412243.842344] [23190]  1000 23190     8291      691   0       0          =
   0 vim
[412243.842347] [23191]  1000 23191     8291      625   1       0          =
   0 vim
[412243.842349] [23198]  1000 23198    10210     2220   3       0          =
   0 zsh
[412243.842352] [23246]  1000 23246     8743      744   0       0          =
   0 zsh
[412243.842354] [23266]  1000 23266     8730     1471   1       0          =
   0 python3
[412243.842357] [23269]  1000 23269     8290      589   1       0          =
   0 vim
[412243.842360] [32120]  1000 32120    16392     1944   2       0          =
   0 mutt
[412243.842362] [ 5745]  1000  5745     9866     1861   2       0          =
   0 zsh
[412243.842365] [ 5944]  1000  5944     9776     1769   3       0          =
   0 zsh
[412243.842368] [ 8651]  1000  8651    10239     2247   2       0          =
   0 zsh
[412243.842371] [10927]  1000 10927     8891      906   3       0          =
   0 zsh
[412243.842373] [13485]  1000 13485     8773      770   2       0          =
   0 zsh
[412243.842376] [13492]  1000 13492    14788      862   0       0          =
   0 mutt
[412243.842379] [13504]  1000 13504    19180      547   3       0          =
   0 i3bar
[412243.842381] [13505]  1000 13505     8066      633   2       0          =
   0 i3status
[412243.842385] [13897]  1000 13897    10964     2962   1       0          =
   0 zsh
[412243.842387] [18368]  1000 18368    15875     1450   2       0          =
   0 mutt
[412243.842390] [25693]  1000 25693     8806      807   3       0          =
   0 zsh
[412243.842392] [12076]  1000 12076     9025     1040   3       0          =
   0 zsh
[412243.842395] [13526]  1000 13526     9782     1792   3       0          =
   0 zsh
[412243.842398] [20336]  1000 20336    10171     2195   2       0          =
   0 zsh
[412243.842400] [20496]  1000 20496     8805      817   0       0          =
   0 zsh
[412243.842403] [22068]  1000 22068     8830      840   0       0          =
   0 zsh
[412243.842405] [32613]  1000 32613    14756      809   1       0          =
   0 mutt
[412243.842408] [25473]  1000 25473     8337      663   1       0          =
   0 vim
[412243.842411] [25480]  1000 25480     9031     1040   3       0          =
   0 zsh
[412243.842413] [26043]  1000 26043     2650      193   1       0          =
   0 ping
[412243.842416] [29752]  1000 29752     8205      885   1       0          =
   0 mosh-client
[412243.842418] [30789]  1000 30789     8765      779   2       0          =
   0 zsh
[412243.842421] [31242]  1000 31242    10062     2086   3       0          =
   0 zsh
[412243.842423] [ 3498]     0  3498     4755     2630   1       0          =
   0 atop
[412243.842426] [ 5991]  1000  5991   226988    10585   1       4          =
 300 chromium
[412243.842428] [ 6011]  1000  6011   222892     6708   1       4          =
 300 chromium
[412243.842431] [ 6103]  1000  6103   242157    23697   3       4          =
 300 chromium
[412243.842434] [ 7830]  1000  7830   225890     9577   1       4          =
 300 chromium
[412243.842436] [ 7915]  1000  7915     8773      775   2       0          =
   0 zsh
[412243.842438] [12787]  1000 12787     9835     1837   3       0          =
   0 zsh
[412243.842441] [19881]  1000 19881     8794      807   2       0          =
   0 zsh
[412243.842444] [26144]  1000 26144   225043     9721   1       4          =
 300 chromium
[412243.842446] [30808]  1000 30808     8155      679   2       0          =
   0 zsh
[412243.842449] [ 2155]  1000  2155     8155      680   2       0          =
   0 zsh
[412243.842452] [ 2681]  1000  2681     4459      503   0       0          =
   0 man
[412243.842455] [ 2692]  1000  2692     2781      255   3       0          =
   0 less
[412243.842458] [ 3315]  1000  3315     4406     1851   1       0          =
   0 atop
[412243.842461] [ 3641]  1000  3641     8285      658   3       0          =
   0 vim
[412243.842463] [ 4252]  1000  4252     8835      831   2       0          =
   0 zsh
[412243.842466] [ 4452]  1000  4452   227004     9327   1       4          =
 300 chromium
[412243.842468] [ 4824]  1000  4824     8176      704   2       0          =
   0 zsh
[412243.842472] [ 6094]  1000  6094     9005      290   1       0          =
   0 ssh
[412243.842475] [ 6096]  1000  6096     8970      209   3       0          =
   0 ssh
[412243.842477] [ 6098]  1000  6098     8970      276   1       0          =
   0 ssh
[412243.842480] [ 8760]  1000  8760   222833     6877   3       4          =
 300 chromium
[412243.842482] [ 8769]  1000  8769     3424      269   0       0          =
   0 nz.sh
[412243.842486] [ 8771]  1000  8771     8347      731   3       0          =
   0 vim
[412243.842488] [ 8888]  1000  8888    44968      294   3       0          =
   0 evinced
[412243.842491] [ 8896]  1000  8896   129425    14815   1       0          =
   0 evince
[412243.842494] [ 9016]  1000  9016   140685    11764   1       0          =
   0 evince
[412243.842496] [ 9146]  1000  9146     8286      637   2       0          =
   0 vim
[412243.842499] [ 9150]  1000  9150     8769      771   0       0          =
   0 zsh
[412243.842501] [ 9158]  1000  9158     8286      608   1       0          =
   0 vim
[412243.842504] [ 9178]  1000  9178   228820    12507   2       4          =
 300 chromium
[412243.842507] [ 9234]  1000  9234   224790     8649   0       4          =
 300 chromium
[412243.842509] [ 9255]  1000  9255   227614    11584   1       4          =
 300 chromium
[412243.842512] [ 9263]  1000  9263   227627    15278   2       4          =
 300 chromium
[412243.842514] [10008]  1000 10008     8769      768   2       0          =
   0 zsh
[412243.842517] [11133]     0 11133     8481      281   0       0          =
   0 sudo
[412243.842519] [11137]     0 11137     3457      299   1       0          =
   0 ccollect
[412243.842521] [11142]     0 11142     3457      206   0       0          =
   0 ccollect
[412243.842523] [11143]     0 11143     3457      148   0       0          =
   0 ccollect
[412243.842526] [11144]     0 11144     2919      224   3       0          =
   0 awk
[412243.842530] [11196]     0 11196     1777      437   3       0          =
   0 rm
[412243.842533] [11239]    73 11239    16333      378   1       0          =
   0 pickup
[412243.842536] [11506]  1000 11506   222892     6520   2       4          =
 300 chromium
[412243.842539] [11517]  1000 11517     8748      765   0       0          =
   0 zsh
[412243.842541] [11525]  1000 11525   226484     8928   3       4          =
 300 chromium
[412243.842543] [11588]  1000 11588   230517    13839   3       4          =
 300 chromium
[412243.842546] [11639]     0 11639     5899      271   2       0          =
   0 vpnc
[412243.842549] [11794]  1000 11794   228300    10913   3       4          =
 300 chromium
[412243.842552] [11805]  1000 11805   225558     8523   1       4          =
 300 chromium
[412243.842554] [12411]     0 12411     9169      395   3       0          =
   0 crond
[412243.842556] [12413]  1000 12413     2937      209   2       0          =
   0 sh
[412243.842558] [12416]  1000 12416   171745     9749   0       0          =
   0 offlineimap
[412243.842560] [12535]     0 12535     9168      380   2       0          =
   0 crond
[412243.842562] Out of memory: Kill process 6103 (chromium) score 324 or sa=
crifice child
[412243.842565] Killed process 6103 (chromium) total-vm:968628kB, anon-rss:=
93408kB, file-rss:1380kB
[412243.843460] crond invoked oom-killer: gfp_mask=3D0xd0, order=3D1, oom_a=
dj=3D0, oom_score_adj=3D0
[412243.843464] crond cpuset=3D/ mems_allowed=3D0
[412243.843467] Pid: 12535, comm: crond Tainted: G        W    3.5.4-1-ARCH=
 #1
[412243.843469] Call Trace:
[412243.843476]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d=
/0xb0
[412243.843481]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[412243.843486]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[412243.843491]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[412243.843496]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[412243.843500]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[412243.843504]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[412243.843509]  [<ffffffff81140ea9>] ? handle_mm_fault+0x259/0x320
[412243.843514]  [<ffffffff8104f72b>] copy_process.part.21+0xeb/0x1530
[412243.843519]  [<ffffffff811646ef>] ? kmem_cache_alloc+0x13f/0x150
[412243.843523]  [<ffffffff811646ef>] ? kmem_cache_alloc+0x13f/0x150
[412243.843527]  [<ffffffff81205716>] ? security_file_alloc+0x16/0x20
[412243.843531]  [<ffffffff81050cf5>] do_fork+0x135/0x3a0
[412243.843535]  [<ffffffff81182da3>] ? do_pipe_flags+0xc3/0x120
[412243.843538]  [<ffffffff8101dd18>] sys_clone+0x28/0x30
[412243.843541]  [<ffffffff814856f3>] stub_clone+0x13/0x20
[412243.843545]  [<ffffffff814853ed>] ? system_call_fastpath+0x1a/0x1f
[412243.843547] Mem-Info:
[412243.843549] Node 0 DMA per-cpu:
[412243.843552] CPU    0: hi:    0, btch:   1 usd:   0
[412243.843554] CPU    1: hi:    0, btch:   1 usd:   0
[412243.843556] CPU    2: hi:    0, btch:   1 usd:   0
[412243.843558] CPU    3: hi:    0, btch:   1 usd:   0
[412243.843559] Node 0 DMA32 per-cpu:
[412243.843563] CPU    0: hi:  186, btch:  31 usd: 175
[412243.843564] CPU    1: hi:  186, btch:  31 usd:  79
[412243.843566] CPU    2: hi:  186, btch:  31 usd:   0
[412243.843569] CPU    3: hi:  186, btch:  31 usd: 120
[412243.843570] Node 0 Normal per-cpu:
[412243.843573] CPU    0: hi:  186, btch:  31 usd:  30
[412243.843575] CPU    1: hi:  186, btch:  31 usd:  24
[412243.843577] CPU    2: hi:  186, btch:  31 usd:   0
[412243.843579] CPU    3: hi:  186, btch:  31 usd:   0
[412243.843584] active_anon:380673 inactive_anon:92757 isolated_anon:0
 active_file:94 inactive_file:201 isolated_file:0
 unevictable:3637 dirty:10 writeback:55 unstable:0
 free:22540 slab_reclaimable:453356 slab_unreclaimable:7570
 mapped:1936 shmem:125669 pagetables:8094 bounce:0
[412243.843587] Node 0 DMA free:15856kB min:260kB low:324kB high:388kB acti=
ve_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable=
:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirt=
y:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:32kB slab_unrecla=
imable:0kB kernel_stack:16kB pagetables:0kB unstable:0kB bounce:0kB writeba=
ck_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[412243.843594] lowmem_reserve[]: 0 2137 3899 3899
[412243.843598] Node 0 DMA32 free:43932kB min:36900kB low:46124kB high:5534=
8kB active_anon:574120kB inactive_anon:98628kB active_file:376kB inactive_f=
ile:764kB unevictable:4124kB isolated(anon):0kB isolated(file):0kB present:=
2188752kB mlocked:36kB dirty:36kB writeback:220kB mapped:472kB shmem:124668=
kB slab_reclaimable:1445812kB slab_unreclaimable:6684kB kernel_stack:656kB =
pagetables:1768kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:1=
2 all_unreclaimable? no
[412243.843605] lowmem_reserve[]: 0 0 1762 1762
[412243.843609] Node 0 Normal free:30372kB min:30416kB low:38020kB high:456=
24kB active_anon:948572kB inactive_anon:272400kB active_file:0kB inactive_f=
ile:40kB unevictable:10424kB isolated(anon):0kB isolated(file):0kB present:=
1804320kB mlocked:10424kB dirty:4kB writeback:0kB mapped:7272kB shmem:37800=
8kB slab_reclaimable:367580kB slab_unreclaimable:23596kB kernel_stack:2552k=
B pagetables:30608kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanne=
d:3188 all_unreclaimable? yes
[412243.843615] lowmem_reserve[]: 0 0 0 0
[412243.843619] Node 0 DMA: 2*4kB 1*8kB 0*16kB 3*32kB 2*64kB 2*128kB 2*256k=
B 1*512kB 2*1024kB 2*2048kB 2*4096kB =3D 15856kB
[412243.843629] Node 0 DMA32: 11012*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB =
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =3D 44048kB
[412243.843638] Node 0 Normal: 2751*4kB 1267*8kB 444*16kB 3*32kB 0*64kB 0*1=
28kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB =3D 30388kB
[412243.843649] 126972 total pagecache pages
[412243.843650] 0 pages in swap cache
[412243.843652] Swap cache stats: add 0, delete 0, find 0/0
[412243.843653] Free swap  =3D 0kB
[412243.843655] Total swap =3D 0kB
[412243.856012] 1048048 pages RAM
[412243.856015] 57533 pages reserved
[412243.856016] 85238 pages shared
[412243.856017] 931570 pages non-shared
[412243.856019] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score=
_adj name
[412243.856026] [  191]     0   191     6555      410   3     -17         -=
1000 systemd-udevd
[412243.856028] [  194]     0   194    74640     1955   3       0          =
   0 systemd-journal
[412243.856031] [  301]     0   301     3302      312   0       0          =
   0 crond
[412243.856033] [  302]     0   302    17693      684   2       0          =
   0 cupsd
[412243.856036] [  304]     0   304    10502      326   1     -17         -=
1000 sshd
[412243.856039] [  305]    81   305     4433      317   1     -13          =
-900 dbus-daemon
[412243.856042] [  309]     0   309     6512      239   1       0          =
   0 systemd-logind
[412243.856044] [  315]     0   315    15747      318   2       0          =
   0 login
[412243.856046] [  316]     0   316     2031      193   0       0          =
   0 agetty
[412243.856049] [  317]     0   317     2031      189   0       0          =
   0 agetty
[412243.856051] [  319]     0   319     2031      191   1       0          =
   0 agetty
[412243.856054] [  320]     0   320     2031      192   1       0          =
   0 agetty
[412243.856056] [  321]     0   321     2031      191   1       0          =
   0 agetty
[412243.856059] [  325]     0   325    51901      562   3       0          =
   0 colord
[412243.856061] [  341]     0   341   123526     1044   1       0          =
   0 colord-sane
[412243.856064] [  395]     0   395     3092      211   3       0          =
   0 master
[412243.856067] [  399]    73   399    16380      393   1       0          =
   0 qmgr
[412243.856070] [  420]  1000   420     3423      283   2       0          =
   0 restart-x
[412243.856073] [  431]  1000   431     3423      298   3       0          =
   0 startx
[412243.856075] [  448]  1000   448     3966      147   3       0          =
   0 xinit
[412243.856078] [  449]  1000   449    92101     4509   3       0          =
   0 X
[412243.856080] [  470]  1000   470    24058      797   1       0          =
   0 i3
[412243.856083] [  477]  1000   477     6062      184   1       0          =
   0 unclutter
[412243.856086] [  480]  1000   480     6004      151   1       0          =
   0 dispad
[412243.856089] [  481]  1000   481    36623    12499   1       0          =
   0 urxvtd
[412243.856092] [  484]  1000   484     8068      476   1       0          =
   0 xbindkeys
[412243.856094] [  495]  1000   495     8155      656   2       0          =
   0 zsh
[412243.856097] [  505]  1000   505     8155      661   3       0          =
   0 zsh
[412243.856100] [  512]     0   512     8481      277   3       0          =
   0 sudo
[412243.856102] [  513]     0   513     6933      483   0       0          =
   0 zsh
[412243.856105] [  543]     0   543     7404      239   1       0          =
   0 wpa_supplicant
[412243.856107] [  659]  1000   659     9860     1868   2       0          =
   0 zsh
[412243.856110] [  772]  1000   772     4494       95   3       0          =
   0 dbus-launch
[412243.856112] [  773]  1000   773     4379      252   3       0          =
   0 dbus-daemon
[412243.856115] [ 1575]  1000  1575    10065     2058   1       0          =
   0 zsh
[412243.856118] [ 1959]  1000  1959     8748      756   1       0          =
   0 zsh
[412243.856120] [ 2835]  1000  2835    40320      829   3       0          =
   0 kdeinit4
[412243.856124] [ 2837]  1000  2837    48444      818   1       0          =
   0 klauncher
[412243.856126] [ 2841]  1000  2841   109726     1964   3       0          =
   0 kded4
[412243.856129] [ 2858]  1000  2858   238338     2685   2       0          =
   0 knotify4
[412243.856132] [ 2863]     0  2863    54958     1184   1       0          =
   0 upowerd
[412243.856134] [ 2868]     0  2868    46649      335   3     -13          =
-900 polkitd
[412243.856137] [ 2895]     0  2895    48362      445   1       0          =
   0 udisks-daemon
[412243.856139] [ 2904]     0  2904    11353      123   1       0          =
   0 udisks-daemon
[412243.856142] [ 6623]  1000  6623     8891      901   2       0          =
   0 zsh
[412243.856145] [ 8723]  1000  8723     8785      784   3       0          =
   0 zsh
[412243.856148] [14485]  1000 14485     8773      772   1       0          =
   0 zsh
[412243.856150] [30479]     0 30479     8481      278   1       0          =
   0 sudo
[412243.856153] [30480]     0 30480     6933      490   1       0          =
   0 zsh
[412243.856155] [ 1816]  1000  1816     8773      758   2       0          =
   0 zsh
[412243.856158] [ 2064]  1000  2064     9797     1778   3       0          =
   0 zsh
[412243.856160] [ 3202]  1000  3202     9839     1855   1       0          =
   0 zsh
[412243.856163] [13775]  1000 13775     8155      679   1       0          =
   0 zsh
[412243.856166] [13783]     0 13783     8481      279   2       0          =
   0 sudo
[412243.856168] [13784]     0 13784     6933      485   2       0          =
   0 zsh
[412243.856171] [14763]  1000 14763     8914      907   1       0          =
   0 zsh
[412243.856174] [29947]  1000 29947     5163      271   0       0          =
   0 zsh
[412243.856176] [29950]  1000 29950   164139    42432   3       0          =
   0 chromium
[412243.856179] [29952]  1000 29952    64978     1253   0       0          =
   0 chromium
[412243.856182] [29953]  1000 29953     1588      137   0       0          =
   0 chromium-sandbo
[412243.856184] [29954]  1000 29954    70030     1322   0       0          =
   0 chromium
[412243.856187] [29960]  1000 29960    34745      443   0       0          =
   0 nacl_helper_boo
[412243.856189] [29961]  1000 29961    76177     1192   3       0          =
   0 chromium
[412243.856192] [29990]  1000 29990   218552     5137   2       4          =
 300 chromium
[412243.856195] [29997]  1000 29997   227279    15041   3       4          =
 300 chromium
[412243.856198] [30004]  1000 30004   218991     5345   3       4          =
 300 chromium
[412243.856200] [20018]     0 20018     2136      155   1       0          =
   0 dhcpcd
[412243.856203] [20887]  1000 20887     9334     1324   2       0          =
   0 zsh
[412243.856205] [23649]  1000 23649    63938      841   1       0          =
   0 dconf-service
[412243.856208] [25961]  1000 25961    14690      761   2       0          =
   0 mutt
[412243.856210] [13576]     0 13576     4494       95   0       0          =
   0 dbus-launch
[412243.856213] [13577]     0 13577     4320      177   2       0          =
   0 dbus-daemon
[412243.856216] [15475]  1000 15475     9224     1221   1       0          =
   0 zsh
[412243.856219] [16635]  1000 16635     8845      865   0       0          =
   0 zsh
[412243.856221] [16929]  1000 16929     8716      706   0       0          =
   0 zsh
[412243.856224] [16982]  1000 16982    15494     1066   1       0          =
   0 mutt
[412243.856227] [17215]  1000 17215    10328     2341   1       0          =
   0 zsh
[412243.856229] [18001]  1000 18001     8769      774   2       0          =
   0 zsh
[412243.856232] [19150]  1000 19150    10512     2525   3       0          =
   0 zsh
[412243.856234] [19271]  1000 19271     8892      907   0       0          =
   0 zsh
[412243.856236] [21316]  1000 21316     8812      816   2       0          =
   0 zsh
[412243.856239] [21373]  1000 21373     8155      661   3       0          =
   0 zsh
[412243.856241] [21389]  1000 21389     8785      789   1       0          =
   0 zsh
[412243.856244] [21617]  1000 21617     8769      776   1       0          =
   0 zsh
[412243.856247] [22183]  1000 22183    14901      990   2       0          =
   0 mutt
[412243.856250] [23190]  1000 23190     8291      691   0       0          =
   0 vim
[412243.856253] [23191]  1000 23191     8291      625   1       0          =
   0 vim
[412243.856255] [23198]  1000 23198    10210     2220   3       0          =
   0 zsh
[412243.856257] [23246]  1000 23246     8743      744   0       0          =
   0 zsh
[412243.856260] [23266]  1000 23266     8730     1471   1       0          =
   0 python3
[412243.856263] [23269]  1000 23269     8290      589   1       0          =
   0 vim
[412243.856266] [32120]  1000 32120    16392     1944   2       0          =
   0 mutt
[412243.856269] [ 5745]  1000  5745     9866     1861   2       0          =
   0 zsh
[412243.856271] [ 5944]  1000  5944     9776     1769   3       0          =
   0 zsh
[412243.856274] [ 8651]  1000  8651    10239     2247   2       0          =
   0 zsh
[412243.856276] [10927]  1000 10927     8891      906   3       0          =
   0 zsh
[412243.856279] [13485]  1000 13485     8773      770   2       0          =
   0 zsh
[412243.856282] [13492]  1000 13492    14788      862   0       0          =
   0 mutt
[412243.856284] [13504]  1000 13504    19180      547   3       0          =
   0 i3bar
[412243.856287] [13505]  1000 13505     8066      633   2       0          =
   0 i3status
[412243.856289] [13897]  1000 13897    10964     2962   1       0          =
   0 zsh
[412243.856293] [18368]  1000 18368    15875     1450   2       0          =
   0 mutt
[412243.856296] [25693]  1000 25693     8806      807   3       0          =
   0 zsh
[412243.856299] [12076]  1000 12076     9025     1040   3       0          =
   0 zsh
[412243.856301] [13526]  1000 13526     9782     1792   3       0          =
   0 zsh
[412243.856303] [20336]  1000 20336    10171     2195   2       0          =
   0 zsh
[412243.856305] [20496]  1000 20496     8805      817   0       0          =
   0 zsh
[412243.856306] [22068]  1000 22068     8830      840   0       0          =
   0 zsh
[412243.856308] [32613]  1000 32613    14756      809   1       0          =
   0 mutt
[412243.856310] [25473]  1000 25473     8337      663   1       0          =
   0 vim
[412243.856312] [25480]  1000 25480     9031     1040   3       0          =
   0 zsh
[412243.856314] [26043]  1000 26043     2650      193   1       0          =
   0 ping
[412243.856315] [29752]  1000 29752     8205      885   1       0          =
   0 mosh-client
[412243.856318] [30789]  1000 30789     8765      779   2       0          =
   0 zsh
[412243.856319] [31242]  1000 31242    10062     2086   3       0          =
   0 zsh
[412243.856321] [ 3498]     0  3498     4755     2630   1       0          =
   0 atop
[412243.856323] [ 5991]  1000  5991   226988    10585   1       4          =
 300 chromium
[412243.856324] [ 6011]  1000  6011   222892     6708   1       4          =
 300 chromium
[412243.856326] [ 7830]  1000  7830   225890     9577   1       4          =
 300 chromium
[412243.856328] [ 7915]  1000  7915     8773      775   2       0          =
   0 zsh
[412243.856330] [12787]  1000 12787     9835     1837   3       0          =
   0 zsh
[412243.856331] [19881]  1000 19881     8794      807   2       0          =
   0 zsh
[412243.856333] [26144]  1000 26144   225043     9721   1       4          =
 300 chromium
[412243.856335] [30808]  1000 30808     8155      679   2       0          =
   0 zsh
[412243.856337] [ 2155]  1000  2155     8155      680   2       0          =
   0 zsh
[412243.856339] [ 2681]  1000  2681     4459      503   0       0          =
   0 man
[412243.856341] [ 2692]  1000  2692     2781      255   3       0          =
   0 less
[412243.856342] [ 3315]  1000  3315     4406     1851   1       0          =
   0 atop
[412243.856344] [ 3641]  1000  3641     8285      658   3       0          =
   0 vim
[412243.856346] [ 4252]  1000  4252     8835      831   2       0          =
   0 zsh
[412243.856348] [ 4452]  1000  4452   227004     9327   1       4          =
 300 chromium
[412243.856350] [ 4824]  1000  4824     8176      704   2       0          =
   0 zsh
[412243.856354] [ 6094]  1000  6094     9005      290   1       0          =
   0 ssh
[412243.856356] [ 6096]  1000  6096     8970      209   3       0          =
   0 ssh
[412243.856357] [ 6098]  1000  6098     8970      276   1       0          =
   0 ssh
[412243.856359] [ 8760]  1000  8760   222833     6877   3       4          =
 300 chromium
[412243.856361] [ 8769]  1000  8769     3424      269   0       0          =
   0 nz.sh
[412243.856362] [ 8771]  1000  8771     8347      731   3       0          =
   0 vim
[412243.856364] [ 8888]  1000  8888    44968      294   3       0          =
   0 evinced
[412243.856366] [ 8896]  1000  8896   129425    14815   1       0          =
   0 evince
[412243.856368] [ 9016]  1000  9016   140685    11764   1       0          =
   0 evince
[412243.856369] [ 9146]  1000  9146     8286      637   2       0          =
   0 vim
[412243.856371] [ 9150]  1000  9150     8769      771   0       0          =
   0 zsh
[412243.856373] [ 9158]  1000  9158     8286      608   1       0          =
   0 vim
[412243.856374] [ 9178]  1000  9178   228820    12507   2       4          =
 300 chromium
[412243.856376] [ 9234]  1000  9234   224790     8649   0       4          =
 300 chromium
[412243.856378] [ 9255]  1000  9255   227614    11584   0       4          =
 300 chromium
[412243.856380] [ 9263]  1000  9263   227627    15278   2       4          =
 300 chromium
[412243.856381] [10008]  1000 10008     8769      768   2       0          =
   0 zsh
[412243.856383] [11133]     0 11133     8481      281   0       0          =
   0 sudo
[412243.856385] [11137]     0 11137     3457      299   1       0          =
   0 ccollect
[412243.856387] [11142]     0 11142     3457      206   0       0          =
   0 ccollect
[412243.856388] [11143]     0 11143     3457      148   0       0          =
   0 ccollect
[412243.856390] [11144]     0 11144     2919      224   3       0          =
   0 awk
[412243.856392] [11196]     0 11196     1777      437   3       0          =
   0 rm
[412243.856394] [11239]    73 11239    16333      378   1       0          =
   0 pickup
[412243.856396] [11506]  1000 11506   222892     6520   2       4          =
 300 chromium
[412243.856398] [11517]  1000 11517     8748      765   0       0          =
   0 zsh
[412243.856399] [11525]  1000 11525   226484     8928   3       4          =
 300 chromium
[412243.856401] [11588]  1000 11588   230517    13839   3       4          =
 300 chromium
[412243.856403] [11639]     0 11639     5899      271   2       0          =
   0 vpnc
[412243.856405] [11794]  1000 11794   228300    10913   3       4          =
 300 chromium
[412243.856407] [11805]  1000 11805   225558     8523   1       4          =
 300 chromium
[412243.856409] [12411]     0 12411     9169      395   3       0          =
   0 crond
[412243.856410] [12413]  1000 12413     2937      209   2       0          =
   0 sh
[412243.856412] [12416]  1000 12416   171745     9749   0       0          =
   0 offlineimap
[412243.856414] [12535]     0 12535     9168      380   2       0          =
   0 crond
[412243.856415] Out of memory: Kill process 9263 (chromium) score 315 or sa=
crifice child
[412243.856418] Killed process 9263 (chromium) total-vm:910508kB, anon-rss:=
59832kB, file-rss:1280kB
[412385.838815] offlineimap invoked oom-killer: gfp_mask=3D0xd0, order=3D1,=
 oom_adj=3D0, oom_score_adj=3D0
[412385.838820] offlineimap cpuset=3D/ mems_allowed=3D0
[412385.838823] Pid: 12645, comm: offlineimap Tainted: G        W    3.5.4-=
1-ARCH #1
[412385.838825] Call Trace:
[412385.838832]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d=
/0xb0
[412385.838838]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[412385.838843]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[412385.838848]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[412385.838853]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[412385.838856]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[412385.838859]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[412385.838862]  [<ffffffff81140ea9>] ? handle_mm_fault+0x259/0x320
[412385.838865]  [<ffffffff8104f72b>] copy_process.part.21+0xeb/0x1530
[412385.838869]  [<ffffffff810870c8>] ? wake_up_new_task+0xf8/0x1a0
[412385.838871]  [<ffffffff81050cf5>] do_fork+0x135/0x3a0
[412385.838874]  [<ffffffff810adc92>] ? sys_futex+0x102/0x190
[412385.838876]  [<ffffffff8101dd18>] sys_clone+0x28/0x30
[412385.838878]  [<ffffffff814856f3>] stub_clone+0x13/0x20
[412385.838882]  [<ffffffff814853ed>] ? system_call_fastpath+0x1a/0x1f
[412385.838883] Mem-Info:
[412385.838884] Node 0 DMA per-cpu:
[412385.838887] CPU    0: hi:    0, btch:   1 usd:   0
[412385.838888] CPU    1: hi:    0, btch:   1 usd:   0
[412385.838889] CPU    2: hi:    0, btch:   1 usd:   0
[412385.838890] CPU    3: hi:    0, btch:   1 usd:   0
[412385.838891] Node 0 DMA32 per-cpu:
[412385.838893] CPU    0: hi:  186, btch:  31 usd:   8
[412385.838894] CPU    1: hi:  186, btch:  31 usd:   0
[412385.838895] CPU    2: hi:  186, btch:  31 usd:   1
[412385.838896] CPU    3: hi:  186, btch:  31 usd:  30
[412385.838897] Node 0 Normal per-cpu:
[412385.838898] CPU    0: hi:  186, btch:  31 usd:   0
[412385.838899] CPU    1: hi:  186, btch:  31 usd:   0
[412385.838901] CPU    2: hi:  186, btch:  31 usd:   0
[412385.838902] CPU    3: hi:  186, btch:  31 usd:   0
[412385.838905] active_anon:350753 inactive_anon:92762 isolated_anon:0
 active_file:135 inactive_file:215 isolated_file:39
 unevictable:3637 dirty:7 writeback:15 unstable:0
 free:23276 slab_reclaimable:483399 slab_unreclaimable:7567
 mapped:3306 shmem:126829 pagetables:7656 bounce:0
[412385.838907] Node 0 DMA free:15848kB min:260kB low:324kB high:388kB acti=
ve_anon:24kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictabl=
e:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dir=
ty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:32kB slab_unrecl=
aimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeba=
ck_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[412385.838911] lowmem_reserve[]: 0 2137 3899 3899
[412385.838913] Node 0 DMA32 free:46844kB min:36900kB low:46124kB high:5534=
8kB active_anon:484128kB inactive_anon:98664kB active_file:532kB inactive_f=
ile:832kB unevictable:4124kB isolated(anon):0kB isolated(file):156kB presen=
t:2188752kB mlocked:36kB dirty:24kB writeback:52kB mapped:5564kB shmem:1291=
28kB slab_reclaimable:1534052kB slab_unreclaimable:6628kB kernel_stack:656k=
B pagetables:1760kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned=
:3221 all_unreclaimable? yes
[412385.838918] lowmem_reserve[]: 0 0 1762 1762
[412385.838920] Node 0 Normal free:30412kB min:30416kB low:38020kB high:456=
24kB active_anon:918860kB inactive_anon:272384kB active_file:8kB inactive_f=
ile:28kB unevictable:10424kB isolated(anon):0kB isolated(file):0kB present:=
1804320kB mlocked:10424kB dirty:4kB writeback:8kB mapped:7660kB shmem:37818=
8kB slab_reclaimable:399512kB slab_unreclaimable:23640kB kernel_stack:2472k=
B pagetables:28864kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanne=
d:3438 all_unreclaimable? yes
[412385.838924] lowmem_reserve[]: 0 0 0 0
[412385.838926] Node 0 DMA: 2*4kB 2*8kB 1*16kB 4*32kB 3*64kB 3*128kB 3*256k=
B 2*512kB 3*1024kB 3*2048kB 1*4096kB =3D 15848kB
[412385.838932] Node 0 DMA32: 11187*4kB 10*8kB 0*16kB 0*32kB 0*64kB 0*128kB=
 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB =3D 46876kB
[412385.838938] Node 0 Normal: 2788*4kB 1418*8kB 381*16kB 4*32kB 0*64kB 0*1=
28kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB =3D 30768kB
[412385.838945] 128090 total pagecache pages
[412385.838946] 0 pages in swap cache
[412385.838947] Swap cache stats: add 0, delete 0, find 0/0
[412385.838948] Free swap  =3D 0kB
[412385.838948] Total swap =3D 0kB
[412385.850144] 1048048 pages RAM
[412385.850146] 57533 pages reserved
[412385.850147] 86043 pages shared
[412385.850149] 936740 pages non-shared
[412385.850150] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score=
_adj name
[412385.850157] [  191]     0   191     6555      410   3     -17         -=
1000 systemd-udevd
[412385.850160] [  194]     0   194    74644     1808   1       0          =
   0 systemd-journal
[412385.850163] [  301]     0   301     3302      311   2       0          =
   0 crond
[412385.850165] [  302]     0   302    17693      684   2       0          =
   0 cupsd
[412385.850167] [  304]     0   304    10502      326   1     -17         -=
1000 sshd
[412385.850170] [  305]    81   305     4433      304   0     -13          =
-900 dbus-daemon
[412385.850173] [  309]     0   309     6512      239   1       0          =
   0 systemd-logind
[412385.850175] [  315]     0   315    15747      318   2       0          =
   0 login
[412385.850178] [  316]     0   316     2031      193   0       0          =
   0 agetty
[412385.850180] [  317]     0   317     2031      189   0       0          =
   0 agetty
[412385.850183] [  319]     0   319     2031      191   1       0          =
   0 agetty
[412385.850185] [  320]     0   320     2031      192   1       0          =
   0 agetty
[412385.850188] [  321]     0   321     2031      191   1       0          =
   0 agetty
[412385.850191] [  325]     0   325    51901      562   3       0          =
   0 colord
[412385.850193] [  341]     0   341   123526     1044   1       0          =
   0 colord-sane
[412385.850196] [  395]     0   395     3092      226   1       0          =
   0 master
[412385.850198] [  399]    73   399    16380      419   1       0          =
   0 qmgr
[412385.850201] [  420]  1000   420     3423      283   2       0          =
   0 restart-x
[412385.850203] [  431]  1000   431     3423      298   3       0          =
   0 startx
[412385.850205] [  448]  1000   448     3966      147   3       0          =
   0 xinit
[412385.850208] [  449]  1000   449    92097     4587   3       0          =
   0 X
[412385.850210] [  470]  1000   470    24058      759   1       0          =
   0 i3
[412385.850213] [  477]  1000   477     6062      184   1       0          =
   0 unclutter
[412385.850215] [  480]  1000   480     6004      163   2       0          =
   0 dispad
[412385.850217] [  481]  1000   481    36623    12538   2       0          =
   0 urxvtd
[412385.850220] [  484]  1000   484     8068      476   1       0          =
   0 xbindkeys
[412385.850223] [  495]  1000   495     8155      656   2       0          =
   0 zsh
[412385.850226] [  505]  1000   505     8155      661   3       0          =
   0 zsh
[412385.850228] [  512]     0   512     8481      277   3       0          =
   0 sudo
[412385.850231] [  513]     0   513     6933      483   0       0          =
   0 zsh
[412385.850233] [  543]     0   543     7404      204   1       0          =
   0 wpa_supplicant
[412385.850235] [  659]  1000   659     9860     1868   2       0          =
   0 zsh
[412385.850237] [  772]  1000   772     4494       95   3       0          =
   0 dbus-launch
[412385.850240] [  773]  1000   773     4379      252   3       0          =
   0 dbus-daemon
[412385.850242] [ 1575]  1000  1575    10065     2058   1       0          =
   0 zsh
[412385.850245] [ 1959]  1000  1959     8748      756   1       0          =
   0 zsh
[412385.850247] [ 2835]  1000  2835    40320      829   3       0          =
   0 kdeinit4
[412385.850251] [ 2837]  1000  2837    48444      818   1       0          =
   0 klauncher
[412385.850254] [ 2841]  1000  2841   109726     1958   2       0          =
   0 kded4
[412385.850256] [ 2858]  1000  2858   238338     2709   1       0          =
   0 knotify4
[412385.850259] [ 2863]     0  2863    54958     1176   1       0          =
   0 upowerd
[412385.850262] [ 2868]     0  2868    46649      349   2     -13          =
-900 polkitd
[412385.850265] [ 2895]     0  2895    48362      445   1       0          =
   0 udisks-daemon
[412385.850268] [ 2904]     0  2904    11353      123   1       0          =
   0 udisks-daemon
[412385.850271] [ 6623]  1000  6623     8891      901   2       0          =
   0 zsh
[412385.850273] [ 8723]  1000  8723     8785      784   3       0          =
   0 zsh
[412385.850276] [14485]  1000 14485     8773      772   1       0          =
   0 zsh
[412385.850279] [30479]     0 30479     8481      278   1       0          =
   0 sudo
[412385.850281] [30480]     0 30480     6933      490   1       0          =
   0 zsh
[412385.850285] [ 1816]  1000  1816     8773      758   2       0          =
   0 zsh
[412385.850288] [ 2064]  1000  2064     9797     1778   3       0          =
   0 zsh
[412385.850290] [ 3202]  1000  3202     9839     1855   1       0          =
   0 zsh
[412385.850293] [13775]  1000 13775     8155      679   1       0          =
   0 zsh
[412385.850295] [13783]     0 13783     8481      279   2       0          =
   0 sudo
[412385.850298] [13784]     0 13784     6933      485   2       0          =
   0 zsh
[412385.850300] [14763]  1000 14763     8914      907   1       0          =
   0 zsh
[412385.850303] [29947]  1000 29947     5163      271   0       0          =
   0 zsh
[412385.850306] [29950]  1000 29950   164139    42476   3       0          =
   0 chromium
[412385.850308] [29952]  1000 29952    64978     1262   0       0          =
   0 chromium
[412385.850311] [29953]  1000 29953     1588      137   0       0          =
   0 chromium-sandbo
[412385.850314] [29954]  1000 29954    70030     1322   0       0          =
   0 chromium
[412385.850317] [29960]  1000 29960    34745      443   0       0          =
   0 nacl_helper_boo
[412385.850320] [29961]  1000 29961    76177     1182   3       0          =
   0 chromium
[412385.850323] [29990]  1000 29990   218552     5153   2       4          =
 300 chromium
[412385.850326] [29997]  1000 29997   227279    14891   2       4          =
 300 chromium
[412385.850328] [30004]  1000 30004   218991     5338   1       4          =
 300 chromium
[412385.850331] [20018]     0 20018     2136      155   1       0          =
   0 dhcpcd
[412385.850334] [20887]  1000 20887     9334     1324   2       0          =
   0 zsh
[412385.850336] [23649]  1000 23649    63938      841   1       0          =
   0 dconf-service
[412385.850338] [25961]  1000 25961    14690      761   2       0          =
   0 mutt
[412385.850341] [13576]     0 13576     4494       95   0       0          =
   0 dbus-launch
[412385.850344] [13577]     0 13577     4320      177   2       0          =
   0 dbus-daemon
[412385.850347] [15475]  1000 15475     9224     1221   1       0          =
   0 zsh
[412385.850350] [16635]  1000 16635     8845      865   0       0          =
   0 zsh
[412385.850352] [16929]  1000 16929     8716      706   0       0          =
   0 zsh
[412385.850355] [16982]  1000 16982    15494     1066   1       0          =
   0 mutt
[412385.850358] [17215]  1000 17215    10328     2341   1       0          =
   0 zsh
[412385.850361] [18001]  1000 18001     8769      774   2       0          =
   0 zsh
[412385.850364] [19150]  1000 19150    10512     2525   3       0          =
   0 zsh
[412385.850366] [19271]  1000 19271     8892      907   0       0          =
   0 zsh
[412385.850369] [21316]  1000 21316     8812      816   2       0          =
   0 zsh
[412385.850372] [21373]  1000 21373     8155      661   3       0          =
   0 zsh
[412385.850374] [21389]  1000 21389     8785      789   1       0          =
   0 zsh
[412385.850378] [21617]  1000 21617     8769      776   1       0          =
   0 zsh
[412385.850380] [22183]  1000 22183    14901      990   2       0          =
   0 mutt
[412385.850383] [23190]  1000 23190     8291      691   0       0          =
   0 vim
[412385.850386] [23191]  1000 23191     8291      625   1       0          =
   0 vim
[412385.850388] [23198]  1000 23198    10210     2220   3       0          =
   0 zsh
[412385.850391] [23246]  1000 23246     8743      744   0       0          =
   0 zsh
[412385.850394] [23266]  1000 23266     8730     1471   1       0          =
   0 python3
[412385.850397] [23269]  1000 23269     8290      589   1       0          =
   0 vim
[412385.850400] [32120]  1000 32120    16392     1944   2       0          =
   0 mutt
[412385.850403] [ 5745]  1000  5745     9866     1861   2       0          =
   0 zsh
[412385.850406] [ 5944]  1000  5944     9776     1769   3       0          =
   0 zsh
[412385.850409] [ 8651]  1000  8651    10239     2247   2       0          =
   0 zsh
[412385.850412] [10927]  1000 10927     8891      906   3       0          =
   0 zsh
[412385.850414] [13485]  1000 13485     8773      770   2       0          =
   0 zsh
[412385.850417] [13492]  1000 13492    14788      862   0       0          =
   0 mutt
[412385.850420] [13504]  1000 13504    19180      541   3       0          =
   0 i3bar
[412385.850423] [13505]  1000 13505     8066      623   1       0          =
   0 i3status
[412385.850426] [13897]  1000 13897    10964     2962   1       0          =
   0 zsh
[412385.850428] [18368]  1000 18368    15875     1429   3       0          =
   0 mutt
[412385.850431] [25693]  1000 25693     8806      807   3       0          =
   0 zsh
[412385.850434] [12076]  1000 12076     9025     1040   3       0          =
   0 zsh
[412385.850437] [13526]  1000 13526     9782     1792   3       0          =
   0 zsh
[412385.850440] [20336]  1000 20336    10171     2195   2       0          =
   0 zsh
[412385.850442] [20496]  1000 20496     8805      817   0       0          =
   0 zsh
[412385.850445] [22068]  1000 22068     8830      840   0       0          =
   0 zsh
[412385.850448] [32613]  1000 32613    14756      809   1       0          =
   0 mutt
[412385.850451] [25473]  1000 25473     8337      663   1       0          =
   0 vim
[412385.850454] [25480]  1000 25480     9031     1040   3       0          =
   0 zsh
[412385.850456] [26043]  1000 26043     2650      214   2       0          =
   0 ping
[412385.850459] [29752]  1000 29752     8205      900   2       0          =
   0 mosh-client
[412385.850462] [30789]  1000 30789     8765      779   2       0          =
   0 zsh
[412385.850464] [31242]  1000 31242    10062     2086   3       0          =
   0 zsh
[412385.850467] [ 3498]     0  3498     4755     2630   1       0          =
   0 atop
[412385.850470] [ 5991]  1000  5991   226988    10572   3       4          =
 300 chromium
[412385.850472] [ 6011]  1000  6011   222892     6665   2       4          =
 300 chromium
[412385.850475] [ 7830]  1000  7830   225890     9580   2       4          =
 300 chromium
[412385.850477] [ 7915]  1000  7915     8773      775   2       0          =
   0 zsh
[412385.850480] [12787]  1000 12787     9835     1837   3       0          =
   0 zsh
[412385.850483] [19881]  1000 19881     8794      807   2       0          =
   0 zsh
[412385.850486] [26144]  1000 26144   225043     9680   3       4          =
 300 chromium
[412385.850488] [30808]  1000 30808     8155      679   2       0          =
   0 zsh
[412385.850490] [ 2155]  1000  2155     8155      680   2       0          =
   0 zsh
[412385.850493] [ 2681]  1000  2681     4459      503   0       0          =
   0 man
[412385.850495] [ 2692]  1000  2692     2781      255   3       0          =
   0 less
[412385.850498] [ 3315]  1000  3315     4406     1851   2       0          =
   0 atop
[412385.850500] [ 3641]  1000  3641     8285      658   3       0          =
   0 vim
[412385.850503] [ 4252]  1000  4252     8835      831   2       0          =
   0 zsh
[412385.850505] [ 4452]  1000  4452   227004     9320   3       4          =
 300 chromium
[412385.850507] [ 4824]  1000  4824     8176      704   2       0          =
   0 zsh
[412385.850511] [ 6094]  1000  6094     9005      344   1       0          =
   0 ssh
[412385.850513] [ 6096]  1000  6096     8970      209   3       0          =
   0 ssh
[412385.850516] [ 6098]  1000  6098     8970      276   1       0          =
   0 ssh
[412385.850518] [ 8760]  1000  8760   222833     6882   3       4          =
 300 chromium
[412385.850521] [ 8769]  1000  8769     3424      269   0       0          =
   0 nz.sh
[412385.850524] [ 8771]  1000  8771     8347      731   3       0          =
   0 vim
[412385.850527] [ 8888]  1000  8888    44968      294   3       0          =
   0 evinced
[412385.850530] [ 8896]  1000  8896   129425    14835   3       0          =
   0 evince
[412385.850533] [ 9016]  1000  9016   140685    11764   1       0          =
   0 evince
[412385.850535] [ 9146]  1000  9146     8286      637   2       0          =
   0 vim
[412385.850538] [ 9150]  1000  9150     8769      771   0       0          =
   0 zsh
[412385.850541] [ 9158]  1000  9158     8286      608   1       0          =
   0 vim
[412385.850544] [ 9178]  1000  9178   228820    12514   1       4          =
 300 chromium
[412385.850547] [ 9234]  1000  9234   224790     8648   3       4          =
 300 chromium
[412385.850549] [ 9255]  1000  9255   227614    11610   1       4          =
 300 chromium
[412385.850553] [10008]  1000 10008     8769      768   2       0          =
   0 zsh
[412385.850556] [11133]     0 11133     8481      281   0       0          =
   0 sudo
[412385.850559] [11137]     0 11137     3457      299   1       0          =
   0 ccollect
[412385.850562] [11142]     0 11142     3457      206   0       0          =
   0 ccollect
[412385.850565] [11143]     0 11143     3457      148   0       0          =
   0 ccollect
[412385.850567] [11144]     0 11144     2919      224   3       0          =
   0 awk
[412385.850571] [11196]     0 11196     1942      607   2       0          =
   0 rm
[412385.850573] [11239]    73 11239    16333      356   3       0          =
   0 pickup
[412385.850577] [11506]  1000 11506   222892     6524   2       4          =
 300 chromium
[412385.850580] [11517]  1000 11517     8748      765   0       0          =
   0 zsh
[412385.850583] [11525]  1000 11525   226484     8578   2       4          =
 300 chromium
[412385.850585] [11588]  1000 11588   229493    12481   3       4          =
 300 chromium
[412385.850588] [11639]     0 11639     5899      300   3       0          =
   0 vpnc
[412385.850590] [11794]  1000 11794   229933    13716   3       4          =
 300 chromium
[412385.850593] [11805]  1000 11805   226070    10263   3       4          =
 300 chromium
[412385.850597] [12604]     0 12604     9169      395   0       0          =
   0 crond
[412385.850600] [12606]  1000 12606     2937      212   3       0          =
   0 sh
[412385.850603] [12608]  1000 12608   171551    13343   3       0          =
   0 offlineimap
[412385.850607] Out of memory: Kill process 29997 (chromium) score 315 or s=
acrifice child
[412385.850610] Killed process 29997 (chromium) total-vm:909116kB, anon-rss=
:59024kB, file-rss:540kB
[412633.628414] chromium invoked oom-killer: gfp_mask=3D0x201da, order=3D0,=
 oom_adj=3D0, oom_score_adj=3D0
[412633.628419] chromium cpuset=3D/ mems_allowed=3D0
[412633.628421] Pid: 29950, comm: chromium Tainted: G        W    3.5.4-1-A=
RCH #1
[412633.628423] Call Trace:
[412633.628431]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d=
/0xb0
[412633.628436]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[412633.628441]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[412633.628445]  [<ffffffff8111a274>] ? oom_unkillable_task+0x24/0xc0
[412633.628451]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[412633.628454]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[412633.628458]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[412633.628462]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[412633.628466]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[412633.628470]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[412633.628473]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[412633.628477]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[412633.628481]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[412633.628484]  [<ffffffff8117952a>] ? do_sync_readv_writev+0xda/0x120
[412633.628488]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[412633.628492]  [<ffffffff81143ae0>] ? find_vma+0x30/0x90
[412633.628497]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[412633.628500]  [<ffffffff8147ca19>] ? __schedule+0x439/0x920
[412633.628504]  [<ffffffff8147e765>] page_fault+0x25/0x30
[412633.628506] Mem-Info:
[412633.628508] Node 0 DMA per-cpu:
[412633.628511] CPU    0: hi:    0, btch:   1 usd:   0
[412633.628512] CPU    1: hi:    0, btch:   1 usd:   0
[412633.628514] CPU    2: hi:    0, btch:   1 usd:   0
[412633.628516] CPU    3: hi:    0, btch:   1 usd:   0
[412633.628517] Node 0 DMA32 per-cpu:
[412633.628520] CPU    0: hi:  186, btch:  31 usd: 170
[412633.628522] CPU    1: hi:  186, btch:  31 usd:   5
[412633.628524] CPU    2: hi:  186, btch:  31 usd:  55
[412633.628526] CPU    3: hi:  186, btch:  31 usd:  48
[412633.628527] Node 0 Normal per-cpu:
[412633.628529] CPU    0: hi:  186, btch:  31 usd:   0
[412633.628531] CPU    1: hi:  186, btch:  31 usd:   0
[412633.628533] CPU    2: hi:  186, btch:  31 usd:   0
[412633.628535] CPU    3: hi:  186, btch:  31 usd:   0
[412633.628539] active_anon:326943 inactive_anon:92411 isolated_anon:0
 active_file:232 inactive_file:325 isolated_file:0
 unevictable:3637 dirty:4 writeback:97 unstable:0
 free:22490 slab_reclaimable:507899 slab_unreclaimable:7565
 mapped:2127 shmem:125362 pagetables:7526 bounce:0
[412633.628543] Node 0 DMA free:15852kB min:260kB low:324kB high:388kB acti=
ve_anon:20kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictabl=
e:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dir=
ty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:32kB slab_unrecl=
aimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeba=
ck_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[412633.628549] lowmem_reserve[]: 0 2137 3899 3899
[412633.628553] Node 0 DMA32 free:43804kB min:36900kB low:46124kB high:5534=
8kB active_anon:451256kB inactive_anon:98744kB active_file:912kB inactive_f=
ile:1164kB unevictable:4124kB isolated(anon):0kB isolated(file):0kB present=
:2188752kB mlocked:36kB dirty:16kB writeback:376kB mapped:648kB shmem:12480=
4kB slab_reclaimable:1567740kB slab_unreclaimable:6580kB kernel_stack:568kB=
 pagetables:1548kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:=
3984 all_unreclaimable? yes
[412633.628559] lowmem_reserve[]: 0 0 1762 1762
[412633.628563] Node 0 Normal free:30304kB min:30416kB low:38020kB high:456=
24kB active_anon:856496kB inactive_anon:270900kB active_file:16kB inactive_=
file:136kB unevictable:10424kB isolated(anon):0kB isolated(file):0kB presen=
t:1804320kB mlocked:10424kB dirty:0kB writeback:12kB mapped:7860kB shmem:37=
6644kB slab_reclaimable:463824kB slab_unreclaimable:23680kB kernel_stack:26=
40kB pagetables:28556kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_sca=
nned:268 all_unreclaimable? yes
[412633.628569] lowmem_reserve[]: 0 0 0 0
[412633.628573] Node 0 DMA: 3*4kB 2*8kB 1*16kB 4*32kB 3*64kB 3*128kB 3*256k=
B 2*512kB 3*1024kB 3*2048kB 1*4096kB =3D 15852kB
[412633.628583] Node 0 DMA32: 9961*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0=
*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB =3D 43940kB
[412633.628592] Node 0 Normal: 3030*4kB 1013*8kB 511*16kB 3*32kB 0*64kB 0*1=
28kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB =3D 30544kB
[412633.628601] 126924 total pagecache pages
[412633.628603] 0 pages in swap cache
[412633.628605] Swap cache stats: add 0, delete 0, find 0/0
[412633.628606] Free swap  =3D 0kB
[412633.628607] Total swap =3D 0kB
[412633.641505] 1048048 pages RAM
[412633.641508] 57533 pages reserved
[412633.641509] 84775 pages shared
[412633.641510] 938255 pages non-shared
[412633.641511] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score=
_adj name
[412633.641518] [  191]     0   191     6555      410   3     -17         -=
1000 systemd-udevd
[412633.641520] [  194]     0   194    74640     2014   1       0          =
   0 systemd-journal
[412633.641524] [  301]     0   301     3302      311   1       0          =
   0 crond
[412633.641526] [  302]     0   302    17693      684   2       0          =
   0 cupsd
[412633.641528] [  304]     0   304    10502      326   1     -17         -=
1000 sshd
[412633.641531] [  305]    81   305     4433      287   1     -13          =
-900 dbus-daemon
[412633.641533] [  309]     0   309     6512      239   1       0          =
   0 systemd-logind
[412633.641536] [  315]     0   315    15747      318   2       0          =
   0 login
[412633.641538] [  316]     0   316     2031      193   0       0          =
   0 agetty
[412633.641540] [  317]     0   317     2031      189   0       0          =
   0 agetty
[412633.641543] [  319]     0   319     2031      191   1       0          =
   0 agetty
[412633.641545] [  320]     0   320     2031      192   1       0          =
   0 agetty
[412633.641547] [  321]     0   321     2031      191   1       0          =
   0 agetty
[412633.641550] [  325]     0   325    51901      562   3       0          =
   0 colord
[412633.641552] [  341]     0   341   123526     1044   1       0          =
   0 colord-sane
[412633.641554] [  395]     0   395     3092      232   3       0          =
   0 master
[412633.641557] [  399]    73   399    16380      419   1       0          =
   0 qmgr
[412633.641559] [  420]  1000   420     3423      283   2       0          =
   0 restart-x
[412633.641562] [  431]  1000   431     3423      298   3       0          =
   0 startx
[412633.641564] [  448]  1000   448     3966      147   3       0          =
   0 xinit
[412633.641567] [  449]  1000   449    91736     4585   0       0          =
   0 X
[412633.641569] [  470]  1000   470    24058      781   1       0          =
   0 i3
[412633.641571] [  477]  1000   477     6062      213   3       0          =
   0 unclutter
[412633.641574] [  480]  1000   480     6004      142   3       0          =
   0 dispad
[412633.641577] [  481]  1000   481    36623    12504   2       0          =
   0 urxvtd
[412633.641579] [  484]  1000   484     8068      476   1       0          =
   0 xbindkeys
[412633.641581] [  495]  1000   495     8155      656   2       0          =
   0 zsh
[412633.641584] [  505]  1000   505     8155      661   3       0          =
   0 zsh
[412633.641586] [  512]     0   512     8481      277   3       0          =
   0 sudo
[412633.641588] [  513]     0   513     6933      483   0       0          =
   0 zsh
[412633.641590] [  543]     0   543     7404      226   2       0          =
   0 wpa_supplicant
[412633.641593] [  659]  1000   659     9860     1868   2       0          =
   0 zsh
[412633.641595] [  772]  1000   772     4494       95   3       0          =
   0 dbus-launch
[412633.641597] [  773]  1000   773     4379      252   3       0          =
   0 dbus-daemon
[412633.641600] [ 1575]  1000  1575    10065     2058   1       0          =
   0 zsh
[412633.641602] [ 1959]  1000  1959     8748      756   1       0          =
   0 zsh
[412633.641604] [ 2835]  1000  2835    40320      829   3       0          =
   0 kdeinit4
[412633.641606] [ 2837]  1000  2837    48444      818   1       0          =
   0 klauncher
[412633.641609] [ 2841]  1000  2841   109726     1994   0       0          =
   0 kded4
[412633.641611] [ 2858]  1000  2858   238338     2683   0       0          =
   0 knotify4
[412633.641614] [ 2863]     0  2863    54958     1194   0       0          =
   0 upowerd
[412633.641616] [ 2868]     0  2868    46649      347   0     -13          =
-900 polkitd
[412633.641618] [ 2895]     0  2895    48362      445   1       0          =
   0 udisks-daemon
[412633.641621] [ 2904]     0  2904    11353      123   1       0          =
   0 udisks-daemon
[412633.641623] [ 6623]  1000  6623     8891      901   2       0          =
   0 zsh
[412633.641625] [ 8723]  1000  8723     8785      784   3       0          =
   0 zsh
[412633.641628] [14485]  1000 14485     8773      772   1       0          =
   0 zsh
[412633.641630] [30479]     0 30479     8481      278   1       0          =
   0 sudo
[412633.641632] [30480]     0 30480     6933      490   1       0          =
   0 zsh
[412633.641634] [ 1816]  1000  1816     8773      758   2       0          =
   0 zsh
[412633.641637] [ 2064]  1000  2064     9797     1778   3       0          =
   0 zsh
[412633.641639] [ 3202]  1000  3202     9839     1855   1       0          =
   0 zsh
[412633.641646] [13775]  1000 13775     8155      679   1       0          =
   0 zsh
[412633.641649] [13783]     0 13783     8481      279   2       0          =
   0 sudo
[412633.641651] [13784]     0 13784     6933      485   2       0          =
   0 zsh
[412633.641654] [14763]  1000 14763     8914      907   1       0          =
   0 zsh
[412633.641656] [29947]  1000 29947     5163      271   0       0          =
   0 zsh
[412633.641658] [29950]  1000 29950   164189    42351   3       0          =
   0 chromium
[412633.641660] [29952]  1000 29952    64978     1281   2       0          =
   0 chromium
[412633.641663] [29953]  1000 29953     1588      137   0       0          =
   0 chromium-sandbo
[412633.641665] [29954]  1000 29954    70030     1322   0       0          =
   0 chromium
[412633.641668] [29960]  1000 29960    34745      443   0       0          =
   0 nacl_helper_boo
[412633.641671] [29961]  1000 29961    76177     1171   3       0          =
   0 chromium
[412633.641673] [29990]  1000 29990   218535     5122   1       4          =
 300 chromium
[412633.641676] [30004]  1000 30004   218974     5280   2       4          =
 300 chromium
[412633.641678] [20018]     0 20018     2136      155   1       0          =
   0 dhcpcd
[412633.641680] [20887]  1000 20887     9334     1324   2       0          =
   0 zsh
[412633.641683] [23649]  1000 23649    63938      841   1       0          =
   0 dconf-service
[412633.641685] [25961]  1000 25961    14690      763   1       0          =
   0 mutt
[412633.641687] [13576]     0 13576     4494       95   0       0          =
   0 dbus-launch
[412633.641690] [13577]     0 13577     4320      177   2       0          =
   0 dbus-daemon
[412633.641692] [15475]  1000 15475     9224     1221   1       0          =
   0 zsh
[412633.641695] [16635]  1000 16635     8845      865   0       0          =
   0 zsh
[412633.641697] [16929]  1000 16929     8716      706   0       0          =
   0 zsh
[412633.641699] [16982]  1000 16982    15494     1066   1       0          =
   0 mutt
[412633.641702] [17215]  1000 17215    10328     2341   1       0          =
   0 zsh
[412633.641704] [18001]  1000 18001     8769      774   2       0          =
   0 zsh
[412633.641706] [19150]  1000 19150    10512     2525   3       0          =
   0 zsh
[412633.641708] [19271]  1000 19271     8892      907   0       0          =
   0 zsh
[412633.641710] [21316]  1000 21316     8812      816   2       0          =
   0 zsh
[412633.641713] [21373]  1000 21373     8155      661   3       0          =
   0 zsh
[412633.641715] [21389]  1000 21389     8785      789   1       0          =
   0 zsh
[412633.641717] [21617]  1000 21617     8769      776   1       0          =
   0 zsh
[412633.641720] [22183]  1000 22183    14901      990   2       0          =
   0 mutt
[412633.641722] [23190]  1000 23190     8291      691   0       0          =
   0 vim
[412633.641724] [23191]  1000 23191     8291      625   1       0          =
   0 vim
[412633.641728] [23198]  1000 23198    10210     2220   3       0          =
   0 zsh
[412633.641730] [23246]  1000 23246     8743      744   0       0          =
   0 zsh
[412633.641733] [23266]  1000 23266     8730     1471   1       0          =
   0 python3
[412633.641735] [23269]  1000 23269     8290      589   1       0          =
   0 vim
[412633.641738] [32120]  1000 32120    16392     1944   2       0          =
   0 mutt
[412633.641740] [ 5745]  1000  5745     9866     1861   2       0          =
   0 zsh
[412633.641743] [ 5944]  1000  5944     9776     1769   3       0          =
   0 zsh
[412633.641745] [ 8651]  1000  8651    10239     2247   2       0          =
   0 zsh
[412633.641748] [10927]  1000 10927     8891      906   3       0          =
   0 zsh
[412633.641750] [13485]  1000 13485     8773      770   2       0          =
   0 zsh
[412633.641752] [13492]  1000 13492    14788      851   2       0          =
   0 mutt
[412633.641755] [13504]  1000 13504    19180      541   3       0          =
   0 i3bar
[412633.641758] [13505]  1000 13505     8066      633   3       0          =
   0 i3status
[412633.641760] [13897]  1000 13897    10964     2962   1       0          =
   0 zsh
[412633.641763] [18368]  1000 18368    15875     1429   3       0          =
   0 mutt
[412633.641765] [25693]  1000 25693     8806      807   3       0          =
   0 zsh
[412633.641768] [12076]  1000 12076     9025     1040   3       0          =
   0 zsh
[412633.641771] [13526]  1000 13526     9782     1792   3       0          =
   0 zsh
[412633.641774] [20336]  1000 20336    10171     2195   2       0          =
   0 zsh
[412633.641776] [20496]  1000 20496     8805      817   0       0          =
   0 zsh
[412633.641779] [22068]  1000 22068     8830      840   0       0          =
   0 zsh
[412633.641782] [32613]  1000 32613    14756      809   1       0          =
   0 mutt
[412633.641784] [25473]  1000 25473     8337      663   1       0          =
   0 vim
[412633.641787] [25480]  1000 25480     9031     1040   3       0          =
   0 zsh
[412633.641790] [26043]  1000 26043     2650      228   3       0          =
   0 ping
[412633.641792] [29752]  1000 29752     8205      879   3       0          =
   0 mosh-client
[412633.641795] [30789]  1000 30789     8765      779   2       0          =
   0 zsh
[412633.641797] [31242]  1000 31242    10062     2086   3       0          =
   0 zsh
[412633.641800] [ 3498]     0  3498     4755     2630   1       0          =
   0 atop
[412633.641803] [ 5991]  1000  5991   226971    10577   1       4          =
 300 chromium
[412633.641806] [ 6011]  1000  6011   222875     6469   2       4          =
 300 chromium
[412633.641808] [ 7830]  1000  7830   225873     9362   1       4          =
 300 chromium
[412633.641811] [ 7915]  1000  7915     8773      775   2       0          =
   0 zsh
[412633.641814] [12787]  1000 12787     9835     1837   3       0          =
   0 zsh
[412633.641816] [19881]  1000 19881     8794      807   2       0          =
   0 zsh
[412633.641819] [26144]  1000 26144   225026     9246   3       4          =
 300 chromium
[412633.641822] [30808]  1000 30808     8155      679   2       0          =
   0 zsh
[412633.641824] [ 2155]  1000  2155     8155      680   2       0          =
   0 zsh
[412633.641827] [ 2681]  1000  2681     4459      503   0       0          =
   0 man
[412633.641829] [ 2692]  1000  2692     2781      255   3       0          =
   0 less
[412633.641832] [ 3315]  1000  3315     4406     1851   3       0          =
   0 atop
[412633.641834] [ 3641]  1000  3641     8285      658   3       0          =
   0 vim
[412633.641836] [ 4252]  1000  4252     8835      831   2       0          =
   0 zsh
[412633.641838] [ 4452]  1000  4452   226987     9174   3       4          =
 300 chromium
[412633.641841] [ 4824]  1000  4824     8176      704   2       0          =
   0 zsh
[412633.641845] [ 6094]  1000  6094     9005      309   1       0          =
   0 ssh
[412633.641847] [ 6096]  1000  6096     8970      209   3       0          =
   0 ssh
[412633.641849] [ 6098]  1000  6098     8970      296   1       0          =
   0 ssh
[412633.641851] [ 8760]  1000  8760   222816     6760   2       4          =
 300 chromium
[412633.641854] [ 8769]  1000  8769     3424      269   0       0          =
   0 nz.sh
[412633.641856] [ 8771]  1000  8771     8347      731   3       0          =
   0 vim
[412633.641858] [ 8888]  1000  8888    44968      294   3       0          =
   0 evinced
[412633.641860] [ 8896]  1000  8896   129425    14848   1       0          =
   0 evince
[412633.641863] [ 9016]  1000  9016   140685    11764   1       0          =
   0 evince
[412633.641866] [ 9146]  1000  9146     8286      637   2       0          =
   0 vim
[412633.641868] [ 9150]  1000  9150     8769      771   0       0          =
   0 zsh
[412633.641871] [ 9158]  1000  9158     8286      608   1       0          =
   0 vim
[412633.641874] [ 9178]  1000  9178   228803    12131   2       4          =
 300 chromium
[412633.641876] [ 9234]  1000  9234   224773     8494   2       4          =
 300 chromium
[412633.641879] [ 9255]  1000  9255   227597    11508   0       4          =
 300 chromium
[412633.641882] [10008]  1000 10008     8769      768   2       0          =
   0 zsh
[412633.641885] [11133]     0 11133     8481      281   0       0          =
   0 sudo
[412633.641888] [11137]     0 11137     3457      299   1       0          =
   0 ccollect
[412633.641890] [11142]     0 11142     3457      206   0       0          =
   0 ccollect
[412633.641893] [11143]     0 11143     3457      148   0       0          =
   0 ccollect
[412633.641895] [11144]     0 11144     2919      224   3       0          =
   0 awk
[412633.641898] [11196]     0 11196     1942      609   1       0          =
   0 rm
[412633.641901] [11239]    73 11239    16333      370   2       0          =
   0 pickup
[412633.641904] [11506]  1000 11506   222875     6135   0       4          =
 300 chromium
[412633.641907] [11517]  1000 11517     8748      765   0       0          =
   0 zsh
[412633.641910] [11525]  1000 11525   225699     7650   2       4          =
 300 chromium
[412633.641913] [11588]  1000 11588   229476    12832   3       4          =
 300 chromium
[412633.641915] [11639]     0 11639     5899      292   3       0          =
   0 vpnc
[412633.641918] [11794]  1000 11794   226235     9023   0       4          =
 300 chromium
[412633.641921] [11805]  1000 11805   224773     7752   0       4          =
 300 chromium
[412633.641925] [12783]  1000 12783   218199     2119   1       4          =
 300 chromium
[412633.641927] [12973]     0 12973     9169      395   3       0          =
   0 crond
[412633.641930] [12975]  1000 12975     2937      198   3       0          =
   0 sh
[412633.641932] [12978]  1000 12978   172265    12378   2       0          =
   0 offlineimap
[412633.641934] Out of memory: Kill process 11588 (chromium) score 312 or s=
acrifice child
[412633.641937] Killed process 11588 (chromium) total-vm:917904kB, anon-rss=
:50228kB, file-rss:1100kB
[412687.529326] offlineimap invoked oom-killer: gfp_mask=3D0xd0, order=3D1,=
 oom_adj=3D0, oom_score_adj=3D0
[412687.529331] offlineimap cpuset=3D/ mems_allowed=3D0
[412687.529333] Pid: 13227, comm: offlineimap Tainted: G        W    3.5.4-=
1-ARCH #1
[412687.529334] Call Trace:
[412687.529340]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d=
/0xb0
[412687.529344]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[412687.529348]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[412687.529352]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[412687.529356]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[412687.529359]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[412687.529362]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[412687.529365]  [<ffffffff81140ea9>] ? handle_mm_fault+0x259/0x320
[412687.529369]  [<ffffffff8104f72b>] copy_process.part.21+0xeb/0x1530
[412687.529371]  [<ffffffff81050cf5>] do_fork+0x135/0x3a0
[412687.529374]  [<ffffffff8101dd18>] sys_clone+0x28/0x30
[412687.529376]  [<ffffffff814856f3>] stub_clone+0x13/0x20
[412687.529379]  [<ffffffff814853ed>] ? system_call_fastpath+0x1a/0x1f
[412687.529380] Mem-Info:
[412687.529381] Node 0 DMA per-cpu:
[412687.529383] CPU    0: hi:    0, btch:   1 usd:   0
[412687.529384] CPU    1: hi:    0, btch:   1 usd:   0
[412687.529386] CPU    2: hi:    0, btch:   1 usd:   0
[412687.529387] CPU    3: hi:    0, btch:   1 usd:   0
[412687.529387] Node 0 DMA32 per-cpu:
[412687.529389] CPU    0: hi:  186, btch:  31 usd:   0
[412687.529391] CPU    1: hi:  186, btch:  31 usd:   0
[412687.529392] CPU    2: hi:  186, btch:  31 usd:   0
[412687.529393] CPU    3: hi:  186, btch:  31 usd:   0
[412687.529394] Node 0 Normal per-cpu:
[412687.529395] CPU    0: hi:  186, btch:  31 usd:   0
[412687.529396] CPU    1: hi:  186, btch:  31 usd:   0
[412687.529397] CPU    2: hi:  186, btch:  31 usd:   0
[412687.529398] CPU    3: hi:  186, btch:  31 usd:   0
[412687.529402] active_anon:312036 inactive_anon:94491 isolated_anon:0
 active_file:129 inactive_file:131 isolated_file:32
 unevictable:3637 dirty:0 writeback:55 unstable:0
 free:24051 slab_reclaimable:520050 slab_unreclaimable:7552
 mapped:4363 shmem:126246 pagetables:7345 bounce:0
[412687.529404] Node 0 DMA free:15848kB min:260kB low:324kB high:388kB acti=
ve_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable=
:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirt=
y:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:32kB slab_unrecla=
imable:0kB kernel_stack:24kB pagetables:0kB unstable:0kB bounce:0kB writeba=
ck_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[412687.529408] lowmem_reserve[]: 0 2137 3899 3899
[412687.529411] Node 0 DMA32 free:49944kB min:36900kB low:46124kB high:5534=
8kB active_anon:436880kB inactive_anon:96396kB active_file:476kB inactive_f=
ile:452kB unevictable:4124kB isolated(anon):0kB isolated(file):128kB presen=
t:2188752kB mlocked:36kB dirty:0kB writeback:220kB mapped:3544kB shmem:1224=
56kB slab_reclaimable:1580396kB slab_unreclaimable:6604kB kernel_stack:552k=
B pagetables:2148kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned=
:1544 all_unreclaimable? yes
[412687.529415] lowmem_reserve[]: 0 0 1762 1762
[412687.529417] Node 0 Normal free:30412kB min:30416kB low:38020kB high:456=
24kB active_anon:811264kB inactive_anon:281568kB active_file:40kB inactive_=
file:72kB unevictable:10424kB isolated(anon):0kB isolated(file):0kB present=
:1804320kB mlocked:10424kB dirty:0kB writeback:0kB mapped:13908kB shmem:382=
528kB slab_reclaimable:499772kB slab_unreclaimable:23604kB kernel_stack:258=
4kB pagetables:27232kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scan=
ned:169 all_unreclaimable? yes
[412687.529421] lowmem_reserve[]: 0 0 0 0
[412687.529424] Node 0 DMA: 2*4kB 2*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256k=
B 1*512kB 2*1024kB 2*2048kB 2*4096kB =3D 15848kB
[412687.529430] Node 0 DMA32: 10781*4kB 287*8kB 41*16kB 2*32kB 0*64kB 0*128=
kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB =3D 50236kB
[412687.529436] Node 0 Normal: 3192*4kB 840*8kB 570*16kB 1*32kB 0*64kB 0*12=
8kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB =3D 30688kB
[412687.529442] 127454 total pagecache pages
[412687.529443] 0 pages in swap cache
[412687.529444] Swap cache stats: add 0, delete 0, find 0/0
[412687.529445] Free swap  =3D 0kB
[412687.529446] Total swap =3D 0kB
[412687.538922] 1048048 pages RAM
[412687.538926] 57533 pages reserved
[412687.538927] 88959 pages shared
[412687.538928] 931756 pages non-shared
[412687.538929] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score=
_adj name
[412687.538936] [  191]     0   191     6555      410   3     -17         -=
1000 systemd-udevd
[412687.538939] [  194]     0   194    74640     2133   3       0          =
   0 systemd-journal
[412687.538942] [  301]     0   301     3302      311   2       0          =
   0 crond
[412687.538945] [  302]     0   302    17693      684   2       0          =
   0 cupsd
[412687.538948] [  304]     0   304    10502      326   1     -17         -=
1000 sshd
[412687.538950] [  305]    81   305     4433      298   1     -13          =
-900 dbus-daemon
[412687.538953] [  309]     0   309     6512      239   1       0          =
   0 systemd-logind
[412687.538956] [  315]     0   315    15747      318   2       0          =
   0 login
[412687.538958] [  316]     0   316     2031      193   0       0          =
   0 agetty
[412687.538960] [  317]     0   317     2031      189   0       0          =
   0 agetty
[412687.538963] [  319]     0   319     2031      191   1       0          =
   0 agetty
[412687.538965] [  320]     0   320     2031      192   1       0          =
   0 agetty
[412687.538968] [  321]     0   321     2031      191   1       0          =
   0 agetty
[412687.538971] [  325]     0   325    51901      562   3       0          =
   0 colord
[412687.538974] [  341]     0   341   123526     1044   1       0          =
   0 colord-sane
[412687.538977] [  395]     0   395     3092      202   3       0          =
   0 master
[412687.538979] [  399]    73   399    16380      389   2       0          =
   0 qmgr
[412687.538982] [  420]  1000   420     3423      283   2       0          =
   0 restart-x
[412687.538985] [  431]  1000   431     3423      298   3       0          =
   0 startx
[412687.538987] [  448]  1000   448     3966      147   3       0          =
   0 xinit
[412687.538990] [  449]  1000   449    90437     4495   1       0          =
   0 X
[412687.538994] [  470]  1000   470    24058      787   1       0          =
   0 i3
[412687.538996] [  477]  1000   477     6062      196   1       0          =
   0 unclutter
[412687.538999] [  480]  1000   480     6004      131   1       0          =
   0 dispad
[412687.539003] [  481]  1000   481    36623    12488   1       0          =
   0 urxvtd
[412687.539006] [  484]  1000   484     8068      476   1       0          =
   0 xbindkeys
[412687.539008] [  495]  1000   495     8155      656   2       0          =
   0 zsh
[412687.539011] [  505]  1000   505     8155      661   3       0          =
   0 zsh
[412687.539014] [  512]     0   512     8481      277   3       0          =
   0 sudo
[412687.539016] [  513]     0   513     6933      483   0       0          =
   0 zsh
[412687.539020] [  543]     0   543     7404      201   1       0          =
   0 wpa_supplicant
[412687.539022] [  659]  1000   659     9860     1868   2       0          =
   0 zsh
[412687.539025] [  772]  1000   772     4494       95   3       0          =
   0 dbus-launch
[412687.539028] [  773]  1000   773     4379      252   3       0          =
   0 dbus-daemon
[412687.539032] [ 1575]  1000  1575    10065     2058   1       0          =
   0 zsh
[412687.539034] [ 1959]  1000  1959     8748      756   1       0          =
   0 zsh
[412687.539037] [ 2835]  1000  2835    40320      829   3       0          =
   0 kdeinit4
[412687.539040] [ 2837]  1000  2837    48444      818   1       0          =
   0 klauncher
[412687.539042] [ 2841]  1000  2841   109726     2002   3       0          =
   0 kded4
[412687.539045] [ 2858]  1000  2858   238338     2692   1       0          =
   0 knotify4
[412687.539047] [ 2863]     0  2863    54958     1177   3       0          =
   0 upowerd
[412687.539050] [ 2868]     0  2868    46649      317   2     -13          =
-900 polkitd
[412687.539054] [ 2895]     0  2895    48362      445   1       0          =
   0 udisks-daemon
[412687.539057] [ 2904]     0  2904    11353      123   1       0          =
   0 udisks-daemon
[412687.539059] [ 6623]  1000  6623     8891      901   2       0          =
   0 zsh
[412687.539062] [ 8723]  1000  8723     8785      784   3       0          =
   0 zsh
[412687.539065] [14485]  1000 14485     8773      772   1       0          =
   0 zsh
[412687.539068] [30479]     0 30479     8481      278   1       0          =
   0 sudo
[412687.539071] [30480]     0 30480     6933      490   1       0          =
   0 zsh
[412687.539074] [ 1816]  1000  1816     8773      758   2       0          =
   0 zsh
[412687.539076] [ 2064]  1000  2064     9797     1778   3       0          =
   0 zsh
[412687.539079] [ 3202]  1000  3202     9839     1855   1       0          =
   0 zsh
[412687.539082] [13775]  1000 13775     8155      679   1       0          =
   0 zsh
[412687.539085] [13783]     0 13783     8481      279   2       0          =
   0 sudo
[412687.539088] [13784]     0 13784     6933      485   2       0          =
   0 zsh
[412687.539090] [14763]  1000 14763     8914      907   1       0          =
   0 zsh
[412687.539093] [29947]  1000 29947     5163      271   0       0          =
   0 zsh
[412687.539096] [29950]  1000 29950   164189    42395   2       0          =
   0 chromium
[412687.539099] [29952]  1000 29952    64978     1241   1       0          =
   0 chromium
[412687.539102] [29953]  1000 29953     1588      137   0       0          =
   0 chromium-sandbo
[412687.539104] [29954]  1000 29954    70030     1322   0       0          =
   0 chromium
[412687.539107] [29960]  1000 29960    34745      443   0       0          =
   0 nacl_helper_boo
[412687.539110] [29961]  1000 29961    76177     1212   3       0          =
   0 chromium
[412687.539112] [29990]  1000 29990   218535     5081   3       4          =
 300 chromium
[412687.539115] [30004]  1000 30004   218974     5296   1       4          =
 300 chromium
[412687.539118] [20018]     0 20018     2136      155   1       0          =
   0 dhcpcd
[412687.539121] [20887]  1000 20887     9334     1324   2       0          =
   0 zsh
[412687.539124] [23649]  1000 23649    63938      841   1       0          =
   0 dconf-service
[412687.539127] [25961]  1000 25961    14690      763   1       0          =
   0 mutt
[412687.539130] [13576]     0 13576     4494       95   0       0          =
   0 dbus-launch
[412687.539133] [13577]     0 13577     4320      177   2       0          =
   0 dbus-daemon
[412687.539136] [15475]  1000 15475     9224     1221   1       0          =
   0 zsh
[412687.539139] [16635]  1000 16635     8845      865   0       0          =
   0 zsh
[412687.539141] [16929]  1000 16929     8716      706   0       0          =
   0 zsh
[412687.539144] [16982]  1000 16982    15494     1045   3       0          =
   0 mutt
[412687.539147] [17215]  1000 17215    10328     2341   1       0          =
   0 zsh
[412687.539150] [18001]  1000 18001     8769      774   2       0          =
   0 zsh
[412687.539153] [19150]  1000 19150    10512     2525   3       0          =
   0 zsh
[412687.539155] [19271]  1000 19271     8892      907   0       0          =
   0 zsh
[412687.539158] [21316]  1000 21316     8812      816   2       0          =
   0 zsh
[412687.539161] [21373]  1000 21373     8155      661   3       0          =
   0 zsh
[412687.539164] [21389]  1000 21389     8785      789   1       0          =
   0 zsh
[412687.539168] [21617]  1000 21617     8769      776   1       0          =
   0 zsh
[412687.539171] [22183]  1000 22183    14901     1009   1       0          =
   0 mutt
[412687.539174] [23190]  1000 23190     8291      691   0       0          =
   0 vim
[412687.539176] [23191]  1000 23191     8291      625   1       0          =
   0 vim
[412687.539180] [23198]  1000 23198    10210     2220   3       0          =
   0 zsh
[412687.539182] [23246]  1000 23246     8743      744   0       0          =
   0 zsh
[412687.539185] [23266]  1000 23266     8730     1471   1       0          =
   0 python3
[412687.539188] [23269]  1000 23269     8290      589   1       0          =
   0 vim
[412687.539191] [32120]  1000 32120    16392     1965   3       0          =
   0 mutt
[412687.539194] [ 5745]  1000  5745     9866     1861   2       0          =
   0 zsh
[412687.539197] [ 5944]  1000  5944     9776     1769   3       0          =
   0 zsh
[412687.539200] [ 8651]  1000  8651    10239     2247   2       0          =
   0 zsh
[412687.539203] [10927]  1000 10927     8891      906   3       0          =
   0 zsh
[412687.539206] [13485]  1000 13485     8773      770   2       0          =
   0 zsh
[412687.539208] [13492]  1000 13492    14788      851   2       0          =
   0 mutt
[412687.539211] [13504]  1000 13504    19180      570   3       0          =
   0 i3bar
[412687.539214] [13505]  1000 13505     8066      603   3       0          =
   0 i3status
[412687.539217] [13897]  1000 13897    10964     2962   1       0          =
   0 zsh
[412687.539220] [18368]  1000 18368    15875     1429   3       0          =
   0 mutt
[412687.539223] [25693]  1000 25693     8806      807   3       0          =
   0 zsh
[412687.539225] [12076]  1000 12076     9025     1040   3       0          =
   0 zsh
[412687.539228] [13526]  1000 13526     9782     1792   3       0          =
   0 zsh
[412687.539231] [20336]  1000 20336    10171     2195   2       0          =
   0 zsh
[412687.539234] [20496]  1000 20496     8805      817   0       0          =
   0 zsh
[412687.539237] [22068]  1000 22068     8830      840   0       0          =
   0 zsh
[412687.539240] [32613]  1000 32613    14756      809   1       0          =
   0 mutt
[412687.539243] [25473]  1000 25473     8337      663   1       0          =
   0 vim
[412687.539246] [25480]  1000 25480     9031     1040   3       0          =
   0 zsh
[412687.539248] [26043]  1000 26043     2650      209   1       0          =
   0 ping
[412687.539251] [29752]  1000 29752     8205      901   3       0          =
   0 mosh-client
[412687.539254] [30789]  1000 30789     8765      779   2       0          =
   0 zsh
[412687.539257] [31242]  1000 31242    10062     2086   3       0          =
   0 zsh
[412687.539260] [ 3498]     0  3498     4755     2630   1       0          =
   0 atop
[412687.539263] [ 5991]  1000  5991   226971    10541   1       4          =
 300 chromium
[412687.539266] [ 6011]  1000  6011   222875     6481   1       4          =
 300 chromium
[412687.539269] [ 7830]  1000  7830   225873     9372   1       4          =
 300 chromium
[412687.539273] [ 7915]  1000  7915     8773      775   2       0          =
   0 zsh
[412687.539276] [12787]  1000 12787     9835     1837   3       0          =
   0 zsh
[412687.539278] [19881]  1000 19881     8794      807   2       0          =
   0 zsh
[412687.539281] [26144]  1000 26144   225026     9249   2       4          =
 300 chromium
[412687.539284] [30808]  1000 30808     8155      679   2       0          =
   0 zsh
[412687.539287] [ 2155]  1000  2155     8155      680   2       0          =
   0 zsh
[412687.539290] [ 2681]  1000  2681     4459      503   0       0          =
   0 man
[412687.539292] [ 2692]  1000  2692     2781      255   3       0          =
   0 less
[412687.539295] [ 3315]  1000  3315     4406     1851   1       0          =
   0 atop
[412687.539298] [ 3641]  1000  3641     8285      658   3       0          =
   0 vim
[412687.539301] [ 4252]  1000  4252     8835      831   2       0          =
   0 zsh
[412687.539304] [ 4452]  1000  4452   226987     9152   2       4          =
 300 chromium
[412687.539306] [ 4824]  1000  4824     8176      704   2       0          =
   0 zsh
[412687.539310] [ 6094]  1000  6094     9005      325   1       0          =
   0 ssh
[412687.539313] [ 6096]  1000  6096     8970      209   3       0          =
   0 ssh
[412687.539316] [ 6098]  1000  6098     8970      262   1       0          =
   0 ssh
[412687.539318] [ 8760]  1000  8760   222816     6739   3       4          =
 300 chromium
[412687.539321] [ 8769]  1000  8769     3424      269   0       0          =
   0 nz.sh
[412687.539324] [ 8771]  1000  8771     8347      731   3       0          =
   0 vim
[412687.539327] [ 8888]  1000  8888    44968      294   3       0          =
   0 evinced
[412687.539330] [ 8896]  1000  8896   129425    14832   2       0          =
   0 evince
[412687.539333] [ 9016]  1000  9016   140685    11783   3       0          =
   0 evince
[412687.539336] [ 9146]  1000  9146     8286      637   2       0          =
   0 vim
[412687.539338] [ 9150]  1000  9150     8769      771   0       0          =
   0 zsh
[412687.539341] [ 9158]  1000  9158     8286      608   1       0          =
   0 vim
[412687.539344] [ 9178]  1000  9178   228803    12143   1       4          =
 300 chromium
[412687.539347] [ 9234]  1000  9234   224773     8465   3       4          =
 300 chromium
[412687.539350] [ 9255]  1000  9255   227597    11577   2       4          =
 300 chromium
[412687.539352] [10008]  1000 10008     8769      768   2       0          =
   0 zsh
[412687.539355] [11133]     0 11133     8481      281   0       0          =
   0 sudo
[412687.539358] [11137]     0 11137     3457      299   1       0          =
   0 ccollect
[412687.539361] [11142]     0 11142     3457      206   0       0          =
   0 ccollect
[412687.539363] [11143]     0 11143     3457      148   0       0          =
   0 ccollect
[412687.539366] [11144]     0 11144     2919      224   3       0          =
   0 awk
[412687.539370] [11196]     0 11196     1942      589   3       0          =
   0 rm
[412687.539373] [11239]    73 11239    16333      359   1       0          =
   0 pickup
[412687.539376] [11506]  1000 11506   222875     6071   1       4          =
 300 chromium
[412687.539379] [11517]  1000 11517     8748      765   0       0          =
   0 zsh
[412687.539382] [11525]  1000 11525   225699     7599   3       4          =
 300 chromium
[412687.539385] [11639]     0 11639     5899      274   3       0          =
   0 vpnc
[412687.539388] [11794]  1000 11794   226235     9034   3       4          =
 300 chromium
[412687.539391] [11805]  1000 11805   224773     7157   3       4          =
 300 chromium
[412687.539395] [13179]  1000 13179   228145    12675   3       4          =
 300 chromium
[412687.539399] [13187]     0 13187     9169      395   1       0          =
   0 crond
[412687.539402] [13189]  1000 13189     2937      200   1       0          =
   0 sh
[412687.539405] [13191]  1000 13191   168987     2686   3       0          =
   0 offlineimap
[412687.539407] Out of memory: Kill process 13179 (chromium) score 312 or s=
acrifice child
[412687.539410] Killed process 13179 (chromium) total-vm:912580kB, anon-rss=
:40740kB, file-rss:9960kB
[412687.541171] offlineimap invoked oom-killer: gfp_mask=3D0xd0, order=3D1,=
 oom_adj=3D0, oom_score_adj=3D0
[412687.541174] offlineimap cpuset=3D/ mems_allowed=3D0
[412687.541177] Pid: 13227, comm: offlineimap Tainted: G        W    3.5.4-=
1-ARCH #1
[412687.541179] Call Trace:
[412687.541186]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d=
/0xb0
[412687.541190]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[412687.541195]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[412687.541200]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[412687.541204]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[412687.541207]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[412687.541212]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[412687.541216]  [<ffffffff81140ea9>] ? handle_mm_fault+0x259/0x320
[412687.541220]  [<ffffffff8104f72b>] copy_process.part.21+0xeb/0x1530
[412687.541223]  [<ffffffff81050cf5>] do_fork+0x135/0x3a0
[412687.541227]  [<ffffffff8101dd18>] sys_clone+0x28/0x30
[412687.541229]  [<ffffffff814856f3>] stub_clone+0x13/0x20
[412687.541233]  [<ffffffff814853ed>] ? system_call_fastpath+0x1a/0x1f
[412687.541235] Mem-Info:
[412687.541236] Node 0 DMA per-cpu:
[412687.541239] CPU    0: hi:    0, btch:   1 usd:   0
[412687.541241] CPU    1: hi:    0, btch:   1 usd:   0
[412687.541242] CPU    2: hi:    0, btch:   1 usd:   0
[412687.541244] CPU    3: hi:    0, btch:   1 usd:   0
[412687.541245] Node 0 DMA32 per-cpu:
[412687.541247] CPU    0: hi:  186, btch:  31 usd:  78
[412687.541249] CPU    1: hi:  186, btch:  31 usd:   0
[412687.541250] CPU    2: hi:  186, btch:  31 usd:  75
[412687.541252] CPU    3: hi:  186, btch:  31 usd: 151
[412687.541253] Node 0 Normal per-cpu:
[412687.541255] CPU    0: hi:  186, btch:  31 usd:   0
[412687.541257] CPU    1: hi:  186, btch:  31 usd:   0
[412687.541259] CPU    2: hi:  186, btch:  31 usd:   0
[412687.541260] CPU    3: hi:  186, btch:  31 usd:  14
[412687.541265] active_anon:314010 inactive_anon:92554 isolated_anon:0
 active_file:166 inactive_file:134 isolated_file:32
 unevictable:3637 dirty:0 writeback:55 unstable:0
 free:23805 slab_reclaimable:520050 slab_unreclaimable:7552
 mapped:2231 shmem:126246 pagetables:7345 bounce:0
[412687.541267] Node 0 DMA free:15848kB min:260kB low:324kB high:388kB acti=
ve_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable=
:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirt=
y:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:32kB slab_unrecla=
imable:0kB kernel_stack:24kB pagetables:0kB unstable:0kB bounce:0kB writeba=
ck_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[412687.541273] lowmem_reserve[]: 0 2137 3899 3899
[412687.541276] Node 0 DMA32 free:48960kB min:36900kB low:46124kB high:5534=
8kB active_anon:439692kB inactive_anon:93732kB active_file:624kB inactive_f=
ile:464kB unevictable:4124kB isolated(anon):0kB isolated(file):128kB presen=
t:2188752kB mlocked:36kB dirty:0kB writeback:220kB mapped:904kB shmem:12245=
6kB slab_reclaimable:1580396kB slab_unreclaimable:6604kB kernel_stack:552kB=
 pagetables:2148kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:=
3496 all_unreclaimable? yes
[412687.541282] lowmem_reserve[]: 0 0 1762 1762
[412687.541285] Node 0 Normal free:30412kB min:30416kB low:38020kB high:456=
24kB active_anon:816348kB inactive_anon:276484kB active_file:40kB inactive_=
file:72kB unevictable:10424kB isolated(anon):0kB isolated(file):0kB present=
:1804320kB mlocked:10424kB dirty:0kB writeback:0kB mapped:8020kB shmem:3825=
28kB slab_reclaimable:499772kB slab_unreclaimable:23604kB kernel_stack:2584=
kB pagetables:27232kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scann=
ed:898 all_unreclaimable? yes
[412687.541291] lowmem_reserve[]: 0 0 0 0
[412687.541294] Node 0 DMA: 2*4kB 2*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256k=
B 1*512kB 2*1024kB 2*2048kB 2*4096kB =3D 15848kB
[412687.541302] Node 0 DMA32: 10708*4kB 243*8kB 0*16kB 0*32kB 0*64kB 0*128k=
B 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB =3D 48872kB
[412687.541310] Node 0 Normal: 3161*4kB 840*8kB 570*16kB 1*32kB 0*64kB 0*12=
8kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB =3D 30564kB
[412687.541318] 127619 total pagecache pages
[412687.541319] 0 pages in swap cache
[412687.541321] Swap cache stats: add 0, delete 0, find 0/0
[412687.541322] Free swap  =3D 0kB
[412687.541324] Total swap =3D 0kB
[412687.554191] 1048048 pages RAM
[412687.554193] 57533 pages reserved
[412687.554194] 85599 pages shared
[412687.554196] 924370 pages non-shared
[412687.554201] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score=
_adj name
[412687.554209] [  191]     0   191     6555      410   3     -17         -=
1000 systemd-udevd
[412687.554211] [  194]     0   194    74640     2196   2       0          =
   0 systemd-journal
[412687.554215] [  301]     0   301     3302      311   2       0          =
   0 crond
[412687.554218] [  302]     0   302    17693      684   2       0          =
   0 cupsd
[412687.554221] [  304]     0   304    10502      326   1     -17         -=
1000 sshd
[412687.554224] [  305]    81   305     4433      298   1     -13          =
-900 dbus-daemon
[412687.554226] [  309]     0   309     6512      239   1       0          =
   0 systemd-logind
[412687.554229] [  315]     0   315    15747      318   2       0          =
   0 login
[412687.554232] [  316]     0   316     2031      193   0       0          =
   0 agetty
[412687.554235] [  317]     0   317     2031      189   0       0          =
   0 agetty
[412687.554238] [  319]     0   319     2031      191   1       0          =
   0 agetty
[412687.554240] [  320]     0   320     2031      192   1       0          =
   0 agetty
[412687.554243] [  321]     0   321     2031      191   1       0          =
   0 agetty
[412687.554245] [  325]     0   325    51901      562   3       0          =
   0 colord
[412687.554249] [  341]     0   341   123526     1044   1       0          =
   0 colord-sane
[412687.554251] [  395]     0   395     3092      202   3       0          =
   0 master
[412687.554254] [  399]    73   399    16380      389   2       0          =
   0 qmgr
[412687.554257] [  420]  1000   420     3423      283   2       0          =
   0 restart-x
[412687.554261] [  431]  1000   431     3423      298   3       0          =
   0 startx
[412687.554264] [  448]  1000   448     3966      147   3       0          =
   0 xinit
[412687.554266] [  449]  1000   449    90437     4495   1       0          =
   0 X
[412687.554269] [  470]  1000   470    24058      787   1       0          =
   0 i3
[412687.554271] [  477]  1000   477     6062      196   1       0          =
   0 unclutter
[412687.554274] [  480]  1000   480     6004      131   1       0          =
   0 dispad
[412687.554277] [  481]  1000   481    36623    12488   1       0          =
   0 urxvtd
[412687.554279] [  484]  1000   484     8068      476   1       0          =
   0 xbindkeys
[412687.554283] [  495]  1000   495     8155      656   2       0          =
   0 zsh
[412687.554285] [  505]  1000   505     8155      661   3       0          =
   0 zsh
[412687.554288] [  512]     0   512     8481      277   3       0          =
   0 sudo
[412687.554291] [  513]     0   513     6933      483   0       0          =
   0 zsh
[412687.554293] [  543]     0   543     7404      201   1       0          =
   0 wpa_supplicant
[412687.554296] [  659]  1000   659     9860     1868   2       0          =
   0 zsh
[412687.554299] [  772]  1000   772     4494       95   3       0          =
   0 dbus-launch
[412687.554301] [  773]  1000   773     4379      252   3       0          =
   0 dbus-daemon
[412687.554305] [ 1575]  1000  1575    10065     2058   1       0          =
   0 zsh
[412687.554307] [ 1959]  1000  1959     8748      756   1       0          =
   0 zsh
[412687.554310] [ 2835]  1000  2835    40320      829   3       0          =
   0 kdeinit4
[412687.554313] [ 2837]  1000  2837    48444      818   1       0          =
   0 klauncher
[412687.554316] [ 2841]  1000  2841   109726     2002   3       0          =
   0 kded4
[412687.554318] [ 2858]  1000  2858   238338     2692   1       0          =
   0 knotify4
[412687.554321] [ 2863]     0  2863    54958     1177   3       0          =
   0 upowerd
[412687.554325] [ 2868]     0  2868    46649      317   2     -13          =
-900 polkitd
[412687.554327] [ 2895]     0  2895    48362      445   1       0          =
   0 udisks-daemon
[412687.554330] [ 2904]     0  2904    11353      123   1       0          =
   0 udisks-daemon
[412687.554333] [ 6623]  1000  6623     8891      901   2       0          =
   0 zsh
[412687.554335] [ 8723]  1000  8723     8785      784   3       0          =
   0 zsh
[412687.554338] [14485]  1000 14485     8773      772   1       0          =
   0 zsh
[412687.554341] [30479]     0 30479     8481      278   1       0          =
   0 sudo
[412687.554343] [30480]     0 30480     6933      490   1       0          =
   0 zsh
[412687.554346] [ 1816]  1000  1816     8773      758   2       0          =
   0 zsh
[412687.554349] [ 2064]  1000  2064     9797     1778   3       0          =
   0 zsh
[412687.554352] [ 3202]  1000  3202     9839     1855   1       0          =
   0 zsh
[412687.554355] [13775]  1000 13775     8155      679   1       0          =
   0 zsh
[412687.554358] [13783]     0 13783     8481      279   2       0          =
   0 sudo
[412687.554361] [13784]     0 13784     6933      485   2       0          =
   0 zsh
[412687.554363] [14763]  1000 14763     8914      907   1       0          =
   0 zsh
[412687.554366] [29947]  1000 29947     5163      271   0       0          =
   0 zsh
[412687.554369] [29950]  1000 29950   164189    42395   2       0          =
   0 chromium
[412687.554373] [29952]  1000 29952    64978     1241   1       0          =
   0 chromium
[412687.554375] [29953]  1000 29953     1588      137   0       0          =
   0 chromium-sandbo
[412687.554378] [29954]  1000 29954    70030     1322   0       0          =
   0 chromium
[412687.554380] [29960]  1000 29960    34745      443   0       0          =
   0 nacl_helper_boo
[412687.554383] [29961]  1000 29961    76177     1212   3       0          =
   0 chromium
[412687.554386] [29990]  1000 29990   218535     5081   3       4          =
 300 chromium
[412687.554388] [30004]  1000 30004   218974     5296   1       4          =
 300 chromium
[412687.554392] [20018]     0 20018     2136      155   1       0          =
   0 dhcpcd
[412687.554395] [20887]  1000 20887     9334     1324   2       0          =
   0 zsh
[412687.554398] [23649]  1000 23649    63938      841   1       0          =
   0 dconf-service
[412687.554401] [25961]  1000 25961    14690      763   1       0          =
   0 mutt
[412687.554403] [13576]     0 13576     4494       95   0       0          =
   0 dbus-launch
[412687.554406] [13577]     0 13577     4320      177   2       0          =
   0 dbus-daemon
[412687.554409] [15475]  1000 15475     9224     1221   1       0          =
   0 zsh
[412687.554412] [16635]  1000 16635     8845      865   0       0          =
   0 zsh
[412687.554415] [16929]  1000 16929     8716      706   0       0          =
   0 zsh
[412687.554418] [16982]  1000 16982    15494     1045   3       0          =
   0 mutt
[412687.554420] [17215]  1000 17215    10328     2341   1       0          =
   0 zsh
[412687.554423] [18001]  1000 18001     8769      774   2       0          =
   0 zsh
[412687.554425] [19150]  1000 19150    10512     2525   3       0          =
   0 zsh
[412687.554428] [19271]  1000 19271     8892      907   0       0          =
   0 zsh
[412687.554430] [21316]  1000 21316     8812      816   2       0          =
   0 zsh
[412687.554434] [21373]  1000 21373     8155      661   3       0          =
   0 zsh
[412687.554436] [21389]  1000 21389     8785      789   1       0          =
   0 zsh
[412687.554439] [21617]  1000 21617     8769      776   1       0          =
   0 zsh
[412687.554442] [22183]  1000 22183    14901     1009   1       0          =
   0 mutt
[412687.554445] [23190]  1000 23190     8291      691   0       0          =
   0 vim
[412687.554447] [23191]  1000 23191     8291      625   1       0          =
   0 vim
[412687.554450] [23198]  1000 23198    10210     2220   3       0          =
   0 zsh
[412687.554453] [23246]  1000 23246     8743      744   0       0          =
   0 zsh
[412687.554455] [23266]  1000 23266     8730     1471   1       0          =
   0 python3
[412687.554458] [23269]  1000 23269     8290      589   1       0          =
   0 vim
[412687.554461] [32120]  1000 32120    16392     1965   2       0          =
   0 mutt
[412687.554463] [ 5745]  1000  5745     9866     1861   2       0          =
   0 zsh
[412687.554466] [ 5944]  1000  5944     9776     1769   3       0          =
   0 zsh
[412687.554469] [ 8651]  1000  8651    10239     2247   2       0          =
   0 zsh
[412687.554471] [10927]  1000 10927     8891      906   3       0          =
   0 zsh
[412687.554474] [13485]  1000 13485     8773      770   2       0          =
   0 zsh
[412687.554476] [13492]  1000 13492    14788      851   2       0          =
   0 mutt
[412687.554479] [13504]  1000 13504    19180      570   3       0          =
   0 i3bar
[412687.554482] [13505]  1000 13505     8066      603   3       0          =
   0 i3status
[412687.554484] [13897]  1000 13897    10964     2962   1       0          =
   0 zsh
[412687.554487] [18368]  1000 18368    15875     1429   3       0          =
   0 mutt
[412687.554491] [25693]  1000 25693     8806      807   3       0          =
   0 zsh
[412687.554494] [12076]  1000 12076     9025     1040   3       0          =
   0 zsh
[412687.554496] [13526]  1000 13526     9782     1792   3       0          =
   0 zsh
[412687.554499] [20336]  1000 20336    10171     2195   2       0          =
   0 zsh
[412687.554501] [20496]  1000 20496     8805      817   0       0          =
   0 zsh
[412687.554504] [22068]  1000 22068     8830      840   0       0          =
   0 zsh
[412687.554506] [32613]  1000 32613    14756      809   1       0          =
   0 mutt
[412687.554510] [25473]  1000 25473     8337      663   1       0          =
   0 vim
[412687.554512] [25480]  1000 25480     9031     1040   3       0          =
   0 zsh
[412687.554515] [26043]  1000 26043     2650      209   1       0          =
   0 ping
[412687.554519] [29752]  1000 29752     8205      901   3       0          =
   0 mosh-client
[412687.554521] [30789]  1000 30789     8765      779   2       0          =
   0 zsh
[412687.554524] [31242]  1000 31242    10062     2086   3       0          =
   0 zsh
[412687.554527] [ 3498]     0  3498     4755     2630   1       0          =
   0 atop
[412687.554529] [ 5991]  1000  5991   226971    10541   1       4          =
 300 chromium
[412687.554532] [ 6011]  1000  6011   222875     6481   1       4          =
 300 chromium
[412687.554535] [ 7830]  1000  7830   225873     9372   1       4          =
 300 chromium
[412687.554538] [ 7915]  1000  7915     8773      775   2       0          =
   0 zsh
[412687.554541] [12787]  1000 12787     9835     1837   3       0          =
   0 zsh
[412687.554543] [19881]  1000 19881     8794      807   2       0          =
   0 zsh
[412687.554546] [26144]  1000 26144   225026     9249   2       4          =
 300 chromium
[412687.554549] [30808]  1000 30808     8155      679   2       0          =
   0 zsh
[412687.554552] [ 2155]  1000  2155     8155      680   2       0          =
   0 zsh
[412687.554554] [ 2681]  1000  2681     4459      503   0       0          =
   0 man
[412687.554558] [ 2692]  1000  2692     2781      255   3       0          =
   0 less
[412687.554561] [ 3315]  1000  3315     4406     1851   1       0          =
   0 atop
[412687.554563] [ 3641]  1000  3641     8285      658   3       0          =
   0 vim
[412687.554566] [ 4252]  1000  4252     8835      831   2       0          =
   0 zsh
[412687.554568] [ 4452]  1000  4452   226987     9152   2       4          =
 300 chromium
[412687.554571] [ 4824]  1000  4824     8176      704   2       0          =
   0 zsh
[412687.554575] [ 6094]  1000  6094     9005      325   1       0          =
   0 ssh
[412687.554577] [ 6096]  1000  6096     8970      209   3       0          =
   0 ssh
[412687.554579] [ 6098]  1000  6098     8970      262   1       0          =
   0 ssh
[412687.554583] [ 8760]  1000  8760   222816     6739   3       4          =
 300 chromium
[412687.554586] [ 8769]  1000  8769     3424      269   0       0          =
   0 nz.sh
[412687.554588] [ 8771]  1000  8771     8347      731   3       0          =
   0 vim
[412687.554591] [ 8888]  1000  8888    44968      294   3       0          =
   0 evinced
[412687.554594] [ 8896]  1000  8896   129425    14832   2       0          =
   0 evince
[412687.554597] [ 9016]  1000  9016   140685    11783   3       0          =
   0 evince
[412687.554599] [ 9146]  1000  9146     8286      637   2       0          =
   0 vim
[412687.554602] [ 9150]  1000  9150     8769      771   0       0          =
   0 zsh
[412687.554605] [ 9158]  1000  9158     8286      608   1       0          =
   0 vim
[412687.554608] [ 9178]  1000  9178   228803    12143   1       4          =
 300 chromium
[412687.554611] [ 9234]  1000  9234   224773     8465   3       4          =
 300 chromium
[412687.554613] [ 9255]  1000  9255   227597    11577   2       4          =
 300 chromium
[412687.554616] [10008]  1000 10008     8769      768   2       0          =
   0 zsh
[412687.554619] [11133]     0 11133     8481      281   0       0          =
   0 sudo
[412687.554622] [11137]     0 11137     3457      299   1       0          =
   0 ccollect
[412687.554626] [11142]     0 11142     3457      206   0       0          =
   0 ccollect
[412687.554628] [11143]     0 11143     3457      148   0       0          =
   0 ccollect
[412687.554631] [11144]     0 11144     2919      224   3       0          =
   0 awk
[412687.554634] [11196]     0 11196     1942      589   3       0          =
   0 rm
[412687.554637] [11239]    73 11239    16333      359   1       0          =
   0 pickup
[412687.554640] [11506]  1000 11506   222875     6071   1       4          =
 300 chromium
[412687.554643] [11517]  1000 11517     8748      765   0       0          =
   0 zsh
[412687.554646] [11525]  1000 11525   225699     7599   3       4          =
 300 chromium
[412687.554649] [11639]     0 11639     5899      274   3       0          =
   0 vpnc
[412687.554652] [11794]  1000 11794   226235     9034   3       4          =
 300 chromium
[412687.554654] [11805]  1000 11805   224773     7157   3       4          =
 300 chromium
[412687.554658] [13187]     0 13187     9169      395   1       0          =
   0 crond
[412687.554661] [13189]  1000 13189     2937      200   1       0          =
   0 sh
[412687.554663] [13191]  1000 13191   168987     2686   3       0          =
   0 offlineimap
[412687.554667] Out of memory: Kill process 9178 (chromium) score 312 or sa=
crifice child
[412687.554670] Killed process 9178 (chromium) total-vm:915212kB, anon-rss:=
47456kB, file-rss:1116kB
[413034.345922] CPU2: Core temperature above threshold, cpu clock throttled=
 (total events =3D 18725)
[413034.345925] CPU3: Package temperature above threshold, cpu clock thrott=
led (total events =3D 69634)
[413034.345926] CPU1: Package temperature above threshold, cpu clock thrott=
led (total events =3D 69634)
[413034.345928] CPU0: Core temperature above threshold, cpu clock throttled=
 (total events =3D 18725)
[413034.345930] CPU0: Package temperature above threshold, cpu clock thrott=
led (total events =3D 69634)
[413034.345935] CPU2: Package temperature above threshold, cpu clock thrott=
led (total events =3D 69634)
[413034.347949] CPU3: Package temperature/speed normal
[413034.347950] CPU1: Package temperature/speed normal
[413034.347952] CPU2: Core temperature/speed normal
[413034.347953] CPU0: Core temperature/speed normal
[413034.347955] CPU2: Package temperature/speed normal
[413034.347956] CPU0: Package temperature/speed normal
[413424.593675] chromium invoked oom-killer: gfp_mask=3D0x201da, order=3D0,=
 oom_adj=3D4, oom_score_adj=3D300
[413424.593679] chromium cpuset=3D/ mems_allowed=3D0
[413424.593681] Pid: 29990, comm: chromium Tainted: G        W    3.5.4-1-A=
RCH #1
[413424.593682] Call Trace:
[413424.593688]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d=
/0xb0
[413424.593692]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[413424.593696]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[413424.593701]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[413424.593705]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[413424.593708]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[413424.593711]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[413424.593714]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[413424.593716]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[413424.593718]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[413424.593721]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[413424.593724]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[413424.593727]  [<ffffffff81078eb0>] ? update_rmtp+0x70/0x70
[413424.593730]  [<ffffffff81079a54>] ? hrtimer_start_range_ns+0x14/0x20
[413424.593732]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[413424.593735]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[413424.593738]  [<ffffffff810adc92>] ? sys_futex+0x102/0x190
[413424.593740]  [<ffffffff8147e765>] page_fault+0x25/0x30
[413424.593742] Mem-Info:
[413424.593743] Node 0 DMA per-cpu:
[413424.593745] CPU    0: hi:    0, btch:   1 usd:   0
[413424.593746] CPU    1: hi:    0, btch:   1 usd:   0
[413424.593747] CPU    2: hi:    0, btch:   1 usd:   0
[413424.593748] CPU    3: hi:    0, btch:   1 usd:   0
[413424.593749] Node 0 DMA32 per-cpu:
[413424.593751] CPU    0: hi:  186, btch:  31 usd:  17
[413424.593752] CPU    1: hi:  186, btch:  31 usd:  30
[413424.593753] CPU    2: hi:  186, btch:  31 usd: 122
[413424.593755] CPU    3: hi:  186, btch:  31 usd:  28
[413424.593755] Node 0 Normal per-cpu:
[413424.593757] CPU    0: hi:  186, btch:  31 usd:   0
[413424.593758] CPU    1: hi:  186, btch:  31 usd:   0
[413424.593759] CPU    2: hi:  186, btch:  31 usd:   0
[413424.593760] CPU    3: hi:  186, btch:  31 usd:   0
[413424.593764] active_anon:138966 inactive_anon:106387 isolated_anon:0
 active_file:60 inactive_file:49 isolated_file:0
 unevictable:2629 dirty:1 writeback:0 unstable:0
 free:22544 slab_reclaimable:688966 slab_unreclaimable:7281
 mapped:2216 shmem:107956 pagetables:4013 bounce:0
[413424.593766] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB acti=
ve_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable=
:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirt=
y:0kB writeback:0kB mapped:4kB shmem:0kB slab_reclaimable:32kB slab_unrecla=
imable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writebac=
k_tmp:0kB pages_scanned:364 all_unreclaimable? yes
[413424.593770] lowmem_reserve[]: 0 2137 3899 3899
[413424.593773] Node 0 DMA32 free:43924kB min:36900kB low:46124kB high:5534=
8kB active_anon:140308kB inactive_anon:99304kB active_file:236kB inactive_f=
ile:72kB unevictable:4096kB isolated(anon):0kB isolated(file):0kB present:2=
188752kB mlocked:8kB dirty:4kB writeback:0kB mapped:372kB shmem:100020kB sl=
ab_reclaimable:1884100kB slab_unreclaimable:6144kB kernel_stack:152kB paget=
ables:616kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:11835 a=
ll_unreclaimable? yes
[413424.593778] lowmem_reserve[]: 0 0 1762 1762
[413424.593780] Node 0 Normal free:30412kB min:30416kB low:38020kB high:456=
24kB active_anon:415556kB inactive_anon:326244kB active_file:8kB inactive_f=
ile:136kB unevictable:6420kB isolated(anon):0kB isolated(file):0kB present:=
1804320kB mlocked:6420kB dirty:0kB writeback:0kB mapped:8488kB shmem:331804=
kB slab_reclaimable:871732kB slab_unreclaimable:22980kB kernel_stack:1720kB=
 pagetables:15436kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned=
:2839 all_unreclaimable? yes
[413424.593784] lowmem_reserve[]: 0 0 0 0
[413424.593786] Node 0 DMA: 2*4kB 2*8kB 2*16kB 4*32kB 3*64kB 3*128kB 3*256k=
B 2*512kB 3*1024kB 3*2048kB 1*4096kB =3D 15864kB
[413424.593793] Node 0 DMA32: 2938*4kB 3336*8kB 66*16kB 1*32kB 0*64kB 0*128=
kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB =3D 43624kB
[413424.593799] Node 0 Normal: 2838*4kB 1244*8kB 450*16kB 1*32kB 0*64kB 0*1=
28kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB =3D 30584kB
[413424.593805] 108903 total pagecache pages
[413424.593806] 0 pages in swap cache
[413424.593807] Swap cache stats: add 0, delete 0, find 0/0
[413424.593808] Free swap  =3D 0kB
[413424.593809] Total swap =3D 0kB
[413424.604855] 1048048 pages RAM
[413424.604857] 57533 pages reserved
[413424.604859] 52698 pages shared
[413424.604860] 940312 pages non-shared
[413424.604861] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score=
_adj name
[413424.604868] [  191]     0   191     6555      406   0     -17         -=
1000 systemd-udevd
[413424.604871] [  194]     0   194    74640     2321   3       0          =
   0 systemd-journal
[413424.604874] [  301]     0   301     3302      302   0       0          =
   0 crond
[413424.604876] [  302]     0   302    17693      680   2       0          =
   0 cupsd
[413424.604879] [  304]     0   304    10502      322   1     -17         -=
1000 sshd
[413424.604881] [  305]    81   305     4433      318   3     -13          =
-900 dbus-daemon
[413424.604883] [  309]     0   309     6512      194   1       0          =
   0 systemd-logind
[413424.604886] [  315]     0   315    15747      314   2       0          =
   0 login
[413424.604888] [  316]     0   316     2031      190   0       0          =
   0 agetty
[413424.604891] [  317]     0   317     2031      186   0       0          =
   0 agetty
[413424.604893] [  319]     0   319     2031      188   1       0          =
   0 agetty
[413424.604895] [  320]     0   320     2031      189   1       0          =
   0 agetty
[413424.604898] [  321]     0   321     2031      188   1       0          =
   0 agetty
[413424.604900] [  325]     0   325    51901      515   3       0          =
   0 colord
[413424.604902] [  341]     0   341   123526     1044   1       0          =
   0 colord-sane
[413424.604904] [  395]     0   395     3092      240   0       0          =
   0 master
[413424.604907] [  399]    73   399    16380      399   3       0          =
   0 qmgr
[413424.604910] [  420]  1000   420     3423      283   2       0          =
   0 restart-x
[413424.604912] [  431]  1000   431     3423      298   3       0          =
   0 startx
[413424.604914] [  448]  1000   448     3966      147   3       0          =
   0 xinit
[413424.604916] [  449]  1000   449    83627     4561   0       0          =
   0 X
[413424.604919] [  470]  1000   470    24058      792   1       0          =
   0 i3
[413424.604921] [  477]  1000   477     6062      195   1       0          =
   0 unclutter
[413424.604923] [  480]  1000   480     6004      118   1       0          =
   0 dispad
[413424.604926] [  481]  1000   481    36621    12462   3       0          =
   0 urxvtd
[413424.604928] [  484]  1000   484     8068      456   3       0          =
   0 xbindkeys
[413424.604930] [  505]  1000   505     8155      657   3       0          =
   0 zsh
[413424.604932] [  512]     0   512     8481      273   3       0          =
   0 sudo
[413424.604935] [  513]     0   513     6933      430   3       0          =
   0 zsh
[413424.604937] [  543]     0   543     7404      204   2       0          =
   0 wpa_supplicant
[413424.604939] [  659]  1000   659     9860     1864   2       0          =
   0 zsh
[413424.604942] [  772]  1000   772     4494       95   3       0          =
   0 dbus-launch
[413424.604944] [  773]  1000   773     4379      241   0       0          =
   0 dbus-daemon
[413424.604946] [ 1575]  1000  1575    10065     2054   1       0          =
   0 zsh
[413424.604949] [ 2835]  1000  2835    40320      829   3       0          =
   0 kdeinit4
[413424.604952] [ 2837]  1000  2837    48444      803   3       0          =
   0 klauncher
[413424.604954] [ 2841]  1000  2841   109726     1969   1       0          =
   0 kded4
[413424.604956] [ 2858]  1000  2858   238338     2698   1       0          =
   0 knotify4
[413424.604959] [ 2863]     0  2863    54958     1188   1       0          =
   0 upowerd
[413424.604961] [ 2868]     0  2868    46649      304   2     -13          =
-900 polkitd
[413424.604964] [ 2895]     0  2895    48361      444   0       0          =
   0 udisks-daemon
[413424.604966] [ 2904]     0  2904    11353      123   1       0          =
   0 udisks-daemon
[413424.604969] [ 6623]  1000  6623     8891      897   2       0          =
   0 zsh
[413424.604971] [ 8723]  1000  8723     8785      780   3       0          =
   0 zsh
[413424.604973] [14485]  1000 14485     8773      768   1       0          =
   0 zsh
[413424.604975] [30479]     0 30479     8481      274   1       0          =
   0 sudo
[413424.604977] [30480]     0 30480     6933      483   1       0          =
   0 zsh
[413424.604980] [ 2064]  1000  2064     9797     1774   3       0          =
   0 zsh
[413424.604982] [ 3202]  1000  3202     9839     1851   1       0          =
   0 zsh
[413424.604984] [14763]  1000 14763     8914      903   1       0          =
   0 zsh
[413424.604986] [29947]  1000 29947     5163      267   0       0          =
   0 zsh
[413424.604989] [29950]  1000 29950   164193    42204   1       0          =
   0 chromium
[413424.604991] [29952]  1000 29952    64978     1247   3       0          =
   0 chromium
[413424.604993] [29953]  1000 29953     1588      137   0       0          =
   0 chromium-sandbo
[413424.604996] [29954]  1000 29954    70030     1322   0       0          =
   0 chromium
[413424.604999] [29960]  1000 29960    34745      443   0       0          =
   0 nacl_helper_boo
[413424.605001] [29961]  1000 29961    76177     1181   1       0          =
   0 chromium
[413424.605003] [29990]  1000 29990   218535     5099   2       4          =
 300 chromium
[413424.605005] [30004]  1000 30004   218974     5365   3       4          =
 300 chromium
[413424.605007] [20018]     0 20018     2136      132   0       0          =
   0 dhcpcd
[413424.605010] [23649]  1000 23649    63938      837   1       0          =
   0 dconf-service
[413424.605012] [25961]  1000 25961    14690      738   2       0          =
   0 mutt
[413424.605014] [13576]     0 13576     4494       95   0       0          =
   0 dbus-launch
[413424.605017] [13577]     0 13577     4320      173   2       0          =
   0 dbus-daemon
[413424.605020] [21389]  1000 21389     8809      811   0       0          =
   0 zsh
[413424.605022] [ 5745]  1000  5745     9866     1857   2       0          =
   0 zsh
[413424.605025] [ 5944]  1000  5944     9776     1765   3       0          =
   0 zsh
[413424.605027] [ 8651]  1000  8651    10239     2241   2       0          =
   0 zsh
[413424.605030] [10927]  1000 10927     8891      902   3       0          =
   0 zsh
[413424.605032] [13485]  1000 13485     8773      766   2       0          =
   0 zsh
[413424.605034] [13492]  1000 13492    14788      869   2       0          =
   0 mutt
[413424.605037] [13504]  1000 13504    19180      545   2       0          =
   0 i3bar
[413424.605039] [13505]  1000 13505     8066      624   3       0          =
   0 i3status
[413424.605041] [13897]  1000 13897    10964     2958   1       0          =
   0 zsh
[413424.605044] [25693]  1000 25693     8806      803   3       0          =
   0 zsh
[413424.605046] [12076]  1000 12076     9025     1036   3       0          =
   0 zsh
[413424.605048] [22068]  1000 22068     8830      834   0       0          =
   0 zsh
[413424.605051] [ 3498]     0  3498     4755     2630   1       0          =
   0 atop
[413424.605053] [ 6011]  1000  6011   222875     6470   2       4          =
 300 chromium
[413424.605056] [12787]  1000 12787     9835     1831   3       0          =
   0 zsh
[413424.605058] [26144]  1000 26144   225026     9214   3       4          =
 300 chromium
[413424.605060] [30808]  1000 30808     8155      673   2       0          =
   0 zsh
[413424.605062] [ 2155]  1000  2155     8155      674   2       0          =
   0 zsh
[413424.605064] [ 2681]  1000  2681     4459      503   0       0          =
   0 man
[413424.605067] [ 2692]  1000  2692     2781      255   3       0          =
   0 less
[413424.605070] [ 3641]  1000  3641     8285      652   3       0          =
   0 vim
[413424.605072] [ 4824]  1000  4824     8176      698   2       0          =
   0 zsh
[413424.605075] [ 6094]  1000  6094     9005      315   1       0          =
   0 ssh
[413424.605077] [ 6096]  1000  6096     8970      209   3       0          =
   0 ssh
[413424.605079] [ 6098]  1000  6098     8970      308   1       0          =
   0 ssh
[413424.605082] [ 8888]  1000  8888    44968      254   2       0          =
   0 evinced
[413424.605084] [11133]     0 11133     8481      273   0       0          =
   0 sudo
[413424.605087] [11137]     0 11137     3457      299   1       0          =
   0 ccollect
[413424.605089] [11142]     0 11142     3457      206   0       0          =
   0 ccollect
[413424.605092] [11143]     0 11143     3457      148   0       0          =
   0 ccollect
[413424.605094] [11144]     0 11144     2919      224   3       0          =
   0 awk
[413424.605096] [11196]     0 11196     1810      473   3       0          =
   0 rm
[413424.605099] [11239]    73 11239    16333      370   1       0          =
   0 pickup
[413424.605103] [13544]  1000 13544   130892    14695   3       0          =
   0 evince
[413424.605106] [13571]  1000 13571     8716      729   1       0          =
   0 zsh
[413424.605108] [13605]  1000 13605     2749      211   1       0          =
   0 less
[413424.605111] Out of memory: Kill process 26144 (chromium) score 309 or s=
acrifice child
[413424.605114] Killed process 26144 (chromium) total-vm:900104kB, anon-rss=
:36208kB, file-rss:648kB
[413502.059742] polkitd invoked oom-killer: gfp_mask=3D0x201da, order=3D0, =
oom_adj=3D-13, oom_score_adj=3D-900
[413502.059750] polkitd cpuset=3D/ mems_allowed=3D0
[413502.059755] Pid: 2868, comm: polkitd Tainted: G        W    3.5.4-1-ARC=
H #1
[413502.059758] Call Trace:
[413502.059770]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d=
/0xb0
[413502.059779]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[413502.059787]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[413502.059796]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[413502.059804]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[413502.059810]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[413502.059817]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[413502.059824]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[413502.059829]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[413502.059835]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[413502.059841]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[413502.059848]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[413502.059854]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[413502.059858]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[413502.059864]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[413502.059871]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[413502.059877]  [<ffffffff8101b9d9>] ? read_tsc+0x9/0x20
[413502.059884]  [<ffffffff810a16a0>] ? ktime_get_ts+0xb0/0xf0
[413502.059889]  [<ffffffff8118bb9f>] ? poll_select_set_timeout+0x6f/0x90
[413502.059894]  [<ffffffff8147e765>] page_fault+0x25/0x30
[413502.059897] Mem-Info:
[413502.059899] Node 0 DMA per-cpu:
[413502.059904] CPU    0: hi:    0, btch:   1 usd:   0
[413502.059907] CPU    1: hi:    0, btch:   1 usd:   0
[413502.059910] CPU    2: hi:    0, btch:   1 usd:   0
[413502.059912] CPU    3: hi:    0, btch:   1 usd:   0
[413502.059915] Node 0 DMA32 per-cpu:
[413502.059919] CPU    0: hi:  186, btch:  31 usd:  95
[413502.059921] CPU    1: hi:  186, btch:  31 usd:  87
[413502.059924] CPU    2: hi:  186, btch:  31 usd:   0
[413502.059927] CPU    3: hi:  186, btch:  31 usd:   0
[413502.059928] Node 0 Normal per-cpu:
[413502.059932] CPU    0: hi:  186, btch:  31 usd:  25
[413502.059935] CPU    1: hi:  186, btch:  31 usd:   7
[413502.059938] CPU    2: hi:  186, btch:  31 usd:   0
[413502.059940] CPU    3: hi:  186, btch:  31 usd:   0
[413502.059948] active_anon:131175 inactive_anon:105489 isolated_anon:0
 active_file:42 inactive_file:41 isolated_file:3
 unevictable:2629 dirty:2 writeback:0 unstable:0
 free:22539 slab_reclaimable:697883 slab_unreclaimable:7219
 mapped:2220 shmem:107081 pagetables:3906 bounce:0
[413502.059953] Node 0 DMA free:15852kB min:260kB low:324kB high:388kB acti=
ve_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable=
:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirt=
y:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:32kB slab_unrecla=
imable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writebac=
k_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[413502.059962] lowmem_reserve[]: 0 2137 3899 3899
[413502.059968] Node 0 DMA32 free:43916kB min:36900kB low:46124kB high:5534=
8kB active_anon:121896kB inactive_anon:99204kB active_file:168kB inactive_f=
ile:8kB unevictable:4096kB isolated(anon):0kB isolated(file):12kB present:2=
188752kB mlocked:8kB dirty:8kB writeback:0kB mapped:192kB shmem:99928kB sla=
b_reclaimable:1902520kB slab_unreclaimable:6040kB kernel_stack:184kB pageta=
bles:852kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:537 all_=
unreclaimable? yes
[413502.059978] lowmem_reserve[]: 0 0 1762 1762
[413502.059984] Node 0 Normal free:30388kB min:30416kB low:38020kB high:456=
24kB active_anon:402804kB inactive_anon:322752kB active_file:0kB inactive_f=
ile:156kB unevictable:6420kB isolated(anon):0kB isolated(file):0kB present:=
1804320kB mlocked:6420kB dirty:0kB writeback:0kB mapped:8688kB shmem:328396=
kB slab_reclaimable:888980kB slab_unreclaimable:22836kB kernel_stack:1680kB=
 pagetables:14772kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned=
:361 all_unreclaimable? yes
[413502.059993] lowmem_reserve[]: 0 0 0 0
[413502.059999] Node 0 DMA: 3*4kB 2*8kB 1*16kB 4*32kB 3*64kB 3*128kB 3*256k=
B 2*512kB 3*1024kB 3*2048kB 1*4096kB =3D 15852kB
[413502.060014] Node 0 DMA32: 2233*4kB 3369*8kB 187*16kB 13*32kB 4*64kB 1*1=
28kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB =3D 43772kB
[413502.060028] Node 0 Normal: 4011*4kB 924*8kB 308*16kB 1*32kB 0*64kB 0*12=
8kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB =3D 30444kB
[413502.060042] 107947 total pagecache pages
[413502.060044] 0 pages in swap cache
[413502.060047] Swap cache stats: add 0, delete 0, find 0/0
[413502.060049] Free swap  =3D 0kB
[413502.060051] Total swap =3D 0kB
[413502.079114] 1048048 pages RAM
[413502.079120] 57533 pages reserved
[413502.079122] 52761 pages shared
[413502.079124] 939853 pages non-shared
[413502.079129] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score=
_adj name
[413502.079142] [  191]     0   191     6555      406   0     -17         -=
1000 systemd-udevd
[413502.079148] [  194]     0   194    74640     2415   0       0          =
   0 systemd-journal
[413502.079154] [  301]     0   301     3302      309   2       0          =
   0 crond
[413502.079160] [  302]     0   302    17693      680   2       0          =
   0 cupsd
[413502.079165] [  304]     0   304    10502      322   1     -17         -=
1000 sshd
[413502.079171] [  305]    81   305     4433      330   1     -13          =
-900 dbus-daemon
[413502.079177] [  309]     0   309     6512      194   1       0          =
   0 systemd-logind
[413502.079183] [  315]     0   315    15747      314   2       0          =
   0 login
[413502.079197] [  316]     0   316     2031      190   0       0          =
   0 agetty
[413502.079199] [  317]     0   317     2031      186   0       0          =
   0 agetty
[413502.079201] [  319]     0   319     2031      188   1       0          =
   0 agetty
[413502.079203] [  320]     0   320     2031      189   1       0          =
   0 agetty
[413502.079205] [  321]     0   321     2031      188   1       0          =
   0 agetty
[413502.079207] [  325]     0   325    51901      515   3       0          =
   0 colord
[413502.079208] [  341]     0   341   123526     1044   1       0          =
   0 colord-sane
[413502.079210] [  395]     0   395     3092      220   2       0          =
   0 master
[413502.079212] [  399]    73   399    16380      399   3       0          =
   0 qmgr
[413502.079214] [  420]  1000   420     3423      283   2       0          =
   0 restart-x
[413502.079216] [  431]  1000   431     3423      298   3       0          =
   0 startx
[413502.079217] [  448]  1000   448     3966      147   3       0          =
   0 xinit
[413502.079219] [  449]  1000   449    82735     4550   2       0          =
   0 X
[413502.079221] [  470]  1000   470    24058      796   2       0          =
   0 i3
[413502.079223] [  477]  1000   477     6062      195   1       0          =
   0 unclutter
[413502.079225] [  480]  1000   480     6004      123   1       0          =
   0 dispad
[413502.079226] [  481]  1000   481    36621    12507   3       0          =
   0 urxvtd
[413502.079228] [  484]  1000   484     8068      456   3       0          =
   0 xbindkeys
[413502.079230] [  505]  1000   505     8155      657   3       0          =
   0 zsh
[413502.079232] [  512]     0   512     8481      273   3       0          =
   0 sudo
[413502.079234] [  513]     0   513     6933      430   3       0          =
   0 zsh
[413502.079235] [  543]     0   543     7404      212   1       0          =
   0 wpa_supplicant
[413502.079237] [  659]  1000   659     9860     1864   2       0          =
   0 zsh
[413502.079239] [  772]  1000   772     4494       95   3       0          =
   0 dbus-launch
[413502.079241] [  773]  1000   773     4379      241   0       0          =
   0 dbus-daemon
[413502.079242] [ 1575]  1000  1575    10065     2054   1       0          =
   0 zsh
[413502.079244] [ 2835]  1000  2835    40320      829   3       0          =
   0 kdeinit4
[413502.079247] [ 2837]  1000  2837    48444      803   3       0          =
   0 klauncher
[413502.079248] [ 2841]  1000  2841   109726     1990   1       0          =
   0 kded4
[413502.079250] [ 2858]  1000  2858   238338     2664   1       0          =
   0 knotify4
[413502.079252] [ 2863]     0  2863    54958     1190   1       0          =
   0 upowerd
[413502.079254] [ 2868]     0  2868    46649      348   1     -13          =
-900 polkitd
[413502.079256] [ 2895]     0  2895    48361      444   0       0          =
   0 udisks-daemon
[413502.079257] [ 2904]     0  2904    11353      123   1       0          =
   0 udisks-daemon
[413502.079259] [ 6623]  1000  6623     8891      897   2       0          =
   0 zsh
[413502.079261] [ 8723]  1000  8723     8785      780   3       0          =
   0 zsh
[413502.079263] [14485]  1000 14485     8773      768   1       0          =
   0 zsh
[413502.079265] [30479]     0 30479     8481      274   1       0          =
   0 sudo
[413502.079267] [30480]     0 30480     6933      483   1       0          =
   0 zsh
[413502.079268] [ 2064]  1000  2064     9797     1774   3       0          =
   0 zsh
[413502.079270] [ 3202]  1000  3202     9839     1851   1       0          =
   0 zsh
[413502.079272] [14763]  1000 14763     8914      903   1       0          =
   0 zsh
[413502.079274] [29947]  1000 29947     5163      267   0       0          =
   0 zsh
[413502.079275] [29950]  1000 29950   164189    42065   0       0          =
   0 chromium
[413502.079277] [29952]  1000 29952    64978     1247   3       0          =
   0 chromium
[413502.079279] [29953]  1000 29953     1588      137   0       0          =
   0 chromium-sandbo
[413502.079280] [29954]  1000 29954    70030     1322   0       0          =
   0 chromium
[413502.079282] [29960]  1000 29960    34745      443   0       0          =
   0 nacl_helper_boo
[413502.079284] [29961]  1000 29961    76177     1162   3       0          =
   0 chromium
[413502.079286] [29990]  1000 29990   218535     5124   1       4          =
 300 chromium
[413502.079287] [30004]  1000 30004   218974     5368   3       4          =
 300 chromium
[413502.079289] [20018]     0 20018     2136      132   0       0          =
   0 dhcpcd
[413502.079291] [23649]  1000 23649    63938      837   1       0          =
   0 dconf-service
[413502.079293] [25961]  1000 25961    14690      738   2       0          =
   0 mutt
[413502.079295] [13576]     0 13576     4494       95   0       0          =
   0 dbus-launch
[413502.079297] [13577]     0 13577     4320      173   2       0          =
   0 dbus-daemon
[413502.079299] [21389]  1000 21389     8809      811   0       0          =
   0 zsh
[413502.079301] [ 5745]  1000  5745     9866     1857   2       0          =
   0 zsh
[413502.079303] [ 5944]  1000  5944     9776     1765   3       0          =
   0 zsh
[413502.079305] [ 8651]  1000  8651    10239     2241   2       0          =
   0 zsh
[413502.079307] [10927]  1000 10927     8891      902   3       0          =
   0 zsh
[413502.079309] [13485]  1000 13485     8773      766   2       0          =
   0 zsh
[413502.079311] [13492]  1000 13492    14788      869   2       0          =
   0 mutt
[413502.079312] [13504]  1000 13504    19180      565   1       0          =
   0 i3bar
[413502.079314] [13505]  1000 13505     8066      616   3       0          =
   0 i3status
[413502.079316] [13897]  1000 13897    10964     2958   1       0          =
   0 zsh
[413502.079318] [25693]  1000 25693     8806      803   3       0          =
   0 zsh
[413502.079320] [12076]  1000 12076     9025     1036   3       0          =
   0 zsh
[413502.079322] [22068]  1000 22068     8830      834   0       0          =
   0 zsh
[413502.079324] [ 3498]     0  3498     4755     2630   1       0          =
   0 atop
[413502.079326] [ 6011]  1000  6011   222875     6494   2       4          =
 300 chromium
[413502.079328] [12787]  1000 12787     9835     1831   3       0          =
   0 zsh
[413502.079329] [30808]  1000 30808     8155      673   2       0          =
   0 zsh
[413502.079331] [ 2155]  1000  2155     8155      674   2       0          =
   0 zsh
[413502.079333] [ 2681]  1000  2681     4459      503   0       0          =
   0 man
[413502.079335] [ 2692]  1000  2692     2781      255   3       0          =
   0 less
[413502.079337] [ 3641]  1000  3641     8285      652   3       0          =
   0 vim
[413502.079338] [ 4824]  1000  4824     8176      698   2       0          =
   0 zsh
[413502.079351] [ 6094]  1000  6094     9005      321   0       0          =
   0 ssh
[413502.079355] [ 6096]  1000  6096     8970      209   3       0          =
   0 ssh
[413502.079359] [ 6098]  1000  6098     8970      275   1       0          =
   0 ssh
[413502.079363] [ 8888]  1000  8888    44968      254   2       0          =
   0 evinced
[413502.079368] [11133]     0 11133     8481      273   0       0          =
   0 sudo
[413502.079372] [11137]     0 11137     3457      299   1       0          =
   0 ccollect
[413502.079376] [11142]     0 11142     3457      206   0       0          =
   0 ccollect
[413502.079380] [11143]     0 11143     3457      148   0       0          =
   0 ccollect
[413502.079384] [11144]     0 11144     2919      224   3       0          =
   0 awk
[413502.079389] [11196]     0 11196     1975      613   0       0          =
   0 rm
[413502.079393] [11239]    73 11239    16333      355   1       0          =
   0 pickup
[413502.079399] [13544]  1000 13544   130892    14696   2       0          =
   0 evince
[413502.079403] [13571]  1000 13571     8716      729   1       0          =
   0 zsh
[413502.079407] [13605]  1000 13605     2749      211   1       0          =
   0 less
[413502.079412] [13795]     0 13795     9169      376   3       0          =
   0 crond
[413502.079415] [13796]     0 13796     9169      376   1       0          =
   0 crond
[413502.079419] [13797]  1000 13797     2937      194   3       0          =
   0 sh
[413502.079423] [13798]  1000 13798     2937      206   0       0          =
   0 sh
[413502.079427] Out of memory: Kill process 6011 (chromium) score 306 or sa=
crifice child
[413502.079433] Killed process 6011 (chromium) total-vm:891500kB, anon-rss:=
25116kB, file-rss:860kB
[413502.080379] polkitd invoked oom-killer: gfp_mask=3D0x201da, order=3D0, =
oom_adj=3D-13, oom_score_adj=3D-900
[413502.080382] polkitd cpuset=3D/ mems_allowed=3D0
[413502.080392] Pid: 2868, comm: polkitd Tainted: G        W    3.5.4-1-ARC=
H #1
[413502.080393] Call Trace:
[413502.080399]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d=
/0xb0
[413502.080404]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[413502.080407]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[413502.080412]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[413502.080416]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[413502.080419]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[413502.080422]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[413502.080426]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[413502.080428]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[413502.080431]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[413502.080435]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[413502.080438]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[413502.080441]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[413502.080443]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[413502.080446]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[413502.080450]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[413502.080453]  [<ffffffff8101b9d9>] ? read_tsc+0x9/0x20
[413502.080456]  [<ffffffff810a16a0>] ? ktime_get_ts+0xb0/0xf0
[413502.080459]  [<ffffffff8118bb9f>] ? poll_select_set_timeout+0x6f/0x90
[413502.080461]  [<ffffffff8147e765>] page_fault+0x25/0x30
[413502.080463] Mem-Info:
[413502.080464] Node 0 DMA per-cpu:
[413502.080474] CPU    0: hi:    0, btch:   1 usd:   0
[413502.080476] CPU    1: hi:    0, btch:   1 usd:   0
[413502.080477] CPU    2: hi:    0, btch:   1 usd:   0
[413502.080479] CPU    3: hi:    0, btch:   1 usd:   0
[413502.080480] Node 0 DMA32 per-cpu:
[413502.080482] CPU    0: hi:  186, btch:  31 usd:  95
[413502.080484] CPU    1: hi:  186, btch:  31 usd:  87
[413502.080485] CPU    2: hi:  186, btch:  31 usd:   9
[413502.080487] CPU    3: hi:  186, btch:  31 usd:   0
[413502.080488] Node 0 Normal per-cpu:
[413502.080490] CPU    0: hi:  186, btch:  31 usd:  25
[413502.080492] CPU    1: hi:  186, btch:  31 usd:   7
[413502.080493] CPU    2: hi:  186, btch:  31 usd:   0
[413502.080495] CPU    3: hi:  186, btch:  31 usd:  21
[413502.080499] active_anon:131175 inactive_anon:105489 isolated_anon:0
 active_file:42 inactive_file:41 isolated_file:3
 unevictable:2629 dirty:2 writeback:0 unstable:0
 free:22539 slab_reclaimable:697883 slab_unreclaimable:7219
 mapped:2220 shmem:107081 pagetables:3906 bounce:0
[413502.080502] Node 0 DMA free:15852kB min:260kB low:324kB high:388kB acti=
ve_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable=
:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirt=
y:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:32kB slab_unrecla=
imable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writebac=
k_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[413502.080508] lowmem_reserve[]: 0 2137 3899 3899
[413502.080511] Node 0 DMA32 free:43916kB min:36900kB low:46124kB high:5534=
8kB active_anon:121896kB inactive_anon:99204kB active_file:168kB inactive_f=
ile:8kB unevictable:4096kB isolated(anon):0kB isolated(file):12kB present:2=
188752kB mlocked:8kB dirty:8kB writeback:0kB mapped:192kB shmem:99928kB sla=
b_reclaimable:1902520kB slab_unreclaimable:6040kB kernel_stack:184kB pageta=
bles:852kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:704 all_=
unreclaimable? yes
[413502.080517] lowmem_reserve[]: 0 0 1762 1762
[413502.080521] Node 0 Normal free:30388kB min:30416kB low:38020kB high:456=
24kB active_anon:402804kB inactive_anon:322752kB active_file:0kB inactive_f=
ile:156kB unevictable:6420kB isolated(anon):0kB isolated(file):0kB present:=
1804320kB mlocked:6420kB dirty:0kB writeback:0kB mapped:8688kB shmem:328396=
kB slab_reclaimable:888980kB slab_unreclaimable:22836kB kernel_stack:1680kB=
 pagetables:14772kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned=
:569 all_unreclaimable? yes
[413502.080526] lowmem_reserve[]: 0 0 0 0
[413502.080529] Node 0 DMA: 3*4kB 2*8kB 1*16kB 4*32kB 3*64kB 3*128kB 3*256k=
B 2*512kB 3*1024kB 3*2048kB 1*4096kB =3D 15852kB
[413502.080538] Node 0 DMA32: 2233*4kB 3369*8kB 187*16kB 13*32kB 4*64kB 1*1=
28kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB =3D 43772kB
[413502.080546] Node 0 Normal: 3980*4kB 924*8kB 308*16kB 1*32kB 0*64kB 0*12=
8kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB =3D 30320kB
[413502.080554] 107947 total pagecache pages
[413502.080555] 0 pages in swap cache
[413502.080557] Swap cache stats: add 0, delete 0, find 0/0
[413502.080558] Free swap  =3D 0kB
[413502.080559] Total swap =3D 0kB
[413502.092901] 1048048 pages RAM
[413502.092903] 57533 pages reserved
[413502.092904] 51542 pages shared
[413502.092905] 934462 pages non-shared
[413502.092907] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score=
_adj name
[413502.092914] [  191]     0   191     6555      406   0     -17         -=
1000 systemd-udevd
[413502.092917] [  194]     0   194    74640     2415   0       0          =
   0 systemd-journal
[413502.092920] [  301]     0   301     3302      309   2       0          =
   0 crond
[413502.092923] [  302]     0   302    17693      680   2       0          =
   0 cupsd
[413502.092926] [  304]     0   304    10502      322   1     -17         -=
1000 sshd
[413502.092929] [  305]    81   305     4433      330   1     -13          =
-900 dbus-daemon
[413502.092931] [  309]     0   309     6512      194   1       0          =
   0 systemd-logind
[413502.092934] [  315]     0   315    15747      314   2       0          =
   0 login
[413502.092936] [  316]     0   316     2031      190   0       0          =
   0 agetty
[413502.092939] [  317]     0   317     2031      186   0       0          =
   0 agetty
[413502.092942] [  319]     0   319     2031      188   1       0          =
   0 agetty
[413502.092944] [  320]     0   320     2031      189   1       0          =
   0 agetty
[413502.092947] [  321]     0   321     2031      188   1       0          =
   0 agetty
[413502.092950] [  325]     0   325    51901      515   3       0          =
   0 colord
[413502.092952] [  341]     0   341   123526     1044   1       0          =
   0 colord-sane
[413502.092955] [  395]     0   395     3092      220   2       0          =
   0 master
[413502.092957] [  399]    73   399    16380      399   3       0          =
   0 qmgr
[413502.092961] [  420]  1000   420     3423      283   2       0          =
   0 restart-x
[413502.092963] [  431]  1000   431     3423      298   3       0          =
   0 startx
[413502.092966] [  448]  1000   448     3966      147   3       0          =
   0 xinit
[413502.092969] [  449]  1000   449    82735     4550   2       0          =
   0 X
[413502.092972] [  470]  1000   470    24058      796   2       0          =
   0 i3
[413502.092974] [  477]  1000   477     6062      195   1       0          =
   0 unclutter
[413502.092978] [  480]  1000   480     6004      123   1       0          =
   0 dispad
[413502.092980] [  481]  1000   481    36621    12507   3       0          =
   0 urxvtd
[413502.092983] [  484]  1000   484     8068      456   3       0          =
   0 xbindkeys
[413502.092985] [  505]  1000   505     8155      657   3       0          =
   0 zsh
[413502.092988] [  512]     0   512     8481      273   3       0          =
   0 sudo
[413502.092991] [  513]     0   513     6933      430   3       0          =
   0 zsh
[413502.092993] [  543]     0   543     7404      212   1       0          =
   0 wpa_supplicant
[413502.092996] [  659]  1000   659     9860     1864   2       0          =
   0 zsh
[413502.092999] [  772]  1000   772     4494       95   3       0          =
   0 dbus-launch
[413502.093001] [  773]  1000   773     4379      241   0       0          =
   0 dbus-daemon
[413502.093004] [ 1575]  1000  1575    10065     2054   1       0          =
   0 zsh
[413502.093007] [ 2835]  1000  2835    40320      829   3       0          =
   0 kdeinit4
[413502.093009] [ 2837]  1000  2837    48444      803   3       0          =
   0 klauncher
[413502.093012] [ 2841]  1000  2841   109726     1990   1       0          =
   0 kded4
[413502.093015] [ 2858]  1000  2858   238338     2664   1       0          =
   0 knotify4
[413502.093018] [ 2863]     0  2863    54958     1190   1       0          =
   0 upowerd
[413502.093020] [ 2868]     0  2868    46649      348   1     -13          =
-900 polkitd
[413502.093023] [ 2895]     0  2895    48361      444   0       0          =
   0 udisks-daemon
[413502.093026] [ 2904]     0  2904    11353      123   1       0          =
   0 udisks-daemon
[413502.093028] [ 6623]  1000  6623     8891      897   2       0          =
   0 zsh
[413502.093031] [ 8723]  1000  8723     8785      780   3       0          =
   0 zsh
[413502.093034] [14485]  1000 14485     8773      768   1       0          =
   0 zsh
[413502.093037] [30479]     0 30479     8481      274   1       0          =
   0 sudo
[413502.093039] [30480]     0 30480     6933      483   1       0          =
   0 zsh
[413502.093042] [ 2064]  1000  2064     9797     1774   3       0          =
   0 zsh
[413502.093046] [ 3202]  1000  3202     9839     1851   1       0          =
   0 zsh
[413502.093048] [14763]  1000 14763     8914      903   1       0          =
   0 zsh
[413502.093051] [29947]  1000 29947     5163      267   0       0          =
   0 zsh
[413502.093053] [29950]  1000 29950   164189    42065   0       0          =
   0 chromium
[413502.093056] [29952]  1000 29952    64978     1247   3       0          =
   0 chromium
[413502.093059] [29953]  1000 29953     1588      137   0       0          =
   0 chromium-sandbo
[413502.093062] [29954]  1000 29954    70030     1322   0       0          =
   0 chromium
[413502.093064] [29960]  1000 29960    34745      443   0       0          =
   0 nacl_helper_boo
[413502.093067] [29961]  1000 29961    76177     1162   3       0          =
   0 chromium
[413502.093070] [29990]  1000 29990   218535     5124   1       4          =
 300 chromium
[413502.093073] [30004]  1000 30004   218974     5368   3       4          =
 300 chromium
[413502.093075] [20018]     0 20018     2136      132   0       0          =
   0 dhcpcd
[413502.093078] [23649]  1000 23649    63938      837   1       0          =
   0 dconf-service
[413502.093081] [25961]  1000 25961    14690      738   2       0          =
   0 mutt
[413502.093084] [13576]     0 13576     4494       95   0       0          =
   0 dbus-launch
[413502.093087] [13577]     0 13577     4320      173   2       0          =
   0 dbus-daemon
[413502.093089] [21389]  1000 21389     8809      811   0       0          =
   0 zsh
[413502.093092] [ 5745]  1000  5745     9866     1857   2       0          =
   0 zsh
[413502.093095] [ 5944]  1000  5944     9776     1765   3       0          =
   0 zsh
[413502.093098] [ 8651]  1000  8651    10239     2241   2       0          =
   0 zsh
[413502.093101] [10927]  1000 10927     8891      902   3       0          =
   0 zsh
[413502.093104] [13485]  1000 13485     8773      766   2       0          =
   0 zsh
[413502.093107] [13492]  1000 13492    14788      869   2       0          =
   0 mutt
[413502.093109] [13504]  1000 13504    19180      565   1       0          =
   0 i3bar
[413502.093112] [13505]  1000 13505     8066      616   3       0          =
   0 i3status
[413502.093115] [13897]  1000 13897    10964     2958   1       0          =
   0 zsh
[413502.093117] [25693]  1000 25693     8806      803   3       0          =
   0 zsh
[413502.093120] [12076]  1000 12076     9025     1036   3       0          =
   0 zsh
[413502.093123] [22068]  1000 22068     8830      834   0       0          =
   0 zsh
[413502.093126] [ 3498]     0  3498     4755     2630   1       0          =
   0 atop
[413502.093129] [12787]  1000 12787     9835     1831   3       0          =
   0 zsh
[413502.093132] [30808]  1000 30808     8155      673   2       0          =
   0 zsh
[413502.093135] [ 2155]  1000  2155     8155      674   2       0          =
   0 zsh
[413502.093138] [ 2681]  1000  2681     4459      503   0       0          =
   0 man
[413502.093140] [ 2692]  1000  2692     2781      255   3       0          =
   0 less
[413502.093143] [ 3641]  1000  3641     8285      652   3       0          =
   0 vim
[413502.093145] [ 4824]  1000  4824     8176      698   2       0          =
   0 zsh
[413502.093149] [ 6094]  1000  6094     9005      321   0       0          =
   0 ssh
[413502.093152] [ 6096]  1000  6096     8970      209   3       0          =
   0 ssh
[413502.093154] [ 6098]  1000  6098     8970      275   1       0          =
   0 ssh
[413502.093157] [ 8888]  1000  8888    44968      254   2       0          =
   0 evinced
[413502.093160] [11133]     0 11133     8481      273   0       0          =
   0 sudo
[413502.093163] [11137]     0 11137     3457      299   1       0          =
   0 ccollect
[413502.093166] [11142]     0 11142     3457      206   0       0          =
   0 ccollect
[413502.093168] [11143]     0 11143     3457      148   0       0          =
   0 ccollect
[413502.093171] [11144]     0 11144     2919      224   3       0          =
   0 awk
[413502.093174] [11196]     0 11196     1975      613   0       0          =
   0 rm
[413502.093177] [11239]    73 11239    16333      355   1       0          =
   0 pickup
[413502.093181] [13544]  1000 13544   130892    14696   2       0          =
   0 evince
[413502.093184] [13571]  1000 13571     8716      729   1       0          =
   0 zsh
[413502.093186] [13605]  1000 13605     2749      211   1       0          =
   0 less
[413502.093190] [13795]     0 13795     9169      376   3       0          =
   0 crond
[413502.093192] [13796]     0 13796     9169      376   1       0          =
   0 crond
[413502.093195] [13797]  1000 13797     2937      193   3       0          =
   0 sh
[413502.093198] [13798]  1000 13798     2937      205   0       0          =
   0 sh
[413502.093200] Out of memory: Kill process 30004 (chromium) score 305 or s=
acrifice child
[413502.093203] Killed process 30004 (chromium) total-vm:875896kB, anon-rss=
:20720kB, file-rss:752kB
[413522.218771] offlineimap invoked oom-killer: gfp_mask=3D0x201da, order=
=3D0, oom_adj=3D0, oom_score_adj=3D0
[413522.218774] offlineimap cpuset=3D/ mems_allowed=3D0
[413522.218777] Pid: 13808, comm: offlineimap Tainted: G        W    3.5.4-=
1-ARCH #1
[413522.218778] Call Trace:
[413522.218784]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d=
/0xb0
[413522.218788]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[413522.218792]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[413522.218796]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[413522.218800]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[413522.218802]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[413522.218805]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[413522.218809]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[413522.218811]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[413522.218814]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[413522.218817]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[413522.218819]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[413522.218822]  [<ffffffff8136c4a7>] ? sock_aio_write+0x147/0x180
[413522.218825]  [<ffffffff810aaa7b>] ? wake_futex+0x3b/0x60
[413522.218828]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[413522.218831]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[413522.218833]  [<ffffffff8147e765>] page_fault+0x25/0x30
[413522.218834] Mem-Info:
[413522.218835] Node 0 DMA per-cpu:
[413522.218837] CPU    0: hi:    0, btch:   1 usd:   0
[413522.218839] CPU    1: hi:    0, btch:   1 usd:   0
[413522.218840] CPU    2: hi:    0, btch:   1 usd:   0
[413522.218841] CPU    3: hi:    0, btch:   1 usd:   0
[413522.218842] Node 0 DMA32 per-cpu:
[413522.218844] CPU    0: hi:  186, btch:  31 usd:   0
[413522.218845] CPU    1: hi:  186, btch:  31 usd:   0
[413522.218846] CPU    2: hi:  186, btch:  31 usd:   0
[413522.218847] CPU    3: hi:  186, btch:  31 usd:   0
[413522.218848] Node 0 Normal per-cpu:
[413522.218850] CPU    0: hi:  186, btch:  31 usd:   0
[413522.218851] CPU    1: hi:  186, btch:  31 usd:   0
[413522.218852] CPU    2: hi:  186, btch:  31 usd:   0
[413522.218853] CPU    3: hi:  186, btch:  31 usd:   0
[413522.218856] active_anon:126645 inactive_anon:105553 isolated_anon:0
 active_file:139 inactive_file:288 isolated_file:0
 unevictable:2629 dirty:67 writeback:0 unstable:0
 free:22519 slab_reclaimable:702186 slab_unreclaimable:7152
 mapped:2234 shmem:107129 pagetables:3772 bounce:0
[413522.218858] Node 0 DMA free:15856kB min:260kB low:324kB high:388kB acti=
ve_anon:16kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictabl=
e:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dir=
ty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:32kB slab_unrecl=
aimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeba=
ck_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[413522.218862] lowmem_reserve[]: 0 2137 3899 3899
[413522.218865] Node 0 DMA32 free:43812kB min:36900kB low:46124kB high:5534=
8kB active_anon:110412kB inactive_anon:99428kB active_file:548kB inactive_f=
ile:1148kB unevictable:4096kB isolated(anon):0kB isolated(file):0kB present=
:2188752kB mlocked:8kB dirty:264kB writeback:0kB mapped:288kB shmem:100152k=
B slab_reclaimable:1911920kB slab_unreclaimable:5944kB kernel_stack:240kB p=
agetables:1220kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:29=
567 all_unreclaimable? yes
[413522.218869] lowmem_reserve[]: 0 0 1762 1762
[413522.218872] Node 0 Normal free:30408kB min:30416kB low:38020kB high:456=
24kB active_anon:396152kB inactive_anon:322784kB active_file:8kB inactive_f=
ile:4kB unevictable:6420kB isolated(anon):0kB isolated(file):0kB present:18=
04320kB mlocked:6420kB dirty:4kB writeback:0kB mapped:8648kB shmem:328364kB=
 slab_reclaimable:896792kB slab_unreclaimable:22664kB kernel_stack:1640kB p=
agetables:13868kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:2=
88 all_unreclaimable? yes
[413522.218876] lowmem_reserve[]: 0 0 0 0
[413522.218878] Node 0 DMA: 2*4kB 1*8kB 2*16kB 4*32kB 3*64kB 3*128kB 3*256k=
B 2*512kB 3*1024kB 3*2048kB 1*4096kB =3D 15856kB
[413522.218885] Node 0 DMA32: 1965*4kB 3458*8kB 245*16kB 14*32kB 3*64kB 0*1=
28kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB =3D 44180kB
[413522.218891] Node 0 Normal: 3821*4kB 1034*8kB 312*16kB 2*32kB 0*64kB 0*1=
28kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB =3D 30660kB
[413522.218897] 108412 total pagecache pages
[413522.218898] 0 pages in swap cache
[413522.218899] Swap cache stats: add 0, delete 0, find 0/0
[413522.218900] Free swap  =3D 0kB
[413522.218901] Total swap =3D 0kB
[413522.227928] 1048048 pages RAM
[413522.227931] 57533 pages reserved
[413522.227932] 51658 pages shared
[413522.227933] 939750 pages non-shared
[413522.227934] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score=
_adj name
[413522.227940] [  191]     0   191     6555      406   0     -17         -=
1000 systemd-udevd
[413522.227943] [  194]     0   194    74640     2576   2       0          =
   0 systemd-journal
[413522.227947] [  301]     0   301     3302      307   2       0          =
   0 crond
[413522.227950] [  302]     0   302    17693      680   2       0          =
   0 cupsd
[413522.227952] [  304]     0   304    10502      322   1     -17         -=
1000 sshd
[413522.227955] [  305]    81   305     4433      277   2     -13          =
-900 dbus-daemon
[413522.227957] [  309]     0   309     6512      194   1       0          =
   0 systemd-logind
[413522.227959] [  315]     0   315    15747      314   2       0          =
   0 login
[413522.227962] [  316]     0   316     2031      190   0       0          =
   0 agetty
[413522.227964] [  317]     0   317     2031      186   0       0          =
   0 agetty
[413522.227967] [  319]     0   319     2031      188   1       0          =
   0 agetty
[413522.227969] [  320]     0   320     2031      189   1       0          =
   0 agetty
[413522.227972] [  321]     0   321     2031      188   1       0          =
   0 agetty
[413522.227974] [  325]     0   325    51901      515   3       0          =
   0 colord
[413522.227976] [  341]     0   341   123526     1044   1       0          =
   0 colord-sane
[413522.227979] [  395]     0   395     3092      205   1       0          =
   0 master
[413522.227981] [  399]    73   399    16380      399   3       0          =
   0 qmgr
[413522.227984] [  420]  1000   420     3423      283   2       0          =
   0 restart-x
[413522.227986] [  431]  1000   431     3423      298   3       0          =
   0 startx
[413522.227989] [  448]  1000   448     3966      147   3       0          =
   0 xinit
[413522.227992] [  449]  1000   449    82749     4541   2       0          =
   0 X
[413522.227995] [  470]  1000   470    24058      799   0       0          =
   0 i3
[413522.227997] [  477]  1000   477     6062      195   1       0          =
   0 unclutter
[413522.228000] [  480]  1000   480     6004      123   1       0          =
   0 dispad
[413522.228002] [  481]  1000   481    36621    12507   3       0          =
   0 urxvtd
[413522.228004] [  484]  1000   484     8068      456   3       0          =
   0 xbindkeys
[413522.228007] [  505]  1000   505     8155      657   3       0          =
   0 zsh
[413522.228009] [  512]     0   512     8481      273   3       0          =
   0 sudo
[413522.228012] [  513]     0   513     6933      430   3       0          =
   0 zsh
[413522.228014] [  543]     0   543     7404      202   1       0          =
   0 wpa_supplicant
[413522.228017] [  659]  1000   659     9860     1864   2       0          =
   0 zsh
[413522.228019] [  772]  1000   772     4494       95   3       0          =
   0 dbus-launch
[413522.228021] [  773]  1000   773     4379      241   0       0          =
   0 dbus-daemon
[413522.228024] [ 1575]  1000  1575    10065     2054   1       0          =
   0 zsh
[413522.228026] [ 2835]  1000  2835    40320      829   3       0          =
   0 kdeinit4
[413522.228028] [ 2837]  1000  2837    48444      803   3       0          =
   0 klauncher
[413522.228031] [ 2841]  1000  2841   109726     1966   1       0          =
   0 kded4
[413522.228033] [ 2858]  1000  2858   238338     2680   1       0          =
   0 knotify4
[413522.228035] [ 2863]     0  2863    54958     1164   2       0          =
   0 upowerd
[413522.228038] [ 2868]     0  2868    46649      320   3     -13          =
-900 polkitd
[413522.228041] [ 2895]     0  2895    48361      444   0       0          =
   0 udisks-daemon
[413522.228044] [ 2904]     0  2904    11353      123   1       0          =
   0 udisks-daemon
[413522.228047] [ 6623]  1000  6623     8891      897   2       0          =
   0 zsh
[413522.228049] [ 8723]  1000  8723     8785      780   3       0          =
   0 zsh
[413522.228051] [14485]  1000 14485     8773      768   1       0          =
   0 zsh
[413522.228054] [30479]     0 30479     8481      274   1       0          =
   0 sudo
[413522.228056] [30480]     0 30480     6933      483   1       0          =
   0 zsh
[413522.228059] [ 2064]  1000  2064     9797     1774   3       0          =
   0 zsh
[413522.228061] [ 3202]  1000  3202     9839     1851   1       0          =
   0 zsh
[413522.228063] [14763]  1000 14763     8914      903   1       0          =
   0 zsh
[413522.228066] [29947]  1000 29947     5163      267   0       0          =
   0 zsh
[413522.228068] [29950]  1000 29950   164189    42030   1       0          =
   0 chromium
[413522.228071] [29952]  1000 29952    64978     1239   1       0          =
   0 chromium
[413522.228073] [29953]  1000 29953     1588      137   0       0          =
   0 chromium-sandbo
[413522.228075] [29954]  1000 29954    70030     1322   0       0          =
   0 chromium
[413522.228078] [29960]  1000 29960    34745      443   0       0          =
   0 nacl_helper_boo
[413522.228080] [29961]  1000 29961    76177     1172   1       0          =
   0 chromium
[413522.228082] [29990]  1000 29990   218535     5048   2       4          =
 300 chromium
[413522.228085] [20018]     0 20018     2136      132   0       0          =
   0 dhcpcd
[413522.228087] [23649]  1000 23649    63938      837   1       0          =
   0 dconf-service
[413522.228090] [25961]  1000 25961    14690      738   2       0          =
   0 mutt
[413522.228093] [13576]     0 13576     4494       95   0       0          =
   0 dbus-launch
[413522.228096] [13577]     0 13577     4320      173   2       0          =
   0 dbus-daemon
[413522.228098] [21389]  1000 21389     8809      811   0       0          =
   0 zsh
[413522.228101] [ 5745]  1000  5745     9866     1857   2       0          =
   0 zsh
[413522.228103] [ 5944]  1000  5944     9776     1765   3       0          =
   0 zsh
[413522.228106] [ 8651]  1000  8651    10239     2241   2       0          =
   0 zsh
[413522.228108] [10927]  1000 10927     8891      902   3       0          =
   0 zsh
[413522.228110] [13485]  1000 13485     8773      766   2       0          =
   0 zsh
[413522.228113] [13492]  1000 13492    14788      869   2       0          =
   0 mutt
[413522.228115] [13504]  1000 13504    19180      512   1       0          =
   0 i3bar
[413522.228117] [13505]  1000 13505     8066      617   1       0          =
   0 i3status
[413522.228120] [13897]  1000 13897    10964     2958   1       0          =
   0 zsh
[413522.228122] [25693]  1000 25693     8806      803   3       0          =
   0 zsh
[413522.228124] [12076]  1000 12076     9025     1036   3       0          =
   0 zsh
[413522.228127] [22068]  1000 22068     8830      834   0       0          =
   0 zsh
[413522.228130] [ 3498]     0  3498     4755     2630   1       0          =
   0 atop
[413522.228132] [12787]  1000 12787     9835     1831   3       0          =
   0 zsh
[413522.228135] [30808]  1000 30808     8155      673   2       0          =
   0 zsh
[413522.228137] [ 2155]  1000  2155     8155      674   2       0          =
   0 zsh
[413522.228140] [ 2681]  1000  2681     4459      503   0       0          =
   0 man
[413522.228143] [ 2692]  1000  2692     2781      255   3       0          =
   0 less
[413522.228145] [ 3641]  1000  3641     8285      652   3       0          =
   0 vim
[413522.228148] [ 4824]  1000  4824     8176      698   2       0          =
   0 zsh
[413522.228151] [ 6094]  1000  6094     9005      319   2       0          =
   0 ssh
[413522.228154] [ 6096]  1000  6096     8970      209   3       0          =
   0 ssh
[413522.228157] [ 6098]  1000  6098     8970      300   1       0          =
   0 ssh
[413522.228160] [ 8888]  1000  8888    44968      254   2       0          =
   0 evinced
[413522.228164] [11133]     0 11133     8481      273   0       0          =
   0 sudo
[413522.228167] [11137]     0 11137     3457      299   1       0          =
   0 ccollect
[413522.228170] [11142]     0 11142     3457      206   0       0          =
   0 ccollect
[413522.228172] [11143]     0 11143     3457      148   0       0          =
   0 ccollect
[413522.228175] [11144]     0 11144     2919      224   3       0          =
   0 awk
[413522.228178] [11196]     0 11196     3891     2514   3       0          =
   0 rm
[413522.228182] [11239]    73 11239    16333      344   2       0          =
   0 pickup
[413522.228186] [13544]  1000 13544   130892    14717   2       0          =
   0 evince
[413522.228189] [13571]  1000 13571     8716      729   1       0          =
   0 zsh
[413522.228192] [13605]  1000 13605     2749      211   1       0          =
   0 less
[413522.228196] [13795]     0 13795     9169      376   3       0          =
   0 crond
[413522.228198] [13797]  1000 13797     2937      213   1       0          =
   0 sh
[413522.228199] [13800]  1000 13800   169982     2362   1       0          =
   0 offlineimap
[413522.228201] [13801]  1000 13801   217175     2109   3       4          =
 300 chromium
[413522.228203] Out of memory: Kill process 29990 (chromium) score 305 or s=
acrifice child
[413522.228206] Killed process 29990 (chromium) total-vm:874140kB, anon-rss=
:19792kB, file-rss:400kB
[413548.033327] evince invoked oom-killer: gfp_mask=3D0x201da, order=3D0, o=
om_adj=3D0, oom_score_adj=3D0
[413548.033331] evince cpuset=3D/ mems_allowed=3D0
[413548.033333] Pid: 13544, comm: evince Tainted: G        W    3.5.4-1-ARC=
H #1
[413548.033335] Call Trace:
[413548.033341]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d=
/0xb0
[413548.033345]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[413548.033349]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[413548.033353]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[413548.033357]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[413548.033360]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[413548.033363]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[413548.033366]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[413548.033369]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[413548.033371]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[413548.033375]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[413548.033377]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[413548.033380]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[413548.033382]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[413548.033384]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[413548.033388]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[413548.033391]  [<ffffffff8147b83e>] ? mutex_unlock+0xe/0x10
[413548.033394]  [<ffffffff811ba57c>] ? inotify_ioctl+0x9c/0xb0
[413548.033396]  [<ffffffff8118aad7>] ? do_vfs_ioctl+0x97/0x530
[413548.033399]  [<ffffffff811bfcbd>] ? eventfd_read+0x3d/0x70
[413548.033401]  [<ffffffff8147e765>] page_fault+0x25/0x30
[413548.033403] Mem-Info:
[413548.033404] Node 0 DMA per-cpu:
[413548.033406] CPU    0: hi:    0, btch:   1 usd:   0
[413548.033407] CPU    1: hi:    0, btch:   1 usd:   0
[413548.033409] CPU    2: hi:    0, btch:   1 usd:   0
[413548.033410] CPU    3: hi:    0, btch:   1 usd:   0
[413548.033411] Node 0 DMA32 per-cpu:
[413548.033412] CPU    0: hi:  186, btch:  31 usd:  96
[413548.033413] CPU    1: hi:  186, btch:  31 usd:  30
[413548.033415] CPU    2: hi:  186, btch:  31 usd:  17
[413548.033416] CPU    3: hi:  186, btch:  31 usd:  17
[413548.033416] Node 0 Normal per-cpu:
[413548.033418] CPU    0: hi:  186, btch:  31 usd:  38
[413548.033419] CPU    1: hi:  186, btch:  31 usd:  32
[413548.033420] CPU    2: hi:  186, btch:  31 usd:   0
[413548.033421] CPU    3: hi:  186, btch:  31 usd:  88
[413548.033424] active_anon:121081 inactive_anon:105530 isolated_anon:0
 active_file:180 inactive_file:105 isolated_file:0
 unevictable:2629 dirty:1 writeback:55 unstable:0
 free:22500 slab_reclaimable:707821 slab_unreclaimable:7109
 mapped:2271 shmem:107124 pagetables:3671 bounce:0
[413548.033427] Node 0 DMA free:15856kB min:260kB low:324kB high:388kB acti=
ve_anon:16kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictabl=
e:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dir=
ty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:32kB slab_unrecl=
aimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeba=
ck_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[413548.033431] lowmem_reserve[]: 0 2137 3899 3899
[413548.033433] Node 0 DMA32 free:43792kB min:36900kB low:46124kB high:5534=
8kB active_anon:103820kB inactive_anon:99260kB active_file:148kB inactive_f=
ile:120kB unevictable:4096kB isolated(anon):0kB isolated(file):0kB present:=
2188752kB mlocked:8kB dirty:0kB writeback:84kB mapped:196kB shmem:99980kB s=
lab_reclaimable:1919836kB slab_unreclaimable:5852kB kernel_stack:184kB page=
tables:1048kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:914 a=
ll_unreclaimable? yes
[413548.033438] lowmem_reserve[]: 0 0 1762 1762
[413548.033440] Node 0 Normal free:30352kB min:30416kB low:38020kB high:456=
24kB active_anon:380488kB inactive_anon:322860kB active_file:572kB inactive=
_file:300kB unevictable:6420kB isolated(anon):0kB isolated(file):128kB pres=
ent:1804320kB mlocked:6420kB dirty:4kB writeback:136kB mapped:8888kB shmem:=
328516kB slab_reclaimable:911416kB slab_unreclaimable:22584kB kernel_stack:=
1616kB pagetables:13636kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_s=
canned:2118 all_unreclaimable? yes
[413548.033445] lowmem_reserve[]: 0 0 0 0
[413548.033447] Node 0 DMA: 2*4kB 1*8kB 2*16kB 4*32kB 3*64kB 3*128kB 3*256k=
B 2*512kB 3*1024kB 3*2048kB 1*4096kB =3D 15856kB
[413548.033453] Node 0 DMA32: 1775*4kB 3441*8kB 259*16kB 14*32kB 6*64kB 1*1=
28kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB =3D 43828kB
[413548.033459] Node 0 Normal: 5073*4kB 680*8kB 72*16kB 0*32kB 1*64kB 1*128=
kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB =3D 30404kB
[413548.033465] 108365 total pagecache pages
[413548.033466] 0 pages in swap cache
[413548.033467] Swap cache stats: add 0, delete 0, find 0/0
[413548.033468] Free swap  =3D 0kB
[413548.033469] Total swap =3D 0kB
[413548.043138] 1048048 pages RAM
[413548.043141] 57533 pages reserved
[413548.043142] 51066 pages shared
[413548.043143] 939508 pages non-shared
[413548.043146] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score=
_adj name
[413548.043153] [  191]     0   191     6555      406   0     -17         -=
1000 systemd-udevd
[413548.043156] [  194]     0   194    74640     2625   1       0          =
   0 systemd-journal
[413548.043159] [  301]     0   301     3302      305   1       0          =
   0 crond
[413548.043162] [  302]     0   302    17693      680   2       0          =
   0 cupsd
[413548.043164] [  304]     0   304    10502      322   1     -17         -=
1000 sshd
[413548.043167] [  305]    81   305     4433      295   1     -13          =
-900 dbus-daemon
[413548.043169] [  309]     0   309     6512      194   1       0          =
   0 systemd-logind
[413548.043171] [  315]     0   315    15747      314   2       0          =
   0 login
[413548.043174] [  316]     0   316     2031      190   0       0          =
   0 agetty
[413548.043176] [  317]     0   317     2031      186   0       0          =
   0 agetty
[413548.043179] [  319]     0   319     2031      188   1       0          =
   0 agetty
[413548.043181] [  320]     0   320     2031      189   1       0          =
   0 agetty
[413548.043184] [  321]     0   321     2031      188   1       0          =
   0 agetty
[413548.043186] [  325]     0   325    51901      515   3       0          =
   0 colord
[413548.043189] [  341]     0   341   123526     1044   1       0          =
   0 colord-sane
[413548.043192] [  395]     0   395     3092      205   1       0          =
   0 master
[413548.043194] [  399]    73   399    16380      399   3       0          =
   0 qmgr
[413548.043197] [  420]  1000   420     3423      283   2       0          =
   0 restart-x
[413548.043199] [  431]  1000   431     3423      298   3       0          =
   0 startx
[413548.043202] [  448]  1000   448     3966      147   3       0          =
   0 xinit
[413548.043204] [  449]  1000   449    82772     4528   3       0          =
   0 X
[413548.043207] [  470]  1000   470    24058      775   1       0          =
   0 i3
[413548.043210] [  477]  1000   477     6062      195   1       0          =
   0 unclutter
[413548.043212] [  480]  1000   480     6004      134   3       0          =
   0 dispad
[413548.043215] [  481]  1000   481    36621    12501   3       0          =
   0 urxvtd
[413548.043218] [  484]  1000   484     8068      456   3       0          =
   0 xbindkeys
[413548.043220] [  505]  1000   505     8155      657   3       0          =
   0 zsh
[413548.043222] [  512]     0   512     8481      273   3       0          =
   0 sudo
[413548.043225] [  513]     0   513     6933      430   3       0          =
   0 zsh
[413548.043228] [  543]     0   543     7404      242   1       0          =
   0 wpa_supplicant
[413548.043230] [  659]  1000   659     9860     1864   2       0          =
   0 zsh
[413548.043233] [  772]  1000   772     4494       95   3       0          =
   0 dbus-launch
[413548.043235] [  773]  1000   773     4379      241   0       0          =
   0 dbus-daemon
[413548.043238] [ 1575]  1000  1575    10065     2054   1       0          =
   0 zsh
[413548.043241] [ 2835]  1000  2835    40320      829   3       0          =
   0 kdeinit4
[413548.043244] [ 2837]  1000  2837    48444      803   3       0          =
   0 klauncher
[413548.043246] [ 2841]  1000  2841   109726     1951   2       0          =
   0 kded4
[413548.043249] [ 2858]  1000  2858   238338     2667   1       0          =
   0 knotify4
[413548.043251] [ 2863]     0  2863    54958     1191   2       0          =
   0 upowerd
[413548.043254] [ 2868]     0  2868    46649      322   2     -13          =
-900 polkitd
[413548.043256] [ 2895]     0  2895    48361      444   0       0          =
   0 udisks-daemon
[413548.043259] [ 2904]     0  2904    11353      123   1       0          =
   0 udisks-daemon
[413548.043262] [ 6623]  1000  6623     8891      897   2       0          =
   0 zsh
[413548.043264] [ 8723]  1000  8723     8785      780   3       0          =
   0 zsh
[413548.043267] [14485]  1000 14485     8773      768   1       0          =
   0 zsh
[413548.043269] [30479]     0 30479     8481      274   1       0          =
   0 sudo
[413548.043272] [30480]     0 30480     6933      483   1       0          =
   0 zsh
[413548.043274] [ 2064]  1000  2064     9797     1774   3       0          =
   0 zsh
[413548.043277] [ 3202]  1000  3202     9839     1851   1       0          =
   0 zsh
[413548.043279] [14763]  1000 14763     8914      903   1       0          =
   0 zsh
[413548.043282] [29947]  1000 29947     5163      267   0       0          =
   0 zsh
[413548.043285] [29950]  1000 29950   164155    41986   1       0          =
   0 chromium
[413548.043287] [29952]  1000 29952    64978     1238   0       0          =
   0 chromium
[413548.043289] [29953]  1000 29953     1588      137   0       0          =
   0 chromium-sandbo
[413548.043292] [29954]  1000 29954    70030     1322   0       0          =
   0 chromium
[413548.043294] [29960]  1000 29960    34745      443   0       0          =
   0 nacl_helper_boo
[413548.043297] [29961]  1000 29961    76177     1173   2       0          =
   0 chromium
[413548.043300] [20018]     0 20018     2136      132   0       0          =
   0 dhcpcd
[413548.043303] [23649]  1000 23649    63938      837   1       0          =
   0 dconf-service
[413548.043305] [25961]  1000 25961    14690      738   2       0          =
   0 mutt
[413548.043308] [13576]     0 13576     4494       95   0       0          =
   0 dbus-launch
[413548.043311] [13577]     0 13577     4320      173   2       0          =
   0 dbus-daemon
[413548.043313] [21389]  1000 21389     8809      811   0       0          =
   0 zsh
[413548.043316] [ 5745]  1000  5745     9866     1857   2       0          =
   0 zsh
[413548.043318] [ 5944]  1000  5944     9776     1765   3       0          =
   0 zsh
[413548.043321] [ 8651]  1000  8651    10239     2241   2       0          =
   0 zsh
[413548.043323] [10927]  1000 10927     8891      902   3       0          =
   0 zsh
[413548.043326] [13485]  1000 13485     8773      766   2       0          =
   0 zsh
[413548.043329] [13492]  1000 13492    14788      869   2       0          =
   0 mutt
[413548.043331] [13504]  1000 13504    19180      555   3       0          =
   0 i3bar
[413548.043334] [13505]  1000 13505     8066      610   1       0          =
   0 i3status
[413548.043336] [13897]  1000 13897    10964     2958   1       0          =
   0 zsh
[413548.043339] [25693]  1000 25693     8806      803   3       0          =
   0 zsh
[413548.043341] [12076]  1000 12076     9025     1036   3       0          =
   0 zsh
[413548.043344] [22068]  1000 22068     8830      834   0       0          =
   0 zsh
[413548.043347] [ 3498]     0  3498     4755     2630   1       0          =
   0 atop
[413548.043349] [12787]  1000 12787     9835     1831   3       0          =
   0 zsh
[413548.043352] [30808]  1000 30808     8155      673   2       0          =
   0 zsh
[413548.043354] [ 2155]  1000  2155     8155      674   2       0          =
   0 zsh
[413548.043356] [ 2681]  1000  2681     4459      503   0       0          =
   0 man
[413548.043359] [ 2692]  1000  2692     2781      255   3       0          =
   0 less
[413548.043361] [ 3641]  1000  3641     8285      652   3       0          =
   0 vim
[413548.043364] [ 4824]  1000  4824     8176      698   2       0          =
   0 zsh
[413548.043367] [ 6094]  1000  6094     9005      323   1       0          =
   0 ssh
[413548.043370] [ 6096]  1000  6096     8970      209   3       0          =
   0 ssh
[413548.043373] [ 6098]  1000  6098     8970      300   1       0          =
   0 ssh
[413548.043376] [ 8888]  1000  8888    44968      254   2       0          =
   0 evinced
[413548.043379] [11133]     0 11133     8481      273   0       0          =
   0 sudo
[413548.043382] [11137]     0 11137     3457      299   1       0          =
   0 ccollect
[413548.043384] [11142]     0 11142     3457      206   0       0          =
   0 ccollect
[413548.043387] [11143]     0 11143     3457      148   0       0          =
   0 ccollect
[413548.043389] [11144]     0 11144     2919      224   3       0          =
   0 awk
[413548.043392] [11196]     0 11196     3891     2500   0       0          =
   0 rm
[413548.043395] [11239]    73 11239    16333      344   2       0          =
   0 pickup
[413548.043398] [13544]  1000 13544   130892    14695   1       0          =
   0 evince
[413548.043401] [13571]  1000 13571     8716      729   1       0          =
   0 zsh
[413548.043404] [13605]  1000 13605     2749      211   1       0          =
   0 less
[413548.043407] [13801]  1000 13801   218165     2040   1       4          =
 300 chromium
[413548.043409] [13842]  1000 13842   217141     2036   2       4          =
 300 chromium
[413548.043411] Out of memory: Kill process 13801 (chromium) score 302 or s=
acrifice child
[413548.043415] Killed process 13801 (chromium) total-vm:872660kB, anon-rss=
:7644kB, file-rss:516kB
[413557.184490] evince invoked oom-killer: gfp_mask=3D0x44d0, order=3D2, oo=
m_adj=3D0, oom_score_adj=3D0
[413557.184494] evince cpuset=3D/ mems_allowed=3D0
[413557.184496] Pid: 13544, comm: evince Tainted: G        W    3.5.4-1-ARC=
H #1
[413557.184498] Call Trace:
[413557.184503]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d=
/0xb0
[413557.184508]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[413557.184512]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[413557.184517]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[413557.184521]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[413557.184523]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[413557.184526]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[413557.184529]  [<ffffffff81476834>] kmalloc_large_node+0x61/0x8e
[413557.184533]  [<ffffffff81166b0f>] __kmalloc_node_track_caller+0x19f/0x2=
30
[413557.184536]  [<ffffffff8136fc51>] ? sock_alloc_send_pskb+0x1d1/0x320
[413557.184539]  [<ffffffff81374ec9>] __alloc_skb+0x79/0x230
[413557.184541]  [<ffffffff8136fc51>] sock_alloc_send_pskb+0x1d1/0x320
[413557.184544]  [<ffffffff8118cd16>] ? do_sys_poll+0x3e6/0x4c0
[413557.184546]  [<ffffffff8136fdb5>] sock_alloc_send_skb+0x15/0x20
[413557.184550]  [<ffffffff81411e8b>] unix_stream_sendmsg+0x27b/0x450
[413557.184552]  [<ffffffff8136c4a7>] sock_aio_write+0x147/0x180
[413557.184554]  [<ffffffff8136c360>] ? sock_aio_read+0x40/0x40
[413557.184557]  [<ffffffff8117952a>] do_sync_readv_writev+0xda/0x120
[413557.184561]  [<ffffffff8120567c>] ? security_file_permission+0x2c/0xb0
[413557.184563]  [<ffffffff81178c41>] ? rw_verify_area+0x61/0xf0
[413557.184565]  [<ffffffff81179814>] do_readv_writev+0xd4/0x1e0
[413557.184567]  [<ffffffff81179955>] vfs_writev+0x35/0x60
[413557.184569]  [<ffffffff81179aea>] sys_writev+0x4a/0xc0
[413557.184571]  [<ffffffff8118cecb>] ? sys_poll+0x6b/0x100
[413557.184575]  [<ffffffff814853ed>] system_call_fastpath+0x1a/0x1f
[413557.184577] Mem-Info:
[413557.184578] Node 0 DMA per-cpu:
[413557.184580] CPU    0: hi:    0, btch:   1 usd:   0
[413557.184581] CPU    1: hi:    0, btch:   1 usd:   0
[413557.184582] CPU    2: hi:    0, btch:   1 usd:   0
[413557.184583] CPU    3: hi:    0, btch:   1 usd:   0
[413557.184584] Node 0 DMA32 per-cpu:
[413557.184586] CPU    0: hi:  186, btch:  31 usd:   0
[413557.184587] CPU    1: hi:  186, btch:  31 usd:   0
[413557.184588] CPU    2: hi:  186, btch:  31 usd:   0
[413557.184589] CPU    3: hi:  186, btch:  31 usd:   0
[413557.184590] Node 0 Normal per-cpu:
[413557.184592] CPU    0: hi:  186, btch:  31 usd:   4
[413557.184593] CPU    1: hi:  186, btch:  31 usd:   0
[413557.184594] CPU    2: hi:  186, btch:  31 usd:   0
[413557.184595] CPU    3: hi:  186, btch:  31 usd:   0
[413557.184598] active_anon:120187 inactive_anon:105501 isolated_anon:0
 active_file:0 inactive_file:0 isolated_file:33
 unevictable:2629 dirty:7 writeback:0 unstable:0
 free:23469 slab_reclaimable:708660 slab_unreclaimable:7103
 mapped:2254 shmem:107115 pagetables:3528 bounce:0
[413557.184600] Node 0 DMA free:15856kB min:260kB low:324kB high:388kB acti=
ve_anon:16kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictabl=
e:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dir=
ty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:32kB slab_unrecl=
aimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeba=
ck_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[413557.184604] lowmem_reserve[]: 0 2137 3899 3899
[413557.184607] Node 0 DMA32 free:46068kB min:36900kB low:46124kB high:5534=
8kB active_anon:102224kB inactive_anon:99212kB active_file:0kB inactive_fil=
e:0kB unevictable:4096kB isolated(anon):0kB isolated(file):0kB present:2188=
752kB mlocked:8kB dirty:12kB writeback:0kB mapped:296kB shmem:99928kB slab_=
reclaimable:1921128kB slab_unreclaimable:5808kB kernel_stack:160kB pagetabl=
es:656kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:287 all_un=
reclaimable? yes
[413557.184612] lowmem_reserve[]: 0 0 1762 1762
[413557.184614] Node 0 Normal free:31952kB min:30416kB low:38020kB high:456=
24kB active_anon:378508kB inactive_anon:322792kB active_file:0kB inactive_f=
ile:0kB unevictable:6420kB isolated(anon):0kB isolated(file):132kB present:=
1804320kB mlocked:6420kB dirty:16kB writeback:0kB mapped:8720kB shmem:32853=
2kB slab_reclaimable:913480kB slab_unreclaimable:22604kB kernel_stack:1608k=
B pagetables:13456kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanne=
d:384 all_unreclaimable? yes
[413557.184618] lowmem_reserve[]: 0 0 0 0
[413557.184620] Node 0 DMA: 2*4kB 1*8kB 2*16kB 4*32kB 3*64kB 3*128kB 3*256k=
B 2*512kB 3*1024kB 3*2048kB 1*4096kB =3D 15856kB
[413557.184627] Node 0 DMA32: 2195*4kB 3542*8kB 268*16kB 12*32kB 4*64kB 0*1=
28kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB =3D 46140kB
[413557.184632] Node 0 Normal: 5866*4kB 611*8kB 11*16kB 0*32kB 1*64kB 1*128=
kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB =3D 32048kB
[413557.184639] 108041 total pagecache pages
[413557.184640] 0 pages in swap cache
[413557.184641] Swap cache stats: add 0, delete 0, find 0/0
[413557.184642] Free swap  =3D 0kB
[413557.184643] Total swap =3D 0kB
[413557.193630] 1048048 pages RAM
[413557.193633] 57533 pages reserved
[413557.193634] 49669 pages shared
[413557.193635] 939119 pages non-shared
[413557.193636] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score=
_adj name
[413557.193644] [  191]     0   191     6555      406   0     -17         -=
1000 systemd-udevd
[413557.193647] [  194]     0   194    74640     2667   3       0          =
   0 systemd-journal
[413557.193651] [  301]     0   301     3302      305   1       0          =
   0 crond
[413557.193654] [  302]     0   302    17693      680   2       0          =
   0 cupsd
[413557.193656] [  304]     0   304    10502      322   1     -17         -=
1000 sshd
[413557.193659] [  305]    81   305     4433      295   1     -13          =
-900 dbus-daemon
[413557.193661] [  309]     0   309     6512      194   1       0          =
   0 systemd-logind
[413557.193664] [  315]     0   315    15747      314   2       0          =
   0 login
[413557.193666] [  316]     0   316     2031      190   0       0          =
   0 agetty
[413557.193668] [  317]     0   317     2031      186   0       0          =
   0 agetty
[413557.193671] [  319]     0   319     2031      188   1       0          =
   0 agetty
[413557.193674] [  320]     0   320     2031      189   1       0          =
   0 agetty
[413557.193676] [  321]     0   321     2031      188   1       0          =
   0 agetty
[413557.193678] [  325]     0   325    51901      515   3       0          =
   0 colord
[413557.193681] [  341]     0   341   123526     1044   1       0          =
   0 colord-sane
[413557.193684] [  395]     0   395     3092      205   1       0          =
   0 master
[413557.193686] [  399]    73   399    16380      399   3       0          =
   0 qmgr
[413557.193690] [  420]  1000   420     3423      283   2       0          =
   0 restart-x
[413557.193692] [  431]  1000   431     3423      298   3       0          =
   0 startx
[413557.193695] [  448]  1000   448     3966      147   3       0          =
   0 xinit
[413557.193698] [  449]  1000   449    82749     4528   3       0          =
   0 X
[413557.193700] [  470]  1000   470    24058      804   3       0          =
   0 i3
[413557.193703] [  477]  1000   477     6062      195   1       0          =
   0 unclutter
[413557.193706] [  480]  1000   480     6004      125   2       0          =
   0 dispad
[413557.193708] [  481]  1000   481    36621    12501   3       0          =
   0 urxvtd
[413557.193711] [  484]  1000   484     8068      456   3       0          =
   0 xbindkeys
[413557.193713] [  505]  1000   505     8155      657   3       0          =
   0 zsh
[413557.193716] [  512]     0   512     8481      273   3       0          =
   0 sudo
[413557.193719] [  513]     0   513     6933      430   3       0          =
   0 zsh
[413557.193721] [  543]     0   543     7404      237   1       0          =
   0 wpa_supplicant
[413557.193723] [  659]  1000   659     9860     1864   2       0          =
   0 zsh
[413557.193726] [  772]  1000   772     4494       95   3       0          =
   0 dbus-launch
[413557.193728] [  773]  1000   773     4379      241   0       0          =
   0 dbus-daemon
[413557.193731] [ 1575]  1000  1575    10065     2054   1       0          =
   0 zsh
[413557.193734] [ 2835]  1000  2835    40320      829   3       0          =
   0 kdeinit4
[413557.193737] [ 2837]  1000  2837    48444      803   3       0          =
   0 klauncher
[413557.193739] [ 2841]  1000  2841   109726     1986   2       0          =
   0 kded4
[413557.193742] [ 2858]  1000  2858   238338     2667   1       0          =
   0 knotify4
[413557.193745] [ 2863]     0  2863    54958     1191   2       0          =
   0 upowerd
[413557.193748] [ 2868]     0  2868    46649      322   2     -13          =
-900 polkitd
[413557.193751] [ 2895]     0  2895    48361      444   0       0          =
   0 udisks-daemon
[413557.193754] [ 2904]     0  2904    11353      123   1       0          =
   0 udisks-daemon
[413557.193758] [ 6623]  1000  6623     8891      897   2       0          =
   0 zsh
[413557.193760] [ 8723]  1000  8723     8785      780   3       0          =
   0 zsh
[413557.193763] [14485]  1000 14485     8773      768   1       0          =
   0 zsh
[413557.193766] [30479]     0 30479     8481      274   1       0          =
   0 sudo
[413557.193768] [30480]     0 30480     6933      483   1       0          =
   0 zsh
[413557.193770] [ 2064]  1000  2064     9797     1774   3       0          =
   0 zsh
[413557.193771] [ 3202]  1000  3202     9839     1851   1       0          =
   0 zsh
[413557.193773] [14763]  1000 14763     8914      903   1       0          =
   0 zsh
[413557.193775] [29947]  1000 29947     5163      267   0       0          =
   0 zsh
[413557.193777] [29950]  1000 29950   164155    42043   1       0          =
   0 chromium
[413557.193779] [29952]  1000 29952    64978     1238   0       0          =
   0 chromium
[413557.193780] [29953]  1000 29953     1588      137   0       0          =
   0 chromium-sandbo
[413557.193782] [29954]  1000 29954    70030     1322   0       0          =
   0 chromium
[413557.193784] [29960]  1000 29960    34745      443   0       0          =
   0 nacl_helper_boo
[413557.193786] [29961]  1000 29961    76177     1199   1       0          =
   0 chromium
[413557.193787] [20018]     0 20018     2136      132   0       0          =
   0 dhcpcd
[413557.193789] [23649]  1000 23649    63938      837   1       0          =
   0 dconf-service
[413557.193791] [25961]  1000 25961    14690      738   2       0          =
   0 mutt
[413557.193793] [13576]     0 13576     4494       95   0       0          =
   0 dbus-launch
[413557.193795] [13577]     0 13577     4320      173   2       0          =
   0 dbus-daemon
[413557.193796] [21389]  1000 21389     8809      811   0       0          =
   0 zsh
[413557.193798] [ 5745]  1000  5745     9866     1857   2       0          =
   0 zsh
[413557.193801] [ 5944]  1000  5944     9776     1765   3       0          =
   0 zsh
[413557.193803] [ 8651]  1000  8651    10239     2241   2       0          =
   0 zsh
[413557.193804] [10927]  1000 10927     8891      902   3       0          =
   0 zsh
[413557.193806] [13485]  1000 13485     8773      766   2       0          =
   0 zsh
[413557.193808] [13492]  1000 13492    14788      869   2       0          =
   0 mutt
[413557.193809] [13504]  1000 13504    19180      526   1       0          =
   0 i3bar
[413557.193811] [13505]  1000 13505     8066      588   2       0          =
   0 i3status
[413557.193813] [13897]  1000 13897    10964     2958   1       0          =
   0 zsh
[413557.193815] [25693]  1000 25693     8806      803   3       0          =
   0 zsh
[413557.193817] [12076]  1000 12076     9025     1036   3       0          =
   0 zsh
[413557.193819] [22068]  1000 22068     8830      834   0       0          =
   0 zsh
[413557.193821] [ 3498]     0  3498     4755     2630   1       0          =
   0 atop
[413557.193823] [12787]  1000 12787     9835     1831   3       0          =
   0 zsh
[413557.193825] [30808]  1000 30808     8155      673   2       0          =
   0 zsh
[413557.193827] [ 2155]  1000  2155     8155      674   2       0          =
   0 zsh
[413557.193829] [ 2681]  1000  2681     4459      503   0       0          =
   0 man
[413557.193831] [ 2692]  1000  2692     2781      255   3       0          =
   0 less
[413557.193832] [ 3641]  1000  3641     8285      652   3       0          =
   0 vim
[413557.193834] [ 4824]  1000  4824     8176      698   2       0          =
   0 zsh
[413557.193837] [ 6094]  1000  6094     9005      323   1       0          =
   0 ssh
[413557.193838] [ 6096]  1000  6096     8970      209   3       0          =
   0 ssh
[413557.193840] [ 6098]  1000  6098     8970      300   1       0          =
   0 ssh
[413557.193842] [ 8888]  1000  8888    44968      254   2       0          =
   0 evinced
[413557.193844] [11133]     0 11133     8481      273   0       0          =
   0 sudo
[413557.193846] [11137]     0 11137     3457      299   1       0          =
   0 ccollect
[413557.193848] [11142]     0 11142     3457      206   0       0          =
   0 ccollect
[413557.193850] [11143]     0 11143     3457      148   0       0          =
   0 ccollect
[413557.193852] [11144]     0 11144     2919      224   3       0          =
   0 awk
[413557.193854] [11196]     0 11196     3891     2507   3       0          =
   0 rm
[413557.193856] [11239]    73 11239    16333      344   2       0          =
   0 pickup
[413557.193859] [13544]  1000 13544   130892    14729   1       0          =
   0 evince
[413557.193860] [13571]  1000 13571     8716      729   1       0          =
   0 zsh
[413557.193862] [13605]  1000 13605     2749      211   1       0          =
   0 less
[413557.193864] [13842]  1000 13842   218165     2040   1       4          =
 300 chromium
[413557.193866] Out of memory: Kill process 13842 (chromium) score 302 or s=
acrifice child
[413557.193868] Killed process 13842 (chromium) total-vm:872660kB, anon-rss=
:7588kB, file-rss:572kB
[413561.455358] X invoked oom-killer: gfp_mask=3D0x201da, order=3D0, oom_ad=
j=3D0, oom_score_adj=3D0
[413561.455362] X cpuset=3D/ mems_allowed=3D0
[413561.455366] Pid: 449, comm: X Tainted: G        W    3.5.4-1-ARCH #1
[413561.455367] Call Trace:
[413561.455375]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d=
/0xb0
[413561.455380]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[413561.455385]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[413561.455391]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[413561.455396]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[413561.455399]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[413561.455404]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[413561.455408]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[413561.455412]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[413561.455415]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[413561.455420]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[413561.455424]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[413561.455427]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[413561.455431]  [<ffffffff8118c557>] ? core_sys_select+0x267/0x320
[413561.455434]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[413561.455438]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[413561.455442]  [<ffffffff8117a07c>] ? get_empty_filp+0x8c/0x190
[413561.455444]  [<ffffffff8117a1ab>] ? alloc_file+0x2b/0xd0
[413561.455448]  [<ffffffff8136bc14>] ? sock_alloc_file+0xa4/0x120
[413561.455452]  [<ffffffff81177354>] ? fd_install+0x64/0x80
[413561.455455]  [<ffffffff8136bcba>] ? sock_map_fd+0x2a/0x40
[413561.455458]  [<ffffffff8147e765>] page_fault+0x25/0x30
[413561.455459] Mem-Info:
[413561.455461] Node 0 DMA per-cpu:
[413561.455464] CPU    0: hi:    0, btch:   1 usd:   0
[413561.455466] CPU    1: hi:    0, btch:   1 usd:   0
[413561.455468] CPU    2: hi:    0, btch:   1 usd:   0
[413561.455469] CPU    3: hi:    0, btch:   1 usd:   0
[413561.455471] Node 0 DMA32 per-cpu:
[413561.455474] CPU    0: hi:  186, btch:  31 usd:  59
[413561.455475] CPU    1: hi:  186, btch:  31 usd: 182
[413561.455477] CPU    2: hi:  186, btch:  31 usd:  30
[413561.455479] CPU    3: hi:  186, btch:  31 usd:  30
[413561.455480] Node 0 Normal per-cpu:
[413561.455483] CPU    0: hi:  186, btch:  31 usd:  79
[413561.455485] CPU    1: hi:  186, btch:  31 usd:  51
[413561.455486] CPU    2: hi:  186, btch:  31 usd:  30
[413561.455488] CPU    3: hi:  186, btch:  31 usd:  62
[413561.455493] active_anon:119568 inactive_anon:105522 isolated_anon:0
 active_file:0 inactive_file:73 isolated_file:38
 unevictable:2629 dirty:12 writeback:0 unstable:0
 free:22484 slab_reclaimable:709689 slab_unreclaimable:7105
 mapped:2307 shmem:107171 pagetables:3431 bounce:0
[413561.455497] Node 0 DMA free:15856kB min:260kB low:324kB high:388kB acti=
ve_anon:16kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictabl=
e:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dir=
ty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:32kB slab_unrecl=
aimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeba=
ck_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[413561.455503] lowmem_reserve[]: 0 2137 3899 3899
[413561.455507] Node 0 DMA32 free:43744kB min:36900kB low:46124kB high:5534=
8kB active_anon:102048kB inactive_anon:99228kB active_file:44kB inactive_fi=
le:452kB unevictable:4096kB isolated(anon):0kB isolated(file):152kB present=
:2188752kB mlocked:8kB dirty:8kB writeback:0kB mapped:468kB shmem:99952kB s=
lab_reclaimable:1921612kB slab_unreclaimable:5816kB kernel_stack:176kB page=
tables:752kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:28026 =
all_unreclaimable? yes
[413561.455514] lowmem_reserve[]: 0 0 1762 1762
[413561.455518] Node 0 Normal free:30336kB min:30416kB low:38020kB high:456=
24kB active_anon:376208kB inactive_anon:322860kB active_file:0kB inactive_f=
ile:0kB unevictable:6420kB isolated(anon):0kB isolated(file):0kB present:18=
04320kB mlocked:6420kB dirty:40kB writeback:0kB mapped:8760kB shmem:328732k=
B slab_reclaimable:917112kB slab_unreclaimable:22604kB kernel_stack:1584kB =
pagetables:12972kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:=
21331 all_unreclaimable? yes
[413561.455525] lowmem_reserve[]: 0 0 0 0
[413561.455528] Node 0 DMA: 2*4kB 1*8kB 2*16kB 4*32kB 3*64kB 3*128kB 3*256k=
B 2*512kB 3*1024kB 3*2048kB 1*4096kB =3D 15856kB
[413561.455538] Node 0 DMA32: 2065*4kB 3657*8kB 131*16kB 0*32kB 0*64kB 0*12=
8kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB =3D 43708kB
[413561.455547] Node 0 Normal: 5771*4kB 471*8kB 4*16kB 0*32kB 1*64kB 1*128k=
B 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB =3D 30436kB
[413561.455556] 108243 total pagecache pages
[413561.455558] 0 pages in swap cache
[413561.455560] Swap cache stats: add 0, delete 0, find 0/0
[413561.455561] Free swap  =3D 0kB
[413561.455562] Total swap =3D 0kB
[413561.468336] 1048048 pages RAM
[413561.468338] 57533 pages reserved
[413561.468339] 49250 pages shared
[413561.468340] 939380 pages non-shared
[413561.468342] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score=
_adj name
[413561.468348] [  191]     0   191     6555      406   0     -17         -=
1000 systemd-udevd
[413561.468352] [  194]     0   194    74652     2709   3       0          =
   0 systemd-journal
[413561.468355] [  301]     0   301     3302      309   1       0          =
   0 crond
[413561.468357] [  302]     0   302    17693      680   2       0          =
   0 cupsd
[413561.468359] [  304]     0   304    10502      322   1     -17         -=
1000 sshd
[413561.468362] [  305]    81   305     4433      295   1     -13          =
-900 dbus-daemon
[413561.468364] [  309]     0   309     6512      194   1       0          =
   0 systemd-logind
[413561.468366] [  315]     0   315    15747      314   2       0          =
   0 login
[413561.468369] [  316]     0   316     2031      190   0       0          =
   0 agetty
[413561.468371] [  317]     0   317     2031      186   0       0          =
   0 agetty
[413561.468374] [  319]     0   319     2031      188   1       0          =
   0 agetty
[413561.468376] [  320]     0   320     2031      189   1       0          =
   0 agetty
[413561.468378] [  321]     0   321     2031      188   1       0          =
   0 agetty
[413561.468381] [  325]     0   325    51901      515   3       0          =
   0 colord
[413561.468383] [  341]     0   341   123526     1044   1       0          =
   0 colord-sane
[413561.468385] [  395]     0   395     3092      243   1       0          =
   0 master
[413561.468387] [  399]    73   399    16380      410   2       0          =
   0 qmgr
[413561.468390] [  420]  1000   420     3423      283   2       0          =
   0 restart-x
[413561.468392] [  431]  1000   431     3423      298   3       0          =
   0 startx
[413561.468395] [  448]  1000   448     3966      147   3       0          =
   0 xinit
[413561.468397] [  449]  1000   449    82749     4530   3       0          =
   0 X
[413561.468399] [  470]  1000   470    24058      804   3       0          =
   0 i3
[413561.468401] [  477]  1000   477     6062      195   1       0          =
   0 unclutter
[413561.468404] [  480]  1000   480     6004      128   2       0          =
   0 dispad
[413561.468406] [  481]  1000   481    36621    12501   3       0          =
   0 urxvtd
[413561.468408] [  484]  1000   484     8068      456   3       0          =
   0 xbindkeys
[413561.468410] [  505]  1000   505     8155      657   3       0          =
   0 zsh
[413561.468413] [  512]     0   512     8481      273   3       0          =
   0 sudo
[413561.468415] [  513]     0   513     6933      430   3       0          =
   0 zsh
[413561.468418] [  543]     0   543     7404      237   1       0          =
   0 wpa_supplicant
[413561.468420] [  659]  1000   659     9860     1864   2       0          =
   0 zsh
[413561.468422] [  772]  1000   772     4494       95   3       0          =
   0 dbus-launch
[413561.468425] [  773]  1000   773     4379      241   0       0          =
   0 dbus-daemon
[413561.468427] [ 1575]  1000  1575    10065     2054   1       0          =
   0 zsh
[413561.468430] [ 2835]  1000  2835    40320      829   3       0          =
   0 kdeinit4
[413561.468432] [ 2837]  1000  2837    48444      803   3       0          =
   0 klauncher
[413561.468434] [ 2841]  1000  2841   109726     1983   2       0          =
   0 kded4
[413561.468437] [ 2858]  1000  2858   238338     2667   1       0          =
   0 knotify4
[413561.468439] [ 2863]     0  2863    54958     1191   2       0          =
   0 upowerd
[413561.468441] [ 2868]     0  2868    46649      346   2     -13          =
-900 polkitd
[413561.468444] [ 2895]     0  2895    48361      444   0       0          =
   0 udisks-daemon
[413561.468446] [ 2904]     0  2904    11353      123   1       0          =
   0 udisks-daemon
[413561.468448] [ 6623]  1000  6623     8891      897   2       0          =
   0 zsh
[413561.468451] [ 8723]  1000  8723     8785      780   3       0          =
   0 zsh
[413561.468453] [14485]  1000 14485     8773      768   1       0          =
   0 zsh
[413561.468455] [30479]     0 30479     8481      274   1       0          =
   0 sudo
[413561.468458] [30480]     0 30480     6933      483   1       0          =
   0 zsh
[413561.468460] [ 2064]  1000  2064     9797     1774   3       0          =
   0 zsh
[413561.468462] [ 3202]  1000  3202     9839     1851   1       0          =
   0 zsh
[413561.468464] [14763]  1000 14763     8914      903   1       0          =
   0 zsh
[413561.468467] [29947]  1000 29947     5163      267   0       0          =
   0 zsh
[413561.468469] [29950]  1000 29950   164155    41984   0       0          =
   0 chromium
[413561.468471] [29952]  1000 29952    64978     1238   0       0          =
   0 chromium
[413561.468473] [29953]  1000 29953     1588      137   0       0          =
   0 chromium-sandbo
[413561.468476] [29954]  1000 29954    70030     1322   0       0          =
   0 chromium
[413561.468478] [29960]  1000 29960    34745      443   0       0          =
   0 nacl_helper_boo
[413561.468481] [29961]  1000 29961    76177     1173   3       0          =
   0 chromium
[413561.468483] [20018]     0 20018     2136      132   0       0          =
   0 dhcpcd
[413561.468485] [23649]  1000 23649    63938      837   1       0          =
   0 dconf-service
[413561.468488] [25961]  1000 25961    14690      738   2       0          =
   0 mutt
[413561.468490] [13576]     0 13576     4494       95   0       0          =
   0 dbus-launch
[413561.468492] [13577]     0 13577     4320      173   2       0          =
   0 dbus-daemon
[413561.468495] [21389]  1000 21389     8809      811   0       0          =
   0 zsh
[413561.468497] [ 5745]  1000  5745     9866     1857   2       0          =
   0 zsh
[413561.468499] [ 5944]  1000  5944     9776     1765   3       0          =
   0 zsh
[413561.468502] [ 8651]  1000  8651    10239     2241   2       0          =
   0 zsh
[413561.468505] [10927]  1000 10927     8891      902   3       0          =
   0 zsh
[413561.468507] [13485]  1000 13485     8773      766   2       0          =
   0 zsh
[413561.468509] [13492]  1000 13492    14788      869   2       0          =
   0 mutt
[413561.468511] [13504]  1000 13504    19180      534   3       0          =
   0 i3bar
[413561.468514] [13505]  1000 13505     8066      608   3       0          =
   0 i3status
[413561.468516] [13897]  1000 13897    10964     2958   1       0          =
   0 zsh
[413561.468519] [25693]  1000 25693     8806      803   3       0          =
   0 zsh
[413561.468521] [12076]  1000 12076     9025     1036   3       0          =
   0 zsh
[413561.468524] [22068]  1000 22068     8830      834   0       0          =
   0 zsh
[413561.468527] [ 3498]     0  3498     4755     2630   1       0          =
   0 atop
[413561.468529] [12787]  1000 12787     9835     1831   3       0          =
   0 zsh
[413561.468531] [30808]  1000 30808     8155      673   2       0          =
   0 zsh
[413561.468534] [ 2155]  1000  2155     8155      674   2       0          =
   0 zsh
[413561.468536] [ 2681]  1000  2681     4459      503   0       0          =
   0 man
[413561.468539] [ 2692]  1000  2692     2781      255   3       0          =
   0 less
[413561.468541] [ 3641]  1000  3641     8285      652   3       0          =
   0 vim
[413561.468545] [ 4824]  1000  4824     8176      698   2       0          =
   0 zsh
[413561.468549] [ 6094]  1000  6094     9005      323   1       0          =
   0 ssh
[413561.468551] [ 6096]  1000  6096     8970      209   3       0          =
   0 ssh
[413561.468555] [ 6098]  1000  6098     8970      300   1       0          =
   0 ssh
[413561.468557] [ 8888]  1000  8888    44968      254   2       0          =
   0 evinced
[413561.468560] [11133]     0 11133     8481      273   0       0          =
   0 sudo
[413561.468563] [11137]     0 11137     3457      299   1       0          =
   0 ccollect
[413561.468565] [11142]     0 11142     3457      206   0       0          =
   0 ccollect
[413561.468567] [11143]     0 11143     3457      148   0       0          =
   0 ccollect
[413561.468570] [11144]     0 11144     2919      224   3       0          =
   0 awk
[413561.468572] [11196]     0 11196     3891     2525   2       0          =
   0 rm
[413561.468575] [11239]    73 11239    16333      344   2       0          =
   0 pickup
[413561.468579] [13544]  1000 13544   130892    14737   0       0          =
   0 evince
[413561.468581] [13571]  1000 13571     8716      729   1       0          =
   0 zsh
[413561.468583] [13605]  1000 13605     2749      211   1       0          =
   0 less
[413561.468586] [13850]     0 13850     9169      384   2       0          =
   0 crond
[413561.468589] [13851]  1000 13851     2937      210   2       0          =
   0 sh
[413561.468591] [13852]  1000 13852     4878      257   0       0          =
   0 fetchmail
[413561.468593] Out of memory: Kill process 29950 (chromium) score 42 or sa=
crifice child
[413561.468599] Killed process 29952 (chromium) total-vm:259912kB, anon-rss=
:4628kB, file-rss:324kB
[413563.085896] fetchmail invoked oom-killer: gfp_mask=3D0x201da, order=3D0=
, oom_adj=3D0, oom_score_adj=3D0
[413563.085900] fetchmail cpuset=3D/ mems_allowed=3D0
[413563.085903] Pid: 13852, comm: fetchmail Tainted: G        W    3.5.4-1-=
ARCH #1
[413563.085905] Call Trace:
[413563.085912]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d=
/0xb0
[413563.085917]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[413563.085922]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[413563.085928]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[413563.085933]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[413563.085936]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[413563.085941]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[413563.085945]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[413563.085949]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[413563.085952]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[413563.085957]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[413563.085960]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[413563.085965]  [<ffffffff81376897>] ? __kfree_skb+0x47/0xa0
[413563.085969]  [<ffffffff8147d029>] ? schedule+0x29/0x70
[413563.085973]  [<ffffffff8147a9f4>] ? schedule_timeout+0x2b4/0x340
[413563.085976]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[413563.085981]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[413563.085986]  [<ffffffff81079a38>] ? hrtimer_start+0x18/0x20
[413563.085991]  [<ffffffff81058b3c>] ? do_setitimer+0x1cc/0x260
[413563.085994]  [<ffffffff81058d0d>] ? sys_setitimer+0xdd/0x120
[413563.085997]  [<ffffffff8147e765>] page_fault+0x25/0x30
[413563.085999] Mem-Info:
[413563.086001] Node 0 DMA per-cpu:
[413563.086004] CPU    0: hi:    0, btch:   1 usd:   0
[413563.086006] CPU    1: hi:    0, btch:   1 usd:   0
[413563.086007] CPU    2: hi:    0, btch:   1 usd:   0
[413563.086009] CPU    3: hi:    0, btch:   1 usd:   0
[413563.086011] Node 0 DMA32 per-cpu:
[413563.086014] CPU    0: hi:  186, btch:  31 usd: 146
[413563.086015] CPU    1: hi:  186, btch:  31 usd:  16
[413563.086017] CPU    2: hi:  186, btch:  31 usd:  29
[413563.086019] CPU    3: hi:  186, btch:  31 usd:  62
[413563.086020] Node 0 Normal per-cpu:
[413563.086023] CPU    0: hi:  186, btch:  31 usd:  37
[413563.086025] CPU    1: hi:  186, btch:  31 usd: 102
[413563.086027] CPU    2: hi:  186, btch:  31 usd:   0
[413563.086029] CPU    3: hi:  186, btch:  31 usd:  91
[413563.086034] active_anon:119304 inactive_anon:105522 isolated_anon:0
 active_file:60 inactive_file:110 isolated_file:32
 unevictable:2629 dirty:15 writeback:46 unstable:0
 free:22506 slab_reclaimable:709964 slab_unreclaimable:7090
 mapped:2448 shmem:107171 pagetables:3334 bounce:0
[413563.086038] Node 0 DMA free:15856kB min:260kB low:324kB high:388kB acti=
ve_anon:16kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictabl=
e:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dir=
ty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:32kB slab_unrecl=
aimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeba=
ck_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[413563.086045] lowmem_reserve[]: 0 2137 3899 3899
[413563.086049] Node 0 DMA32 free:43856kB min:36900kB low:46124kB high:5534=
8kB active_anon:102032kB inactive_anon:99228kB active_file:188kB inactive_f=
ile:340kB unevictable:4096kB isolated(anon):0kB isolated(file):0kB present:=
2188752kB mlocked:8kB dirty:20kB writeback:0kB mapped:700kB shmem:99952kB s=
lab_reclaimable:1921612kB slab_unreclaimable:5792kB kernel_stack:176kB page=
tables:752kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:18524 =
all_unreclaimable? yes
[413563.086057] lowmem_reserve[]: 0 0 1762 1762
[413563.086060] Node 0 Normal free:30312kB min:30416kB low:38020kB high:456=
24kB active_anon:375168kB inactive_anon:322860kB active_file:52kB inactive_=
file:100kB unevictable:6420kB isolated(anon):0kB isolated(file):128kB prese=
nt:1804320kB mlocked:6420kB dirty:40kB writeback:184kB mapped:9092kB shmem:=
328732kB slab_reclaimable:918212kB slab_unreclaimable:22568kB kernel_stack:=
1584kB pagetables:12584kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_s=
canned:18857 all_unreclaimable? yes
[413563.086067] lowmem_reserve[]: 0 0 0 0
[413563.086071] Node 0 DMA: 2*4kB 1*8kB 2*16kB 4*32kB 3*64kB 3*128kB 3*256k=
B 2*512kB 3*1024kB 3*2048kB 1*4096kB =3D 15856kB
[413563.086081] Node 0 DMA32: 2018*4kB 3681*8kB 142*16kB 0*32kB 0*64kB 0*12=
8kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB =3D 43888kB
[413563.086090] Node 0 Normal: 5815*4kB 443*8kB 0*16kB 0*32kB 1*64kB 1*128k=
B 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB =3D 30324kB
[413563.086099] 108363 total pagecache pages
[413563.086101] 0 pages in swap cache
[413563.086103] Swap cache stats: add 0, delete 0, find 0/0
[413563.086104] Free swap  =3D 0kB
[413563.086105] Total swap =3D 0kB
[413563.097907] 1048048 pages RAM
[413563.097909] 57533 pages reserved
[413563.097910] 48354 pages shared
[413563.097911] 940174 pages non-shared
[413563.097913] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score=
_adj name
[413563.097920] [  191]     0   191     6555      406   0     -17         -=
1000 systemd-udevd
[413563.097922] [  194]     0   194    74652     2758   0       0          =
   0 systemd-journal
[413563.097926] [  301]     0   301     3302      309   1       0          =
   0 crond
[413563.097929] [  302]     0   302    17693      680   2       0          =
   0 cupsd
[413563.097931] [  304]     0   304    10502      322   1     -17         -=
1000 sshd
[413563.097934] [  305]    81   305     4433      295   1     -13          =
-900 dbus-daemon
[413563.097936] [  309]     0   309     6512      194   1       0          =
   0 systemd-logind
[413563.097939] [  315]     0   315    15747      314   2       0          =
   0 login
[413563.097942] [  316]     0   316     2031      190   0       0          =
   0 agetty
[413563.097944] [  317]     0   317     2031      186   0       0          =
   0 agetty
[413563.097947] [  319]     0   319     2031      188   1       0          =
   0 agetty
[413563.097950] [  320]     0   320     2031      189   1       0          =
   0 agetty
[413563.097952] [  321]     0   321     2031      188   1       0          =
   0 agetty
[413563.097954] [  325]     0   325    51901      515   3       0          =
   0 colord
[413563.097957] [  341]     0   341   123526     1044   1       0          =
   0 colord-sane
[413563.097960] [  395]     0   395     3092      243   1       0          =
   0 master
[413563.097963] [  399]    73   399    16380      410   2       0          =
   0 qmgr
[413563.097965] [  420]  1000   420     3423      283   2       0          =
   0 restart-x
[413563.097968] [  431]  1000   431     3423      298   3       0          =
   0 startx
[413563.097970] [  448]  1000   448     3966      147   3       0          =
   0 xinit
[413563.097973] [  449]  1000   449    82749     4535   3       0          =
   0 X
[413563.097975] [  470]  1000   470    24058      804   3       0          =
   0 i3
[413563.097977] [  477]  1000   477     6062      195   1       0          =
   0 unclutter
[413563.097979] [  480]  1000   480     6004      147   2       0          =
   0 dispad
[413563.097982] [  481]  1000   481    36621    12501   3       0          =
   0 urxvtd
[413563.097985] [  484]  1000   484     8068      456   3       0          =
   0 xbindkeys
[413563.097987] [  505]  1000   505     8155      657   3       0          =
   0 zsh
[413563.097989] [  512]     0   512     8481      273   3       0          =
   0 sudo
[413563.097992] [  513]     0   513     6933      430   3       0          =
   0 zsh
[413563.097994] [  543]     0   543     7404      232   1       0          =
   0 wpa_supplicant
[413563.097997] [  659]  1000   659     9860     1864   2       0          =
   0 zsh
[413563.097999] [  772]  1000   772     4494       95   3       0          =
   0 dbus-launch
[413563.098002] [  773]  1000   773     4379      241   0       0          =
   0 dbus-daemon
[413563.098005] [ 1575]  1000  1575    10065     2054   1       0          =
   0 zsh
[413563.098008] [ 2835]  1000  2835    40320      829   3       0          =
   0 kdeinit4
[413563.098010] [ 2837]  1000  2837    48444      803   3       0          =
   0 klauncher
[413563.098013] [ 2841]  1000  2841   109726     1983   2       0          =
   0 kded4
[413563.098015] [ 2858]  1000  2858   238338     2667   1       0          =
   0 knotify4
[413563.098018] [ 2863]     0  2863    54958     1191   2       0          =
   0 upowerd
[413563.098021] [ 2868]     0  2868    46649      345   2     -13          =
-900 polkitd
[413563.098023] [ 2895]     0  2895    48361      444   0       0          =
   0 udisks-daemon
[413563.098026] [ 2904]     0  2904    11353      123   1       0          =
   0 udisks-daemon
[413563.098029] [ 6623]  1000  6623     8891      897   2       0          =
   0 zsh
[413563.098031] [ 8723]  1000  8723     8785      780   3       0          =
   0 zsh
[413563.098034] [14485]  1000 14485     8773      768   1       0          =
   0 zsh
[413563.098037] [30479]     0 30479     8481      274   1       0          =
   0 sudo
[413563.098039] [30480]     0 30480     6933      483   1       0          =
   0 zsh
[413563.098042] [ 2064]  1000  2064     9797     1774   3       0          =
   0 zsh
[413563.098044] [ 3202]  1000  3202     9839     1851   1       0          =
   0 zsh
[413563.098046] [14763]  1000 14763     8914      903   1       0          =
   0 zsh
[413563.098049] [29947]  1000 29947     5163      267   0       0          =
   0 zsh
[413563.098051] [29950]  1000 29950   164155    41954   0       0          =
   0 chromium
[413563.098054] [29953]  1000 29953     1588      137   0       0          =
   0 chromium-sandbo
[413563.098057] [29954]  1000 29954    70030     1322   0       0          =
   0 chromium
[413563.098060] [29960]  1000 29960    34745      443   0       0          =
   0 nacl_helper_boo
[413563.098063] [29961]  1000 29961    76177     1173   3       0          =
   0 chromium
[413563.098065] [20018]     0 20018     2136      132   0       0          =
   0 dhcpcd
[413563.098068] [23649]  1000 23649    63938      837   1       0          =
   0 dconf-service
[413563.098070] [25961]  1000 25961    14690      738   2       0          =
   0 mutt
[413563.098073] [13576]     0 13576     4494       95   0       0          =
   0 dbus-launch
[413563.098075] [13577]     0 13577     4320      173   2       0          =
   0 dbus-daemon
[413563.098077] [21389]  1000 21389     8809      811   0       0          =
   0 zsh
[413563.098080] [ 5745]  1000  5745     9866     1857   2       0          =
   0 zsh
[413563.098082] [ 5944]  1000  5944     9776     1765   3       0          =
   0 zsh
[413563.098085] [ 8651]  1000  8651    10239     2241   2       0          =
   0 zsh
[413563.098087] [10927]  1000 10927     8891      902   3       0          =
   0 zsh
[413563.098089] [13485]  1000 13485     8773      766   2       0          =
   0 zsh
[413563.098092] [13492]  1000 13492    14788      869   2       0          =
   0 mutt
[413563.098094] [13504]  1000 13504    19180      534   3       0          =
   0 i3bar
[413563.098096] [13505]  1000 13505     8066      645   2       0          =
   0 i3status
[413563.098098] [13897]  1000 13897    10964     2958   1       0          =
   0 zsh
[413563.098101] [25693]  1000 25693     8806      803   3       0          =
   0 zsh
[413563.098104] [12076]  1000 12076     9025     1036   3       0          =
   0 zsh
[413563.098107] [22068]  1000 22068     8830      834   0       0          =
   0 zsh
[413563.098110] [ 3498]     0  3498     4755     2630   1       0          =
   0 atop
[413563.098112] [12787]  1000 12787     9835     1831   3       0          =
   0 zsh
[413563.098114] [30808]  1000 30808     8155      673   2       0          =
   0 zsh
[413563.098117] [ 2155]  1000  2155     8155      674   2       0          =
   0 zsh
[413563.098120] [ 2681]  1000  2681     4459      503   0       0          =
   0 man
[413563.098123] [ 2692]  1000  2692     2781      255   3       0          =
   0 less
[413563.098125] [ 3641]  1000  3641     8285      652   3       0          =
   0 vim
[413563.098128] [ 4824]  1000  4824     8176      698   2       0          =
   0 zsh
[413563.098131] [ 6094]  1000  6094     9005      330   1       0          =
   0 ssh
[413563.098133] [ 6096]  1000  6096     8970      209   3       0          =
   0 ssh
[413563.098136] [ 6098]  1000  6098     8970      300   1       0          =
   0 ssh
[413563.098138] [ 8888]  1000  8888    44968      254   2       0          =
   0 evinced
[413563.098142] [11133]     0 11133     8481      273   0       0          =
   0 sudo
[413563.098144] [11137]     0 11137     3457      299   1       0          =
   0 ccollect
[413563.098147] [11142]     0 11142     3457      206   0       0          =
   0 ccollect
[413563.098149] [11143]     0 11143     3457      148   0       0          =
   0 ccollect
[413563.098151] [11144]     0 11144     2919      224   3       0          =
   0 awk
[413563.098155] [11196]     0 11196     3891     2541   2       0          =
   0 rm
[413563.098158] [11239]    73 11239    16333      344   2       0          =
   0 pickup
[413563.098161] [13544]  1000 13544   130892    14713   0       0          =
   0 evince
[413563.098163] [13571]  1000 13571     8716      729   1       0          =
   0 zsh
[413563.098165] [13605]  1000 13605     2749      211   1       0          =
   0 less
[413563.098169] [13850]     0 13850     9169      384   2       0          =
   0 crond
[413563.098171] [13851]  1000 13851     2937      210   2       0          =
   0 sh
[413563.098173] [13852]  1000 13852     4878      276   3       0          =
   0 fetchmail
[413563.098176] Out of memory: Kill process 29950 (chromium) score 42 or sa=
crifice child
[413563.098181] Killed process 29953 (chromium-sandbo) total-vm:6352kB, ano=
n-rss:96kB, file-rss:452kB
[413563.098532] fetchmail invoked oom-killer: gfp_mask=3D0x201da, order=3D0=
, oom_adj=3D0, oom_score_adj=3D0
[413563.098535] fetchmail cpuset=3D/ mems_allowed=3D0
[413563.098537] Pid: 13852, comm: fetchmail Tainted: G        W    3.5.4-1-=
ARCH #1
[413563.098539] Call Trace:
[413563.098544]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d=
/0xb0
[413563.098549]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[413563.098553]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[413563.098558]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[413563.098563]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[413563.098566]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[413563.098569]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[413563.098574]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[413563.098576]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[413563.098579]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[413563.098583]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[413563.098586]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[413563.098591]  [<ffffffff81376897>] ? __kfree_skb+0x47/0xa0
[413563.098594]  [<ffffffff8147d029>] ? schedule+0x29/0x70
[413563.098597]  [<ffffffff8147a9f4>] ? schedule_timeout+0x2b4/0x340
[413563.098600]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[413563.098604]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[413563.098608]  [<ffffffff81079a38>] ? hrtimer_start+0x18/0x20
[413563.098612]  [<ffffffff81058b3c>] ? do_setitimer+0x1cc/0x260
[413563.098615]  [<ffffffff81058d0d>] ? sys_setitimer+0xdd/0x120
[413563.098618]  [<ffffffff8147e765>] page_fault+0x25/0x30
[413563.098619] Mem-Info:
[413563.098621] Node 0 DMA per-cpu:
[413563.098623] CPU    0: hi:    0, btch:   1 usd:   0
[413563.098625] CPU    1: hi:    0, btch:   1 usd:   0
[413563.098626] CPU    2: hi:    0, btch:   1 usd:   0
[413563.098628] CPU    3: hi:    0, btch:   1 usd:   0
[413563.098629] Node 0 DMA32 per-cpu:
[413563.098631] CPU    0: hi:  186, btch:  31 usd: 158
[413563.098633] CPU    1: hi:  186, btch:  31 usd: 154
[413563.098634] CPU    2: hi:  186, btch:  31 usd:  33
[413563.098636] CPU    3: hi:  186, btch:  31 usd:  62
[413563.098637] Node 0 Normal per-cpu:
[413563.098639] CPU    0: hi:  186, btch:  31 usd:  74
[413563.098640] CPU    1: hi:  186, btch:  31 usd: 153
[413563.098642] CPU    2: hi:  186, btch:  31 usd:   0
[413563.098643] CPU    3: hi:  186, btch:  31 usd:  91
[413563.098648] active_anon:119304 inactive_anon:105522 isolated_anon:0
 active_file:60 inactive_file:8 isolated_file:0
 unevictable:2629 dirty:15 writeback:46 unstable:0
 free:22506 slab_reclaimable:709964 slab_unreclaimable:7090
 mapped:2402 shmem:107171 pagetables:3334 bounce:0
[413563.098650] Node 0 DMA free:15856kB min:260kB low:324kB high:388kB acti=
ve_anon:16kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictabl=
e:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dir=
ty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:32kB slab_unrecl=
aimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeba=
ck_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[413563.098656] lowmem_reserve[]: 0 2137 3899 3899
[413563.098659] Node 0 DMA32 free:43856kB min:36900kB low:46124kB high:5534=
8kB active_anon:102032kB inactive_anon:99228kB active_file:188kB inactive_f=
ile:0kB unevictable:4096kB isolated(anon):0kB isolated(file):0kB present:21=
88752kB mlocked:8kB dirty:20kB writeback:0kB mapped:700kB shmem:99952kB sla=
b_reclaimable:1921612kB slab_unreclaimable:5792kB kernel_stack:176kB pageta=
bles:752kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:20540 al=
l_unreclaimable? yes
[413563.098665] lowmem_reserve[]: 0 0 1762 1762
[413563.098668] Node 0 Normal free:30312kB min:30416kB low:38020kB high:456=
24kB active_anon:375168kB inactive_anon:322860kB active_file:52kB inactive_=
file:96kB unevictable:6420kB isolated(anon):0kB isolated(file):0kB present:=
1804320kB mlocked:6420kB dirty:40kB writeback:184kB mapped:8908kB shmem:328=
732kB slab_reclaimable:918212kB slab_unreclaimable:22568kB kernel_stack:158=
4kB pagetables:12584kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scan=
ned:20809 all_unreclaimable? yes
[413563.098674] lowmem_reserve[]: 0 0 0 0
[413563.098677] Node 0 DMA: 2*4kB 1*8kB 2*16kB 4*32kB 3*64kB 3*128kB 3*256k=
B 2*512kB 3*1024kB 3*2048kB 1*4096kB =3D 15856kB
[413563.098686] Node 0 DMA32: 2018*4kB 3681*8kB 142*16kB 0*32kB 0*64kB 0*12=
8kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB =3D 43888kB
[413563.098694] Node 0 Normal: 5815*4kB 443*8kB 0*16kB 0*32kB 1*64kB 1*128k=
B 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB =3D 30324kB
[413563.098702] 108152 total pagecache pages
[413563.098703] 0 pages in swap cache
[413563.098705] Swap cache stats: add 0, delete 0, find 0/0
[413563.098706] Free swap  =3D 0kB
[413563.098707] Total swap =3D 0kB
[413563.110510] 1048048 pages RAM
[413563.110513] 57533 pages reserved
[413563.110514] 48260 pages shared
[413563.110515] 939999 pages non-shared
[413563.110517] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score=
_adj name
[413563.110524] [  191]     0   191     6555      406   0     -17         -=
1000 systemd-udevd
[413563.110526] [  194]     0   194    74652     2758   0       0          =
   0 systemd-journal
[413563.110529] [  301]     0   301     3302      309   1       0          =
   0 crond
[413563.110531] [  302]     0   302    17693      680   2       0          =
   0 cupsd
[413563.110533] [  304]     0   304    10502      322   1     -17         -=
1000 sshd
[413563.110536] [  305]    81   305     4433      295   1     -13          =
-900 dbus-daemon
[413563.110539] [  309]     0   309     6512      194   1       0          =
   0 systemd-logind
[413563.110542] [  315]     0   315    15747      314   2       0          =
   0 login
[413563.110545] [  316]     0   316     2031      190   0       0          =
   0 agetty
[413563.110547] [  317]     0   317     2031      186   0       0          =
   0 agetty
[413563.110550] [  319]     0   319     2031      188   1       0          =
   0 agetty
[413563.110553] [  320]     0   320     2031      189   1       0          =
   0 agetty
[413563.110556] [  321]     0   321     2031      188   1       0          =
   0 agetty
[413563.110559] [  325]     0   325    51901      515   3       0          =
   0 colord
[413563.110562] [  341]     0   341   123526     1044   1       0          =
   0 colord-sane
[413563.110564] [  395]     0   395     3092      243   1       0          =
   0 master
[413563.110567] [  399]    73   399    16380      410   2       0          =
   0 qmgr
[413563.110570] [  420]  1000   420     3423      283   2       0          =
   0 restart-x
[413563.110572] [  431]  1000   431     3423      298   3       0          =
   0 startx
[413563.110575] [  448]  1000   448     3966      147   3       0          =
   0 xinit
[413563.110578] [  449]  1000   449    82749     4531   3       0          =
   0 X
[413563.110581] [  470]  1000   470    24058      804   3       0          =
   0 i3
[413563.110583] [  477]  1000   477     6062      195   1       0          =
   0 unclutter
[413563.110586] [  480]  1000   480     6004      147   2       0          =
   0 dispad
[413563.110588] [  481]  1000   481    36621    12501   3       0          =
   0 urxvtd
[413563.110623] [  484]  1000   484     8068      456   3       0          =
   0 xbindkeys
[413563.110625] [  505]  1000   505     8155      657   3       0          =
   0 zsh
[413563.110628] [  512]     0   512     8481      273   3       0          =
   0 sudo
[413563.110630] [  513]     0   513     6933      430   3       0          =
   0 zsh
[413563.110633] [  543]     0   543     7404      232   1       0          =
   0 wpa_supplicant
[413563.110635] [  659]  1000   659     9860     1864   2       0          =
   0 zsh
[413563.110637] [  772]  1000   772     4494       95   3       0          =
   0 dbus-launch
[413563.110640] [  773]  1000   773     4379      241   0       0          =
   0 dbus-daemon
[413563.110643] [ 1575]  1000  1575    10065     2054   1       0          =
   0 zsh
[413563.110645] [ 2835]  1000  2835    40320      829   3       0          =
   0 kdeinit4
[413563.110647] [ 2837]  1000  2837    48444      803   3       0          =
   0 klauncher
[413563.110650] [ 2841]  1000  2841   109726     1983   2       0          =
   0 kded4
[413563.110652] [ 2858]  1000  2858   238338     2667   1       0          =
   0 knotify4
[413563.110654] [ 2863]     0  2863    54958     1191   2       0          =
   0 upowerd
[413563.110657] [ 2868]     0  2868    46649      345   0     -13          =
-900 polkitd
[413563.110660] [ 2895]     0  2895    48361      444   0       0          =
   0 udisks-daemon
[413563.110662] [ 2904]     0  2904    11353      123   1       0          =
   0 udisks-daemon
[413563.110666] [ 6623]  1000  6623     8891      897   2       0          =
   0 zsh
[413563.110668] [ 8723]  1000  8723     8785      780   3       0          =
   0 zsh
[413563.110670] [14485]  1000 14485     8773      768   1       0          =
   0 zsh
[413563.110673] [30479]     0 30479     8481      274   1       0          =
   0 sudo
[413563.110676] [30480]     0 30480     6933      483   1       0          =
   0 zsh
[413563.110678] [ 2064]  1000  2064     9797     1774   3       0          =
   0 zsh
[413563.110681] [ 3202]  1000  3202     9839     1851   1       0          =
   0 zsh
[413563.110683] [14763]  1000 14763     8914      903   1       0          =
   0 zsh
[413563.110686] [29947]  1000 29947     5163      267   0       0          =
   0 zsh
[413563.110688] [29950]  1000 29950   164155    41952   2       0          =
   0 chromium
[413563.110691] [29954]  1000 29954    70030     1322   0       0          =
   0 chromium
[413563.110693] [29960]  1000 29960    34745      443   0       0          =
   0 nacl_helper_boo
[413563.110695] [29961]  1000 29961    76177     1173   3       0          =
   0 chromium
[413563.110698] [20018]     0 20018     2136      132   0       0          =
   0 dhcpcd
[413563.110700] [23649]  1000 23649    63938      837   1       0          =
   0 dconf-service
[413563.110703] [25961]  1000 25961    14690      738   2       0          =
   0 mutt
[413563.110706] [13576]     0 13576     4494       95   0       0          =
   0 dbus-launch
[413563.110708] [13577]     0 13577     4320      173   2       0          =
   0 dbus-daemon
[413563.110710] [21389]  1000 21389     8809      811   0       0          =
   0 zsh
[413563.110713] [ 5745]  1000  5745     9866     1857   2       0          =
   0 zsh
[413563.110716] [ 5944]  1000  5944     9776     1765   3       0          =
   0 zsh
[413563.110719] [ 8651]  1000  8651    10239     2241   2       0          =
   0 zsh
[413563.110721] [10927]  1000 10927     8891      902   3       0          =
   0 zsh
[413563.110723] [13485]  1000 13485     8773      766   2       0          =
   0 zsh
[413563.110725] [13492]  1000 13492    14788      869   2       0          =
   0 mutt
[413563.110727] [13504]  1000 13504    19180      534   3       0          =
   0 i3bar
[413563.110729] [13505]  1000 13505     8066      634   2       0          =
   0 i3status
[413563.110732] [13897]  1000 13897    10964     2958   1       0          =
   0 zsh
[413563.110735] [25693]  1000 25693     8806      803   3       0          =
   0 zsh
[413563.110738] [12076]  1000 12076     9025     1036   3       0          =
   0 zsh
[413563.110741] [22068]  1000 22068     8830      834   0       0          =
   0 zsh
[413563.110743] [ 3498]     0  3498     4755     2630   1       0          =
   0 atop
[413563.110745] [12787]  1000 12787     9835     1831   3       0          =
   0 zsh
[413563.110749] [30808]  1000 30808     8155      673   2       0          =
   0 zsh
[413563.110751] [ 2155]  1000  2155     8155      674   2       0          =
   0 zsh
[413563.110754] [ 2681]  1000  2681     4459      503   0       0          =
   0 man
[413563.110757] [ 2692]  1000  2692     2781      255   3       0          =
   0 less
[413563.110759] [ 3641]  1000  3641     8285      652   3       0          =
   0 vim
[413563.110762] [ 4824]  1000  4824     8176      698   2       0          =
   0 zsh
[413563.110765] [ 6094]  1000  6094     9005      326   1       0          =
   0 ssh
[413563.110767] [ 6096]  1000  6096     8970      209   3       0          =
   0 ssh
[413563.110770] [ 6098]  1000  6098     8970      300   1       0          =
   0 ssh
[413563.110773] [ 8888]  1000  8888    44968      254   2       0          =
   0 evinced
[413563.110775] [11133]     0 11133     8481      273   0       0          =
   0 sudo
[413563.110778] [11137]     0 11137     3457      299   1       0          =
   0 ccollect
[413563.110781] [11142]     0 11142     3457      206   0       0          =
   0 ccollect
[413563.110784] [11143]     0 11143     3457      148   0       0          =
   0 ccollect
[413563.110786] [11144]     0 11144     2919      224   3       0          =
   0 awk
[413563.110790] [11196]     0 11196     3891     2541   2       0          =
   0 rm
[413563.110793] [11239]    73 11239    16333      344   2       0          =
   0 pickup
[413563.110797] [13544]  1000 13544   130892    14713   2       0          =
   0 evince
[413563.110800] [13571]  1000 13571     8716      729   1       0          =
   0 zsh
[413563.110803] [13605]  1000 13605     2749      211   1       0          =
   0 less
[413563.110806] [13850]     0 13850     9169      384   2       0          =
   0 crond
[413563.110809] [13851]  1000 13851     2937      210   2       0          =
   0 sh
[413563.110812] [13852]  1000 13852     4878      268   3       0          =
   0 fetchmail
[413563.110814] Out of memory: Kill process 29950 (chromium) score 42 or sa=
crifice child
[413563.110819] Killed process 29950 (chromium) total-vm:656620kB, anon-rss=
:166172kB, file-rss:1624kB
[413614.899395] CPU1: Core temperature above threshold, cpu clock throttled=
 (total events =3D 58220)
[413614.899398] CPU2: Package temperature above threshold, cpu clock thrott=
led (total events =3D 73113)
[413614.899400] CPU3: Core temperature above threshold, cpu clock throttled=
 (total events =3D 58220)
[413614.899402] CPU0: Package temperature above threshold, cpu clock thrott=
led (total events =3D 73113)
[413614.899403] CPU3: Package temperature above threshold, cpu clock thrott=
led (total events =3D 73113)
[413614.899409] CPU1: Package temperature above threshold, cpu clock thrott=
led (total events =3D 73113)
[413614.900379] CPU1: Core temperature/speed normal
[413614.900381] CPU2: Package temperature/speed normal
[413614.900382] CPU3: Core temperature/speed normal
[413614.900384] CPU0: Package temperature/speed normal
[413614.900386] CPU3: Package temperature/speed normal
[413614.900390] CPU1: Package temperature/speed normal
[413714.774992] evince invoked oom-killer: gfp_mask=3D0x201da, order=3D0, o=
om_adj=3D0, oom_score_adj=3D0
[413714.774995] evince cpuset=3D/ mems_allowed=3D0
[413714.774998] Pid: 13544, comm: evince Tainted: G        W    3.5.4-1-ARC=
H #1
[413714.774999] Call Trace:
[413714.775005]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d=
/0xb0
[413714.775009]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[413714.775013]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[413714.775017]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[413714.775021]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[413714.775023]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[413714.775026]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[413714.775030]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[413714.775032]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[413714.775034]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[413714.775037]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[413714.775040]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[413714.775043]  [<ffffffff8117952a>] ? do_sync_readv_writev+0xda/0x120
[413714.775045]  [<ffffffff811b7c3b>] ? fsnotify+0x24b/0x340
[413714.775048]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[413714.775051]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[413714.775053]  [<ffffffff8147e765>] page_fault+0x25/0x30
[413714.775054] Mem-Info:
[413714.775055] Node 0 DMA per-cpu:
[413714.775058] CPU    0: hi:    0, btch:   1 usd:   0
[413714.775059] CPU    1: hi:    0, btch:   1 usd:   0
[413714.775060] CPU    2: hi:    0, btch:   1 usd:   0
[413714.775061] CPU    3: hi:    0, btch:   1 usd:   0
[413714.775062] Node 0 DMA32 per-cpu:
[413714.775064] CPU    0: hi:  186, btch:  31 usd:   0
[413714.775065] CPU    1: hi:  186, btch:  31 usd:   0
[413714.775066] CPU    2: hi:  186, btch:  31 usd:   0
[413714.775067] CPU    3: hi:  186, btch:  31 usd:   0
[413714.775068] Node 0 Normal per-cpu:
[413714.775069] CPU    0: hi:  186, btch:  31 usd:   0
[413714.775070] CPU    1: hi:  186, btch:  31 usd:   0
[413714.775072] CPU    2: hi:  186, btch:  31 usd:   0
[413714.775073] CPU    3: hi:  186, btch:  31 usd:   0
[413714.775076] active_anon:77807 inactive_anon:102693 isolated_anon:0
 active_file:110 inactive_file:11 isolated_file:0
 unevictable:2629 dirty:6 writeback:36 unstable:0
 free:22498 slab_reclaimable:755701 slab_unreclaimable:6964
 mapped:2092 shmem:104175 pagetables:2714 bounce:0
[413714.775078] Node 0 DMA free:15852kB min:260kB low:324kB high:388kB acti=
ve_anon:20kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictabl=
e:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dir=
ty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:32kB slab_unrecl=
aimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeba=
ck_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[413714.775082] lowmem_reserve[]: 0 2137 3899 3899
[413714.775085] Node 0 DMA32 free:43728kB min:36900kB low:46124kB high:5534=
8kB active_anon:69044kB inactive_anon:98620kB active_file:204kB inactive_fi=
le:0kB unevictable:4096kB isolated(anon):0kB isolated(file):0kB present:218=
8752kB mlocked:8kB dirty:4kB writeback:16kB mapped:296kB shmem:99476kB slab=
_reclaimable:1957512kB slab_unreclaimable:5452kB kernel_stack:144kB pagetab=
les:504kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:30558 all=
_unreclaimable? yes
[413714.775089] lowmem_reserve[]: 0 0 1762 1762
[413714.775092] Node 0 Normal free:30412kB min:30416kB low:38020kB high:456=
24kB active_anon:242164kB inactive_anon:312152kB active_file:236kB inactive=
_file:140kB unevictable:6420kB isolated(anon):0kB isolated(file):0kB presen=
t:1804320kB mlocked:6420kB dirty:20kB writeback:128kB mapped:8072kB shmem:3=
17224kB slab_reclaimable:1065260kB slab_unreclaimable:22404kB kernel_stack:=
1368kB pagetables:10352kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_s=
canned:85635 all_unreclaimable? yes
[413714.775096] lowmem_reserve[]: 0 0 0 0
[413714.775098] Node 0 DMA: 3*4kB 2*8kB 1*16kB 4*32kB 3*64kB 3*128kB 3*256k=
B 2*512kB 3*1024kB 3*2048kB 1*4096kB =3D 15852kB
[413714.775104] Node 0 DMA32: 2589*4kB 3678*8kB 1*16kB 0*32kB 0*64kB 0*128k=
B 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB =3D 43892kB
[413714.775110] Node 0 Normal: 3357*4kB 682*8kB 517*16kB 3*32kB 1*64kB 0*12=
8kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB =3D 30644kB
[413714.775116] 105197 total pagecache pages
[413714.775117] 0 pages in swap cache
[413714.775118] Swap cache stats: add 0, delete 0, find 0/0
[413714.775119] Free swap  =3D 0kB
[413714.775120] Total swap =3D 0kB
[413714.784104] 1048048 pages RAM
[413714.784107] 57533 pages reserved
[413714.784108] 48870 pages shared
[413714.784109] 938531 pages non-shared
[413714.784111] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score=
_adj name
[413714.784118] [  191]     0   191     6555      406   0     -17         -=
1000 systemd-udevd
[413714.784121] [  194]     0   194    74652     2979   2       0          =
   0 systemd-journal
[413714.784125] [  301]     0   301     3302      307   3       0          =
   0 crond
[413714.784128] [  302]     0   302    17693      680   2       0          =
   0 cupsd
[413714.784130] [  304]     0   304    10502      322   1     -17         -=
1000 sshd
[413714.784133] [  305]    81   305     4433      295   2     -13          =
-900 dbus-daemon
[413714.784135] [  309]     0   309     6512      194   1       0          =
   0 systemd-logind
[413714.784138] [  315]     0   315    15747      314   2       0          =
   0 login
[413714.784140] [  316]     0   316     2031      190   0       0          =
   0 agetty
[413714.784143] [  317]     0   317     2031      186   0       0          =
   0 agetty
[413714.784146] [  319]     0   319     2031      188   1       0          =
   0 agetty
[413714.784150] [  320]     0   320     2031      189   1       0          =
   0 agetty
[413714.784152] [  321]     0   321     2031      188   1       0          =
   0 agetty
[413714.784155] [  325]     0   325    51901      515   3       0          =
   0 colord
[413714.784158] [  341]     0   341   123526     1054   1       0          =
   0 colord-sane
[413714.784161] [  395]     0   395     3092      211   3       0          =
   0 master
[413714.784164] [  399]    73   399    16380      410   2       0          =
   0 qmgr
[413714.784167] [  420]  1000   420     3423      283   2       0          =
   0 restart-x
[413714.784169] [  431]  1000   431     3423      298   3       0          =
   0 startx
[413714.784171] [  448]  1000   448     3966      147   3       0          =
   0 xinit
[413714.784174] [  449]  1000   449    80884     4357   0       0          =
   0 X
[413714.784176] [  470]  1000   470    24058      808   1       0          =
   0 i3
[413714.784179] [  477]  1000   477     6062      207   3       0          =
   0 unclutter
[413714.784182] [  480]  1000   480     6004      145   0       0          =
   0 dispad
[413714.784184] [  481]  1000   481    36621    12458   1       0          =
   0 urxvtd
[413714.784187] [  484]  1000   484     8068      456   3       0          =
   0 xbindkeys
[413714.784190] [  505]  1000   505     8155      657   3       0          =
   0 zsh
[413714.784192] [  512]     0   512     8481      273   3       0          =
   0 sudo
[413714.784195] [  513]     0   513     6933      430   3       0          =
   0 zsh
[413714.784198] [  543]     0   543     7404      246   2       0          =
   0 wpa_supplicant
[413714.784200] [  659]  1000   659     9860     1864   2       0          =
   0 zsh
[413714.784203] [  772]  1000   772     4494       95   3       0          =
   0 dbus-launch
[413714.784205] [  773]  1000   773     4379      241   0       0          =
   0 dbus-daemon
[413714.784208] [ 1575]  1000  1575    10065     2054   1       0          =
   0 zsh
[413714.784211] [ 2835]  1000  2835    40320      829   3       0          =
   0 kdeinit4
[413714.784213] [ 2837]  1000  2837    48444      803   3       0          =
   0 klauncher
[413714.784216] [ 2841]  1000  2841   109726     1962   2       0          =
   0 kded4
[413714.784218] [ 2858]  1000  2858   238338     2678   0       0          =
   0 knotify4
[413714.784221] [ 2863]     0  2863    54958     1167   2       0          =
   0 upowerd
[413714.784223] [ 2868]     0  2868    46649      335   2     -13          =
-900 polkitd
[413714.784226] [ 2895]     0  2895    48361      417   1       0          =
   0 udisks-daemon
[413714.784228] [ 2904]     0  2904    11353      123   1       0          =
   0 udisks-daemon
[413714.784231] [ 6623]  1000  6623     8891      897   2       0          =
   0 zsh
[413714.784234] [ 8723]  1000  8723     8785      780   3       0          =
   0 zsh
[413714.784237] [14485]  1000 14485     8773      768   1       0          =
   0 zsh
[413714.784239] [30479]     0 30479     8481      274   1       0          =
   0 sudo
[413714.784242] [30480]     0 30480     6933      483   1       0          =
   0 zsh
[413714.784245] [ 2064]  1000  2064     9797     1774   3       0          =
   0 zsh
[413714.784247] [ 3202]  1000  3202     9839     1851   1       0          =
   0 zsh
[413714.784249] [14763]  1000 14763     8914      903   1       0          =
   0 zsh
[413714.784251] [20018]     0 20018     2136      132   0       0          =
   0 dhcpcd
[413714.784254] [23649]  1000 23649    63938      837   1       0          =
   0 dconf-service
[413714.784257] [25961]  1000 25961    14690      738   2       0          =
   0 mutt
[413714.784259] [13576]     0 13576     4494       95   0       0          =
   0 dbus-launch
[413714.784262] [13577]     0 13577     4320      173   2       0          =
   0 dbus-daemon
[413714.784265] [21389]  1000 21389     8809      811   0       0          =
   0 zsh
[413714.784268] [ 5745]  1000  5745     9866     1857   2       0          =
   0 zsh
[413714.784271] [ 5944]  1000  5944     9776     1765   3       0          =
   0 zsh
[413714.784274] [ 8651]  1000  8651    10239     2241   2       0          =
   0 zsh
[413714.784277] [10927]  1000 10927     8891      902   3       0          =
   0 zsh
[413714.784279] [13485]  1000 13485     8773      766   2       0          =
   0 zsh
[413714.784282] [13492]  1000 13492    14788      869   2       0          =
   0 mutt
[413714.784284] [13504]  1000 13504    19180      524   3       0          =
   0 i3bar
[413714.784287] [13505]  1000 13505     8066      616   1       0          =
   0 i3status
[413714.784290] [13897]  1000 13897    10964     2958   1       0          =
   0 zsh
[413714.784292] [25693]  1000 25693     8806      803   3       0          =
   0 zsh
[413714.784294] [12076]  1000 12076     9025     1036   3       0          =
   0 zsh
[413714.784296] [22068]  1000 22068     8830      834   0       0          =
   0 zsh
[413714.784298] [ 3498]     0  3498     4755     2630   1       0          =
   0 atop
[413714.784300] [12787]  1000 12787     9835     1831   3       0          =
   0 zsh
[413714.784301] [30808]  1000 30808     8155      673   2       0          =
   0 zsh
[413714.784303] [ 2155]  1000  2155     8155      674   2       0          =
   0 zsh
[413714.784305] [ 2681]  1000  2681     4459      503   0       0          =
   0 man
[413714.784307] [ 2692]  1000  2692     2781      255   3       0          =
   0 less
[413714.784309] [ 3641]  1000  3641     8285      652   3       0          =
   0 vim
[413714.784310] [ 4824]  1000  4824     8176      698   2       0          =
   0 zsh
[413714.784313] [ 6094]  1000  6094     9005      337   1       0          =
   0 ssh
[413714.784315] [ 6096]  1000  6096     8970      209   3       0          =
   0 ssh
[413714.784317] [ 6098]  1000  6098     8970      294   1       0          =
   0 ssh
[413714.784319] [ 8888]  1000  8888    44968      254   2       0          =
   0 evinced
[413714.784321] [11133]     0 11133     8481      273   0       0          =
   0 sudo
[413714.784323] [11137]     0 11137     3457      299   1       0          =
   0 ccollect
[413714.784324] [11142]     0 11142     3457      206   0       0          =
   0 ccollect
[413714.784326] [11143]     0 11143     3457      148   0       0          =
   0 ccollect
[413714.784328] [11144]     0 11144     2919      224   3       0          =
   0 awk
[413714.784330] [11196]     0 11196     2103      779   1       0          =
   0 rm
[413714.784332] [11239]    73 11239    16333      371   2       0          =
   0 pickup
[413714.784334] [13544]  1000 13544   139663    18570   0       0          =
   0 evince
[413714.784336] [13571]  1000 13571     8716      729   1       0          =
   0 zsh
[413714.784338] [13605]  1000 13605     2749      211   1       0          =
   0 less
[413714.784340] Out of memory: Kill process 13544 (evince) score 18 or sacr=
ifice child
[413714.784342] Killed process 13544 (evince) total-vm:558652kB, anon-rss:7=
3412kB, file-rss:868kB
[413714.785576] systemd-journal invoked oom-killer: gfp_mask=3D0x201da, ord=
er=3D0, oom_adj=3D0, oom_score_adj=3D0
[413714.785579] systemd-journal cpuset=3D/ mems_allowed=3D0
[413714.785581] Pid: 194, comm: systemd-journal Tainted: G        W    3.5.=
4-1-ARCH #1
[413714.785582] Call Trace:
[413714.785588]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d=
/0xb0
[413714.785593]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[413714.785596]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[413714.785601]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[413714.785605]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[413714.785607]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[413714.785610]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[413714.785613]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[413714.785616]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[413714.785618]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[413714.785621]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[413714.785624]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[413714.785626]  [<ffffffff81124b70>] ? lru_add_drain_cpu+0xa0/0xf0
[413714.785629]  [<ffffffff8147ba8e>] ? __mutex_lock_slowpath+0x24e/0x340
[413714.785631]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[413714.785634]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[413714.785638]  [<ffffffff811bcf94>] ? ep_poll+0x134/0x360
[413714.785642]  [<ffffffff81086f70>] ? try_to_wake_up+0x2f0/0x2f0
[413714.785644]  [<ffffffff8147e765>] page_fault+0x25/0x30
[413714.785646] Mem-Info:
[413714.785647] Node 0 DMA per-cpu:
[413714.785649] CPU    0: hi:    0, btch:   1 usd:   0
[413714.785650] CPU    1: hi:    0, btch:   1 usd:   0
[413714.785651] CPU    2: hi:    0, btch:   1 usd:   0
[413714.785652] CPU    3: hi:    0, btch:   1 usd:   0
[413714.785653] Node 0 DMA32 per-cpu:
[413714.785655] CPU    0: hi:  186, btch:  31 usd:   0
[413714.785656] CPU    1: hi:  186, btch:  31 usd:   0
[413714.785657] CPU    2: hi:  186, btch:  31 usd:   0
[413714.785658] CPU    3: hi:  186, btch:  31 usd:   0
[413714.785659] Node 0 Normal per-cpu:
[413714.785661] CPU    0: hi:  186, btch:  31 usd:   0
[413714.785662] CPU    1: hi:  186, btch:  31 usd:   0
[413714.785663] CPU    2: hi:  186, btch:  31 usd:   0
[413714.785664] CPU    3: hi:  186, btch:  31 usd:   0
[413714.785667] active_anon:77807 inactive_anon:102693 isolated_anon:0
 active_file:131 inactive_file:54 isolated_file:0
 unevictable:2629 dirty:6 writeback:36 unstable:0
 free:22498 slab_reclaimable:755701 slab_unreclaimable:6964
 mapped:2092 shmem:104175 pagetables:2714 bounce:0
[413714.785669] Node 0 DMA free:15852kB min:260kB low:324kB high:388kB acti=
ve_anon:20kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictabl=
e:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dir=
ty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:32kB slab_unrecl=
aimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeba=
ck_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[413714.785673] lowmem_reserve[]: 0 2137 3899 3899
[413714.785676] Node 0 DMA32 free:43728kB min:36900kB low:46124kB high:5534=
8kB active_anon:69044kB inactive_anon:98620kB active_file:204kB inactive_fi=
le:76kB unevictable:4096kB isolated(anon):0kB isolated(file):0kB present:21=
88752kB mlocked:8kB dirty:4kB writeback:16kB mapped:296kB shmem:99476kB sla=
b_reclaimable:1957512kB slab_unreclaimable:5452kB kernel_stack:144kB pageta=
bles:504kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:30949 al=
l_unreclaimable? yes
[413714.785680] lowmem_reserve[]: 0 0 1762 1762
[413714.785683] Node 0 Normal free:30412kB min:30416kB low:38020kB high:456=
24kB active_anon:242164kB inactive_anon:312152kB active_file:320kB inactive=
_file:140kB unevictable:6420kB isolated(anon):0kB isolated(file):0kB presen=
t:1804320kB mlocked:6420kB dirty:20kB writeback:128kB mapped:8072kB shmem:3=
17224kB slab_reclaimable:1065260kB slab_unreclaimable:22404kB kernel_stack:=
1368kB pagetables:10352kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_s=
canned:856 all_unreclaimable? yes
[413714.785687] lowmem_reserve[]: 0 0 0 0
[413714.785689] Node 0 DMA: 3*4kB 2*8kB 1*16kB 4*32kB 3*64kB 3*128kB 3*256k=
B 2*512kB 3*1024kB 3*2048kB 1*4096kB =3D 15852kB
[413714.785695] Node 0 DMA32: 2589*4kB 3678*8kB 1*16kB 0*32kB 0*64kB 0*128k=
B 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB =3D 43892kB
[413714.785701] Node 0 Normal: 3357*4kB 683*8kB 517*16kB 3*32kB 1*64kB 0*12=
8kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB =3D 30652kB
[413714.785707] 105197 total pagecache pages
[413714.785709] 0 pages in swap cache
[413714.785710] Swap cache stats: add 0, delete 0, find 0/0
[413714.785711] Free swap  =3D 0kB
[413714.785712] Total swap =3D 0kB
[413714.794691] 1048048 pages RAM
[413714.794693] 57533 pages reserved
[413714.794694] 48869 pages shared
[413714.794695] 938530 pages non-shared
[413714.794696] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score=
_adj name
[413714.794702] [  191]     0   191     6555      406   0     -17         -=
1000 systemd-udevd
[413714.794704] [  194]     0   194    74652     2979   1       0          =
   0 systemd-journal
[413714.794707] [  301]     0   301     3302      307   3       0          =
   0 crond
[413714.794709] [  302]     0   302    17693      680   2       0          =
   0 cupsd
[413714.794710] [  304]     0   304    10502      322   1     -17         -=
1000 sshd
[413714.794712] [  305]    81   305     4433      295   2     -13          =
-900 dbus-daemon
[413714.794715] [  309]     0   309     6512      194   1       0          =
   0 systemd-logind
[413714.794716] [  315]     0   315    15747      314   2       0          =
   0 login
[413714.794718] [  316]     0   316     2031      190   0       0          =
   0 agetty
[413714.794720] [  317]     0   317     2031      186   0       0          =
   0 agetty
[413714.794722] [  319]     0   319     2031      188   1       0          =
   0 agetty
[413714.794723] [  320]     0   320     2031      189   1       0          =
   0 agetty
[413714.794725] [  321]     0   321     2031      188   1       0          =
   0 agetty
[413714.794727] [  325]     0   325    51901      515   3       0          =
   0 colord
[413714.794729] [  341]     0   341   123526     1054   1       0          =
   0 colord-sane
[413714.794731] [  395]     0   395     3092      211   3       0          =
   0 master
[413714.794732] [  399]    73   399    16380      410   2       0          =
   0 qmgr
[413714.794734] [  420]  1000   420     3423      283   2       0          =
   0 restart-x
[413714.794736] [  431]  1000   431     3423      298   3       0          =
   0 startx
[413714.794738] [  448]  1000   448     3966      147   3       0          =
   0 xinit
[413714.794740] [  449]  1000   449    80884     4357   0       0          =
   0 X
[413714.794742] [  470]  1000   470    24058      808   1       0          =
   0 i3
[413714.794744] [  477]  1000   477     6062      207   3       0          =
   0 unclutter
[413714.794746] [  480]  1000   480     6004      145   0       0          =
   0 dispad
[413714.794748] [  481]  1000   481    36621    12458   1       0          =
   0 urxvtd
[413714.794749] [  484]  1000   484     8068      456   3       0          =
   0 xbindkeys
[413714.794751] [  505]  1000   505     8155      657   3       0          =
   0 zsh
[413714.794753] [  512]     0   512     8481      273   3       0          =
   0 sudo
[413714.794755] [  513]     0   513     6933      430   3       0          =
   0 zsh
[413714.794757] [  543]     0   543     7404      246   2       0          =
   0 wpa_supplicant
[413714.794758] [  659]  1000   659     9860     1864   2       0          =
   0 zsh
[413714.794760] [  772]  1000   772     4494       95   3       0          =
   0 dbus-launch
[413714.794762] [  773]  1000   773     4379      241   0       0          =
   0 dbus-daemon
[413714.794764] [ 1575]  1000  1575    10065     2054   1       0          =
   0 zsh
[413714.794765] [ 2835]  1000  2835    40320      829   3       0          =
   0 kdeinit4
[413714.794767] [ 2837]  1000  2837    48444      803   3       0          =
   0 klauncher
[413714.794769] [ 2841]  1000  2841   109726     1962   2       0          =
   0 kded4
[413714.794771] [ 2858]  1000  2858   238338     2678   0       0          =
   0 knotify4
[413714.794772] [ 2863]     0  2863    54958     1167   2       0          =
   0 upowerd
[413714.794774] [ 2868]     0  2868    46649      335   2     -13          =
-900 polkitd
[413714.794776] [ 2895]     0  2895    48361      417   1       0          =
   0 udisks-daemon
[413714.794778] [ 2904]     0  2904    11353      123   1       0          =
   0 udisks-daemon
[413714.794779] [ 6623]  1000  6623     8891      897   2       0          =
   0 zsh
[413714.794782] [ 8723]  1000  8723     8785      780   3       0          =
   0 zsh
[413714.794784] [14485]  1000 14485     8773      768   1       0          =
   0 zsh
[413714.794786] [30479]     0 30479     8481      274   1       0          =
   0 sudo
[413714.794787] [30480]     0 30480     6933      483   1       0          =
   0 zsh
[413714.794789] [ 2064]  1000  2064     9797     1774   3       0          =
   0 zsh
[413714.794791] [ 3202]  1000  3202     9839     1851   1       0          =
   0 zsh
[413714.794792] [14763]  1000 14763     8914      903   1       0          =
   0 zsh
[413714.794794] [20018]     0 20018     2136      132   0       0          =
   0 dhcpcd
[413714.794796] [23649]  1000 23649    63938      837   1       0          =
   0 dconf-service
[413714.794798] [25961]  1000 25961    14690      738   2       0          =
   0 mutt
[413714.794800] [13576]     0 13576     4494       95   0       0          =
   0 dbus-launch
[413714.794802] [13577]     0 13577     4320      173   2       0          =
   0 dbus-daemon
[413714.794803] [21389]  1000 21389     8809      811   0       0          =
   0 zsh
[413714.794805] [ 5745]  1000  5745     9866     1857   2       0          =
   0 zsh
[413714.794807] [ 5944]  1000  5944     9776     1765   3       0          =
   0 zsh
[413714.794809] [ 8651]  1000  8651    10239     2241   2       0          =
   0 zsh
[413714.794811] [10927]  1000 10927     8891      902   3       0          =
   0 zsh
[413714.794813] [13485]  1000 13485     8773      766   2       0          =
   0 zsh
[413714.794814] [13492]  1000 13492    14788      869   2       0          =
   0 mutt
[413714.794816] [13504]  1000 13504    19180      524   3       0          =
   0 i3bar
[413714.794818] [13505]  1000 13505     8066      616   1       0          =
   0 i3status
[413714.794820] [13897]  1000 13897    10964     2958   1       0          =
   0 zsh
[413714.794822] [25693]  1000 25693     8806      803   3       0          =
   0 zsh
[413714.794823] [12076]  1000 12076     9025     1036   3       0          =
   0 zsh
[413714.794825] [22068]  1000 22068     8830      834   0       0          =
   0 zsh
[413714.794827] [ 3498]     0  3498     4755     2630   1       0          =
   0 atop
[413714.794829] [12787]  1000 12787     9835     1831   3       0          =
   0 zsh
[413714.794831] [30808]  1000 30808     8155      673   2       0          =
   0 zsh
[413714.794833] [ 2155]  1000  2155     8155      674   2       0          =
   0 zsh
[413714.794835] [ 2681]  1000  2681     4459      503   0       0          =
   0 man
[413714.794837] [ 2692]  1000  2692     2781      255   3       0          =
   0 less
[413714.794839] [ 3641]  1000  3641     8285      652   3       0          =
   0 vim
[413714.794840] [ 4824]  1000  4824     8176      698   2       0          =
   0 zsh
[413714.794843] [ 6094]  1000  6094     9005      337   1       0          =
   0 ssh
[413714.794845] [ 6096]  1000  6096     8970      209   3       0          =
   0 ssh
[413714.794846] [ 6098]  1000  6098     8970      294   1       0          =
   0 ssh
[413714.794848] [ 8888]  1000  8888    44968      254   2       0          =
   0 evinced
[413714.794850] [11133]     0 11133     8481      273   0       0          =
   0 sudo
[413714.794852] [11137]     0 11137     3457      299   1       0          =
   0 ccollect
[413714.794854] [11142]     0 11142     3457      206   0       0          =
   0 ccollect
[413714.794856] [11143]     0 11143     3457      148   0       0          =
   0 ccollect
[413714.794858] [11144]     0 11144     2919      224   3       0          =
   0 awk
[413714.794860] [11196]     0 11196     2103      779   1       0          =
   0 rm
[413714.794862] [11239]    73 11239    16333      371   2       0          =
   0 pickup
[413714.794865] [13549]  1000 13544   139663    18633   1       0          =
   0 EvJobScheduler
[413714.794867] [13571]  1000 13571     8716      729   1       0          =
   0 zsh
[413714.794869] [13605]  1000 13605     2749      211   1       0          =
   0 less
[413714.794871] Out of memory: Kill process 13549 (EvJobScheduler) score 18=
 or sacrifice child
[413714.794873] Killed process 13549 (EvJobScheduler) total-vm:558652kB, an=
on-rss:73480kB, file-rss:1052kB

--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=slabtop

 Active / Total Objects (% used)    : 2582292 / 2626621 (98.3%)
 Active / Total Slabs (% used)      : 244130 / 244130 (100.0%)
 Active / Total Caches (% used)     : 73 / 103 (70.9%)
 Active / Total Size (% used)       : 2989274.45K / 3001284.16K (99.6%)
 Minimum / Average / Maximum Object : 0.01K / 1.14K / 15.23K

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
2445759 2445759 100%    1.21K 239310       26   7657920K jfs_ip
 20628  20628 100%    0.11K    573       36      2292K sysfs_dir_cache
 17451   9599  55%    0.19K    831       21      3324K dentry
 14025  10047  71%    0.05K    165       85       660K shared_policy_node
 12032   7830  65%    0.06K    188       64       752K kmalloc-64
 11569   6744  58%    0.17K    503       23      2012K vm_area_struct
  9728   9728 100%    0.01K     19      512        76K kmalloc-8
  8608   3725  43%    0.25K    269       32      2152K kmalloc-256
  8127   6505  80%    0.58K    301       27      4816K inode_cache
  8008   3682  45%    0.55K    286       28      4576K radix_tree_node
  7310   7310 100%    0.02K     43      170       172K numa_policy
  6808   3796  55%    0.09K    148       46       592K anon_vma
  5888   5041  85%    0.02K     23      256        92K kmalloc-16
  5120   3772  73%    0.03K     40      128       160K kmalloc-32
  5024   5024 100%    0.12K    157       32       628K jfs_mp
  4998   4478  89%    0.04K     49      102       196K Acpi-Namespace
  4368   4204  96%    0.07K     78       56       312K Acpi-ParseExt
  4074   3139  77%    0.09K     97       42       388K kmalloc-96
  3780   2841  75%    0.19K    180       21       720K kmalloc-192
  3744   3541  94%    0.12K    117       32       468K kmalloc-128
  2144   1396  65%    0.50K     67       32      1072K kmalloc-512
  1992   1479  74%    0.66K     83       24      1328K shmem_inode_cache
  1984   1210  60%    1.00K     62       32      1984K kmalloc-1024
  1053    729  69%    0.81K     27       39       864K task_xstate


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=slabtop-post-umount

 Active / Total Objects (% used)    : 194322 / 223669 (86.9%)
 Active / Total Slabs (% used)      : 6894 / 6894 (100.0%)
 Active / Total Caches (% used)     : 75 / 103 (72.8%)
 Active / Total Size (% used)       : 62817.74K / 69669.07K (90.2%)
 Minimum / Average / Maximum Object : 0.01K / 0.31K / 15.23K

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
 38787  38100  98%    0.19K   1847       21      7388K dentry
 20628  20628 100%    0.11K    573       36      2292K sysfs_dir_cache
 19834  19834 100%    1.21K    915       26     29280K jfs_ip
 11968   8591  71%    0.06K    187       64       748K kmalloc-64
 11900   6433  54%    0.05K    140       85       560K shared_policy_node
 11200  11200 100%    0.55K    400       28      6400K radix_tree_node
 10695   7319  68%    0.17K    465       23      1860K vm_area_struct
  9728   9728 100%    0.01K     19      512        76K kmalloc-8
  8544   3914  45%    0.25K    267       32      2136K kmalloc-256
  8127   7884  97%    0.58K    301       27      4816K inode_cache
  6348   3614  56%    0.09K    138       46       552K anon_vma
  5888   5041  85%    0.02K     23      256        92K kmalloc-16
  5312   5312 100%    0.12K    166       32       664K jfs_mp
  5120   3771  73%    0.03K     40      128       160K kmalloc-32
  5031   5031 100%    0.10K    129       39       516K buffer_head
  4368   4204  96%    0.07K     78       56       312K Acpi-ParseExt
  4032   3131  77%    0.09K     96       42       384K kmalloc-96
  3744   3565  95%    0.12K    117       32       468K kmalloc-128
  3738   2536  67%    0.19K    178       21       712K kmalloc-192
  3584   3584 100%    0.02K     14      256        56K jbd2_revoke_table_s
  3264   3264 100%    0.04K     32      102       128K Acpi-Namespace
  2210   2126  96%    0.02K     13      170        52K numa_policy
  2144   1539  71%    0.50K     67       32      1072K kmalloc-512
  2064   1687  81%    0.66K     86       24      1376K shmem_inode_cache


--k1lZvvs/B4yU6o8G--

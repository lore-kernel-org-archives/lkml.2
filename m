Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab2JDTuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 15:50:55 -0400
Received: from frost.carfax.org.uk ([85.119.82.111]:55580 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756950Ab2JDTux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 15:50:53 -0400
X-Greylist: delayed 1831 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Oct 2012 15:50:53 EDT
Date: Thu, 4 Oct 2012 20:20:17 +0100
From: Hugo Mills <hugo-lkml@carfax.org.uk>
To: linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: i915 problems with suspend to disk
Message-ID: <20121004192017.GI25498@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	linux-kernel@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="boAH8PqvUi1v1f55"
Content-Disposition: inline
X-GPG-Fingerprint: 8C59 86C7 81F3 93FE BB02  DDB1 20AC B3BE 515C 238D
X-GPG-Key: 515C238D
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
X-frost.carfax.org.uk-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--boAH8PqvUi1v1f55
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Hi,

   On 3.6, I've got a problem with my video driver after resuming from
suspend-to-disk: the lower part of the display flickers, rapidly but
irregularly (think of a neon sign in a bad film noir), flicking
between the correct display and... something else, it's hard to see
what.

   Shutting the lid of the machine (to trigger a suspend-to-ram) and
waking it up again fixes the flicker.

   In syslogs, I have nothing obvious on suspend, and this warning on
resume:

Oct  4 19:53:04 ruth kernel: [ 2892.184086] ------------[ cut here ]------------
Oct  4 19:53:04 ruth kernel: [ 2892.184114] WARNING: at drivers/gpu/drm/i915/intel_display.c:1225 intel_crtc_disable+0x52/0x86 [i915]()
Oct  4 19:53:04 ruth kernel: [ 2892.184115] Hardware name: 0196CTO
Oct  4 19:53:04 ruth kernel: [ 2892.184117] pipe B assertion failure (expected off, current on)
Oct  4 19:53:04 ruth kernel: [ 2892.184188] Modules linked in: cpufreq_powersave cpufreq_userspace cpufreq_stats cpufreq_conservative rfcomm bnep binfmt_misc uinput nfsd auth_rpcgss nfs_acl nfs lockd fscache sunrpc ext4 jbd2 mbcache loop arc4 iwldvm mac80211 snd_hda_codec_hdmi snd_hda_codec_conexant coretemp i915 snd_hda_intel snd_hda_codec drm_kms_helper iwlwifi snd_hwdep snd_pcm snd_page_alloc joydev snd_seq snd_seq_device snd_timer kvm_intel drm i2c_algo_bit thinkpad_acpi acpi_cpufreq nvram btusb bluetooth kvm crc16 cfg80211 microcode psmouse evdev i2c_i801 video rfkill wmi mperf i2c_core snd battery ac processor soundcore button btrfs crc32c libcrc32c zlib_deflate sha256_generic ablk_helper cryptd aes_x86_64 aes_generic cbc dm_crypt dm_mod sd_mod crc_t10dif ums_realtek usb_storage uas thermal thermal_sys ahci libahci libata uhci_hcd scsi_mod ehci_hcd r8169 mii usbcore usb_common
Oct  4 19:53:04 ruth kernel: [ 2892.184198] Pid: 4117, comm: kworker/u:3 Not tainted 3.6.0 #14
Oct  4 19:53:04 ruth kernel: [ 2892.184199] Call Trace:
Oct  4 19:53:04 ruth kernel: [ 2892.184207]  [<ffffffff8102bdc5>] ? warn_slowpath_common+0x78/0x8c
Oct  4 19:53:04 ruth kernel: [ 2892.184213]  [<ffffffff8104afd3>] ? async_schedule+0xc/0xc
Oct  4 19:53:04 ruth kernel: [ 2892.184216]  [<ffffffff8102be71>] ? warn_slowpath_fmt+0x45/0x4a
Oct  4 19:53:04 ruth kernel: [ 2892.184221]  [<ffffffff8104afd3>] ? async_schedule+0xc/0xc
Oct  4 19:53:04 ruth kernel: [ 2892.184238]  [<ffffffffa03fdae0>] ? intel_crtc_disable+0x52/0x86 [i915]
Oct  4 19:53:04 ruth kernel: [ 2892.184245]  [<ffffffffa0273e47>] ? drm_helper_disable_unused_functions+0xd0/0xfb [drm_kms_helper]
Oct  4 19:53:04 ruth kernel: [ 2892.184250]  [<ffffffffa027461e>] ? drm_helper_resume_force_mode+0xf1/0xff [drm_kms_helper]
Oct  4 19:53:04 ruth kernel: [ 2892.184254]  [<ffffffff8104afd3>] ? async_schedule+0xc/0xc
Oct  4 19:53:04 ruth kernel: [ 2892.184264]  [<ffffffffa03dc17f>] ? i915_drm_thaw+0xd4/0x10b [i915]
Oct  4 19:53:04 ruth kernel: [ 2892.184274]  [<ffffffffa03dc4fc>] ? i915_resume+0x3b/0x50 [i915]
Oct  4 19:53:04 ruth kernel: [ 2892.184279]  [<ffffffff81193f21>] ? pci_legacy_resume+0x39/0x39
Oct  4 19:53:04 ruth kernel: [ 2892.184284]  [<ffffffff812196f7>] ? dpm_run_callback.isra.5+0x26/0x54
Oct  4 19:53:04 ruth kernel: [ 2892.184289]  [<ffffffff81219fe1>] ? device_resume+0xd0/0x110
Oct  4 19:53:04 ruth kernel: [ 2892.184292]  [<ffffffff8121a035>] ? async_resume+0x14/0x38
Oct  4 19:53:04 ruth kernel: [ 2892.184296]  [<ffffffff8104b070>] ? async_run_entry_fn+0x9d/0x175
Oct  4 19:53:04 ruth kernel: [ 2892.184300]  [<ffffffff81041a1a>] ? process_one_work+0x184/0x2a3
Oct  4 19:53:04 ruth kernel: [ 2892.184304]  [<ffffffff810426f1>] ? worker_thread+0x1fe/0x29f
Oct  4 19:53:04 ruth kernel: [ 2892.184307]  [<ffffffff810424f3>] ? manage_workers+0x223/0x223
Oct  4 19:53:04 ruth kernel: [ 2892.184310]  [<ffffffff810424f3>] ? manage_workers+0x223/0x223
Oct  4 19:53:04 ruth kernel: [ 2892.184315]  [<ffffffff81045adf>] ? kthread+0x67/0x6f
Oct  4 19:53:04 ruth kernel: [ 2892.184319]  [<ffffffff812fe774>] ? kernel_thread_helper+0x4/0x10
Oct  4 19:53:04 ruth kernel: [ 2892.184324]  [<ffffffff81045a78>] ? kthread_freezable_should_stop+0x3c/0x3c
Oct  4 19:53:04 ruth kernel: [ 2892.184327]  [<ffffffff812fe770>] ? gs_change+0xb/0xb
Oct  4 19:53:04 ruth kernel: [ 2892.184328] ---[ end trace 4e63ed9ed8ebc493 ]---

   Hardware is a Lenovo Thinkpad Edge13, lspci says:

00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)

aka

00:02.0 0300: 8086:2a42 (rev 07)

   Let me know if you need more information. I can probably manage a
bisect if necessary -- it's easily repeatable as a bug.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                   --- Ceci n'est pas une pipe:  | ---                   

--boAH8PqvUi1v1f55
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUG3hcb9z9OVl50rAAQIPAw/+PTmEo/emKxq+hDmsKFF9FtJFqz1yk+Vs
dR44YG0JtR6fwqJJysvQPL4k9/Idi5qvYL632DHmfWcoiuO5NI0CRj+GBe4tcNBt
rfDeA9rAzlIXVOScif5JUX1TAd84dEnV1xS0gB5HLVeybDCKolg1GeP3EUK/5bMV
+zD3t1thoDuWcltguBTBwJtGLjGVHOEF0kwhVxYLxnT3jtzoPVpoNL7z27rvBHOv
mN38k4Mli0F7Rh9zCrS6fz2heq6OlP3CbgfIViQdt7AcFglulO4FoXoshVnzgHlP
+4G8cDq/bnjPLG6/ZIRu/3FAZd13E5iVKliWWmQXd9H+nFO6RGUn2I3ikVxV6Jf8
TAmzr7VlvomhoUHSUhvtdK1jyY/pvBN9oy/Oq7mLDpymXYFRylVEQ6oEuzVKaeZy
S0FRp/lJA/by39nFDYSjhz8apJ9sVGG08Mm+0lVJyWpmfkqSIbpv212FMgxTyhZx
QXpLphoJYhQnEmQhztVEIONGTxq2Ct1sHOy0/V6tdevIpa5BRqExP3mY15PrINjs
jIaheBc0/x1crWUbE65TDZIkW76RkazH2hLWJpCbzV+Jyd0VDsOkHe2LgJqC5xCW
A4k3UDG6Tv1EzGL7ww2hyL81Gl9697bRrj6BZXqoWGJ2TdkeTamr+f1iC2AtvcvR
zCyBkOzZHag=
=cvZe
-----END PGP SIGNATURE-----

--boAH8PqvUi1v1f55--

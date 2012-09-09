Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab2IIMyd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 08:54:33 -0400
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:56108 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab2IIMy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 08:54:29 -0400
Message-ID: <20120909155424.862635h7ncykg9s0@www.81.fi>
Date: Sun, 09 Sep 2012 15:54:24 +0300
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Romain Francoise <romain@orebokech.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: Linux 3.6-rc5
References: <CA+55aFwnPfdyTTG6WTuhChomg=t9nSS18xracq3iQ3F5+PWOog@mail.gmail.com>
 <87har7h84h.fsf@silenus.orebokech.com>
In-Reply-To: <87har7h84h.fsf@silenus.orebokech.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Romain Francoise <romain@orebokech.com>:

> Still seeing this BUG with -rc5, that I originally reported here:
> http://marc.info/?l=linux-crypto-vger&m=134653220530264&w=2

Does reverting e46e9a46386bca8e80a6467b5c643dc494861896 help?

That commit added crypto selftest for authenc(hmac(sha1),cbc(aes)) in  
3.6, and probably made this bug visible (but not directly causing it).

-Jussi

>
> [   26.362567] ------------[ cut here ]------------
> [   26.362583] kernel BUG at crypto/scatterwalk.c:37!
> [   26.362606] invalid opcode: 0000 [#1] SMP
> [   26.362622] Modules linked in: authenc xfrm6_mode_tunnel  
> xfrm4_mode_tunnel cpufreq_conservative cpufreq_userspace  
> cpufreq_powersave cpufreq_stats xfrm_user xfrm4_tunnel tunnel4  
> ipcomp xfrm_ipcomp esp4 ah4 binfmt_misc deflate zlib_deflate ctr  
> twofish_generic twofish_avx_x86_64 twofish_x86_64_3way  
> twofish_x86_64 twofish_common camellia_generic camellia_x86_64  
> serpent_avx_x86_64 serpent_sse2_x86_64 serpent_generic glue_helper  
> lrw xts gf128mul blowfish_generic blowfish_x86_64 blowfish_common  
> cast5 des_generic cbc xcbc rmd160 sha512_generic sha1_ssse3  
> sha1_generic hmac crypto_null af_key xfrm_algo ip6table_filter  
> ip6_tables xt_recent xt_LOG nf_conntrack_ipv4 nf_defrag_ipv4  
> xt_state nf_conntrack xt_tcpudp iptable_filter ip_tables x_tables  
> hwmon_vid msr vhost_net macvtap macvlan tun loop bridge stp llc  
> firewire_sbp2 fuse rc_dib0700_rc5 snd_hda_codec_hdmi dvb_usb_dib0700  
> dib7000m dib0090 dib8000 dib0070 dib7000p dib3000mc dibx000_common  
> dvb_usb snd_hda_codec_realtek dvb_core rc_co
>  re snd
> _hda_intel snd_hda_codec snd_seq_midi snd_seq_midi_event snd_hwdep  
> snd_pcm_oss snd_rawmidi snd_mixer_oss snd_seq snd_pcm snd_seq_device  
> radeon snd_timer snd soundcore acpi_cpufreq mperf ttm processor  
> drm_kms_helper thermal_sys mxm_wmi drm snd_page_alloc i2c_algo_bit  
> i2c_i801 i2c_core lpc_ich button psmouse evdev coretemp serio_raw  
> wmi pcspkr mei kvm_intel kvm ext4 crc16 jbd2 mbcache sha256_generic  
> usb_storage uas dm_crypt dm_mod raid10 raid1 md_mod sg ata_generic  
> sd_mod hid_generic crc_t10dif pata_marvell usbhid hid crc32c_intel  
> ghash_clmulni_intel aesni_intel aes_x86_64 aes_generic ablk_helper  
> cryptd firewire_ohci microcode ahci firewire_core libahci crc_itu_t  
> libata scsi_mod xhci_hcd ehci_hcd usbcore usb_common e1000e
> [   26.371138] CPU 5
> [   26.371146] Pid: 3704, comm: cryptomgr_test Not tainted  
> 3.6.0-rc5-ore #1                  /DP67BG
> [   26.374095] RIP: 0010:[<ffffffff811d70d1>]  [<ffffffff811d70d1>]  
> scatterwalk_start+0x11/0x20
> [   26.375598] RSP: 0018:ffff88040d62b9d8  EFLAGS: 00010246
> [   26.377067] RAX: 0000000000000000 RBX: ffff88040b6e3868 RCX:  
> 0000000000000014
> [   26.378567] RDX: 0000000000000020 RSI: ffff88040b6e3868 RDI:  
> ffff88040d62b9e0
> [   26.380028] RBP: 0000000000000020 R08: 0000000000000001 R09:  
> ffff88040b6e39a8
> [   26.381494] R10: ffffffffa06b4000 R11: ffff88040b6e39fc R12:  
> 0000000000000014
> [   26.383023] R13: 0000000000000001 R14: ffff88040b6e38f8 R15:  
> 0000000000000000
> [   26.384488] FS:  0000000000000000(0000) GS:ffff88041f540000(0000)  
> knlGS:0000000000000000
> [   26.385973] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   26.387581] CR2: 00007f54c282fbd0 CR3: 000000000180b000 CR4:  
> 00000000000407e0
> [   26.389057] DR0: 0000000000000000 DR1: 0000000000000000 DR2:  
> 0000000000000000
> [   26.390547] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:  
> 0000000000000400
> [   26.392015] Process cryptomgr_test (pid: 3704, threadinfo  
> ffff88040d62a000, task ffff88040ca3ab60)
> [   26.393558] Stack:
> [   26.395103]  ffffffff811d72fb ffff88040b6e3868 0000002000000000  
> ffff88040b6e3868
> [   26.396622]  ffff88040b6e3800 ffff88040b6e3868 0000000000000020  
> ffff88040b6e3868
> [   26.398163]  ffff88040919f440 ffff88040d62bcc8 ffffffffa07edaa0  
> ffff88040b6e3930
> [   26.399643] Call Trace:
> [   26.401112]  [<ffffffff811d72fb>] ? scatterwalk_map_and_copy+0x5b/0xd0
> [   26.402714]  [<ffffffffa07edaa0>] ?  
> crypto_authenc_genicv+0xa0/0x300 [authenc]
> [   26.404274]  [<ffffffff811de5bb>] ? test_aead+0x58b/0xcd0
> [   26.406082]  [<ffffffff811d4cb0>] ? crypto_mod_get+0x10/0x30
> [   26.407704]  [<ffffffff811d57c3>] ? crypto_alloc_base+0x53/0xb0
> [   26.409267]  [<ffffffffa01dd6e0>] ?  
> cryptd_alloc_ablkcipher+0x80/0xc0 [cryptd]
> [   26.410838]  [<ffffffff8113f3fd>] ? __kmalloc+0x20d/0x250
> [   26.412364]  [<ffffffff811d6321>] ? crypto_spawn_tfm2+0x31/0x70
> [   26.413938]  [<ffffffffa0066050>] ? ablk_init_common+0x10/0x30  
> [ablk_helper]
> [   26.415448]  [<ffffffff811d56f9>] ? __crypto_alloc_tfm+0xf9/0x170
> [   26.416963]  [<ffffffff811d63a3>] ? crypto_spawn_tfm+0x43/0x90
> [   26.418505]  [<ffffffff811d998e>] ? skcipher_geniv_init+0x1e/0x40
> [   26.420046]  [<ffffffff811d56f9>] ? __crypto_alloc_tfm+0xf9/0x170
> [   26.421599]  [<ffffffff811d63a3>] ? crypto_spawn_tfm+0x43/0x90
> [   26.423228]  [<ffffffff8113f3fd>] ? __kmalloc+0x20d/0x250
> [   26.424788]  [<ffffffffa07ed359>] ?  
> crypto_authenc_init_tfm+0x49/0xc0 [authenc]
> [   26.426374]  [<ffffffff811d56f9>] ? __crypto_alloc_tfm+0xf9/0x170
> [   26.427999]  [<ffffffff811dedd8>] ? alg_test_aead+0x48/0xb0
> [   26.429781]  [<ffffffff811dddee>] ? alg_test+0xfe/0x310
> [   26.431503]  [<ffffffff8141de1a>] ? __schedule+0x2ba/0x700
> [   26.433235]  [<ffffffff811dcb30>] ? cryptomgr_probe+0xb0/0xb0
> [   26.434918]  [<ffffffff811dcb68>] ? cryptomgr_test+0x38/0x40
> [   26.436524]  [<ffffffff8106fbb5>] ? kthread+0x85/0x90
> [   26.436526]  [<ffffffff81427d44>] ? kernel_thread_helper+0x4/0x10
> [   26.436527]  [<ffffffff8106fb30>] ?  
> kthread_freezable_should_stop+0x60/0x60
> [   26.436528]  [<ffffffff81427d40>] ? gs_change+0x13/0x13
> [   26.436537] Code: 00 00 88 ff ff 48 c1 e0 0c 48 01 d0 8b 57 08 81  
> e2 ff 0f 00 00 48 01 d0 c3 90 48 89 37 8b 46 0c 85 c0 74 07 8b 46 08  
> 89 47 08 c3 <0f> 0b 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 8b 47 08  
> 48 8b 17
> [   26.436538] RIP  [<ffffffff811d70d1>] scatterwalk_start+0x11/0x20
> [   26.436538]  RSP <ffff88040d62b9d8>
> [   26.436544] ---[ end trace 1d0abbb65dcc723e ]---
> [   26.436546] note: cryptomgr_test[3704] exited with preempt_count 1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>




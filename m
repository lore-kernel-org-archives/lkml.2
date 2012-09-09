Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab2IITUH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 15:20:07 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:38534 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754197Ab2IITUE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 15:20:04 -0400
Date: Sun, 9 Sep 2012 12:19:58 -0700
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Romain Francoise <romain@orebokech.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Linux 3.6-rc5
Message-ID: <20120909191958.GB9782@gondor.apana.org.au>
References: <CA+55aFwnPfdyTTG6WTuhChomg=t9nSS18xracq3iQ3F5+PWOog@mail.gmail.com>
 <87har7h84h.fsf@silenus.orebokech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <87har7h84h.fsf@silenus.orebokech.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2012 at 11:13:02AM +0200, Romain Francoise wrote:
> Still seeing this BUG with -rc5, that I originally reported here:
> http://marc.info/?l=linux-crypto-vger&m=134653220530264&w=2
> 
> [   26.362567] ------------[ cut here ]------------
> [   26.362583] kernel BUG at crypto/scatterwalk.c:37!
> [   26.362606] invalid opcode: 0000 [#1] SMP 
> [   26.362622] Modules linked in: authenc xfrm6_mode_tunnel xfrm4_mode_tunnel cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 binfmt_misc deflate zlib_deflate ctr twofish_generic twofish_avx_x86_64 twofish_x86_64_3way twofish_x86_64 twofish_common camellia_generic camellia_x86_64 serpent_avx_x86_64 serpent_sse2_x86_64 serpent_generic glue_helper lrw xts gf128mul blowfish_generic blowfish_x86_64 blowfish_common cast5 des_generic cbc xcbc rmd160 sha512_generic sha1_ssse3 sha1_generic hmac crypto_null af_key xfrm_algo ip6table_filter ip6_tables xt_recent xt_LOG nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp iptable_filter ip_tables x_tables hwmon_vid msr vhost_net macvtap macvlan tun loop bridge stp llc firewire_sbp2 fuse rc_dib0700_rc5 snd_hda_codec_hdmi dvb_usb_dib0700 dib7000m dib0090 dib8000 dib0070 dib7000p dib3000mc dibx000_common dvb_usb snd_hda_codec_realtek dvb_core rc_co
>  re snd
> _hda_intel snd_hda_codec snd_seq_midi snd_seq_midi_event snd_hwdep snd_pcm_oss snd_rawmidi snd_mixer_oss snd_seq snd_pcm snd_seq_device radeon snd_timer snd soundcore acpi_cpufreq mperf ttm processor drm_kms_helper thermal_sys mxm_wmi drm snd_page_alloc i2c_algo_bit i2c_i801 i2c_core lpc_ich button psmouse evdev coretemp serio_raw wmi pcspkr mei kvm_intel kvm ext4 crc16 jbd2 mbcache sha256_generic usb_storage uas dm_crypt dm_mod raid10 raid1 md_mod sg ata_generic sd_mod hid_generic crc_t10dif pata_marvell usbhid hid crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 aes_generic ablk_helper cryptd firewire_ohci microcode ahci firewire_core libahci crc_itu_t libata scsi_mod xhci_hcd ehci_hcd usbcore usb_common e1000e

Can you try blacklisting/not loading sha1_ssse3 and aesni_intel
to see which one of them is causing this crash? Of course if you
can still reproduce this without loading either of them that would
also be interesting to know.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

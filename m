Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab0LRRNJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 12:13:09 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:34566 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756888Ab0LRRNI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 12:13:08 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/NJxddtPzNK+afsGbmAQ90Tp6rdWLTEfjfQuB46z
	iwIw7syGCSIkNf
Subject: Re: Thunar crashes kernel
From: Mike Galbraith <efault@gmx.de>
To: Romain Francoise <romain@orebokech.com>
Cc: Christian Hesse <mail@earthworm.de>, linux-kernel@vger.kernel.org
In-Reply-To: <87y67nt3o8.fsf@elegiac.orebokech.com>
References: <20101218005526.177e1617@leda.vpn.lugor.de>
	 <1292646773.7406.19.camel@marge.simson.net>
	 <87y67nt3o8.fsf@elegiac.orebokech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Dec 2010 19:13:05 +0100
Message-ID: <1292695985.1181.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-12-18 at 18:02 +0100, Romain Francoise wrote:
> Mike Galbraith <efault@gmx.de> writes:
> 
> > Attached is a quilt tarball of what I've got plugged into 36.2
> > here if you want to try it.
> 
> FWIW, I added fix_skip_clock_update.diff on top of what I was running
> previously (2.6.36.2 + the two patches you posted previously and are
> included in the tarball), and the WARN_ON_ONCE(test_tsk_need_resched(next));
> triggers on two machines. It looks like this:

Thanks.  I've hit it twice too, looking for how the heck it can happen.
Both of mine were worker_thread.

> 
> [ 2712.156085] ------------[ cut here ]------------
> [ 2712.156097] WARNING: at /home/romain/tmp/linux/linux-2.6-2.6.36/debian/build/source_amd64_none/kernel/sched.c:3807 schedule+0x448/0x5f9()
> [ 2712.156102] Hardware name:
> [ 2712.156105] Modules linked in: authenc xfrm6_mode_tunnel xfrm4_mode_tunnel deflate zlib_deflate ctr twofish_generic twofish_x86_64 twofish_common camellia serpent blowfish cast5 des_generic xcbc rmd160 sha512_generic sha1_generic hmac crypto_null xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key ext4 jbd2 crc16 cpufreq_userspace cpufreq_stats cpufreq_conservative cpufreq_powersave xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables coretemp acpi_cpufreq mperf loop sha256_generic aes_x86_64 aes_generic cbc dm_crypt dm_mod i915 ftdi_sio snd_hda_codec_realtek drm_kms_helper drm snd_hda_intel snd_hda_codec usbserial tpm_tis i2c_i801 tpm snd_pcsp i2c_algo_bit i2c_core rng_core tpm_bios snd_hwdep snd_pcm video psmouse parport_pc parport output snd_timer snd evdev soundcore serio_raw snd_page_alloc led_class processor button ext3 jbd mbcache raid1 md_mod sd_mod crc_t10dif ata_generic uhci_hcd thermal thermal_sys ata_piix ehci_hcd floppy r8169 usbcore mii libata scsi_mod nls_base [last unloaded: scsi_wait_scan]
> [ 2712.156225] Pid: 2958, comm: tmux Not tainted 2.6.36-ore-amd64 #1
> [ 2712.156229] Call Trace:
> [ 2712.156236]  [<ffffffff8104487c>] ? warn_slowpath_common+0x78/0x8c
> [ 2712.156242]  [<ffffffff8130e173>] ? schedule+0x448/0x5f9
> [ 2712.156248]  [<ffffffff8130e719>] ? schedule_timeout+0xa0/0xd7
> [ 2712.156254]  [<ffffffff81050c65>] ? process_timeout+0x0/0xb
> [ 2712.156261]  [<ffffffff811192e6>] ? sys_epoll_wait+0x17f/0x267
> [ 2712.156268]  [<ffffffff8103fab3>] ? default_wake_function+0x0/0xf
> [ 2712.156274]  [<ffffffff81008a02>] ? system_call_fastpath+0x16/0x1b
> [ 2712.156279] ---[ end trace 06ece612984887c2 ]---
> 
> On the other machine:
> 
> [ 6279.152199] Pid: 29865, comm: kworker/0:2 Tainted: P            2.6.36-ore-amd64 #1
> [ 6279.152201] Call Trace:
> [ 6279.152207]  [<ffffffff8104487c>] ? warn_slowpath_common+0x78/0x8c
> [ 6279.152211]  [<ffffffff8130e173>] ? schedule+0x448/0x5f9
> [ 6279.152215]  [<ffffffff8105a396>] ? worker_thread+0x23b/0x240
> [ 6279.152218]  [<ffffffff8105a15b>] ? worker_thread+0x0/0x240
> [ 6279.152221]  [<ffffffff8105a15b>] ? worker_thread+0x0/0x240
> [ 6279.152225]  [<ffffffff8105d10c>] ? kthread+0x7a/0x82
> [ 6279.152228]  [<ffffffff81009824>] ? kernel_thread_helper+0x4/0x10
> [ 6279.152232]  [<ffffffff8105d092>] ? kthread+0x0/0x82
> [ 6279.152234]  [<ffffffff81009820>] ? kernel_thread_helper+0x0/0x10
> [ 6279.152237] ---[ end trace 5be61ee2b4fbcfdd ]---



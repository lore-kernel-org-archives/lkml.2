Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab0CWEaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 00:30:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44842 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab0CWEaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 00:30:04 -0400
Message-ID: <4BA843C5.9080307@suse.de>
Date: Tue, 23 Mar 2010 09:59:57 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@verizon.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>
Subject: Re: shutdown bugs, since about 2.6.31 or so
References: <201003222050.55716.gene.heskett@verizon.net>
In-Reply-To: <201003222050.55716.gene.heskett@verizon.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ccing linux-cifs-client@lists.samba.org where most of the cifs
development happens.

On 03/23/2010 06:20 AM, Gene Heskett wrote:
> Greetings;
> 
> I do not know if I am miss-configured or what, and I hadn't worried about it 
> extensively because the machine runs fine ANAICT.
> 
> But any reboot method short of just pressing the hdwe reset button generates 
> quite a lengthy process of repeatedly pressing ctl-alt-del, minimum of 6 
> times I believe, in order to actually do a shutdown, and this isn't at all 
> graceful.  Not all of it makes it to the log, but here is what does.
> 
> Mar 22 16:47:53 coyote kernel: [ 3000.619173] BUG: Dentry d76beaa0{i=2,n=/} 
> still in use (1) [unmount of cifs cifs]
> Mar 22 16:47:53 coyote kernel: [ 3000.619191] ------------[ cut here 
> ]------------
> Mar 22 16:47:53 coyote kernel: [ 3000.619303] kernel BUG at fs/dcache.c:676!
> Mar 22 16:47:53 coyote kernel: [ 3000.619420] invalid opcode: 0000 [#1] 
> PREEMPT SMP
> Mar 22 16:47:53 coyote kernel: [ 3000.619597] last sysfs file: 
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/ATK0110:00/hwmon/hwmon0/in3_input
> Mar 22 16:47:53 coyote kernel: [ 3000.619803] Modules linked in: nls_utf8 
> cifs radeon ttm drm_kms_helper drm agpgart nfsd lockd nfs_acl auth_rpcgss 
> expo
> rtfs rfcomm sco bnep l2cap autofs4 sunrpc ipv6 or51132 snd_usb_audio 
> snd_usb_lib cx88_dvb cx88_vp3054_i2c videobuf_dvb snd_emu10k1_synth 
> snd_emux_synth
> snd_seq_virmidi snd_seq_midi_emul dvb_core tuner_simple tuner_types tda9887 
> tda8290 tuner snd_emu10k1 cx8800 cx8802 cx88xx snd_rawmidi snd_ac97_codec ac
> 97_bus snd_seq_dummy i2c_algo_bit snd_seq_oss snd_seq_midi_event snd_seq 
> ftdi_sio btusb snd_pcm_oss snd_mixer_oss snd_pcm tveeprom bluetooth 
> snd_seq_dev
> ice snd_timer v4l2_common snd_page_alloc videodev snd_util_mem snd_hwdep 
> v4l1_compat usbserial btcx_risc snd i2c_nforce2 sg k10temp firewire_ohci 
> firewi
> re_core rtc_cmos videobuf_dma_sg sr_mod cdrom pcspkr soundcore videobuf_core 
> rtc_core crc_itu_t rfkill hwmon usblp joydev rtc_lib button evdev sd_mod ex
> t3 jbd uhci_hcd ohci_hcd ehci_hcd [last unloaded: asus_atk0110]
> Mar 22 16:47:53 coyote kernel: [ 3000.620117]
> Mar 22 16:47:53 coyote kernel: [ 3000.620117] Pid: 5747, comm: umount.cifs 
> Not tainted 2.6.34-rc2 #1 M2N-SLI DELUXE/System Product Name
> Mar 22 16:47:53 coyote kernel: [ 3000.620117] EIP: 0060:[<c10946ae>] EFLAGS: 
> 00010246 CPU: 1
> Mar 22 16:47:53 coyote kernel: [ 3000.620117] EIP is at 
> shrink_dcache_for_umount_subtree+0x14b/0x1fe
> Mar 22 16:47:53 coyote kernel: [ 3000.620117] EAX: 0000005b EBX: 00000001 
> ECX: 00000046 EDX: 00000000
> Mar 22 16:47:53 coyote kernel: [ 3000.620117] ESI: d76beaa0 EDI: d76beafc 
> EBP: d55e6f24 ESP: d55e6ef4
> Mar 22 16:47:53 coyote kernel: [ 3000.620117]  DS: 007b ES: 007b FS: 00d8 GS: 
> 00e0 SS: 0068
> Mar 22 16:47:53 coyote kernel: [ 3000.620117] Process umount.cifs (pid: 5747, 
> ti=d55e6000 task=d55d8780 task.ti=d55e6000)
> Mar 22 16:47:53 coyote kernel: [ 3000.620117] Stack:
> Mar 22 16:47:53 coyote kernel: [ 3000.620117]  c12d20ac d76beaa0 00000002 
> d76beafc 00000001 fa14da01 dc956b64 fa14da01
> Mar 22 16:47:53 coyote kernel: [ 3000.620117] <0> 0000001b dc956a00 fa14a7b4 
> dc956a00 d55e6f30 c109478e dc956a00 d55e6f40
> Mar 22 16:47:53 coyote kernel: [ 3000.620117] <0> c1087d38 00000013 fa158a5c 
> d55e6f4c c1087e32 dc956a00 d55e6f5c c10883c6
> Mar 22 16:47:53 coyote kernel: [ 3000.620117] Call Trace:
> Mar 22 16:47:53 coyote kernel: [ 3000.620117]  [<c109478e>] ? 
> shrink_dcache_for_umount+0x2d/0x37
> Mar 22 16:47:53 coyote kernel: [ 3000.620117]  [<c1087d38>] ? 
> generic_shutdown_super+0x15/0xd2
> Mar 22 16:47:53 coyote kernel: [ 3000.620117]  [<c1087e32>] ? 
> kill_anon_super+0xc/0x43
> Mar 22 16:47:53 coyote kernel: [ 3000.620117]  [<c10883c6>] ? 
> deactivate_super+0x39/0x4b
> Mar 22 16:47:53 coyote kernel: [ 3000.620117]  [<c1098dfd>] ? 
> mntput_no_expire+0x8c/0xbb
> Mar 22 16:47:53 coyote kernel: [ 3000.620117]  [<c10992df>] ? 
> sys_umount+0x299/0x2be
> Mar 22 16:47:53 coyote kernel: [ 3000.620117]  [<c1002813>] ? 
> sysenter_do_call+0x12/0x22
> Mar 22 16:47:53 coyote kernel: [ 3000.620117] Code: 00 89 45 ec 8b 46 10 8b 
> 1e 8b 7e 28 85 c0 74 03 8b 50 20 8d 81 64 01 00 00 50 ff 75 ec 53 57 52 56 6
> 8 ac 20 2d c1 e8 b5 fc 1b 00 <0f> 0b 83 c4 1c eb fe 8b 7e 1c 39 fe 75 04 31 
> ff eb 03 f0 ff 0f
> Mar 22 16:47:53 coyote kernel: [ 3000.620117] EIP: [<c10946ae>] 
> shrink_dcache_for_umount_subtree+0x14b/0x1fe SS:ESP 0068:d55e6ef4
> Mar 22 16:47:53 coyote kernel: [ 3000.627952] ---[ end trace fbecccbb5fac2d05 
> ]---
> 
> Now, after this point, I have to press ctl-alt-del at least 2 times to get it 
> to continue the shutdown, it will timeout 3 times trying to umount /usr, and 
> then finally squawk about a cifs mount that is done in my rc.local file.  
> That requires 2 more presses of the ctl-alt-del keys, then it finally says 
> its shutting down, and 20 to 30 seconds later I have to press them again 
> before it actually reverts to the bios to begin the next boot anew.
> 
> I have seen this fs/dcache.c line 676 mentioned many times here, and I would 
> have thought by now this nuisance would have been spanked.
> 
> Thanks.
> 


-- 
Suresh Jayaraman

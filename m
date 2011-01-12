Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab1ALWoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 17:44:09 -0500
Received: from smtp227-pc.aruba.it ([62.149.157.227]:51649 "HELO
	smtp2-pc.aruba.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1755111Ab1ALWoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 17:44:07 -0500
From: Michele Ballabio <barra_cuda@katamail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: BUG in rt2x00lib_txdone() with 2.6.37-rc8
Date: Wed, 12 Jan 2011 23:34:53 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-mike-1mike; KDE/4.5.5; i686; ; )
Cc: bebarino@gmail.com, htd@fancy-poultry.org, linux-wireless@vger.kernel.org,
        IvDoorn@gmail.com, users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101122334.55039.barra_cuda@katamail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.01.2011, Stephen Boyd wrote: 
>On 01/01/11 02:28, Heinz Diehl wrote:
>> On 31.12.2010, Stephen Boyd wrote: 
>> 
>>> [ 9085.714105] BUG: unable to handle kernel NULL pointer dereference at
>>> 00000000000000a4
>>> [ 9085.714816] IP: [<ffffffffa0025458>] rt2x00lib_txdone+0x36/0x249
>>> [rt2x00lib]
>>> [ 9085.715017] PGD 215fd067 PUD 292f4067 PMD 0
>>> [ 9085.715017] Oops: 0000 [#1] SMP
>>> [ 9085.715017] last sysfs file:
>>> /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
>>> [ 9085.715017] CPU 1
>>> [ 9085.715017] Modules linked in: usb_storage thermal snd_seq_oss
>>> snd_seq_midi snd_seq_dummy snd_pcm_oss snd_mixer_oss snd_hrtimer
>>> snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_event
>>> snd_seq_midi_emul snd_seq scsi_wait_scan powernow_k8 mperf i2c_i801 fuse
>>> fan snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm
>>> snd_seq_device snd_timer snd_page_alloc snd_util_mem rt73usb crc_itu_t
>>> rt2x00usb snd_hwdep snd processor r8169 via82cxxx rt2x00lib soundcore
>>> mii button k8temp
>>> [ 9085.715017]
>>> [ 9085.715017] Pid: 11513, comm: kworker/1:0 Not tainted 2.6.37-rc7+ #27
>>> MS-7094/MS-7094
>> [....]
>> 
>> I'm not quite shure on this, but it reminds me on this bug here:
>> https://bugzilla.kernel.org/show_bug.cgi?id=24892
>> 
>
>I believe I had the latest net tree merged into 2.6.37-rc7 in which case
>the patch mentioned in that bugzilla would already be applied.

I can confirm this bug is present in v2.6.37, and not in v2.6.36.
It seems to trigger quite randomly, I think in less than 2-3 hours after
the boot (sometimes in half an hour), and it leaves no trace in my log
files.

As Stephen said, most of the times the screen shows later oopses triggered
by this one, so it is not easy to identify it either.

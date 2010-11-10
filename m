Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab0KJF7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 00:59:46 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37112 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab0KJF7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 00:59:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=froiv8ytCi0Qve/75dUnbarrrFxSa/gKvilWYAKSJWov7vUg5qJ8mwoOyTIZOdgeec
         IDexEYKQNZpEC6c3IY31ay/3AXQ0SElptR4bqxeIDxWt4pH+uD36vjXQxjN1jxmNwia2
         GQlZ4zZW8prJzG0W1YlWECc892niO9m2RYTc0=
Subject: Re: warnings in 2.6.37-rc1+
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <20101110054948.GA16612@gamma.logic.tuwien.ac.at>
References: <20101110054948.GA16612@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 06:59:38 +0100
Message-ID: <1289368778.2700.23.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 10 novembre 2010 à 14:49 +0900, Norbert Preining a écrit :
> Hi all
> 
> (please keep in Cc, thanks)
> 
> [ 1592.320059] ------------[ cut here ]------------
> [ 1592.320077] WARNING: at net/ipv4/devinet.c:137 in_dev_finish_destroy+0x3d/0x6e()
> [ 1592.320083] Hardware name: VGN-Z11VN_B
> [ 1592.320088] Modules linked in: vboxnetadp vboxnetflt sco bnep rfcomm l2cap crc16 binfmt_misc dm_crypt dm_mod isofs btrfs zlib_deflate crc32c libcrc32c vfat fat hso fuse vboxdrv loop uinput snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi arc4 snd_rawmidi snd_seq_midi_event snd_seq iwlagn iwlcore mac80211 snd_timer btusb firewire_ohci firewire_core bluetooth snd_seq_device tpm_infineon sony_laptop snd soundcore crc_itu_t cfg80211 rfkill joydev snd_page_alloc
> [ 1592.320207] Pid: 0, comm: kworker/0:0 Tainted: P        W   2.6.37-rc1+ #3
> [ 1592.320213] Call Trace:
> [ 1592.320218]  <IRQ>  [<ffffffff81035075>] warn_slowpath_common+0x80/0x98
> [ 1592.320236]  [<ffffffff810350a2>] warn_slowpath_null+0x15/0x17
> [ 1592.320245]  [<ffffffff81352ede>] in_dev_finish_destroy+0x3d/0x6e
> [ 1592.320257]  [<ffffffff8132b5f7>] ipv4_dst_destroy+0x53/0x58
> [ 1592.320266]  [<ffffffff81314c26>] dst_destroy+0x78/0xd6
> [ 1592.320275]  [<ffffffff8132b340>] dst_free+0x1a/0x29
> [ 1592.320283]  [<ffffffff8132b358>] dst_rcu_free+0x9/0xb
> [ 1592.320292]  [<ffffffff8107b5fd>] __rcu_process_callbacks+0x173/0x265
> [ 1592.320301]  [<ffffffff8107b72e>] rcu_process_callbacks+0x3f/0x60
> [ 1592.320310]  [<ffffffff81039e1c>] __do_softirq+0x8f/0x140
> [ 1592.320322]  [<ffffffff810563fa>] ? tick_program_event+0x21/0x23
> [ 1592.320331]  [<ffffffff8100304c>] call_softirq+0x1c/0x28
> [ 1592.320339]  [<ffffffff81004c23>] do_softirq+0x33/0x68
> [ 1592.320347]  [<ffffffff8103a036>] irq_exit+0x36/0x8b
> [ 1592.320358]  [<ffffffff81019699>] smp_apic_timer_interrupt+0x88/0x96
> [ 1592.320366]  [<ffffffff81002b13>] apic_timer_interrupt+0x13/0x20
> [ 1592.320371]  <EOI>  [<ffffffff811ae0ef>] ? acpi_idle_enter_simple+0xc8/0xfa
> [ 1592.320389]  [<ffffffff811ae0ea>] ? acpi_idle_enter_simple+0xc3/0xfa
> [ 1592.320401]  [<ffffffff812e053c>] cpuidle_idle_call+0x9e/0xd6
> [ 1592.320408]  [<ffffffff81001484>] cpu_idle+0x56/0x9c
> [ 1592.320418]  [<ffffffff813816c8>] start_secondary+0x199/0x19d
> [ 1592.320426] ---[ end trace 5f7d0c35de1972f1 ]---
> 
> followed by a strange message:
> [ 1592.320431] Freeing alive in_device ffff88013e49b200
> 
> happened several times, starting after a wake up from suspend to ram.
> 
> Best wishes

Should be solved by a patch David will send to Linus in next round.

http://git.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commitdiff;h=18943d292facbc70e6a36fc62399ae833f64671b

Thanks





Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab0KHU3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 15:29:33 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50213 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab0KHU3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 15:29:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iYvkI8XTxGElFzloiWj8Pm48DAvH/wAOBDPk6/UdAo2GTNgY5k9SrjAnnshWf+tftc
         V1/EPWC/E5zWPUAd2lLLbYwWfXZG2wiYtU4YHb3GzRCI+rDM6ealXRqyfxkBHyTtrZKT
         cf2ynXDb9KwGJU8WZqscxv9cmSDQ5C4GHULRA=
Subject: Re: 2.6.37-rc1-git5 -- WARNING: at net/ipv4/devinet.c:137
 in_dev_finish_destroy+0x3d/0x6e()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Miles Lane <miles.lane@gmail.com>, ilpo.jarvinen@helsinki.fi,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        netdev@vger.kernel.org
In-Reply-To: <20101108200600.GG4032@linux.vnet.ibm.com>
References: <AANLkTinVyf4CpxdzEWUn7zTyOrAMKY3H9Dct-HfopiSD@mail.gmail.com>
	 <20101108200600.GG4032@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Nov 2010 21:29:26 +0100
Message-ID: <1289248166.2790.1.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 08 novembre 2010 à 12:06 -0800, Paul E. McKenney a écrit :
> On Mon, Nov 08, 2010 at 02:56:06PM -0500, Miles Lane wrote:
> > WARNING: at net/ipv4/devinet.c:137 in_dev_finish_destroy+0x3d/0x6e()
> > Hardware name: UL50VT
> > Modules linked in: ipv6 snd_hda_codec_hdmi snd_hda_codec_realtek
> > snd_hda_intel snd_hda_codec snd_pcm_oss snd_hwdep snd_mixer_oss
> > snd_seq_dummy snd_pcm snd_seq_oss snd_seq_midi iwlagn snd_rawmidi
> > snd_seq_midi_event snd_seq iwlcore uvcvideo snd_timer mac80211
> > snd_seq_device videodev v4l1_compat v4l2_compat_ioctl32 i915 snd
> > rtc_cmos rtc_core psmouse cfg80211 soundcore drm_kms_helper
> > snd_page_alloc rtc_lib asus_laptop video battery ac sparse_keymap wmi
> > button rfkill processor power_supply led_class usb_storage sg sr_mod
> > sd_mod cdrom atl1c ehci_hcd uhci_hcd thermal thermal_sys hwmon
> > Pid: 0, comm: kworker/0:0 Not tainted 2.6.37-rc1-git5 #10
> > Call Trace:
> >  <IRQ>  [<ffffffff8103767e>] warn_slowpath_common+0x80/0x98
> >  [<ffffffff810376ab>] warn_slowpath_null+0x15/0x17
> >  [<ffffffff8130d549>] in_dev_finish_destroy+0x3d/0x6e
> >  [<ffffffff8130d58e>] in_dev_put+0x14/0x16
> >  [<ffffffff8130d5ab>] inet_rcu_free_ifa+0x1b/0x27
> >  [<ffffffff810834a8>] __rcu_process_callbacks+0x1a4/0x2bc
> >  [<ffffffff8108363b>] rcu_process_callbacks+0x7b/0x82
> >  [<ffffffff8103cb9c>] __do_softirq+0xb8/0x15a
> >  [<ffffffff8100394c>] call_softirq+0x1c/0x28
> >  [<ffffffff81005637>] do_softirq+0x38/0x81
> >  [<ffffffff8103cce9>] irq_exit+0x45/0x94
> >  [<ffffffff8101ac1f>] smp_apic_timer_interrupt+0x78/0x86
> >  [<ffffffff81003413>] apic_timer_interrupt+0x13/0x20
> >  <EOI>  [<ffffffff8134aff6>] ? _raw_spin_unlock_irqrestore+0x3c/0x69
> >  [<ffffffff81059cb3>] clockevents_notify+0x11e/0x12d
> >  [<ffffffffa008e561>] ? acpi_idle_enter_bm+0x236/0x271 [processor]
> >  [<ffffffffa008dfce>] lapic_timer_state_broadcast+0x41/0x43 [processor]
> >  [<ffffffffa008e588>] acpi_idle_enter_bm+0x25d/0x271 [processor]
> >  [<ffffffff8129db30>] cpuidle_idle_call+0x9e/0xda
> >  [<ffffffff810012ea>] cpu_idle+0xce/0x10c
> >  [<ffffffff81343ce8>] start_secondary+0x1fc/0x205
> > ---[ end trace 1d49bc8ff0266634 ]---
> > Freeing alive in_device ffff88013fe536d0
> 
> Ilpo, thoughts?
> 

Hmm... 

    WARN_ON(idev->mc_list);

Might be a problem with refcounts somewhere...

Miles, is it reproductible ?

Thanks



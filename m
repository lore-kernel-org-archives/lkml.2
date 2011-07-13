Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750872Ab1GMEUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 00:20:10 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44150 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab1GMEUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 00:20:08 -0400
Subject: Re: Imon module Oops and kernel hang
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <4E1CCC26.4060506@psychogeeks.com>
Date: Wed, 13 Jul 2011 00:20:05 -0400
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Content-Transfer-Encoding: 7bit
Message-Id: <1B380AD0-FE0D-47DF-B2C3-605253C9C783@wilsonet.com>
References: <4E1B978C.2030407@psychogeeks.com> <20110712080309.d538fec9.rdunlap@xenotime.net> <7B814F02-408C-434F-B813-8630B60914DA@wilsonet.com> <4E1CCC26.4060506@psychogeeks.com>
To: Chris W <lkml@psychogeeks.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 12, 2011, at 6:35 PM, Chris W wrote:

> Thanks for the reply.
> 
> On 13/07/11 05:55, Jarod Wilson wrote:
>> 
>> I don't see any rc_imon_pad or rc_imon_mce modules there, and I've not
>> seen any panics with multiple imon devices here, so I'm guessing you
>> didn't build either of the possible imon keymaps, and having a null
>> keymap is interacting badly with rc_g_keycode_from_table.
> 
> 
> There is only one imon device in this machine.

Understood. What I meant is that *I* have multiple imon devices, and
haven't seen any such panic with any of them. :)


> The rc keymap modules have been built (en masse as a result of
> CONFIG_RC_MAP=m) but I am not explicitly loading them and they do not
> get automatically loaded.

Huh. That's unexpected. They get auto-loaded here, last I knew. I'll have
to give one of my devices a spin tomorrow, not sure exactly what the last
kernel I tried one of them on was. Pretty sure they're working fine with
the Fedora 15 2.6.38.x kernels and vanilla (but Fedora-configured) 3.0-rc
kernels though.


> I just tried this:
> 
> kepler ~ # rmmod rc_winfast ir_lirc_codec lirc_dev ir_sony_decoder
> ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder ir_nec_decoder
> 
> kepler ~ # modprobe -v rc-imon-pad
> insmod /lib/modules/2.6.39.3/kernel/drivers/media/rc/keymaps/rc-imon-pad.ko
> 
> kepler ~ # modprobe -v rc-imon-mce
> insmod /lib/modules/2.6.39.3/kernel/drivers/media/rc/keymaps/rc-imon-mce.ko
...
> kepler ~ # modprobe -v imon debug=1
> insmod /lib/modules/2.6.39.3/kernel/drivers/media/rc/imon.ko debug=1
> 
> with the same crash (below).  (I have the tainting nvidia driver loaded
> today but it was absent yesterday)
> 
> Perhaps there something else in the kernel config that must be on in
> order to support the keymaps?
> 
> Any other thoughts?

Not at the moment. That T.889 line is... odd. No clue what the heck that
thing is. Lemme see what I can see tomorrow (just past midnight here at
the moment), if I don't hit anything, I might need a copy of your kernel
config to repro.

> Jul 13 08:21:14 kepler Call Trace:
> Jul 13 08:21:14 kepler [<c101e9ae>] ? T.889+0x2e/0x50
> Jul 13 08:21:14 kepler [<f8e3759c>] imon_remote_key_lookup+0x1c/0x70 [imon]
> Jul 13 08:21:14 kepler [<f8e376dc>] imon_incoming_packet+0x5c/0xe10 [imon]
> Jul 13 08:21:14 kepler [<fbcde004>] ? _nv004358rm+0x24/0x70 [nvidia]
> Jul 13 08:21:14 kepler [<fbcde030>] ? _nv004358rm+0x50/0x70 [nvidia]
> Jul 13 08:21:14 kepler [<c124f353>] ? __ata_qc_complete+0x73/0x110
> Jul 13 08:21:14 kepler [<f8e38563>] usb_rx_callback_intf0+0x63/0x70 [imon]
> Jul 13 08:21:14 kepler [<c1272cc8>] usb_hcd_giveback_urb+0x48/0xb0
> Jul 13 08:21:14 kepler [<c128a5ee>] uhci_giveback_urb+0x8e/0x220
> Jul 13 08:21:14 kepler [<c128ac16>] uhci_scan_schedule+0x396/0x9a0
> Jul 13 08:21:14 kepler [<c128cfd1>] uhci_irq+0x91/0x170
> Jul 13 08:21:14 kepler [<c1271de1>] usb_hcd_irq+0x21/0x50
> Jul 13 08:21:14 kepler [<c1051246>] handle_irq_event_percpu+0x36/0x140
> Jul 13 08:21:14 kepler [<c1015f06>] ? __io_apic_modify_irq+0x76/0x90
> Jul 13 08:21:14 kepler [<c1053000>] ? handle_edge_irq+0x100/0x100
> Jul 13 08:21:14 kepler [<c1051382>] handle_irq_event+0x32/0x60
> Jul 13 08:21:14 kepler [<c1053045>] handle_fasteoi_irq+0x45/0xc0


-- 
Jarod Wilson
jarod@wilsonet.com




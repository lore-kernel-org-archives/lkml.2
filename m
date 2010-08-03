Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab0HCISy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 04:18:54 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59291 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab0HCISv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 04:18:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=gNqUWBVYx9yI5bmjMfQbsR8ZWfQF6a/UOEmBHy5RzNQt5JzUGkPL9Vu54XtNdeIKo3
         rO5mCUpcE2n6i5eF9u+yWEIEml3pv0LtCOx4W0ClvR/XFH89eb+l1VOkGdsMB3Bylenf
         Rm+Xguy9Ho76+/R7kFUfp+Ulbzm1wGDDf+BV4=
MIME-Version: 1.0
In-Reply-To: <1280460642.2173.3.camel@localhost.localdomain>
References: <1280460642.2173.3.camel@localhost.localdomain>
Date: Tue, 3 Aug 2010 10:18:49 +0200
X-Google-Sender-Auth: BjCJK5iBtZKU4lFKyBWUVJW7_hc
Message-ID: <AANLkTi=p-_owFPD1_uD4c2KvO0RB-c-GO3Cq-y9b0EfR@mail.gmail.com>
Subject: Re: 2.6.33.6-rt26: oops
From: John Kacur <jkacur@redhat.com>
To: Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>
Cc: john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 5:30 AM, Fernando Lopez-Lezcano
<nando@ccrma.stanford.edu> wrote:
> Hi all...
> This may not be rt related but here it goes anyway. It happened when I
> tried to restart my iptables service (/sbin/service iptables start). I
> think a day or two ago I had another network related hang, but it was a
> complete hang (no clues left behind - power button to reset).
>
> -- Fernando
>
>
>
> Jul 29 18:27:57 localhost kernel: BUG: unable to handle kernel NULL
> pointer dereference at (null)
> Jul 29 18:27:57 localhost kernel: IP: [<c045ad40>] exit_creds+0xc/0x54
> Jul 29 18:27:57 localhost kernel: *pdpt = 0000000000a68001 *pde =
> 0000000000000000
> Jul 29 18:27:57 localhost kernel: Oops: 0000 [#1] PREEMPT SMP
> Jul 29 18:27:57 localhost kernel: last sysfs
> file: /sys/devices/virtual/net/pan0/statistics/collisions
> Jul 29 18:27:57 localhost kernel: Modules linked in: snd_seq_midi
> snd_seq_midi_event snd_seq_dummy snd_usb_audio snd_usb_lib snd_rawmidi
> fuse rfcomm sco bridge stp llc bnep l2cap sunrpc cpufreq_ondemand
> acpi_cpufreq ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables
> ipv6 dm_multipath uinput arc4 snd_hda_codec_analog ecb iwl3945
> snd_hda_intel snd_hda_codec iwlcore thinkpad_acpi btusb sdhci_pci sdhci
> mmc_core snd_hwdep e1000e snd_seq ohci1394 ricoh_mmc snd_seq_device
> snd_pcm snd_timer snd mac80211 i2c_i801 iTCO_wdt iTCO_vendor_support
> joydev cfg80211 bluetooth snd_page_alloc rfkill soundcore yenta_socket
> rsrc_nonstatic i915 drm_kms_helper drm i2c_algo_bit i2c_core video
> output [last unloaded: microcode]
> Jul 29 18:27:57 localhost kernel:
> Jul 29 18:27:57 localhost kernel: Pid: 6956, comm: sirq-rcu/1 Not
> tainted 2.6.33.6-147.2.4.rt26.1.fc12.ccrma.i686.rtPAE #1 6463CTO/6463CTO
> Jul 29 18:27:57 localhost kernel: EIP: 0060:[<c045ad40>] EFLAGS:
> 00010287 CPU: 1
> Jul 29 18:27:57 localhost kernel: EIP is at exit_creds+0xc/0x54
> Jul 29 18:27:57 localhost kernel: EAX: 00000000 EBX: f0e1a430 ECX:
> f0e1a960 EDX: 00000000
> Jul 29 18:27:57 localhost kernel: ESI: c410434c EDI: f0e1a960 EBP:
> f3321f38 ESP: f3321f34
> Jul 29 18:27:57 localhost kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0
> SS: 0068 preempt:00000000
> Jul 29 18:27:57 localhost kernel: Process sirq-rcu/1 (pid: 6956,
> ti=f3320000 task=f2b92d30 task.ti=f3320000)
> Jul 29 18:27:57 localhost kernel: Stack:
> Jul 29 18:27:57 localhost kernel: f0e1a430 f3321f44 c043e974 c4104334
> f3321f4c c043e9b4 f3321f70 c048507b
> Jul 29 18:27:57 localhost kernel: <0> 00000000 00000000 c099bbc0
> 00000283 c4103fdc c0a5cfec 00000200 f3321f78
> Jul 29 18:27:57 localhost kernel: <0> c0485192 f3321fa4 c044445e
> c0a5cfec f2b92d30 fffffdff 00000001 00000000
> Jul 29 18:27:57 localhost kernel: Call Trace:
> Jul 29 18:27:57 localhost kernel: [<c043e974>] ? __put_task_struct
> +0x54/0x87
> Jul 29 18:27:57 localhost kernel: [<c043e9b4>] ? __put_task_struct_cb
> +0xd/0xf
> Jul 29 18:27:57 localhost kernel: [<c048507b>] ? __rcu_process_callbacks
> +0x153/0x21a
> Jul 29 18:27:57 localhost kernel: [<c0485192>] ? rcu_process_callbacks
> +0x50/0x57
> Jul 29 18:27:57 localhost kernel: [<c044445e>] ? run_ksoftirqd
> +0x138/0x236
> Jul 29 18:27:57 localhost kernel: [<c0444326>] ? run_ksoftirqd+0x0/0x236
> Jul 29 18:27:57 localhost kernel: [<c04557ae>] ? kthread+0x5f/0x64
> Jul 29 18:27:57 localhost kernel: [<c045574f>] ? kthread+0x0/0x64
> Jul 29 18:27:57 localhost kernel: [<c040907e>] ? kernel_thread_helper
> +0x6/0x10
> Jul 29 18:27:57 localhost kernel: Code: 00 00 00 89 f8 e8 cb d7 1d 00 89
> f0 e8 bc fd ff ff 89 f0 e8 b5 fd ff ff 31 c0 5b 5e 5f 5d c3 55 89 e5 53
> 89 c3 8b 80 0c 03 00 00 <8b> 00 8b 83 08 03 00 00 c7 83 08 03 00 00 00
> 00 00 00 e8 8b fd
> Jul 29 18:27:57 localhost kernel: EIP: [<c045ad40>] exit_creds+0xc/0x54
> SS:ESP 0068:f3321f34
> Jul 29 18:27:57 localhost kernel: CR2: 0000000000000000
> Jul 29 18:27:57 localhost kernel: ---[ end trace ebf66505b4c2cac5 ]---
>

Is this easily reproducible? If so, can you try again with v2.6.33.6-rt28?
Thanks

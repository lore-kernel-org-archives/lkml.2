Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab1DRKyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 06:54:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54548 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab1DRKys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 06:54:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=A8QMOpKjxa4SjqCiv17YnbkZf/+x4kOL6ZeYv+96a6EgAweK/7Bd9Kd5Ld32EhDONu
         V6YExUcEDIcbemqLJNJPippRQgGtowmHMzOLQgN6hRh/3VPgOodflC9NXLjF1EkSRD89
         pCxebX0hZ50Flyiut1AFSueYHoWNiwDlckyNI=
MIME-Version: 1.0
In-Reply-To: <20110412182618.GB2836@joana>
References: <BANLkTin0bKs1D3JxVODw3F+qH0ZqRwh5KA@mail.gmail.com>
	<Pine.LNX.4.44L0.1104121210250.2000-100000@iolanthe.rowland.org>
	<20110412182618.GB2836@joana>
Date: Mon, 18 Apr 2011 12:54:47 +0200
Message-ID: <BANLkTinm9Yydw_bSxj2s1=G3ayoJz8Ph7g@mail.gmail.com>
Subject: Re: Endless print of uhci_result_common: failed with status 440000
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Zdenek Kabelac <zdenek.kabelac@gmail.com>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org, padovan@profusion.mobi
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/12 Gustavo F. Padovan <padovan@profusion.mobi>:
> * Alan Stern <stern@rowland.harvard.edu> [2011-04-12 12:10:56 -0400]:
>
>> On Tue, 12 Apr 2011, Zdenek Kabelac wrote:
>>
>> > 2011/4/11 Alan Stern <stern@rowland.harvard.edu>:
>> > > On Mon, 11 Apr 2011, Zdenek Kabelac wrote:
>> > >
>> > >> > I've created:
>> > >> >
>> > >> > https://bugzilla.kernel.org/show_bug.cgi?id=33062
>> > >> >
>> > >> > and I'm cc-ing linux-bluetooth.
>> > >> >
>> > >>
>> > >> In fact this Ooops might be related to:
>> > >>
>> > >> http://marc.info/?l=linux-kernel&m=130207593728273&w=2
>> > >
>> > > It might be. ?Did you try reverting the patch mentioned in that email?
>> > >
>> >
>> > Yep - it looks like the patch
>> > http://marc.info/?l=linux-bluetooth&m=130230770920378&w=2
>> > solved my problem with weird deadlocks.
>
> I pushed a patch that fixes this in a better way, it's on the bluetooth-2.6
> tree (should arrive to linus tree in some days).


hmm

Ok  - I assume you mean this patch:

http://git.kernel.org/?p=linux/kernel/git/padovan/bluetooth-2.6.git;a=commitdiff;h=b7d850641d2bc45b2320bfcb096f11406890ff3a

It seems to be detaching timer slightly differently as the one from
Keith probably.
Here is the trace I've got with older Keith's patch (which I've
believed was fine already)

iwl3945 0000:03:00.0: loaded firmware version 15.32.2.9
systemd[1]: Service bluetooth.target is not needed anymore. Stopping.
------------[ cut here ]------------
WARNING: at lib/list_debug.c:30 __list_add+0x8f/0xa0()
Hardware name: 6464CTO
list_add corruption. prev->next should be next (ffff88013b139390), but
was 2020203a6c61746f. (prev=ffff880137b63350).
Modules linked in: sunrpc ipt_REJECT xt_physdev xt_state
iptable_filter ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4
nf_conntrack nf_defrag_ipv4 ip_tables x_tables btusb bluetooth
snd_hda_codec_analog arc4 ecb crypto_blkcipher cryptomgr aead
crypto_algapi snd_hda_intel iwl3945 snd_hda_codec snd_seq iwl_legacy
snd_seq_device mac80211 snd_pcm thinkpad_acpi cfg80211 snd_timer
e1000e psmouse snd serio_raw wmi soundcore i2c_i801 snd_page_alloc
nvram iTCO_wdt iTCO_vendor_support evdev i915 dm_mirror dm_region_hash
dm_log dm_mod drm_kms_helper drm i2c_algo_bit i2c_core autofs4 usbhid
hid pcmcia sdhci_pci sdhci ehci_hcd uhci_hcd mmc_core sr_mod cdrom
yenta_socket usbcore video backlight
Pid: 44, comm: kworker/1:2 Not tainted 2.6.39-rc3-00236-g115ab9e #7
Call Trace:
 [<ffffffff810501df>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff810502d6>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff812988ef>] __list_add+0x8f/0xa0
 [<ffffffff810602f3>] internal_add_timer+0xb3/0x140
 [<ffffffff81062bd2>] mod_timer+0x152/0x450
 [<ffffffff81117bb6>] ? refresh_cpu_vm_stats+0x106/0x170
 [<ffffffff81062ee8>] add_timer+0x18/0x20
 [<ffffffff8106df4f>] queue_delayed_work_on+0xbf/0x140
 [<ffffffff8106f0d1>] queue_delayed_work+0x21/0x40
 [<ffffffff8106f10b>] schedule_delayed_work+0x1b/0x20
 [<ffffffff81117c71>] vmstat_update+0x51/0x60
 [<ffffffff81070c38>] process_one_work+0x1c8/0x6f0
 [<ffffffff81070bd7>] ? process_one_work+0x167/0x6f0
 [<ffffffff81493c44>] ? retint_restore_args+0xe/0xe
 [<ffffffff81117c20>] ? refresh_cpu_vm_stats+0x170/0x170
 [<ffffffff81071539>] worker_thread+0x159/0x340
 [<ffffffff810713e0>] ? rescuer_thread+0x240/0x240
 [<ffffffff810760fb>] kthread+0x9b/0xa0
 [<ffffffff8149b9d4>] kernel_thread_helper+0x4/0x10
 [<ffffffff810367a4>] ? finish_task_switch+0x74/0x110
 [<ffffffff8149367b>] ? _raw_spin_unlock_irq+0x3b/0x60
 [<ffffffff81493c44>] ? retint_restore_args+0xe/0xe
 [<ffffffff81076060>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff8149b9d0>] ? gs_change+0xb/0xb
---[ end trace 9184dc8969677db3 ]---

I'll see whether new version will not show this warning.

Zdenek

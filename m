Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970Ab0EYWeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 18:34:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46707 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758443Ab0EYWeM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 18:34:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=C61sF9avjAb1KgW6cTx2//PLim16sFmWQN03WTiy7sG+agxMamP2LLOBtLU6sXlfDa
         9kVllzRLto6QTa28fkO9d21t75SkwYa7F3xzgxKLgY/00CrkhI9CD9Oq2gBGoSsfG2TD
         mS1hmqrRTzGFje6MXdavyNfeoG3Ipg8Ar3F8M=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <201005251027.32778.dmitry.torokhov@gmail.com>
References: <20100525163920.GA2730@core.coreip.homeip.net>
	 <1274806916.18861.0.camel@jlt3.sipsolutions.net>
	 <1274807302.7494.1.camel@abhi-desktop>
	 <201005251027.32778.dmitry.torokhov@gmail.com>
Date: Wed, 26 May 2010 00:34:10 +0200
Message-ID: <AANLkTiljgdU4guPZUFMTI1xtfD5YLYoAicy6xmRhxfXL@mail.gmail.com>
Subject: Re: iwl3945 dies (oops) in post 2.6.34 kernels
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, 582906@bugs.debian.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ CC <582906@bugs.debian.org> ]

Unfortunately, I didn't notice I compiled compat-wireless (2010-05-21)
on user request against linux-image-2.6.32-5-686 and was using it
since then.
AFAICS Debian Bug #582906 can be closed.

$ dpkg -l | grep linux-image
ii  linux-image-2.6.32-5-686
    2.6.32-13                             Linux 2.6.32 for modern PCs

$ sudo lsmod | grep iwl | sort
cfg80211              100582  3 iwl3945,iwlcore,mac80211
compat_firmware_class     4683  1 iwl3945
iwl3945                45461  0
iwlcore                58688  1 iwl3945
mac80211              140617  2 iwl3945,iwlcore

On first sight it seems both patches fixed the issue here:

sd@seduxbox:~/src/compat-wireless/compat-wireless-2010-05-21$ cat
.pc/applied-patches
iwlwifi-fix-internal-scan-race.patch
temp.patch

By the way, iwlwifi-fix-internal-scan-race.patch alone did it not.

Any ideas for a testcase to be sure the problem is really fixed, now?

- Sedat -

[1] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=582906

P.S.:

$ dmesg | egrep -i 'iwl|80211|wlan'
[    9.854377] cfg80211: Calling CRDA to update world regulatory domain
[   11.196129] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network
Connection driver for Linux, in-tree:s
[   11.196132] iwl3945: Copyright(c) 2003-2010 Intel Corporation
[   11.196215] iwl3945 0000:10:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   11.196229] iwl3945 0000:10:00.0: setting latency timer to 64
[   11.250133] iwl3945 0000:10:00.0: Tunable channels: 13 802.11bg, 23
802.11a channels
[   11.250136] iwl3945 0000:10:00.0: Detected Intel Wireless WiFi Link 3945ABG
[   11.250277] iwl3945 0000:10:00.0: irq 29 for MSI/MSI-X
[   11.437198] cfg80211: World regulatory domain updated:
[   11.792890] phy0: Selected rate control algorithm 'iwl-3945-rs'
[   20.000982] iwl3945 0000:10:00.0: loaded firmware version 15.32.2.9
[   20.090054] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   30.185858] wlan0: direct probe to 00:04:0e:e4:00:3d (try 1)
[   30.188652] wlan0: direct probe responded
[   30.200042] wlan0: authenticate with 00:04:0e:e4:00:3d (try 1)
[   30.203234] wlan0: authenticated
[   30.203856] wlan0: associate with 00:04:0e:e4:00:3d (try 1)
[   30.400035] wlan0: associate with 00:04:0e:e4:00:3d (try 2)
[   30.404960] wlan0: RX AssocResp from 00:04:0e:e4:00:3d (capab=0x411
status=0 aid=1)
[   30.404966] wlan0: associated
[   30.406500] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   41.048032] wlan0: no IPv6 routers present

On Tue, May 25, 2010 at 7:27 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Tuesday 25 May 2010 10:08:22 am Abhijeet Kolekar wrote:
>> On Tue, 2010-05-25 at 10:01 -0700, Johannes Berg wrote:
>> > On Tue, 2010-05-25 at 09:39 -0700, Dmitry Torokhov wrote:
>> > > Hi,
>> > >
>> > > I am getting the following crashers in iwl3945 after updating to
>> > > post-2.6.34 kernels. This is with the pull from Linus's tree as of last
>> > > night (the taint is from nvidia module):
>> > >
>> > > [ 3330.630734] general protection fault: 0000 [#1] PREEMPT SMP
>> > > [ 3330.630752] last sysfs file: /sys/devices/platform/dock.0/docked
>> > > [ 3330.630761] CPU 0
>> > > [ 3330.630766] Modules linked in: cryptd aes_x86_64 aes_generic fuse
>> > > rfcomm sco bnep l2cap autofs4 coretemp hwmon sunrpc ppdev parport_pc
>> > > parport acpi_cpufreq mperf uinput nvidia(P) snd_hda_codec_idt arc4
>> > > snd_hda_intel ecb snd_hda_codec snd_hwdep iwl3945 joydev snd_seq
>> > > snd_seq_device snd_pcm iwlcore mac80211 snd_timer cfg80211 snd psmouse
>> > > iTCO_wdt dell_wmi iTCO_vendor_support serio_raw tg3 battery
>> > > dell_laptop dcdbas soundcore snd_page_alloc btusb bluetooth video
>> > > pcspkr mac_hid ac wmi libphy firewire_ohci i2c_i801 firewire_core
>> > > yenta_socket crc_itu_t ohci_hcd [last unloaded: microcode] [
>> > > 3330.630950]
>> > > [ 3330.630958] Pid: 455, comm: iwl3945 Tainted: P            2.6.35-rc0
>> > > #293 0WM416/Latitude D630 [ 3330.630967] RIP:
>> > > 0010:[<ffffffffa01e70d3>]  [<ffffffffa01e70d3>]
>> > > iwl3945_get_channels_for_scan+0xe3/0x460 [iwl3945]
>> >
>> > http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2208
>>
>> Can you please try this patch and report your findings?
>>
>> http://bugzilla.intellinuxwireless.org/attachment.cgi?id=2447
>>
>
> Thanks, will try both this patch and the one John mention. Later tonight
> though.
>
> --
> Dmitry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

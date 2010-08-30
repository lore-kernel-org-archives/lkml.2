Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab0H3KEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 06:04:48 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46173 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab0H3KEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 06:04:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=x++vz7qEgZom7qsHWUit5UXp1PZfF1jeTFQ8/eeIfSPdg9v+NT/sMuR3LXTfurJTNf
         Dh6giU73pc28fLSsZ2a379RhBikDGDzFrqQ3/zPErn3NaUNGsWSLqdovp27zYLhZzxWh
         6qCbOmynZVyCmdIIe6w7k7CpquHNpe8QSjvjo=
Date: Mon, 30 Aug 2010 13:04:39 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, Lin Ming <ming.m.lin@intel.com>,
        Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-pm@lists.linux-foundation.org,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: BUG: scheduling while atomic
Message-ID: <20100830100439.GA5252@swordfish.minsk.epam.com>
References: <20100827075911.GA5966@swordfish.minsk.epam.com>
 <201008272102.52041.rjw@sisk.pl>
 <20100828064254.GA2128@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <20100828064254.GA2128@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/28/10 08:42), Pavel Machek wrote:
> On Fri 2010-08-27 21:02:51, Rafael J. Wysocki wrote:
> > On Friday, August 27, 2010, Sergey Senozhatsky wrote:
> > > Hello,
> > >=20
> > > .36-rc2-git4
> >=20
> > Well, that looks like an ACPI battery driver issue.
> >=20
> > What was the last know good kernel?
>=20
> Also you might want to see if unloading battery driver before hibernation
> allows you do proceed...
> 									Pavel


# lsmod | grep battery
battery                 6278  0=20
# modprobe -r battery
# s2disk=20

[   67.230820] snapshot_ioctl: ioctl '80083307' is deprecated and will be r=
emoved soon, update your suspend-to-disk utilities
[   67.230832] Syncing filesystems ... 0x0/0x28
[   68.819307]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.819310]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.819313]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.819315]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.819318]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.21ff610ify68.]  fffff80e9] _ix5.8  ffe0_t0xe
Aug 30 12:59:11 swordfish 8.  ff02] rethee/ [<fstp438] BUG68.8190:  (0x547
[[<fff49]  #2u_hotsnd_seqevice  snd_miouse snd_hda_intel snd_hda_codec snd_=
pcm serio_raw evdev snd_timer snd_page_alloc snd soundcore ehci_hcd sr_mod =
usbcore cdrom sd_mod ahci libahci [last unloaded: battery]
[   68.819474] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.819476] Call Trace:
[   68.819478]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.819481]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.819484]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.819486]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.819490]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.819492]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.819495]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.819498]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.819501]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.819503]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.819506]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.819508]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.819511]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.819514]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.819517]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.819620] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.819622] 3 locks held by s2disk/5135:
[   68.819623]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.819627]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.819631]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.819636] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.819656] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.819658] Call Trace:
[   68.819660]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.819663]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.819666]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.819669]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.819672]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.819675]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.819677]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.819680]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.819683]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.819685]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.819688]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.819691]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.819694]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.819696]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.819699]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.819802] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.819804] 3 locks held by s2disk/5135:
[   68.819805]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.819810]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.819814]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.819818] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.819839] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.819840] Call Trace:
[   68.819843]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.819846]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.819849]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.819851]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.819855]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.819857]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.819860]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.819862]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.819865]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.819868]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.819871]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.819873]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.819876]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.819879]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.819882]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.819985] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.819986] 3 locks held by s2disk/5135:
[   68.819988]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.819992]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.819996]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.820000] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.820021] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.820023] Call Trace:
[   68.820025]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.820028]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.820031]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.820033]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.820037]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.820039]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.820042]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.820045]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.820048]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.820050]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.820053]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.820055]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.820058]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.820061]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.820064]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.820167] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.820169] 3 locks held by s2disk/5135:
[   68.820170]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.820174]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.820178]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.820183] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.820203] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.820205] Call Trace:
[   68.820207]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.820210]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.820213]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.820216]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.820219]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.820222]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.820224]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.820227]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.820230]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.820232]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.820235]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.820238]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.820241]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.820243]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.820246]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.820349] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.820351] 3 locks held by s2disk/5135:
[   68.820352]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.820357]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.820361]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.820365] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.820386] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.820387] Call Trace:
[   68.820390]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.820392]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.820396]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.820398]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.820401]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.820404]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.820407]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.820409]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.820412]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.820415]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.820418]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.820420]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.820423]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.820426]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.820429]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.820532] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.820533] 3 locks held by s2disk/5135:
[   68.820535]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.820539]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.820543]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.820547] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.820568] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.820570] Call Trace:
[   68.820572]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.820575]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.820578]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.820580]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.820584]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.820586]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.820589]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.820592]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.820595]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.820597]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.820600]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.820602]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.820605]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.820608]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.820611]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.820714] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.820716] 3 locks held by s2disk/5135:
[   68.820717]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.820721]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.820725]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.820730] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.820750] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.820752] Call Trace:
[   68.820754]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.820757]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.820760]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.820763]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.820766]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.820769]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.820771]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.820774]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.820777]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.820779]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.820782]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.820785]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.820788]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.820790]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.820793]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.820896] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.820898] 3 locks held by s2disk/5135:
[   68.820899]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.820904]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.820908]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.820912] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.820933] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.820934] Call Trace:
[   68.820937]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.820940]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.820943]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.820945]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.820949]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.820951]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.820954]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.820956]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.820959]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.820962]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.820965]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.820967]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.820970]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.820973]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.820976]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.821079] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.821080] 3 locks held by s2disk/5135:
[   68.821082]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.821086]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.821090]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.821094] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.821115] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.821117] Call Trace:
[   68.821119]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.821122]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.821125]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.821127]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.821131]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.821133]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.821136]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.821139]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.821142]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.821144]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.821147]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.821149]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.821152]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.821155]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.821158]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.821261] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.821263] 3 locks held by s2disk/5135:
[   68.821264]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.821268]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.821272]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.821277] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.821297] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.821299] Call Trace:
[   68.821301]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.821304]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.821307]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.821310]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.821313]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.821316]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.821318]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.821321]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.821324]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.821326]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.821329]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.821332]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.821335]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.821337]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.821340]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.821443] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.821445] 3 locks held by s2disk/5135:
[   68.821446]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.821451]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.821455]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.821459] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.821480] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.821481] Call Trace:
[   68.821484]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.821487]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.821490]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.821492]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.821496]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.821498]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.821501]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.821503]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.821506]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.821509]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.821512]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.821514]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.821517]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.821520]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.821523]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.821626] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.821627] 3 locks held by s2disk/5135:
[   68.821629]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.821633]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.821637]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.821641] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.821662] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.821664] Call Trace:
[   68.821666]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.821669]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.821672]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.821674]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.821678]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.821680]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.821683]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.821686]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.821689]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.821691]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.821694]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.821696]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.821699]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.821702]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.821705]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.821808] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.821810] 3 locks held by s2disk/5135:
[   68.821811]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.821815]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.821820]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.821824] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.821844] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.821846] Call Trace:
[   68.821848]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.821851]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.821854]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.821857]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.821860]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.821863]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.821865]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.821868]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.821871]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.821874]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.821876]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.821879]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.821882]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.821884]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.821887]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.821990] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.821992] 3 locks held by s2disk/5135:
[   68.821993]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.821998]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.822002]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.822006] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.822033] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.822035] Call Trace:
[   68.822037]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.822040]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.822043]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.822046]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.822049]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.822052]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.822054]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.822057]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.822060]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.822063]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.822065]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.822068]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.822071]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.822074]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.822076]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.822180] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.822181] 3 locks held by s2disk/5135:
[   68.822183]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.822187]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.822191]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.822195] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.822216] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.822218] Call Trace:
[   68.822220]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.822223]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.822226]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.822228]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.822232]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.822234]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.822237]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.822240]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.822243]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.822245]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.822248]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.822251]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.822253]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.822256]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.822259]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.822362] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.822364] 3 locks held by s2disk/5135:
[   68.822365]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.822369]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.822374]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.822378] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.822398] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.822400] Call Trace:
[   68.822402]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.822405]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.822408]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.822411]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.822414]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.822417]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.822419]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.822422]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.822425]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.822428]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.822430]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.822433]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.822436]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.822439]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.822441]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.822544] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.822546] 3 locks held by s2disk/5135:
[   68.822547]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.822552]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.822556]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.822560] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.822581] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.822582] Call Trace:
[   68.822585]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.822588]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.822591]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.822593]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.822597]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.822599]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.822602]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.822605]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.822607]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.822610]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.822613]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.822615]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.822618]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.822621]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.822624]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.822727] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.822729] 3 locks held by s2disk/5135:
[   68.822730]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.822734]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.822738]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.822742] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.822763] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.822765] Call Trace:
[   68.822767]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.822770]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.822773]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.822776]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.822779]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.822781]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.822784]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.822787]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.822790]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.822792]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.822795]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.822798]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.822800]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.822803]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.822806]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.822909] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.822911] 3 locks held by s2disk/5135:
[   68.822912]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.822916]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.822921]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.822925] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.822946] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.822947] Call Trace:
[   68.822950]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.822952]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.822955]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.822958]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.822961]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.822964]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.822966]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.822969]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.822972]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.822975]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.822977]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.822980]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.822983]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.822986]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.822989]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.823092] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.823093] 3 locks held by s2disk/5135:
[   68.823094]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.823099]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.823103]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.823107] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.823128] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.823129] Call Trace:
[   68.823132]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.823135]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.823138]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.823140]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.823144]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.823146]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.823149]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.823152]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.823155]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.823157]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.823160]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.823162]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.823165]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.823168]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.823171]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.823274] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.823276] 3 locks held by s2disk/5135:
[   68.823277]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.823281]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.823285]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.823289] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.823310] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.823312] Call Trace:
[   68.823314]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.823317]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.823320]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.823323]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.823326]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.823329]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.823331]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.823334]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.823337]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.823339]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.823342]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.823345]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.823348]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.823350]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.823353]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.823456] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.823458] 3 locks held by s2disk/5135:
[   68.823459]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.823463]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.823468]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.823472] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.823493] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.823494] Call Trace:
[   68.823497]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.823499]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.823503]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.823505]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.823508]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.823511]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.823514]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.823516]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.823519]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.823522]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.823525]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.823527]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.823530]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.823533]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.823536]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.823639] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.823640] 3 locks held by s2disk/5135:
[   68.823642]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.823646]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.823650]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.823654] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.823675] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.823677] Call Trace:
[   68.823679]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.823682]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.823685]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.823687]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.823691]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.823693]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.823696]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.823699]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.823702]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.823704]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.823707]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.823709]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.823712]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.823715]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.823718]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.823821] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.823823] 3 locks held by s2disk/5135:
[   68.823824]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.823828]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.823832]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.823837] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.823857] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.823859] Call Trace:
[   68.823861]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.823864]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.823867]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.823870]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.823873]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.823876]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.823878]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.823881]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.823884]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.823886]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.823889]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.823892]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.823895]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.823897]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.823900]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.824003] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.824005] 3 locks held by s2disk/5135:
[   68.824006]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.824011]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.824015]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.824019] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.824040] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.824041] Call Trace:
[   68.824044]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.824047]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.824050]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.824052]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.824056]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.824058]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.824061]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.824063]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.824066]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.824069]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.824072]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.824074]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.824077]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.824080]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.824083]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.824186] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.824187] 3 locks held by s2disk/5135:
[   68.824189]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.824193]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.824197]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.824201] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.824222] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.824224] Call Trace:
[   68.824226]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.824229]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.824232]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.824234]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.824238]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.824240]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.824243]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.824246]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.824249]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.824251]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.824254]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.824257]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.824259]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.824262]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.824265]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.824368] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.824370] 3 locks held by s2disk/5135:
[   68.824371]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.824375]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.824380]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.824384] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.824404] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.824406] Call Trace:
[   68.824409]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.824411]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.824414]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.824417]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.824420]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.824423]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.824425]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.824428]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.824431]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.824434]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.824436]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.824439]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.824442]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.824445]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.824447]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.824550] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.824552] 3 locks held by s2disk/5135:
[   68.824553]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.824558]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.824562]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.824566] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.824587] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.824588] Call Trace:
[   68.824591]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.824594]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.824597]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.824599]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.824603]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.824605]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.824608]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.824611]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.824613]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.824616]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.824619]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.824621]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.824624]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.824627]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.824630]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.824733] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.824735] 3 locks held by s2disk/5135:
[   68.824736]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.824740]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.824744]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.824748] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.824769] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.824771] Call Trace:
[   68.824773]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.824776]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.824779]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.824782]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.824785]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.824787]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.824790]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.824793]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.824796]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.824798]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.824801]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.824804]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.824806]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.824809]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.824812]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.824915] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.824917] 3 locks held by s2disk/5135:
[   68.824918]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.824922]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.824927]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.824931] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.824952] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.824953] Call Trace:
[   68.824956]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.824958]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.824961]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.824964]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.824967]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.824970]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.824973]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.824975]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.824978]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.824981]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.824983]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.824986]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.824989]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.824992]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.824995]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.825098] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.825099] 3 locks held by s2disk/5135:
[   68.825100]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.825105]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.825109]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.825113] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.825134] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.825135] Call Trace:
[   68.825138]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.825141]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.825144]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.825146]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.825150]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.825152]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.825155]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.825158]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.825161]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.825163]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.825166]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.825168]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.825171]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.825174]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.825177]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.825280] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.825282] 3 locks held by s2disk/5135:
[   68.825283]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.825287]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.825291]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.825295] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.825316] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.825318] Call Trace:
[   68.825320]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.825323]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.825326]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.825329]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.825332]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.825335]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.825337]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.825340]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.825343]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.825351]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.825354]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.825356]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.825359]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.825362]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.825365]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.825468] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.825470] 3 locks held by s2disk/5135:
[   68.825471]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.825475]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.825480]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.825484] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.825505] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.825506] Call Trace:
[   68.825509]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.825511]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.825515]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.825517]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.825520]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.825523]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.825526]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.825528]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.825531]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.825534]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.825537]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.825539]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.825542]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.825545]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.825548]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.825651] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.825652] 3 locks held by s2disk/5135:
[   68.825654]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.825658]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.825662]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.825666] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.825687] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.825689] Call Trace:
[   68.825691]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.825694]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.825697]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.825699]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.825703]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.825705]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.825708]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.825711]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.825714]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.825716]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.825719]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.825721]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.825724]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.825727]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.825730]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.825833] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.825835] 3 locks held by s2disk/5135:
[   68.825836]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.825840]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.825844]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.825849] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.825869] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.825871] Call Trace:
[   68.825873]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.825876]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.825879]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.825882]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.825885]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.825888]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.825890]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.825893]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.825896]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.825899]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.825901]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.825904]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.825907]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.825909]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.825912]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.826015] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.826017] 3 locks held by s2disk/5135:
[   68.826018]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.826023]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.826027]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.826031] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.826052] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.826053] Call Trace:
[   68.826056]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.826059]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.826062]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.826064]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.826068]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.826070]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.826073]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.826075]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.826078]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.826081]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.826084]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.826086]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.826089]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.826092]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.826095]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.826198] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.826199] 3 locks held by s2disk/5135:
[   68.826201]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.826205]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.826209]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.826213] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.826234] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.826236] Call Trace:
[   68.826238]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.826241]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.826244]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.826247]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.826250]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.826252]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.826255]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.826258]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.826261]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.826263]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.826266]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.826269]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.826271]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.826274]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.826277]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.826380] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.826382] 3 locks held by s2disk/5135:
[   68.826383]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.826387]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.826392]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.826396] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.826416] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.826418] Call Trace:
[   68.826421]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.826423]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.826426]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.826429]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.826432]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.826435]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.826437]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.826440]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.826443]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.826446]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.826448]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.826451]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.826454]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.826457]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.826459]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.826562] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.826564] 3 locks held by s2disk/5135:
[   68.826565]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.826570]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.826574]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.826578] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.826599] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.826601] Call Trace:
[   68.826603]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.826606]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.826609]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.826611]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.826615]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.826617]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.826620]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.826623]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.826626]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.826628]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.826631]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.826634]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.826636]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.826639]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.826642]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.826745] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.826747] 3 locks held by s2disk/5135:
[   68.826748]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.826752]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.826757]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.826761] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.826782] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.826783] Call Trace:
[   68.826786]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.826788]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.826792]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.826794]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.826797]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.826800]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.826803]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.826805]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.826808]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.826811]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.826814]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.826816]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.826819]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.826822]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.826825]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.826928] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.826929] 3 locks held by s2disk/5135:
[   68.826930]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.826935]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.826939]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.826943] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.826964] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.826965] Call Trace:
[   68.826968]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.826971]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.826974]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.826976]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.826980]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.826982]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.826985]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.826988]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.826991]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.826993]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.826996]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.826998]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.827001]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.827004]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.827007]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.827110] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.827112] 3 locks held by s2disk/5135:
[   68.827113]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.827117]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.827121]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.827126] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.827146] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.827148] Call Trace:
[   68.827150]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.827153]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.827156]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.827159]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.827162]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.827165]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.827167]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.827170]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.827173]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.827175]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.827178]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.827181]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.827184]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.827186]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.827189]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.827292] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.827294] 3 locks held by s2disk/5135:
[   68.827295]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.827299]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.827304]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.827308] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.827329] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.827330] Call Trace:
[   68.827333]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.827335]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.827338]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.827341]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.827344]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.827347]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.827350]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.827352]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.827355]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.827358]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.827361]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.827363]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.827366]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.827369]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.827372]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.827475] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.827476] 3 locks held by s2disk/5135:
[   68.827477]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.827482]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.827486]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.827490] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.827511] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.827512] Call Trace:
[   68.827515]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.827518]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.827521]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.827523]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.827527]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.827529]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.827532]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.827535]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.827538]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.827540]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.827543]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.827545]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.827548]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.827551]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.827554]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.827657] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.827659] 3 locks held by s2disk/5135:
[   68.827660]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.827664]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.827668]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.827672] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.827693] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.827695] Call Trace:
[   68.827697]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.827700]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.827703]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.827706]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.827709]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.827712]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.827714]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.827717]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.827720]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.827722]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.827725]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.827728]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.827731]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.827733]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.827736]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.827839] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.827841] 3 locks held by s2disk/5135:
[   68.827842]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.827846]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.827851]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.827855] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.827876] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.827877] Call Trace:
[   68.827880]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.827882]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.827885]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.827888]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.827891]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.827894]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.827897]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.827899]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.827902]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.827905]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.827908]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.827910]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.827913]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.827916]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.827919]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.828022] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.828023] 3 locks held by s2disk/5135:
[   68.828024]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.828029]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.828033]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.828037] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.828058] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.828060] Call Trace:
[   68.828062]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.828065]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.828068]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.828070]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.828074]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.828076]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.828079]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.828082]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.828085]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.828087]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.828090]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.828092]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.828095]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.828098]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.828101]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.828204] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.828206] 3 locks held by s2disk/5135:
[   68.828207]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.828211]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.828215]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.828220] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.828240] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.828242] Call Trace:
[   68.828244]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.828247]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.828250]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.828253]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.828256]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.828259]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.828261]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.828264]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.828267]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.828269]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.828272]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.828275]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.828278]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.828280]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.828283]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.828386] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.828388] 3 locks held by s2disk/5135:
[   68.828389]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.828394]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.828398]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.828402] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.828423] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.828424] Call Trace:
[   68.828427]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.828430]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.828433]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.828435]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.828439]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.828441]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.828444]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.828446]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.828449]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.828452]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.828455]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.828457]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.828460]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.828463]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.828466]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.828569] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.828570] 3 locks held by s2disk/5135:
[   68.828572]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.828576]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.828580]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.828584] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.828605] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.828607] Call Trace:
[   68.828609]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.828612]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.828615]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.828617]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.828621]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.828623]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.828626]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.828629]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.828632]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.828634]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.828637]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.828639]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.828642]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.828645]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.828648]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.828751] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.828753] 3 locks held by s2disk/5135:
[   68.828754]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.828759]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.828763]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.828768] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.828789] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.828791] Call Trace:
[   68.828793]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.828796]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.828799]  [<ffffffff813fa297>] do_boot_cpu+0x509/0x601
[   68.828802]  [<ffffffff813fa38f>] ? do_fork_idle+0x0/0x28
[   68.828806]  [<ffffffff813faa6f>] native_cpu_up+0xb4/0x129
[   68.828808]  [<ffffffff813fbe44>] _cpu_up+0x98/0xe9
[   68.828811]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.828814]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.828817]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.828819]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.828822]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.828825]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.828827]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.828830]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.828833]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.848861] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.848863] 4 locks held by s2disk/5135:
[   68.848864]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.848869]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.848874]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.848878]  #3:  (sched_domains_mutex){+.+.+.}, at: [<ffffffff81037c09>=
] partition_sched_domains+0x28/0x23f
[   68.848884] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.848905] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.848907] Call Trace:
[   68.848910]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.848913]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.848917]  [<ffffffff81065853>] ? __lock_acquire+0x181b/0x182d
[   68.848920]  [<ffffffff81401543>] schedule_timeout+0x38/0x220
[   68.848924]  [<ffffffff81063240>] ? mark_held_locks+0x50/0x72
[   68.848926]  [<ffffffff81403fce>] ? _raw_spin_unlock_irq+0x2b/0x59
[   68.848930]  [<ffffffff81400816>] wait_for_common+0xca/0x144
[   68.848933]  [<ffffffff81036a6e>] ? default_wake_function+0x0/0xf
[   68.848935]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
[   68.848938]  [<ffffffff8140092a>] wait_for_completion+0x18/0x1a
[   68.848943]  [<ffffffff81097be7>] synchronize_sched+0x64/0x7f
[   68.848948]  [<ffffffff810509a6>] ? wakeme_after_rcu+0x0/0x12
[   68.848951]  [<ffffffff8102d225>] rq_attach_root+0xaa/0xc5
[   68.848954]  [<ffffffff8102d848>] cpu_attach_domain+0x157/0x16e
[   68.848957]  [<ffffffff81037cbd>] partition_sched_domains+0xdc/0x23f
[   68.848962]  [<ffffffff8107ec76>] cpuset_update_active_cpus+0x61/0x68
[   68.848964]  [<ffffffff8102d2ff>] cpuset_cpu_active+0x19/0x24
[   68.848969]  [<ffffffff81057730>] notifier_call_chain+0x32/0x5e
[   68.848972]  [<ffffffff8105777b>] __raw_notifier_call_chain+0x9/0xb
[   68.848975]  [<ffffffff8103ca0b>] __cpu_notify+0x1b/0x2d
[   68.848977]  [<ffffffff8103ca2b>] cpu_notify+0xe/0x10
[   68.848979]  [<ffffffff813fbe6c>] _cpu_up+0xc0/0xe9
[   68.848982]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.848985]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.848988]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.848991]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.848994]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.848996]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.848999]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.849002]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.849005]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.861976] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.861980] 4 locks held by s2disk/5135:
[   68.861983]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.861993]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.862002]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.862010]  #3:  (sched_domains_mutex){+.+.+.}, at: [<ffffffff81037c09>=
] partition_sched_domains+0x28/0x23f
[   68.862020] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.862068] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.862069] Call Trace:
[   68.862072]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.862075]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.862078]  [<ffffffff81403fce>] ? _raw_spin_unlock_irq+0x2b/0x59
[   68.862081]  [<ffffffff81401543>] schedule_timeout+0x38/0x220
[   68.862084]  [<ffffffff81063240>] ? mark_held_locks+0x50/0x72
[   68.862086]  [<ffffffff81403fce>] ? _raw_spin_unlock_irq+0x2b/0x59
[   68.862089]  [<ffffffff81400816>] wait_for_common+0xca/0x144
[   68.862092]  [<ffffffff81036a6e>] ? default_wake_function+0x0/0xf
[   68.862095]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
[   68.862098]  [<ffffffff8140092a>] wait_for_completion+0x18/0x1a
[   68.862101]  [<ffffffff81097be7>] synchronize_sched+0x64/0x7f
[   68.862103]  [<ffffffff810509a6>] ? wakeme_after_rcu+0x0/0x12
[   68.862106]  [<ffffffff81037ce1>] partition_sched_domains+0x100/0x23f
[   68.862110]  [<ffffffff8107ec76>] cpuset_update_active_cpus+0x61/0x68
[   68.862112]  [<ffffffff8102d2ff>] cpuset_cpu_active+0x19/0x24
[   68.862115]  [<ffffffff81057730>] notifier_call_chain+0x32/0x5e
[   68.862118]  [<ffffffff8105777b>] __raw_notifier_call_chain+0x9/0xb
[   68.862120]  [<ffffffff8103ca0b>] __cpu_notify+0x1b/0x2d
[   68.862123]  [<ffffffff8103ca2b>] cpu_notify+0xe/0x10
[   68.862125]  [<ffffffff813fbe6c>] _cpu_up+0xc0/0xe9
[   68.862128]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.862131]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.862134]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.862136]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.862139]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.862142]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.862145]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.862147]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.862150]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.889629] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.889631] 3 locks held by s2disk/5135:
[   68.889632]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.889637]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.889642]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.889646] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.889668] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.889670] Call Trace:
[   68.889673]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.889676]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.889679]  [<ffffffff81063240>] ? mark_held_locks+0x50/0x72
[   68.889682]  [<ffffffff81053315>] ? prepare_to_wait+0x71/0x7c
[   68.889685]  [<ffffffff813fc663>] wait_trustee_state+0x87/0xaa
[   68.889688]  [<ffffffff810530d5>] ? autoremove_wake_function+0x0/0x34
[   68.889692]  [<ffffffff813f124a>] workqueue_cpu_callback+0x199/0x1f8
[   68.889695]  [<ffffffff81057730>] notifier_call_chain+0x32/0x5e
[   68.889698]  [<ffffffff8105777b>] __raw_notifier_call_chain+0x9/0xb
[   68.889700]  [<ffffffff8103ca0b>] __cpu_notify+0x1b/0x2d
[   68.889703]  [<ffffffff8103ca2b>] cpu_notify+0xe/0x10
[   68.889705]  [<ffffffff813fbe6c>] _cpu_up+0xc0/0xe9
[   68.889708]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.889711]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.889714]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.889716]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.889719]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.889722]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.889725]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.889728]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.889731]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.889932] NMI watchdog enabled, takes one hw-pmu counter.
[   68.889949] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.889952] 3 locks held by s2disk/5135:
[   68.889953]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.889960]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103cb48>=
] cpu_maps_update_begin+0x12/0x14
[   68.889965]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103caba>] c=
pu_hotplug_begin+0x27/0x4e
[   68.889971] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.889999] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.890000] Call Trace:
[   68.890003]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.890007]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.890010]  [<ffffffff81034a34>] ? select_idle_sibling+0x48/0xe9
[   68.890013]  [<ffffffff81401543>] schedule_timeout+0x38/0x220
[   68.890016]  [<ffffffff81063240>] ? mark_held_locks+0x50/0x72
[   68.890019]  [<ffffffff81403fce>] ? _raw_spin_unlock_irq+0x2b/0x59
[   68.890022]  [<ffffffff81400816>] wait_for_common+0xca/0x144
[   68.890025]  [<ffffffff81036a6e>] ? default_wake_function+0x0/0xf
[   68.890028]  [<ffffffff8140092a>] wait_for_completion+0x18/0x1a
[   68.890031]  [<ffffffff81052e1a>] kthread_create+0xab/0x155
[   68.890034]  [<ffffffff8106bdb4>] ? generic_exec_single+0x7a/0x89
[   68.890038]  [<ffffffff81093024>] ? watchdog+0x0/0xd2
[   68.890042]  [<ffffffff81092fb8>] watchdog_enable+0xe1/0x14d
[   68.890044]  [<ffffffff813fd1e6>] cpu_callback+0x71/0x8f
[   68.890047]  [<ffffffff81057730>] notifier_call_chain+0x32/0x5e
[   68.890050]  [<ffffffff8105777b>] __raw_notifier_call_chain+0x9/0xb
[   68.890053]  [<ffffffff8103ca0b>] __cpu_notify+0x1b/0x2d
[   68.890055]  [<ffffffff8103ca2b>] cpu_notify+0xe/0x10
[   68.890057]  [<ffffffff813fbe6c>] _cpu_up+0xc0/0xe9
[   68.890060]  [<ffffffff813ef108>] enable_nonboot_cpus+0x48/0xad
[   68.890063]  [<ffffffff81072116>] hibernation_snapshot+0x1ad/0x258
[   68.890066]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.890069]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.890072]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.890075]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.890078]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.890080]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.890083]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.890727] CPU3 is up
[   68.892352] ACPI: Waking up from system sleep state S4
[   68.915379] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1=
 (was 0x100006, writing 0x100002)
[   68.915847] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00403, writing 0x2b00407)
[   68.916131] HDA Intel 0000:01:00.1: restoring config space at offset 0x1=
 (was 0x100007, writing 0x100003)
[   68.916303] tg3 0000:02:00.0: restoring config space at offset 0x1 (was =
0x100006, writing 0x100406)
[   68.916710] PM: early restore of devices complete after 1.668 msecs
[   68.957702] PM: Thaw Swap
[   68.957881] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[   68.957967] usb usb1: root hub lost power or was reset
[   68.961871] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[   68.961906] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> =
IRQ 22
[   68.961918] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   68.961999] HDA Intel 0000:00:1b.0: irq 45 for MSI/MSI-X
[   68.962122] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.962126] 3 locks held by s2disk/5135:
[   68.962128]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.962140]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff8132=
2e7d>] device_resume+0x2b/0xe7
[   68.962161]  #2:  (&ec->lock){+.+.+.}, at: [<ffffffff81227937>] acpi_ec_=
transaction+0x86/0x235
[   68.962168] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.962202] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.962217] Call Trace:
[   68.962222]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.962230]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.962234]  [<ffffffff814016ec>] schedule_timeout+0x1e1/0x220
[   68.962241]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
[   68.962245]  [<ffffffff81227612>] acpi_ec_transaction_unlocked+0x14e/0x2=
19
[   68.962250]  [<ffffffff810530d5>] ? autoremove_wake_function+0x0/0x34
[   68.962253]  [<ffffffff81227a45>] acpi_ec_transaction+0x194/0x235
[   68.962257] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[   68.962261]  [<ffffffff8140403e>] ? _raw_spin_unlock_irqrestore+0x42/0x74
[   68.962275]  [<ffffffff81227b80>] acpi_ec_read+0x48/0x54
[   68.962279]  [<ffffffff81227ceb>] acpi_ec_space_handler+0x87/0xfe
[   68.962282]  [<ffffffff81227c64>] ? acpi_ec_space_handler+0x0/0xfe
[   68.962287]  [<ffffffff812317a2>] acpi_ev_address_space_dispatch+0x1d2/0=
x221
[   68.962291]  [<ffffffff81227c64>] ? acpi_ec_space_handler+0x0/0xfe
[   68.962296]  [<ffffffff812371db>] acpi_ex_access_region+0x28b/0x316
[   68.962300]  [<ffffffff81237549>] acpi_ex_field_datum_io+0xfa/0x2bd
[   68.962305]  [<ffffffff812227fe>] ? acpi_os_wait_semaphore+0xd5/0x13c
[   68.962309]  [<ffffffff8123779f>] acpi_ex_extract_from_field+0x93/0x1bb
[   68.962315]  [<ffffffff812358dc>] acpi_ex_read_data_from_field+0x1b8/0x1=
ed
[   68.962320]  [<ffffffff8122f525>] ? acpi_ds_create_operand+0x158/0x28d
[   68.962326]  [<ffffffff8123bfef>] acpi_ex_resolve_node_to_value+0x223/0x=
2b4
[   68.962331]  [<ffffffff81230bd1>] ? acpi_ds_obj_stack_push+0xae/0xb9
[   68.962336]  [<ffffffff812365c5>] acpi_ex_resolve_to_value+0x275/0x2ba
[   68.962341]  [<ffffffff8122f7eb>] acpi_ds_evaluate_name_path+0x7b/0xf8
[   68.962347]  [<ffffffff8124383a>] ? acpi_ps_get_next_namepath+0x73/0x24a
[   68.962351]  [<ffffffff8122d96b>] acpi_ds_exec_end_op+0x9b/0x578
[   68.962356]  [<ffffffff81244f5d>] acpi_ps_parse_loop+0x88a/0xa55
[   68.962362]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
[   68.962367]  [<ffffffff81244164>] acpi_ps_parse_aml+0x104/0x3c4
[   68.962372]  [<ffffffff812458fc>] acpi_ps_execute_method+0x20f/0x2f3
[   68.962379]  [<ffffffff8123f983>] acpi_ns_evaluate+0x18b/0x2d2
[   68.962381] usb usb2: root hub lost power or was reset
[   68.962385]  [<ffffffff8123f234>] acpi_evaluate_object+0x1b8/0x2fc
[   68.962390]  [<ffffffff81222e26>] acpi_evaluate_integer+0x3f/0xb7
[   68.962393]  [<ffffffff81402535>] ? mutex_lock_nested+0x2ae/0x30d
[   68.962397]  [<ffffffff812251bd>] ? acpi_device_resume+0x0/0x29
[   68.962402]  [<ffffffffa01cd051>] acpi_ac_get_state+0x36/0x6a [ac]
[   68.966258]  [<ffffffffa01cd17c>] acpi_ac_resume+0x35/0x63 [ac]
[   68.966276]  [<ffffffff812251e4>] acpi_device_resume+0x27/0x29
[   68.966279]  [<ffffffff81322e24>] legacy_resume+0x1f/0x4d
[   68.966283]  [<ffffffff81322eba>] device_resume+0x68/0xe7
[   68.966288]  [<ffffffff813238a9>] dpm_resume_end+0xff/0x384
[   68.966293]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
[   68.966297]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.966300] pci 0000:00:1e.0: setting latency timer to 64
[   68.966306]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.966312]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.966317]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.966324]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.966329]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.966333] ahci 0000:00:1f.2: setting latency timer to 64
[   68.966337]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.966401] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[   68.966525] sd 0:0:0:0: [sda] Starting disk
[   68.966534] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   68.966537] 2 locks held by s2disk/5135:
[   68.966538]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   68.966545]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff8132=
2e7d>] device_resume+0x2b/0xe7
[   68.966550] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   68.966580] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   68.966582] Call Trace:
[   68.966586]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   68.966591]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   68.966596]  [<ffffffff814016ec>] schedule_timeout+0x1e1/0x220
[   68.966600]  [<ffffffff81045db7>] ? process_timeout+0x0/0xb
[   68.966604]  [<ffffffff8140177a>] schedule_timeout_interruptible+0x19/0x=
1b
[   68.966609]  [<ffffffff8122226e>] acpi_os_sleep+0x11/0x13
[   68.966612]  [<ffffffff81239060>] acpi_ex_system_do_sleep+0x26/0x31
[   68.966616]  [<ffffffff81237ae8>] acpi_ex_opcode_1A_0T_0R+0x5b/0xa1
[   68.966620]  [<ffffffff8122d9c8>] acpi_ds_exec_end_op+0xf8/0x578
[   68.966624]  [<ffffffff81244f5d>] acpi_ps_parse_loop+0x88a/0xa55
[   68.966628]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
[   68.966632]  [<ffffffff81244164>] acpi_ps_parse_aml+0x104/0x3c4
[   68.966636]  [<ffffffff812458fc>] acpi_ps_execute_method+0x20f/0x2f3
[   68.966640]  [<ffffffff8123f983>] acpi_ns_evaluate+0x18b/0x2d2
[   68.966644]  [<ffffffff8123f234>] acpi_evaluate_object+0x1b8/0x2fc
[   68.966647]  [<ffffffff81222e26>] acpi_evaluate_integer+0x3f/0xb7
[   68.966651]  [<ffffffff81402535>] ? mutex_lock_nested+0x2ae/0x30d
[   68.966654]  [<ffffffff812251bd>] ? acpi_device_resume+0x0/0x29
[   68.966658]  [<ffffffffa01cd051>] acpi_ac_get_state+0x36/0x6a [ac]
[   68.966662]  [<ffffffffa01cd17c>] acpi_ac_resume+0x35/0x63 [ac]
[   68.966665]  [<ffffffff812251e4>] acpi_device_resume+0x27/0x29
[   68.966668]  [<ffffffff81322e24>] legacy_resume+0x1f/0x4d
[   68.966671]  [<ffffffff81322eba>] device_resume+0x68/0xe7
[   68.966675]  [<ffffffff813238a9>] dpm_resume_end+0xff/0x384
[   68.966679]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
[   68.966683]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   68.966687]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   68.966691] radeon 0000:01:00.0: power state changed by ACPI to D0
[   68.966695] pcieport 0000:00:1c.0: wake-up capability disabled by ACPI
[   68.966699]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   68.966702]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   68.966705]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   68.966707]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   68.966710]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   68.966736] tg3 0000:02:00.0: PME# disabled
[   68.966741] HDA Intel 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[   68.966750] HDA Intel 0000:01:00.1: setting latency timer to 64
[   68.966851] HDA Intel 0000:01:00.1: irq 46 for MSI/MSI-X
[   68.966953] radeon 0000:01:00.0: power state changed by ACPI to D0
[   68.966963] radeon 0000:01:00.0: setting latency timer to 64
[   68.969199] tg3 0000:02:00.0: eth0: Link is down
[   68.970829] [drm] Clocks initialized !
[   69.013476] [drm] ring test succeeded in 1 usecs
[   69.013525] [drm] ib test succeeded in 0 usecs
[   69.291305] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   69.294621] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   69.298717] ata1.00: configured for UDMA/133
[   69.304615] usb 1-1: reset high speed USB device using ehci_hcd and addr=
ess 2
[   69.326464] ata2.00: configured for UDMA/100
[   69.465158] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   69.465163] 1 lock held by s2disk/5135:
[   69.465166]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   69.465182] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   69.465229] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   69.465233] Call Trace:
[   69.465241]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   69.465251]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   69.465258]  [<ffffffff81401543>] schedule_timeout+0x38/0x220
[   69.465266]  [<ffffffff81063240>] ? mark_held_locks+0x50/0x72
[   69.465271]  [<ffffffff81403fce>] ? _raw_spin_unlock_irq+0x2b/0x59
[   69.465278]  [<ffffffff81400816>] wait_for_common+0xca/0x144
[   69.465286]  [<ffffffff81036a6e>] ? default_wake_function+0x0/0xf
[   69.465291]  [<ffffffff81063240>] ? mark_held_locks+0x50/0x72
[   69.465297]  [<ffffffff8140092a>] wait_for_completion+0x18/0x1a
[   69.465304]  [<ffffffff8132294b>] dpm_wait+0x2c/0x2e
[   69.465309]  [<ffffffff81322e73>] device_resume+0x21/0xe7
[   69.465315]  [<ffffffff813238a9>] dpm_resume_end+0xff/0x384
[   69.465322]  [<ffffffff81072178>] hibernation_snapshot+0x20f/0x258
[   69.465328]  [<ffffffff81075262>] snapshot_ioctl+0x25c/0x547
[   69.465336]  [<ffffffff8110610c>] ? fsnotify+0x69/0x22f
[   69.465343]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   69.465351]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   69.465360]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   69.465366]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   69.465372]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   69.534211] usb 2-1: reset high speed USB device using ehci_hcd and addr=
ess 2
[   69.723995] usb 1-1.1: reset high speed USB device using ehci_hcd and ad=
dress 3
[   70.123272] usb 2-1.1: reset low speed USB device using ehci_hcd and add=
ress 3
[   70.985873] PM: restore of devices complete after 2031.799 msecs
[   70.989029] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   70.989034] no locks held by s2disk/5135.
[   70.989038] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   70.989104] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   70.989109] Call Trace:
[   70.989117]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   70.989126]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   70.989134]  [<ffffffff814035c2>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   70.989143]  [<ffffffff8100208e>] sysret_careful+0x19/0x1f
[   70.989435] BUG: scheduling while atomic: s2disk/5135/0x10000002
[   70.989440] 2 locks held by s2disk/5135:
[   70.989443]  #0:  (&tty->atomic_write_lock){+.+.+.}, at: [<ffffffff8125b=
3ee>] tty_write_lock+0x19/0x46
[   70.989453]  #1:  (&tty->output_lock){+.+...}, at: [<ffffffff8125d8f5>] =
process_output+0x24/0x51
[   70.989461] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   70.989500] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   70.989504] Call Trace:
[   70.989510]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   70.989516]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   70.989523]  [<ffffffff810363d7>] __cond_resched+0x13/0x1f
[   70.989529]  [<ffffffff8140133d>] _cond_resched+0x29/0x30
[   70.989534]  [<ffffffff81401509>] console_conditional_schedule+0x12/0x14
[   70.989542]  [<ffffffff8126eed0>] do_con_write+0x1ecd/0x1f0d
[   70.989549]  [<ffffffff81402585>] ? mutex_lock_nested+0x2fe/0x30d
[   70.989555]  [<ffffffff8125d8f5>] ? process_output+0x24/0x51
[   70.989560]  [<ffffffff8126ef57>] con_write+0x11/0x26
[   70.989565]  [<ffffffff8125d7ad>] do_output_char+0x92/0x1b6
[   70.989570]  [<ffffffff8125d90b>] process_output+0x3a/0x51
[   70.989576]  [<ffffffff8125e327>] n_tty_write+0x27b/0x35e
[   70.989582]  [<ffffffff81036a6e>] ? default_wake_function+0x0/0xf
[   70.989587]  [<ffffffff8125b5cd>] tty_write+0x1b2/0x23e
[   70.989592]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   70.989600]  [<ffffffff810dbb9e>] vfs_write+0xb0/0x14f
[   70.989606]  [<ffffffff810dbe3a>] sys_write+0x45/0x6c
[   70.989612]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   70.989662] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   70.989666] 2 locks held by s2disk/5135:
[   70.989668]  #0:  (&tty->atomic_write_lock){+.+.+.}, at: [<ffffffff8125b=
3ee>] tty_write_lock+0x19/0x46
[   70.989677]  #1:  (&tty->output_lock){+.+...}, at: [<ffffffff8125d8f5>] =
process_output+0x24/0x51
[   70.989685] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   70.989724] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   70.989727] Call Trace:
[   70.989733]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   70.989739]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   70.989746]  [<ffffffff81401543>] schedule_timeout+0x38/0x220
[   70.989752]  [<ffffffff81063240>] ? mark_held_locks+0x50/0x72
[   70.989757]  [<ffffffff81403fce>] ? _raw_spin_unlock_irq+0x2b/0x59
[   70.989764]  [<ffffffff81402c7c>] __down+0x68/0x95
[   70.989770]  [<ffffffff8105764c>] ? down+0xf/0x38
[   70.989775]  [<ffffffff81057665>] down+0x28/0x38
[   70.989782]  [<ffffffff8103b775>] acquire_console_sem+0x29/0x48
[   70.989788]  [<ffffffff8126a119>] con_flush_chars+0x28/0x43
[   70.989793]  [<ffffffff8126ef62>] con_write+0x1c/0x26
[   70.989798]  [<ffffffff8125d7ad>] do_output_char+0x92/0x1b6
[   70.989803]  [<ffffffff8125d90b>] process_output+0x3a/0x51
[   70.989808]  [<ffffffff8125e327>] n_tty_write+0x27b/0x35e
[   70.989815]  [<ffffffff81036a6e>] ? default_wake_function+0x0/0xf
[   70.989820]  [<ffffffff8125b5cd>] tty_write+0x1b2/0x23e
[   70.989825]  [<ffffffff8125e0ac>] ? n_tty_write+0x0/0x35e
[   70.989831]  [<ffffffff810dbb9e>] vfs_write+0xb0/0x14f
[   70.989836]  [<ffffffff810dbe3a>] sys_write+0x45/0x6c
[   70.989842]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   71.006597] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   71.006599] no locks held by s2disk/5135.
[   71.006601] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   71.006632] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   71.006634] Call Trace:
[   71.006638]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   71.006642]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   71.006645]  [<ffffffff814035c2>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   71.006649]  [<ffffffff8100208e>] sysret_careful+0x19/0x1f
[   71.006666] Restarting tasks ...=20
[   71.007159] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   71.007164] 1 lock held by s2disk/5135:
[   71.007168]  #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8107505f>] snapshot_=
ioctl+0x59/0x547
[   71.007184] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   71.007269] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   71.007274] Call Trace:
[   71.007281]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   71.007289]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   71.007296]  [<ffffffff81036a5c>] ? try_to_wake_up+0x327/0x339
[   71.007305]  [<ffffffff810717a1>] thaw_processes+0x34/0x47
[   71.007312]  [<ffffffff8107521a>] snapshot_ioctl+0x214/0x547
[   71.007320]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[   71.007327]  [<ffffffff814011cf>] ? schedule+0x8a3/0x8f2
[   71.007334]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   71.007341]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[   71.007348]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[   71.007945] done.
[   71.008066] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   71.008071] no locks held by s2disk/5135.
[   71.008074] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   71.008168] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   71.008173] Call Trace:
[   71.008181]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   71.008190]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   71.008198]  [<ffffffff810ec10c>] ? dput+0x24/0x159
[   71.008206]  [<ffffffff814035c2>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   71.008214]  [<ffffffff8100208e>] sysret_careful+0x19/0x1f
[   71.029794] PM: Basic memory bitmaps freed
[   71.029802] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   71.029805] no locks held by s2disk/5135.
[   71.029807] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   71.029843] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   71.029845] Call Trace:
[   71.029853]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   71.029860]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   71.029865]  [<ffffffff810ec10c>] ? dput+0x24/0x159
[   71.029869]  [<ffffffff814035c2>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   71.029875]  [<ffffffff8100208e>] sysret_careful+0x19/0x1f
[   71.030299] note: s2disk[5135] exited with preempt_count 1
[   71.034441] BUG: scheduling while atomic: s2disk/5135/0x00000002
[   71.034445] no locks held by s2disk/5135.
[   71.034447] Modules linked in: snd_seq_dummy ac snd_seq_oss snd_seq_midi=
_event snd_seq snd_seq_device wmi snd_hwdep snd_hda_codec_atihdmi button sn=
d_pcm_oss snd_mixer_oss snd_hda_codec_realtek broadcom usbhid tg3 hid libph=
y psmouse
snd_hda_intel snd_hda_codec snd_pcm serio_raw evdev snd_timer snd_page_allo=
c snd soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci libahci [last unl=
oaded: battery]
[   71.034496] Pid: 5135, comm: s2disk Not tainted 2.6.36-rc3-dbg-00144-gb9=
58348-dirty #146
[   71.034499] Call Trace:
[   71.034506]  [<ffffffff8102e03d>] __schedule_bug+0x72/0x77
[   71.034512]  [<ffffffff81400a08>] schedule+0xdc/0x8f2
[   71.034518]  [<ffffffff81401543>] schedule_timeout+0x38/0x220
[   71.034523]  [<ffffffff81400772>] ? wait_for_common+0x26/0x144
[   71.034530]  [<ffffffff811f7aab>] ? do_raw_spin_lock+0x6b/0x122
[   71.034536]  [<ffffffff81403fce>] ? _raw_spin_unlock_irq+0x2b/0x59
[   71.034542]  [<ffffffff81400816>] wait_for_common+0xca/0x144
[   71.034548]  [<ffffffff81036a6e>] ? default_wake_function+0x0/0xf
[   71.034555]  [<ffffffff810633e5>] ? trace_hardirqs_on+0xd/0xf
[   71.034561]  [<ffffffff8140092a>] wait_for_completion+0x18/0x1a
[   71.034567]  [<ffffffff8104efc2>] flush_workqueue+0x1c5/0x3d9
[   71.034571]  [<ffffffff8104edfd>] ? flush_workqueue+0x0/0x3d9
[   71.034577]  [<ffffffff8104ecef>] ? __cancel_work_timer+0xbf/0x1b1
[   71.034583]  [<ffffffff8104f358>] flush_scheduled_work+0x10/0x12
[   71.034591]  [<ffffffff81261cec>] tty_ldisc_release+0x29/0x87
[   71.034596]  [<ffffffff8125c3e8>] tty_release+0x4ce/0x51e
[   71.034604]  [<ffffffff810dd1e4>] fput+0xff/0x1c3
[   71.034610]  [<ffffffff810da165>] filp_close+0x56/0x60
[   71.034617]  [<ffffffff8103e40d>] put_files_struct+0xb5/0x151
[   71.034621]  [<ffffffff8103e37a>] ? put_files_struct+0x22/0x151
[   71.034627]  [<ffffffff811f7c25>] ? do_raw_spin_unlock+0x8f/0x98
[   71.034632]  [<ffffffff8103e53c>] exit_files+0x46/0x4f
[   71.034636]  [<ffffffff8103e761>] do_exit+0x21c/0x6c4
[   71.034642]  [<ffffffff8100203a>] ? sysret_check+0x2e/0x69
[   71.034647]  [<ffffffff8103ee94>] do_group_exit+0x77/0xa2
[   71.034652]  [<ffffffff8103eed1>] sys_exit_group+0x12/0x16
[   71.034657]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b



	Sergey
--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkx7gjcACgkQfKHnntdSXjTmNQP+LeCK0ngZjZqOM4hWlS2SwuKb
daQl7biQNAzTJ7bc2FDbJaetceiSaYEiahzsVrfD13vp2HtkB5N/f0pD3q5zXk5K
4zM4aUwDOQMQDaVmQPMj8Li7rXsIY03eVocgH0Ss+k2OUyYOfHwX/RZR8LdD+mEd
DOGvaWcr0DpaUELMzzc=
=1yiu
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--

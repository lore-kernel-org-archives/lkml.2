Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab1CVL1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 07:27:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47858 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab1CVL1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 07:27:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=OXrD1cTAJcanfV6p03RLq8+eTDSOlLQQQ+qDBxb6uV/NLdE/cPoilc3njppGJ5vJjp
         dhKAg6umSX7P7eEuPfUhi24+yN+BkYz1fHJOX7GCiABVszeyND58+37PpY5S1SVjtx3w
         GOHaBsj8Tz4aqiba9S+COldW5zjvMUxAqygmE=
MIME-Version: 1.0
Date: Tue, 22 Mar 2011 12:27:31 +0100
Message-ID: <AANLkTim3gpBUtDQ=WnLRjzuwpNe=+m4wLK=maS1tLc8U@mail.gmail.com>
Subject: Machine Check Exception and cpufreq
From: Giorgio <mywing81@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux@brodo.de, dougthompson@xmission.com, mchehab@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have recently noticed the following problem on my machine. When I
run something like "find dir/ -type f -exec md5sum {} \;" where dir/
contains several Gb of data, 90% of the time I get a "Machine Check
Exception" and a kernel panic. These are the logs that I have been
able to capture using netconsole:

#1:
[ 2586.090191]
[ 2586.090194] HARDWARE ERROR
[ 2586.090210] CPU 0: Machine Check Exception:                4 Bank
4: b200001000010c0f
[ 2586.090214] TSC 4657e129df5
[ 2586.090221] PROCESSOR 2:20fc2 TIME 1273577579 SOCKET 0 APIC 0
[ 2586.090225] MC4_STATUS: Uncorrected error, report: yes, MiscV:
invalid, CPU context corrupt: yes
[ 2586.090236]  Northbridge Error, node 0
[ 2586.090241] K8 ECC error.
[ 2586.090246]  Transaction type: generic(generic), no timeout, Cache
Level: L3/generic, Participating Processor: local node observed as 3rd
party (OBS)
[ 2586.090251] This is not a software problem!
[ 2586.090254] Machine check: Processor context corrupt
[ 2586.090259] Kernel panic - not syncing: Fatal machine check on current CPU
[ 2586.090265] Pid: 48, comm: kondemand/0 Tainted: P   M
2.6.32-22-generic #33-Ubuntu
[ 2586.090269] Call Trace:
[ 2586.090274]  <#MC>  [<ffffffff8153e010>] panic+0x78/0x137
[ 2586.090290]  [<ffffffff81024442>] mce_panic+0x1e2/0x210
[ 2586.090297]  [<ffffffff81025803>] do_machine_check+0x7d3/0x820
[ 2586.090304]  [<ffffffff815411bc>] machine_check+0x1c/0x30
[ 2586.090311]  [<ffffffff81038be0>] ? native_read_msr_safe+0x10/0x30
[ 2586.090315]  <<EOE>>  [<ffffffff8102999a>]
query_current_values_with_pending_wait+0x5a/0xe0
[ 2586.090327]  [<ffffffff8102a08a>] write_new_fid+0x7a/0x110
[ 2586.090333]  [<ffffffff8102a20b>] core_frequency_transition+0xeb/0x180
[ 2586.090338]  [<ffffffff8102a39a>] transition_fid_vid+0xfa/0x220
[ 2586.090343]  [<ffffffff8102a5be>] transition_frequency_fidvid+0xbe/0x140
[ 2586.090349]  [<ffffffff8102a81e>] powernowk8_target+0x1de/0x390
[ 2586.090407]  [<ffffffff8143194a>] __cpufreq_driver_target+0x3a/0x40
[ 2586.090413]  [<ffffffff81435bcb>] dbs_check_cpu+0x23b/0x240
[ 2586.090418]  [<ffffffff81435ca8>] do_dbs_timer+0xd8/0x100
[ 2586.090424]  [<ffffffff81435bd0>] ? do_dbs_timer+0x0/0x100
[ 2586.090430]  [<ffffffff81080777>] run_workqueue+0xc7/0x1a0
[ 2586.090436]  [<ffffffff810808f3>] worker_thread+0xa3/0x110
[ 2586.090442]  [<ffffffff81085320>] ? autoremove_wake_function+0x0/0x40
[ 2586.090448]  [<ffffffff81080850>] ? worker_thread+0x0/0x110
[ 2586.090453]  [<ffffffff81084fa6>] kthread+0x96/0xa0
[ 2586.090459]  [<ffffffff810141ea>] child_rip+0xa/0x20
[ 2586.090464]  [<ffffffff81084f10>] ? kthread+0x0/0xa0
[ 2586.090469]  [<ffffffff810141e0>] ? child_rip+0x0/0x20

#2:
[  164.450063]
[  164.450066] HARDWARE ERROR
[  164.450084] CPU 0: Machine Check Exception:                4 Bank
4: b200001000010c0f
[  164.450089] TSC 46facd28a1
[  164.450096] PROCESSOR 2:20fc2 TIME 1273577896 SOCKET 0 APIC 0
[  164.450111] Machine check: Processor context corrupt
[  164.450116] Kernel panic - not syncing: Fatal machine check on current CPU
[  164.450122] Pid: 48, comm: kondemand/0 Tainted: P   M
2.6.32-22-generic #33-Ubuntu
[  164.450127] Call Trace:
[  164.450131]  <#MC>  [<ffffffff8153e010>] panic+0x78/0x137
[  164.450148]  [<ffffffff81024442>] mce_panic+0x1e2/0x210
[  164.450155]  [<ffffffff81025803>] do_machine_check+0x7d3/0x820
[  164.450161]  [<ffffffff815411bc>] machine_check+0x1c/0x30
[  164.450168]  [<ffffffff81038be0>] ? native_read_msr_safe+0x10/0x30
[  164.450173]  <<EOE>>  [<ffffffff8102999a>]
query_current_values_with_pending_wait+0x5a/0xe0
[  164.450185]  [<ffffffff8102a08a>] write_new_fid+0x7a/0x110
[  164.450190]  [<ffffffff8102a20b>] core_frequency_transition+0xeb/0x180
[  164.450195]  [<ffffffff8102a39a>] transition_fid_vid+0xfa/0x220
[  164.450201]  [<ffffffff8102a5be>] transition_frequency_fidvid+0xbe/0x140
[  164.450207]  [<ffffffff8102a81e>] powernowk8_target+0x1de/0x390
[  164.450213]  [<ffffffff8143194a>] __cpufreq_driver_target+0x3a/0x40
[  164.450218]  [<ffffffff81435bcb>] dbs_check_cpu+0x23b/0x240
[  164.450224]  [<ffffffff81435ca8>] do_dbs_timer+0xd8/0x100
[  164.450229]  [<ffffffff81435bd0>] ? do_dbs_timer+0x0/0x100
[  164.450236]  [<ffffffff81080777>] run_workqueue+0xc7/0x1a0
[  164.450295]  [<ffffffff810808f3>] worker_thread+0xa3/0x110
[  164.450301]  [<ffffffff81085320>] ? autoremove_wake_function+0x0/0x40
[  164.450307]  [<ffffffff81080850>] ? worker_thread+0x0/0x110
[  164.450312]  [<ffffffff81084fa6>] kthread+0x96/0xa0
[  164.450318]  [<ffffffff810141ea>] child_rip+0xa/0x20
[  164.450323]  [<ffffffff81084f10>] ? kthread+0x0/0xa0
[  164.450328]  [<ffffffff810141e0>] ? child_rip+0x0/0x20

#3:
[ 2648.130092]
[ 2648.130094] HARDWARE ERROR
[ 2648.130108] CPU 0: Machine Check Exception:                4 Bank
4: b200001000010c0f
[ 2648.130112] TSC 2c7efc1f682
[ 2648.130118] PROCESSOR 2:20fc2 TIME 1273581313 SOCKET 0 APIC 0
[ 2648.130122] No human readable MCE decoding support on this CPU type.
[ 2648.130125] Run the message through 'mcelog --ascii' to decode.
[ 2648.130128] This is not a software problem!
[ 2648.130132] Machine check: Processor context corrupt
[ 2648.130135] Kernel panic - not syncing: Fatal machine check on current CPU
[ 2648.130141] Pid: 48, comm: kondemand/0 Tainted: P   M
2.6.32-22-generic #33-Ubuntu
[ 2648.130145] Call Trace:
[ 2648.130149]  <#MC>  [<ffffffff8153e010>] panic+0x78/0x137
[ 2648.130164]  [<ffffffff81024442>] mce_panic+0x1e2/0x210
[ 2648.130170]  [<ffffffff81025803>] do_machine_check+0x7d3/0x820
[ 2648.130176]  [<ffffffff815411bc>] machine_check+0x1c/0x30
[ 2648.130183]  [<ffffffff81038be0>] ? native_read_msr_safe+0x10/0x30
[ 2648.130187]  <<EOE>>  [<ffffffff8102999a>]
query_current_values_with_pending_wait+0x5a/0xe0
[ 2648.130198]  [<ffffffff8102a08a>] write_new_fid+0x7a/0x110
[ 2648.130203]  [<ffffffff8102a20b>] core_frequency_transition+0xeb/0x180
[ 2648.130207]  [<ffffffff8102a39a>] transition_fid_vid+0xfa/0x220
[ 2648.130212]  [<ffffffff8102a5be>] transition_frequency_fidvid+0xbe/0x140
[ 2648.130217]  [<ffffffff8102a81e>] powernowk8_target+0x1de/0x390
[ 2648.130222]  [<ffffffff8143194a>] __cpufreq_driver_target+0x3a/0x40
[ 2648.130227]  [<ffffffff81435bcb>] dbs_check_cpu+0x23b/0x240
[ 2648.130232]  [<ffffffff81435ca8>] do_dbs_timer+0xd8/0x100
[ 2648.130237]  [<ffffffff81435bd0>] ? do_dbs_timer+0x0/0x100
[ 2648.130243]  [<ffffffff81080777>] run_workqueue+0xc7/0x1a0
[ 2648.130300]  [<ffffffff810808f3>] worker_thread+0xa3/0x110
[ 2648.130306]  [<ffffffff81085320>] ? autoremove_wake_function+0x0/0x40
[ 2648.130311]  [<ffffffff81080850>] ? worker_thread+0x0/0x110
[ 2648.130316]  [<ffffffff81084fa6>] kthread+0x96/0xa0
[ 2648.130321]  [<ffffffff810141ea>] child_rip+0xa/0x20
[ 2648.130326]  [<ffffffff81084f10>] ? kthread+0x0/0xa0
[ 2648.130330]  [<ffffffff810141e0>] ? child_rip+0x0/0x20

#4:
[ 2400.960058]
[ 2400.960060] HARDWARE ERROR
[ 2400.960075] CPU 0: Machine Check Exception:                4 Bank
4: b200001000010c0f
[ 2400.960080] TSC 2f6101e77d4
[ 2400.960086] PROCESSOR 2:20fc2 TIME 1300705797 SOCKET 0 APIC 0
[ 2400.960090] MC4_STATUS: Uncorrected error, report: yes, MiscV:
invalid, CPU context corrupt: yes
[ 2400.960100]  Northbridge Error, node 0
[ 2400.960105] CRC error on link.
[ 2400.960110]  Transaction type: generic(generic), no timeout, Cache
Level: L3/generic, Participating Processor: local node observed as 3rd
party (OBS)
[ 2400.960115] This is not a software problem!
[ 2400.960118] Machine check: Processor context corrupt
[ 2400.960122] Kernel panic - not syncing: Fatal machine check on current CPU
[ 2400.960128] Pid: 48, comm: kondemand/0 Tainted: P   M
2.6.32-30-generic #59-Ubuntu
[ 2400.960132] Call Trace:
[ 2400.960136]  <#MC>  [<ffffffff81542b3d>] panic+0x78/0x139
[ 2400.960152]  [<ffffffff810235a2>] mce_panic+0x1e2/0x210
[ 2400.960159]  [<ffffffff81024963>] do_machine_check+0x7d3/0x820
[ 2400.960166]  [<ffffffff81545e9c>] machine_check+0x1c/0x30
[ 2400.960172]  [<ffffffff81037bf0>] ? native_read_msr_safe+0x10/0x30
[ 2400.960176]  <<EOE>>  [<ffffffff81028afa>]
query_current_values_with_pending_wait+0x5a/0xe0
[ 2400.960186]  [<ffffffff810291ea>] write_new_fid+0x7a/0x110
[ 2400.960191]  [<ffffffff8102936b>] core_frequency_transition+0xeb/0x180
[ 2400.960196]  [<ffffffff810294fa>] transition_fid_vid+0xfa/0x220
[ 2400.960202]  [<ffffffff8102971e>] transition_frequency_fidvid+0xbe/0x140
[ 2400.960207]  [<ffffffff8102997e>] powernowk8_target+0x1de/0x390
[ 2400.960265]  [<ffffffff814359aa>] __cpufreq_driver_target+0x3a/0x40
[ 2400.960271]  [<ffffffff81439c0b>] dbs_check_cpu+0x23b/0x240
[ 2400.960276]  [<ffffffff81439ce8>] do_dbs_timer+0xd8/0x100
[ 2400.960282]  [<ffffffff81439c10>] ? do_dbs_timer+0x0/0x100
[ 2400.960288]  [<ffffffff8107ffa7>] run_workqueue+0xc7/0x1a0
[ 2400.960294]  [<ffffffff81080123>] worker_thread+0xa3/0x110
[ 2400.960300]  [<ffffffff81084b70>] ? autoremove_wake_function+0x0/0x40
[ 2400.960306]  [<ffffffff81080080>] ? worker_thread+0x0/0x110
[ 2400.960311]  [<ffffffff810847f6>] kthread+0x96/0xa0
[ 2400.960316]  [<ffffffff810131ea>] child_rip+0xa/0x20
[ 2400.960322]  [<ffffffff81084760>] ? kthread+0x0/0xa0
[ 2400.960326]  [<ffffffff810131e0>] ? child_rip+0x0/0x20

#5:
[ 1304.370062]
[ 1304.370066] HARDWARE ERROR
[ 1304.370084] CPU 0: Machine Check Exception:                4 Bank
4: b200001000010c0f
[ 1304.370089] TSC 1b3320f8368
[ 1304.370096] PROCESSOR 2:20fc2 TIME 1300708657 SOCKET 0 APIC 0
[ 1304.370100] MC4_STATUS: Uncorrected error, report: yes, MiscV:
invalid, CPU context corrupt: yes
[ 1304.370110]  Northbridge Error, node 0
[ 1304.370115] CRC error on link.
[ 1304.370120]  Transaction type: generic(generic), no timeout, Cache
Level: L3/generic, Participating Processor: local node observed as 3rd
party (OBS)
[ 1304.370124] This is not a software problem!
[ 1304.370128] Machine check: Processor context corrupt
[ 1304.370132] Kernel panic - not syncing: Fatal machine check on current CPU
[ 1304.370137] Pid: 48, comm: kondemand/0 Tainted: P   M
2.6.32-30-generic #59-Ubuntu
[ 1304.370142] Call Trace:
[ 1304.370146]  <#MC>  [<ffffffff81542b3d>] panic+0x78/0x139
[ 1304.370162]  [<ffffffff810235a2>] mce_panic+0x1e2/0x210
[ 1304.370168]  [<ffffffff81024963>] do_machine_check+0x7d3/0x820
[ 1304.370175]  [<ffffffff81545e9c>] machine_check+0x1c/0x30
[ 1304.370182]  [<ffffffff81037bf0>] ? native_read_msr_safe+0x10/0x30
[ 1304.370186]  <<EOE>>  [<ffffffff81028afa>]
query_current_values_with_pending_wait+0x5a/0xe0
[ 1304.370196]  [<ffffffff810291ea>] write_new_fid+0x7a/0x110
[ 1304.370201]  [<ffffffff8102936b>] core_frequency_transition+0xeb/0x180
[ 1304.370206]  [<ffffffff810294fa>] transition_fid_vid+0xfa/0x220
[ 1304.370211]  [<ffffffff8102971e>] transition_frequency_fidvid+0xbe/0x140
[ 1304.370216]  [<ffffffff8102997e>] powernowk8_target+0x1de/0x390
[ 1304.370275]  [<ffffffff814359aa>] __cpufreq_driver_target+0x3a/0x40
[ 1304.370281]  [<ffffffff81439c0b>] dbs_check_cpu+0x23b/0x240
[ 1304.370286]  [<ffffffff81439ce8>] do_dbs_timer+0xd8/0x100
[ 1304.370291]  [<ffffffff81439c10>] ? do_dbs_timer+0x0/0x100
[ 1304.370298]  [<ffffffff8107ffa7>] run_workqueue+0xc7/0x1a0
[ 1304.370303]  [<ffffffff81080123>] worker_thread+0xa3/0x110
[ 1304.370309]  [<ffffffff81084b70>] ? autoremove_wake_function+0x0/0x40
[ 1304.370315]  [<ffffffff81080080>] ? worker_thread+0x0/0x110
[ 1304.370320]  [<ffffffff810847f6>] kthread+0x96/0xa0
[ 1304.370325]  [<ffffffff810131ea>] child_rip+0xa/0x20
[ 1304.370330]  [<ffffffff81084760>] ? kthread+0x0/0xa0
[ 1304.370335]  [<ffffffff810131e0>] ? child_rip+0x0/0x20

Note how the error is always the same and the call trace also seems identical.
After many tests on my hardware (memtest, trying a different power
suppy, trying different bios paramenters, cleaning memory
contacts...), looking at the call trace I thought this could be
related to cpu frequency scaling. So I did the same test again, but
this time I used the 'performance' governor instead of the 'ondemand'
one. And, surprisingly, the problem doesn't occur (not even if I start
multiple heavy jobs,
like one compilation of a big program and two md5sum jobs on different
hard drives).
Could this be a bug on cpufreq? At this point I don't think my
hardware is faulty.
Here's some info about my system:

http://mywing.altervista.org/tmp/info.log

I'm not following the list, so please CC me in all reaply. Thanks.
Regards,

Giorgio Vazzana

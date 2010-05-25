Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab0EYOtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 10:49:05 -0400
Received: from 27.mail-out.ovh.net ([91.121.30.210]:35812 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758383Ab0EYOtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 10:49:02 -0400
Message-ID: <4BFBE357.2040602@example.com>
Date: Tue, 25 May 2010 16:48:55 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Divyesh Shah <dpshah@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 icedove-bin/5449
References: <4BF9EC69.5030709@example.com> <1274777422.5882.591.camel@twins>	 <20100525094347.GA7881@elte.hu>  <4BFB9F0A.9040803@example.com>	 <1274781655.5882.765.camel@twins> <4BFBA0F8.9090908@example.com>	 <4BFBA6A2.4070405@example.com> <4BFBDAF3.3020504@example.com>	 <4BFBE004.5060101@example.com> <1274798197.5882.1491.camel@twins>
In-Reply-To: <1274798197.5882.1491.camel@twins>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 16399858043691561359
X-Ovh-Remote: 83.6.191.44 (abbb44.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.05.2010 16:36, Peter Zijlstra wrote:
> On Tue, 2010-05-25 at 16:34 +0200, Piotr Hosowicz wrote:
>>> Not exactly. I looked into the syslog. I's much better, but I rebooted
>>> to single user mode to rebuild nvidia driver (new beta version) and I
>>> see same error (BUG ... code: ???) on shuting down, mentioning sync,
>>> umount and finally shutdown.
>>
>> Sorry, reversed order - shutdown, umount, finally sync.
>
> Could you post the full splat?

Here you are:

May 25 15:04:35 aapi205 shutdown[16256]: shutting down for system reboot
May 25 15:04:35 aapi205 kernel: [ 9694.523288] BUG: using 
smp_processor_id() in preemptible [00000000] code: shutdown/16256
May 25 15:04:35 aapi205 kernel: [ 9694.523296] caller is 
dqstats_inc+0x19/0x2c
May 25 15:04:35 aapi205 kernel: [ 9694.523299] Pid: 16256, comm: 
shutdown Tainted: P        W   2.6.34-20100524-1752-patched #1
May 25 15:04:35 aapi205 kernel: [ 9694.523301] Call Trace:
May 25 15:04:35 aapi205 kernel: [ 9694.523308]  [<ffffffff811a537b>] 
debug_smp_processor_id+0xc7/0xe0
May 25 15:04:35 aapi205 kernel: [ 9694.523311]  [<ffffffff8112c0ad>] 
dqstats_inc+0x19/0x2c
May 25 15:04:35 aapi205 kernel: [ 9694.523314]  [<ffffffff8112ee66>] 
vfs_quota_sync+0x1b1/0x293
May 25 15:04:35 aapi205 kernel: [ 9694.523319]  [<ffffffff8103bf21>] ? 
wake_up_process+0x10/0x12
May 25 15:04:35 aapi205 kernel: [ 9694.523323]  [<ffffffff81107ad4>] ? 
bdi_queue_work+0x9d/0xb3
May 25 15:04:35 aapi205 kernel: [ 9694.523326]  [<ffffffff8110bbcf>] ? 
sync_one_sb+0x0/0x1d
May 25 15:04:35 aapi205 kernel: [ 9694.523329]  [<ffffffff8110bb8b>] 
__sync_filesystem+0x3a/0x7e
May 25 15:04:35 aapi205 kernel: [ 9694.523332]  [<ffffffff8110bbea>] 
sync_one_sb+0x1b/0x1d
May 25 15:04:35 aapi205 kernel: [ 9694.523335]  [<ffffffff810ee399>] 
iterate_supers+0x6d/0xb2
May 25 15:04:35 aapi205 kernel: [ 9694.523339]  [<ffffffff8110bc16>] 
sys_sync+0x2a/0x57
May 25 15:04:35 aapi205 kernel: [ 9694.523343]  [<ffffffff81002b02>] 
system_call_fastpath+0x16/0x1b
May 25 15:04:35 aapi205 kernel: [ 9694.523898] BUG: using 
smp_processor_id() in preemptible [00000000] code: shutdown/16256
May 25 15:04:35 aapi205 kernel: [ 9694.523902] caller is 
dqstats_inc+0x19/0x2c
May 25 15:04:35 aapi205 kernel: [ 9694.523905] Pid: 16256, comm: 
shutdown Tainted: P        W   2.6.34-20100524-1752-patched #1
May 25 15:04:35 aapi205 kernel: [ 9694.523907] Call Trace:
May 25 15:04:35 aapi205 kernel: [ 9694.523911]  [<ffffffff811a537b>] 
debug_smp_processor_id+0xc7/0xe0
May 25 15:04:35 aapi205 kernel: [ 9694.523915]  [<ffffffff8112c0ad>] 
dqstats_inc+0x19/0x2c
May 25 15:04:35 aapi205 kernel: [ 9694.523918]  [<ffffffff8112ee66>] 
vfs_quota_sync+0x1b1/0x293
May 25 15:04:35 aapi205 kernel: [ 9694.523922]  [<ffffffff8110bbcf>] ? 
sync_one_sb+0x0/0x1d
May 25 15:04:35 aapi205 kernel: [ 9694.523925]  [<ffffffff8110bb8b>] 
__sync_filesystem+0x3a/0x7e
May 25 15:04:35 aapi205 kernel: [ 9694.523928]  [<ffffffff8110bbea>] 
sync_one_sb+0x1b/0x1d
May 25 15:04:35 aapi205 kernel: [ 9694.523931]  [<ffffffff810ee399>] 
iterate_supers+0x6d/0xb2
May 25 15:04:35 aapi205 kernel: [ 9694.523934]  [<ffffffff8110bc16>] 
sys_sync+0x2a/0x57
May 25 15:04:35 aapi205 kernel: [ 9694.523938]  [<ffffffff81002b02>] 
system_call_fastpath+0x16/0x1b
May 25 15:04:35 aapi205 kernel: [ 9694.523952] BUG: using 
smp_processor_id() in preemptible [00000000] code: shutdown/16256
May 25 15:04:35 aapi205 kernel: [ 9694.523956] caller is 
dqstats_inc+0x19/0x2c
May 25 15:04:35 aapi205 kernel: [ 9694.523958] Pid: 16256, comm: 
shutdown Tainted: P        W   2.6.34-20100524-1752-patched #1
May 25 15:04:35 aapi205 kernel: [ 9694.523960] Call Trace:
May 25 15:04:35 aapi205 kernel: [ 9694.523963]  [<ffffffff811a537b>] 
debug_smp_processor_id+0xc7/0xe0
May 25 15:04:35 aapi205 kernel: [ 9694.523967]  [<ffffffff8112c0ad>] 
dqstats_inc+0x19/0x2c
May 25 15:04:35 aapi205 kernel: [ 9694.523970]  [<ffffffff8112ee66>] 
vfs_quota_sync+0x1b1/0x293
May 25 15:04:35 aapi205 kernel: [ 9694.523974]  [<ffffffff8110bbcf>] ? 
sync_one_sb+0x0/0x1d
May 25 15:04:35 aapi205 kernel: [ 9694.523977]  [<ffffffff8110bb8b>] 
__sync_filesystem+0x3a/0x7e
May 25 15:04:35 aapi205 kernel: [ 9694.523980]  [<ffffffff8110bbea>] 
sync_one_sb+0x1b/0x1d
May 25 15:04:35 aapi205 kernel: [ 9694.523983]  [<ffffffff810ee399>] 
iterate_supers+0x6d/0xb2
May 25 15:04:35 aapi205 kernel: [ 9694.523986]  [<ffffffff8110bc2c>] 
sys_sync+0x40/0x57
May 25 15:04:35 aapi205 kernel: [ 9694.523989]  [<ffffffff81002b02>] 
system_call_fastpath+0x16/0x1b
May 25 15:04:36 aapi205 kernel: [ 9695.865459] BUG: using 
smp_processor_id() in preemptible [00000000] code: shutdown/16256
May 25 15:04:36 aapi205 kernel: [ 9695.865466] caller is 
dqstats_inc+0x19/0x2c
May 25 15:04:36 aapi205 kernel: [ 9695.865470] Pid: 16256, comm: 
shutdown Tainted: P        W   2.6.34-20100524-1752-patched #1
May 25 15:04:36 aapi205 kernel: [ 9695.865473] Call Trace:
May 25 15:04:36 aapi205 kernel: [ 9695.865479]  [<ffffffff811a537b>] 
debug_smp_processor_id+0xc7/0xe0
May 25 15:04:36 aapi205 kernel: [ 9695.865483]  [<ffffffff8112c0ad>] 
dqstats_inc+0x19/0x2c
May 25 15:04:36 aapi205 kernel: [ 9695.865487]  [<ffffffff8112ee66>] 
vfs_quota_sync+0x1b1/0x293
May 25 15:04:36 aapi205 kernel: [ 9695.865491]  [<ffffffff8110bbcf>] ? 
sync_one_sb+0x0/0x1d
May 25 15:04:36 aapi205 kernel: [ 9695.865513]  [<ffffffff8110bbcf>] ? 
sync_one_sb+0x0/0x1d
May 25 15:04:36 aapi205 kernel: [ 9695.865516]  [<ffffffff8110bb8b>] 
__sync_filesystem+0x3a/0x7e
May 25 15:04:36 aapi205 kernel: [ 9695.865519]  [<ffffffff8110bbea>] 
sync_one_sb+0x1b/0x1d
May 25 15:04:36 aapi205 kernel: [ 9695.865524]  [<ffffffff810ee399>] 
iterate_supers+0x6d/0xb2
May 25 15:04:36 aapi205 kernel: [ 9695.865528]  [<ffffffff8110bc2c>] 
sys_sync+0x40/0x57
May 25 15:04:36 aapi205 kernel: [ 9695.865533]  [<ffffffff81002b02>] 
system_call_fastpath+0x16/0x1b
May 25 15:04:36 aapi205 init: Switching to runlevel: 6
May 25 15:04:36 aapi205 kernel: [ 9696.142724] ALSA 
sound/pci/hda/hda_intel.c:1665: azx_pcm_prepare: bufsize=0x10000, 
format=0x31
May 25 15:04:36 aapi205 kernel: [ 9696.142740] ALSA 
sound/pci/hda/hda_codec.c:1158: hda_codec_setup_stream: NID=0x6, 
stream=0x5, channel=0, format=0x31
May 25 15:04:36 aapi205 kernel: [ 9696.148528] ALSA 
sound/pci/hda/hda_codec.c:1158: hda_codec_setup_stream: NID=0x2, 
stream=0x5, channel=0, format=0x31
May 25 15:04:36 aapi205 kernel: [ 9696.156527] ALSA 
sound/pci/hda/hda_codec.c:1158: hda_codec_setup_stream: NID=0x3, 
stream=0x5, channel=0, format=0x31
May 25 15:04:36 aapi205 kernel: [ 9696.164525] ALSA 
sound/pci/hda/hda_codec.c:1158: hda_codec_setup_stream: NID=0x4, 
stream=0x5, channel=0, format=0x31
May 25 15:04:36 aapi205 kernel: [ 9696.172525] ALSA 
sound/pci/hda/hda_codec.c:1158: hda_codec_setup_stream: NID=0x5, 
stream=0x5, channel=0, format=0x31
May 25 15:04:37 aapi205 kernel: [ 9697.255097] ALSA 
sound/pci/hda/hda_codec.c:1176: hda_codec_cleanup_stream: NID=0x2
May 25 15:04:37 aapi205 kernel: [ 9697.255106] ALSA 
sound/pci/hda/hda_codec.c:1176: hda_codec_cleanup_stream: NID=0x3
May 25 15:04:37 aapi205 kernel: [ 9697.255112] ALSA 
sound/pci/hda/hda_codec.c:1176: hda_codec_cleanup_stream: NID=0x4
May 25 15:04:37 aapi205 kernel: [ 9697.255118] ALSA 
sound/pci/hda/hda_codec.c:1176: hda_codec_cleanup_stream: NID=0x5
May 25 15:04:37 aapi205 kernel: [ 9697.255123] ALSA 
sound/pci/hda/hda_codec.c:1176: hda_codec_cleanup_stream: NID=0x6
May 25 15:04:40 aapi205 innd: ctlinnd command q:rc.news stop
May 25 15:04:40 aapi205 innd: SERVER shutdown rc.news stop
May 25 15:04:40 aapi205 innd: controlchan! closed
May 25 15:04:40 aapi205 innd: control:12 closed
May 25 15:04:40 aapi205 innd: localconn:14 closed
May 25 15:04:40 aapi205 innd: remconn:15 closed
May 25 15:04:40 aapi205 innd: remconn:17 closed
May 25 15:04:40 aapi205 innd: SERVER perl filtering disabled
May 25 15:04:40 aapi205 innd: SERVER shutdown rc.news stop
May 25 15:04:45 aapi205 xinetd[2822]: Exiting...
May 25 15:04:48 aapi205 kernel: [ 9707.903818] BUG: using 
smp_processor_id() in preemptible [00000000] code: umount/16455
May 25 15:04:48 aapi205 kernel: [ 9707.905420] caller is 
dqstats_inc+0x19/0x2c
May 25 15:04:48 aapi205 kernel: [ 9707.905423] Pid: 16455, comm: umount 
Tainted: P        W   2.6.34-20100524-1752-patched #1
May 25 15:04:48 aapi205 kernel: [ 9707.905426] Call Trace:
May 25 15:04:48 aapi205 kernel: [ 9707.905432]  [<ffffffff811a537b>] 
debug_smp_processor_id+0xc7/0xe0
May 25 15:04:48 aapi205 kernel: [ 9707.905436]  [<ffffffff8112c0ad>] 
dqstats_inc+0x19/0x2c
May 25 15:04:48 aapi205 kernel: [ 9707.905439]  [<ffffffff8112ee66>] 
vfs_quota_sync+0x1b1/0x293
May 25 15:04:48 aapi205 kernel: [ 9707.905444]  [<ffffffff8103bf21>] ? 
wake_up_process+0x10/0x12
May 25 15:04:48 aapi205 kernel: [ 9707.905448]  [<ffffffff81107ad4>] ? 
bdi_queue_work+0x9d/0xb3
May 25 15:04:48 aapi205 kernel: [ 9707.905452]  [<ffffffff8110bbcf>] ? 
sync_one_sb+0x0/0x1d
May 25 15:04:48 aapi205 kernel: [ 9707.905455]  [<ffffffff8110bb8b>] 
__sync_filesystem+0x3a/0x7e
May 25 15:04:48 aapi205 kernel: [ 9707.905458]  [<ffffffff8110bbea>] 
sync_one_sb+0x1b/0x1d
May 25 15:04:48 aapi205 kernel: [ 9707.905462]  [<ffffffff810ee399>] 
iterate_supers+0x6d/0xb2
May 25 15:04:48 aapi205 kernel: [ 9707.905465]  [<ffffffff8110bc16>] 
sys_sync+0x2a/0x57
May 25 15:04:48 aapi205 kernel: [ 9707.905470]  [<ffffffff81002b02>] 
system_call_fastpath+0x16/0x1b
May 25 15:04:48 aapi205 kernel: [ 9707.918645] BUG: using 
smp_processor_id() in preemptible [00000000] code: umount/16455
May 25 15:04:48 aapi205 kernel: [ 9707.920227] caller is 
dqstats_inc+0x19/0x2c
May 25 15:04:48 aapi205 kernel: [ 9707.920230] Pid: 16455, comm: umount 
Tainted: P        W   2.6.34-20100524-1752-patched #1
May 25 15:04:48 aapi205 kernel: [ 9707.920232] Call Trace:
May 25 15:04:48 aapi205 kernel: [ 9707.920237]  [<ffffffff811a537b>] 
debug_smp_processor_id+0xc7/0xe0
May 25 15:04:48 aapi205 kernel: [ 9707.920241]  [<ffffffff8112c0ad>] 
dqstats_inc+0x19/0x2c
May 25 15:04:48 aapi205 kernel: [ 9707.920244]  [<ffffffff8112ee66>] 
vfs_quota_sync+0x1b1/0x293
May 25 15:04:48 aapi205 kernel: [ 9707.920248]  [<ffffffff8110bbcf>] ? 
sync_one_sb+0x0/0x1d
May 25 15:04:48 aapi205 kernel: [ 9707.920251]  [<ffffffff8110bb8b>] 
__sync_filesystem+0x3a/0x7e
May 25 15:04:48 aapi205 kernel: [ 9707.920254]  [<ffffffff8110bbea>] 
sync_one_sb+0x1b/0x1d
May 25 15:04:48 aapi205 kernel: [ 9707.920257]  [<ffffffff810ee399>] 
iterate_supers+0x6d/0xb2
May 25 15:04:48 aapi205 kernel: [ 9707.920260]  [<ffffffff8110bc16>] 
sys_sync+0x2a/0x57
May 25 15:04:48 aapi205 kernel: [ 9707.920264]  [<ffffffff81002b02>] 
system_call_fastpath+0x16/0x1b
May 25 15:04:48 aapi205 kernel: [ 9707.920286] BUG: using 
smp_processor_id() in preemptible [00000000] code: umount/16455
May 25 15:04:48 aapi205 kernel: [ 9707.921976] caller is 
dqstats_inc+0x19/0x2c
May 25 15:04:48 aapi205 kernel: [ 9707.921979] Pid: 16455, comm: umount 
Tainted: P        W   2.6.34-20100524-1752-patched #1
May 25 15:04:48 aapi205 kernel: [ 9707.921982] Call Trace:
May 25 15:04:48 aapi205 kernel: [ 9707.921985]  [<ffffffff811a537b>] 
debug_smp_processor_id+0xc7/0xe0
May 25 15:04:48 aapi205 kernel: [ 9707.921988]  [<ffffffff8112c0ad>] 
dqstats_inc+0x19/0x2c
May 25 15:04:48 aapi205 kernel: [ 9707.921992]  [<ffffffff8112ee66>] 
vfs_quota_sync+0x1b1/0x293
May 25 15:04:48 aapi205 kernel: [ 9707.921996]  [<ffffffff8110bbcf>] ? 
sync_one_sb+0x0/0x1d
May 25 15:04:48 aapi205 kernel: [ 9707.921998]  [<ffffffff8110bb8b>] 
__sync_filesystem+0x3a/0x7e
May 25 15:04:48 aapi205 kernel: [ 9707.922002]  [<ffffffff8110bbea>] 
sync_one_sb+0x1b/0x1d
May 25 15:04:48 aapi205 kernel: [ 9707.922006]  [<ffffffff810ee399>] 
iterate_supers+0x6d/0xb2
May 25 15:04:48 aapi205 kernel: [ 9707.922011]  [<ffffffff8110bc2c>] 
sys_sync+0x40/0x57
May 25 15:04:48 aapi205 kernel: [ 9707.922016]  [<ffffffff81002b02>] 
system_call_fastpath+0x16/0x1b
May 25 15:04:49 aapi205 kernel: [ 9708.697931] BUG: using 
smp_processor_id() in preemptible [00000000] code: umount/16455
May 25 15:04:49 aapi205 kernel: [ 9708.699421] caller is 
dqstats_inc+0x19/0x2c
May 25 15:04:49 aapi205 kernel: [ 9708.699424] Pid: 16455, comm: umount 
Tainted: P        W   2.6.34-20100524-1752-patched #1
May 25 15:04:49 aapi205 kernel: [ 9708.699427] Call Trace:
May 25 15:04:49 aapi205 kernel: [ 9708.699433]  [<ffffffff811a537b>] 
debug_smp_processor_id+0xc7/0xe0
May 25 15:04:49 aapi205 kernel: [ 9708.699436]  [<ffffffff8112c0ad>] 
dqstats_inc+0x19/0x2c
May 25 15:04:49 aapi205 kernel: [ 9708.699440]  [<ffffffff8112ee66>] 
vfs_quota_sync+0x1b1/0x293
May 25 15:04:49 aapi205 kernel: [ 9708.699444]  [<ffffffff8110bbcf>] ? 
sync_one_sb+0x0/0x1d
May 25 15:04:49 aapi205 kernel: [ 9708.699447]  [<ffffffff8110bbcf>] ? 
sync_one_sb+0x0/0x1d
May 25 15:04:49 aapi205 kernel: [ 9708.699450]  [<ffffffff8110bb8b>] 
__sync_filesystem+0x3a/0x7e
May 25 15:04:49 aapi205 kernel: [ 9708.699453]  [<ffffffff8110bbea>] 
sync_one_sb+0x1b/0x1d
May 25 15:04:49 aapi205 kernel: [ 9708.699457]  [<ffffffff810ee399>] 
iterate_supers+0x6d/0xb2
May 25 15:04:49 aapi205 kernel: [ 9708.699460]  [<ffffffff8110bc2c>] 
sys_sync+0x40/0x57
May 25 15:04:49 aapi205 kernel: [ 9708.699464]  [<ffffffff81002b02>] 
system_call_fastpath+0x16/0x1b
May 25 15:04:49 aapi205 kernel: [ 9708.706412] BUG: using 
smp_processor_id() in preemptible [00000000] code: umount/16456
May 25 15:04:49 aapi205 kernel: [ 9708.707918] caller is 
dqstats_inc+0x19/0x2c
May 25 15:04:49 aapi205 kernel: [ 9708.707921] Pid: 16456, comm: umount 
Tainted: P        W   2.6.34-20100524-1752-patched #1
May 25 15:04:49 aapi205 kernel: [ 9708.707924] Call Trace:
May 25 15:04:49 aapi205 kernel: [ 9708.707929]  [<ffffffff811a537b>] 
debug_smp_processor_id+0xc7/0xe0
May 25 15:04:49 aapi205 kernel: [ 9708.707932]  [<ffffffff8112c0ad>] 
dqstats_inc+0x19/0x2c
May 25 15:04:49 aapi205 kernel: [ 9708.707936]  [<ffffffff8112ee66>] 
vfs_quota_sync+0x1b1/0x293
May 25 15:04:49 aapi205 kernel: [ 9708.707940]  [<ffffffff8103bf21>] ? 
wake_up_process+0x10/0x12
May 25 15:04:49 aapi205 kernel: [ 9708.707945]  [<ffffffff81107ad4>] ? 
bdi_queue_work+0x9d/0xb3
May 25 15:04:49 aapi205 kernel: [ 9708.707948]  [<ffffffff8110bbcf>] ? 
sync_one_sb+0x0/0x1d
May 25 15:04:49 aapi205 kernel: [ 9708.707952]  [<ffffffff8110bb8b>] 
__sync_filesystem+0x3a/0x7e
May 25 15:04:49 aapi205 kernel: [ 9708.707955]  [<ffffffff8110bbea>] 
sync_one_sb+0x1b/0x1d
May 25 15:04:49 aapi205 kernel: [ 9708.707958]  [<ffffffff810ee399>] 
iterate_supers+0x6d/0xb2
May 25 15:04:49 aapi205 kernel: [ 9708.707961]  [<ffffffff8110bc16>] 
sys_sync+0x2a/0x57
May 25 15:04:49 aapi205 kernel: [ 9708.707965]  [<ffffffff81002b02>] 
system_call_fastpath+0x16/0x1b
May 25 15:04:49 aapi205 kernel: [ 9708.708035] BUG: using 
smp_processor_id() in preemptible [00000000] code: umount/16456
May 25 15:04:49 aapi205 kernel: [ 9708.709679] caller is 
dqstats_inc+0x19/0x2c
May 25 15:04:49 aapi205 kernel: [ 9708.709683] Pid: 16456, comm: umount 
Tainted: P        W   2.6.34-20100524-1752-patched #1
May 25 15:04:49 aapi205 kernel: [ 9708.709685] Call Trace:
May 25 15:04:49 aapi205 kernel: [ 9708.709690]  [<ffffffff811a537b>] 
debug_smp_processor_id+0xc7/0xe0
May 25 15:04:49 aapi205 kernel: [ 9708.709694]  [<ffffffff8112c0ad>] 
dqstats_inc+0x19/0x2c
May 25 15:04:49 aapi205 kernel: [ 9708.709698]  [<ffffffff8112ee66>] 
vfs_quota_sync+0x1b1/0x293
May 25 15:04:49 aapi205 kernel: [ 9708.709704]  [<ffffffff8110bbcf>] ? 
sync_one_sb+0x0/0x1d
May 25 15:04:49 aapi205 kernel: [ 9708.709708]  [<ffffffff8110bb8b>] 
__sync_filesystem+0x3a/0x7e
May 25 15:04:49 aapi205 kernel: [ 9708.709713]  [<ffffffff8110bbea>] 
sync_one_sb+0x1b/0x1d
May 25 15:04:49 aapi205 kernel: [ 9708.709717]  [<ffffffff810ee399>] 
iterate_supers+0x6d/0xb2
May 25 15:04:49 aapi205 kernel: [ 9708.709721]  [<ffffffff8110bc16>] 
sys_sync+0x2a/0x57
May 25 15:04:49 aapi205 kernel: [ 9708.709726]  [<ffffffff81002b02>] 
system_call_fastpath+0x16/0x1b
May 25 15:04:49 aapi205 kernel: [ 9708.709752] BUG: using 
smp_processor_id() in preemptible [00000000] code: umount/16456
May 25 15:04:49 aapi205 kernel: [ 9708.711428] caller is 
dqstats_inc+0x19/0x2c
May 25 15:04:49 aapi205 kernel: [ 9708.711431] Pid: 16456, comm: umount 
Tainted: P        W   2.6.34-20100524-1752-patched #1
May 25 15:04:49 aapi205 kernel: [ 9708.711434] Call Trace:
May 25 15:04:49 aapi205 kernel: [ 9708.711437]  [<ffffffff811a537b>] 
debug_smp_processor_id+0xc7/0xe0
May 25 15:04:49 aapi205 kernel: [ 9708.711441]  [<ffffffff8112c0ad>] 
dqstats_inc+0x19/0x2c
May 25 15:04:49 aapi205 kernel: [ 9708.711445]  [<ffffffff8112ee66>] 
vfs_quota_sync+0x1b1/0x293
May 25 15:04:49 aapi205 kernel: [ 9708.711448]  [<ffffffff8110bbcf>] ? 
sync_one_sb+0x0/0x1d
May 25 15:04:49 aapi205 kernel: [ 9708.711452]  [<ffffffff8110bb8b>] 
__sync_filesystem+0x3a/0x7e
May 25 15:04:49 aapi205 kernel: [ 9708.711455]  [<ffffffff8110bbea>] 
sync_one_sb+0x1b/0x1d
May 25 15:04:49 aapi205 kernel: [ 9708.711458]  [<ffffffff810ee399>] 
iterate_supers+0x6d/0xb2
May 25 15:04:49 aapi205 kernel: [ 9708.711461]  [<ffffffff8110bc2c>] 
sys_sync+0x40/0x57
May 25 15:04:49 aapi205 kernel: [ 9708.711465]  [<ffffffff81002b02>] 
system_call_fastpath+0x16/0x1b
May 25 15:04:49 aapi205 kernel: [ 9709.009589] BUG: using 
smp_processor_id() in preemptible [00000000] code: umount/16456
May 25 15:04:49 aapi205 kernel: [ 9709.011130] caller is 
dqstats_inc+0x19/0x2c
May 25 15:04:49 aapi205 kernel: [ 9709.011134] Pid: 16456, comm: umount 
Tainted: P        W   2.6.34-20100524-1752-patched #1
May 25 15:04:49 aapi205 kernel: [ 9709.011136] Call Trace:
May 25 15:04:49 aapi205 kernel: [ 9709.011142]  [<ffffffff811a537b>] 
debug_smp_processor_id+0xc7/0xe0
May 25 15:04:49 aapi205 kernel: [ 9709.011146]  [<ffffffff8112c0ad>] 
dqstats_inc+0x19/0x2c
May 25 15:04:49 aapi205 kernel: [ 9709.011149]  [<ffffffff8112ee66>] 
vfs_quota_sync+0x1b1/0x293
May 25 15:04:49 aapi205 kernel: [ 9709.011153]  [<ffffffff8110bbcf>] ? 
sync_one_sb+0x0/0x1d
May 25 15:04:49 aapi205 kernel: [ 9709.011156]  [<ffffffff8110bbcf>] ? 
sync_one_sb+0x0/0x1d
May 25 15:04:49 aapi205 kernel: [ 9709.011159]  [<ffffffff8110bb8b>] 
__sync_filesystem+0x3a/0x7e
May 25 15:04:49 aapi205 kernel: [ 9709.011163]  [<ffffffff8110bbea>] 
sync_one_sb+0x1b/0x1d
May 25 15:04:49 aapi205 kernel: [ 9709.011166]  [<ffffffff810ee399>] 
iterate_supers+0x6d/0xb2
May 25 15:04:49 aapi205 kernel: [ 9709.011170]  [<ffffffff8110bc2c>] 
sys_sync+0x40/0x57
May 25 15:04:49 aapi205 kernel: [ 9709.011174]  [<ffffffff81002b02>] 
system_call_fastpath+0x16/0x1b
May 25 15:04:49 aapi205 kernel: [ 9709.058654] fuse exit
May 25 15:04:50 aapi205 bluetoothd[3086]: bridge pan0 removed
May 25 15:04:51 aapi205 bluetoothd[3086]: Stopping SDP server
May 25 15:04:51 aapi205 bluetoothd[3086]: Exit
May 25 15:04:51 aapi205 kernel: [ 9710.493142] BUG: using 
smp_processor_id() in preemptible [00000000] code: sync/16494
May 25 15:04:51 aapi205 kernel: [ 9710.494737] caller is 
dqstats_inc+0x19/0x2c
May 25 15:04:51 aapi205 kernel: [ 9710.494741] Pid: 16494, comm: sync 
Tainted: P        W   2.6.34-20100524-1752-patched #1
May 25 15:04:51 aapi205 kernel: [ 9710.494743] Call Trace:
May 25 15:04:51 aapi205 kernel: [ 9710.494749]  [<ffffffff811a537b>] 
debug_smp_processor_id+0xc7/0xe0
May 25 15:04:51 aapi205 kernel: [ 9710.494753]  [<ffffffff8112c0ad>] 
dqstats_inc+0x19/0x2c
May 25 15:04:51 aapi205 kernel: [ 9710.494756]  [<ffffffff8112ee66>] 
vfs_quota_sync+0x1b1/0x293
May 25 15:04:51 aapi205 kernel: [ 9710.494761]  [<ffffffff8103bf21>] ? 
wake_up_process+0x10/0x12
May 25 15:04:51 aapi205 kernel: [ 9710.494766]  [<ffffffff81107ad4>] ? 
bdi_queue_work+0x9d/0xb3
May 25 15:04:51 aapi205 kernel: [ 9710.494770]  [<ffffffff8110bbcf>] ? 
sync_one_sb+0x0/0x1d
May 25 15:04:51 aapi205 kernel: [ 9710.494773]  [<ffffffff8110bb8b>] 
__sync_filesystem+0x3a/0x7e
May 25 15:04:51 aapi205 kernel: [ 9710.494776]  [<ffffffff8110bbea>] 
sync_one_sb+0x1b/0x1d
May 25 15:04:51 aapi205 kernel: [ 9710.494780]  [<ffffffff810ee399>] 
iterate_supers+0x6d/0xb2
May 25 15:04:51 aapi205 kernel: [ 9710.494783]  [<ffffffff8110bc16>] 
sys_sync+0x2a/0x57
May 25 15:04:51 aapi205 kernel: [ 9710.494787]  [<ffffffff81002b02>] 
system_call_fastpath+0x16/0x1b
May 25 15:04:51 aapi205 kernel: [ 9710.494813] BUG: using 
smp_processor_id() in preemptible [00000000] code: sync/16494
May 25 15:04:51 aapi205 kernel: [ 9710.496416] caller is 
dqstats_inc+0x19/0x2c
May 25 15:04:51 aapi205 kernel: [ 9710.496418] Pid: 16494, comm: sync 
Tainted: P        W   2.6.34-20100524-1752-patched #1
May 25 15:04:51 aapi205 kernel: [ 9710.496420] Call Trace:
May 25 15:04:51 aapi205 kernel: [ 9710.496424]  [<ffffffff811a537b>] 
debug_smp_processor_id+0xc7/0xe0
May 25 15:04:51 aapi205 kernel: [ 9710.496428]  [<ffffffff8112c0ad>] 
dqstats_inc+0x19/0x2c
May 25 15:04:51 aapi205 kernel: [ 9710.496431]  [<ffffffff8112ee66>] 
vfs_quota_sync+0x1b1/0x293
May 25 15:04:51 aapi205 kernel: [ 9710.496435]  [<ffffffff8110bbcf>] ? 
sync_one_sb+0x0/0x1d
May 25 15:04:51 aapi205 kernel: [ 9710.496438]  [<ffffffff8110bb8b>] 
__sync_filesystem+0x3a/0x7e
May 25 15:04:51 aapi205 kernel: [ 9710.496441]  [<ffffffff8110bbea>] 
sync_one_sb+0x1b/0x1d
May 25 15:04:51 aapi205 kernel: [ 9710.496444]  [<ffffffff810ee399>] 
iterate_supers+0x6d/0xb2
May 25 15:04:51 aapi205 kernel: [ 9710.496447]  [<ffffffff8110bc16>] 
sys_sync+0x2a/0x57
May 25 15:04:51 aapi205 kernel: [ 9710.496451]  [<ffffffff81002b02>] 
system_call_fastpath+0x16/0x1b
May 25 15:04:51 aapi205 acpid: exiting

Cheers,

Piotr Hosowicz

-- 
Nie pytaj co rz±d mo¿e zrobiæ dla ciebie. Pytaj, jak mo¿esz temu zapobiec.
NP: Chickenfoot - Down The Drain
NB: 2.6.34-20100524-1752-patched

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab2FTSBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:01:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58815 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab2FTSBd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:01:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Bret Towe <magnade@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com, Andrew Morton <akpm@linux-foundation.org>,
        mfasheh@suse.com, jlbec@evilplan.org
Subject: Re: BUG in ofcs2_change_file_space
References: <CALjC5haTNDMOTDPL1m1uBTc2a-Qb8cvR44SCaVDFMzGc+Gw3+w@mail.gmail.com>
	<CALjC5hac=Wh_8J0qn0MCo6qXRtjQf1R-8jn79hMma0Qghg7jSQ@mail.gmail.com>
	<CALjC5hZBizcq0DwP=yX0z=_G3MibD2Ztjid2U86ez5YyZZRkYQ@mail.gmail.com>
Date: Wed, 20 Jun 2012 19:01:30 +0100
In-Reply-To: <CALjC5hZBizcq0DwP=yX0z=_G3MibD2Ztjid2U86ez5YyZZRkYQ@mail.gmail.com>
	(Bret Towe's message of "Wed, 20 Jun 2012 10:38:12 -0700")
Message-ID: <87bokddfr9.fsf@canonical.com>
User-Agent: Gnus/5.130006 (Ma Gnus v0.6) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bret Towe <magnade@gmail.com> writes:

> am I just going into spam folders?
>
> On Mon, May 21, 2012 at 8:11 PM, Bret Towe <magnade@gmail.com> wrote:
>> On Thu, Jan 5, 2012 at 2:23 PM, Bret Towe <magnade@gmail.com> wrote:
>>> got an oops on kernel 3.2 with ocfs2
>>> thunderbird loading an email with images is the trigger looks repeatable for me
>>> cache file being saved to /home directory is my guess
>>>
>>> firefox hasnt done it but its cache is in a ramdisk
>>> 3.1.6 wasn't doing this
>>>
>>> let me know what info you need
>>> below is the backtrace from syslog
>>> I would like to test whatever patch you have also
>>>
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.675822] BUG: unable to handle
>>> kernel NULL pointer dereference at 0000000000000038
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.675981] IP:
>>> [<ffffffffa0524f35>] __ocfs2_change_file_space+0x915/0xe40 [ocfs2]
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.676228] PGD ca69a067 PUD
>>> c745b067 PMD 0
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.676326] Oops: 0000 [#1] PREEMPT SMP
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.676416] CPU 1
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.676457] Modules linked in:
>>> nls_iso8859_1 nls_cp437 vfat fat uas usb_storage ocfs2 jbd2 quota_tree
>>> crc32c cpufreq_userspace cpufreq_powersave cpufreq_conservative
>>> binfmt_misc iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse
>>> ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager nfsd nfs
>>> lockd fscache auth_rpcgss nfs_acl sunrpc ipv6 af_packet tcp_bic
>>> ocfs2_stack_user dlm configfs ocfs2_stackglue powernow_k8 mperf usblp
>>> loop kvm_amd kvm snd_hda_codec_via snd_hda_codec_hdmi snd_seq_dummy
>>> snd_seq_oss snd_seq_midi snd_rawmidi snd_hda_intel snd_hda_codec
>>> snd_seq_midi_event snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq
>>> psmouse snd_timer snd_seq_device serio_raw pcspkr k10temp joydev snd
>>> evbug evdev i2c_piix4 soundcore snd_page_alloc button processor raid10
>>> raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq
>>> async_tx raid1 raid0 multipath linear md_mod atl1c [last unloaded:
>>> scsi_wait_scan]
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.678364]
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.678399] Pid: 2835, comm:
>>> thunderbird-bin Not tainted 3.2.0+ #45 System manufacturer System
>>> Product Name/F1A75-M
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.678610] RIP:
>>> 0010:[<ffffffffa0524f35>]  [<ffffffffa0524f35>]
>>> __ocfs2_change_file_space+0x915/0xe40 [ocfs2]
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.678859] RSP:
>>> 0018:ffff8800c75ffe28  EFLAGS: 00010246
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.678915] RAX: 0000000000000000
>>> RBX: ffff88010b810000 RCX: ffff88010b364400
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.678915] RDX: 0000000000000000
>>> RSI: 0000000000000001 RDI: ffffffffa053250d
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.678915] RBP: ffff8800c75ffec8
>>> R08: 00caec6a28080000 R09: ffff88010b364400
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.678915] R10: 000000000000cd75
>>> R11: 0000000000000000 R12: 0000000000000000
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.678915] R13: ffff88008b823e78
>>> R14: ffff88008b823f18 R15: ffff8800cae091e0
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.678915] FS:
>>> 00007fde742f5700(0000) GS:ffff88010fc80000(0000)
>>> knlGS:0000000000000000
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.678915] CS:  0010 DS: 0000
>>> ES: 0000 CR0: 0000000080050033
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.678915] CR2: 0000000000000038
>>> CR3: 00000000ca540000 CR4: 00000000000006e0
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.678915] DR0: 0000000000000000
>>> DR1: 0000000000000000 DR2: 0000000000000000
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.678915] DR3: 0000000000000000
>>> DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.678915] Process
>>> thunderbird-bin (pid: 2835, threadinfo ffff8800c75fe000, task
>>> ffff8800c6788000)
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.678915] Stack:
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.678915]  ffff8800c75fffd8
>>> ffff8800c75fffd8 000000000000cd75 0000000000000000
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.678915]  000000010ab4c900
>>> 0000000000000000 000000000000cd75 0000000000000000
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.678915]  ffff88010b810000
>>> ffff88008b823d98 ffff8800c75ffe98 ffff8800caec6a28
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.678915] Call Trace:
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.678915]  [<ffffffffa05254d4>]
>>> ocfs2_fallocate+0x74/0x80 [ocfs2]
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.678915]  [<ffffffff8111e04d>]
>>> do_fallocate+0xed/0x160
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.678915]  [<ffffffff8111e106>]
>>> sys_fallocate+0x46/0x70
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.678915]  [<ffffffff8155c3d2>]
>>> system_call_fastpath+0x16/0x1b
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.678915] Code: 68 49 89 55 78
>>> 4c 89 ee 48 8b 55 b8 49 89 45 60 4c 89 ff 49 89 45 70 e8 da 5d 00 00
>>> 85 c0 41 89 c4 0f 88 53 01 00 00 48 8b 55 88 <f7> 42 38 00 10 10 00 74
>>> 05 41 80 4f 14 01 4c 89 fe 48 89 df e8
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.678915] RIP
>>> [<ffffffffa0524f35>] __ocfs2_change_file_space+0x915/0xe40 [ocfs2]
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.678915]  RSP <ffff8800c75ffe28>
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.678915] CR2: 0000000000000038
>>> Jan  5 14:02:23 notmini64 kernel: [ 1431.695509] ---[ end trace
>>> 7e71a95e14e247b3 ]---
>>
>>
>> a patch has been available for this for a while now
>> found here: http://oss.oracle.com/pipermail/ocfs2-devel/2012-January/008464.html
>> but it still has not hit mainline
>> is there any way we can get this included?

I believe something like this would be more appropriated, as a NULL as the
'file' parameter seems to be valid in that context:

---
 fs/ocfs2/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 6e39668..84822a4 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1950,7 +1950,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 	if (ret < 0)
 		mlog_errno(ret);
 
-	if (file->f_flags & O_SYNC)
+	if (file && (file->f_flags & O_SYNC))
 		handle->h_sync = 1;
 
 	ocfs2_commit_trans(osb, handle);
-- 
1.7.9.5


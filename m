Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab1JIG7v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 02:59:51 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59527 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab1JIG7u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 02:59:50 -0400
MIME-Version: 1.0
In-Reply-To: <4E5FF216.2020207@suse.cz>
References: <20110828131502.GA2580@redhat.com>
	<4E5FF216.2020207@suse.cz>
Date: Sun, 9 Oct 2011 14:59:49 +0800
Message-ID: <CABqxG0c0wiaSXrLKCYc8Ef+uXEwkp=nuG+7-+pLoEEURkkDt=Q@mail.gmail.com>
Subject: Re: WARNING: at drivers/tty/tty_ldisc.c:766 tty_ldisc_reinit+0x52/0x90()
 [3.0]
From: Dave Young <hidave.darkstar@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 2, 2011 at 4:59 AM, Jiri Slaby <jslaby@suse.cz> wrote:
> On 08/28/2011 03:15 PM, Dave Jones wrote:
>>
>> Just saw this on a box that was recieving an rsync while I ssh'd in.
>> The ssh session hung.
>
> Yes, could you apply the attached debug patch and post a dmesg output?

I see this problem as well, the debug patch reports the refcount is 2

You can produce the WARN as below:
in xterm run:

exec 0<>/dev/console 1<>/dev/console 2<>/dev/console

>
>> WARNING: at drivers/tty/tty_ldisc.c:766 tty_ldisc_reinit+0x52/0x90()
>> Hardware name:
>> Modules linked in: nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc
>> p4_clockmod freq_table speedstep_lib nf_conntrack_ipv4 nf_defrag_ipv4
>> xt_state nf_conntrack microcode serio_raw snd_hda_codec_realtek i2c_i801
>> snd_hda_intel snd_hda_codec iTCO_wdt snd_hwdep iTCO_vendor_support snd_seq
>> snd_seq_device snd_pcm snd_timer snd r8169 soundcore mii snd_page_alloc
>> pata_sil680 i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last
>> unloaded: mperf]
>> Pid: 1381, comm: sshd Not tainted 2.6.40-4.fc15.x86_64.debug #1
>> Call Trace:
>>  [<ffffffff81058e74>] warn_slowpath_common+0x83/0x9b
>>  [<ffffffff81058ea6>] warn_slowpath_null+0x1a/0x1c
>>  [<ffffffff812f8e18>] tty_ldisc_reinit+0x52/0x90
>>  [<ffffffff812f9415>] tty_ldisc_hangup+0x13f/0x1e1
>>  [<ffffffff812f21b6>] __tty_hangup+0x111/0x35f
>>  [<ffffffff812f2429>] tty_vhangup+0xe/0x10
>>  [<ffffffff812faade>] pty_close+0x128/0x132
>>  [<ffffffff812f3404>] tty_release+0x1d8/0x4dc
>>  [<ffffffff81087a2e>] ? lock_release_holdtime.part.8+0x6b/0x72
>>  [<ffffffff8100eebf>] ? native_sched_clock+0x34/0x36
>>  [<ffffffff8113cdb2>] fput+0x127/0x1f5
>>  [<ffffffff81139d90>] filp_close+0x70/0x7b
>>  [<ffffffff81139e91>] sys_close+0xf6/0x13b
>>  [<ffffffff814fdf02>] system_call_fastpath+0x16/0x1b
>
>
>
> --
> js
> suse labs
>



-- 
Regards
Dave

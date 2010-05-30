Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab0E3Ifs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 04:35:48 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36638 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab0E3Ifq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 04:35:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=HVBPd3LbChcMEFpYwvQAXXjRHPhUcuXrNf+mVe0HPv/aTlZnjqvjSBpYNHZb0OPcYI
         GwCDOSToaTq1np1wMQrmI6ZFwJqBuo4rPnWJ/Duf7Q9zAV/s9qIPHIZuIg8gkQRD+d5x
         9h/lnshWbftRFpBugb6aFXrp6K7F+1IWxJpgw=
MIME-Version: 1.0
In-Reply-To: <AANLkTil5lzl8kCHRr7HZNhUCEC4qzuciWQAOenS1aCzO@mail.gmail.com>
References: <AANLkTil5lzl8kCHRr7HZNhUCEC4qzuciWQAOenS1aCzO@mail.gmail.com>
Date: Sun, 30 May 2010 18:35:44 +1000
Message-ID: <AANLkTikjZxmlWmDIHuKbNSpz7UfINwvjamyZ-xdFNjzh@mail.gmail.com>
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code: 
	ondemand/1327
From: andrew hendry <andrew.hendry@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running hdparm -tT /dev/sda gets a similar one.

[ 2705.519946] BUG: using smp_processor_id() in preemptible [00000000]
code: hdparm/2479
[ 2705.519948] caller is vfs_quota_sync+0x18c/0x350
[ 2705.519950] Pid: 2479, comm: hdparm Not tainted 2.6.34 #2
[ 2705.519951] Call Trace:
[ 2705.519953]  [<ffffffff81288548>] debug_smp_processor_id+0xd8/0xf0
[ 2705.519956]  [<ffffffff8118d21c>] vfs_quota_sync+0x18c/0x350
[ 2705.519958]  [<ffffffff811621c0>] ? sync_one_sb+0x0/0x30
[ 2705.519960]  [<ffffffff811621c0>] ? sync_one_sb+0x0/0x30
[ 2705.519962]  [<ffffffff81162161>] __sync_filesystem+0x41/0xa0
[ 2705.519964]  [<ffffffff811621e0>] sync_one_sb+0x20/0x30
[ 2705.519966]  [<ffffffff8113cd54>] iterate_supers+0x84/0xd0
[ 2705.519969]  [<ffffffff8116221f>] sys_sync+0x2f/0x70
[ 2705.519971]  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b

On Sun, May 30, 2010 at 6:02 PM, andrew hendry <andrew.hendry@gmail.com> wrote:
> I get 6 of these logged together about 1 minute after startup on an i7-860.
> Config attached. Distro is Ubuntu 10.04 64 bit.
> Is this one known or should I start a bisect?
>
> [   64.924201] BUG: using smp_processor_id() in preemptible [00000000]
> code: ondemand/1327
> [   64.924625] caller is nr_iowait_cpu+0x1a/0x40
> [   64.924627] Pid: 1327, comm: ondemand Not tainted 2.6.34 #2
> [   64.924629] Call Trace:
> [   64.924634]  [<ffffffff81288548>] debug_smp_processor_id+0xd8/0xf0
> [   64.924637]  [<ffffffff81042c7a>] nr_iowait_cpu+0x1a/0x40
> [   64.924641]  [<ffffffff81089f42>] update_ts_time_stats+0x72/0x90
> [   64.924645]  [<ffffffff81012759>] ? read_tsc+0x9/0x20
> [   64.924647]  [<ffffffff81084733>] ? ktime_get+0x63/0xe0
> [   64.924650]  [<ffffffff8108a162>] get_cpu_idle_time_us+0x52/0x80
> [   64.924654]  [<ffffffff8140a44c>] cpufreq_governor_dbs+0x1dc/0x430
> [   64.924657]  [<ffffffff81407af5>] __cpufreq_governor+0xc5/0x190
> [   64.924660]  [<ffffffff81407552>] ? lock_policy_rwsem_write+0x52/0x90
> [   64.924662]  [<ffffffff81407d07>] __cpufreq_set_policy+0x147/0x190
> [   64.924665]  [<ffffffff81408125>] store_scaling_governor+0xe5/0x210
> [   64.924667]  [<ffffffff81408480>] ? handle_update+0x0/0x20
> [   64.924672]  [<ffffffff8151dc00>] ? _raw_write_unlock_irq+0x40/0x50
> [   64.924675]  [<ffffffff814075f7>] store+0x67/0xa0
> [   64.924679]  [<ffffffff811a1375>] sysfs_write_file+0xe5/0x170
> [   64.924682]  [<ffffffff8113b088>] vfs_write+0xb8/0x180
> [   64.924685]  [<ffffffff8113b231>] sys_write+0x51/0x90
> [   64.924689]  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
>

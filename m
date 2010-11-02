Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab0KBKZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 06:25:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:40196 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab0KBKZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 06:25:50 -0400
Message-ID: <4CCFE7C1.60909@kernel.org>
Date: Tue, 02 Nov 2010 11:28:17 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: James Cloos <cloos@jhcloos.com>, Eli Billauer <eli@billauer.co.il>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: open() on /dev/tty takes 30 seconds on 2.6.36
References: <4CCBCD8E.1020601@billauer.co.il> <201010310436.18613.arnd@arndb.de> <m31v766fax.fsf@jhcloos.com> <201010311236.38844.arnd@arndb.de>
In-Reply-To: <201010311236.38844.arnd@arndb.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 02 Nov 2010 10:25:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/31/2010 12:36 PM, Arnd Bergmann wrote:
> On Sunday 31 October 2010, James Cloos wrote:
>> WARNING: at kernel/workqueue.c:1180 worker_enter_idle+0xd6/0xe2()
>> Hardware name: MS-7642
>> Modules linked in: tcp_diag inet_diag ipt_addrtype xt_dscp xt_string xt_owner xt_multiport xt_iprange xt_hashlimit xt_DSCP xt_NFQUEUE xt_mark xt_connmark tun snd_pcm_oss snd_mixer_oss snd_usb_audio snd_usbmidi_lib snd_rawmidi tpm_tis tpm ppdev parport_pc tpm_bios parport serio_raw edac_core k10temp pcspkr i2c_piix4 shpchp
>> Pid: 8061, comm: kworker/0:1 Not tainted 2.6.36-carbon1 #18
>> Call Trace:
>>  [<ffffffff81050c60>] warn_slowpath_common+0x85/0x9d
>>  [<ffffffff81050c92>] warn_slowpath_null+0x1a/0x1c
>>  [<ffffffff81066861>] worker_enter_idle+0xd6/0xe2
>>  [<ffffffff81068453>] worker_thread+0x182/0x19b
>>  [<ffffffff810682d1>] ? worker_thread+0x0/0x19b
>>  [<ffffffff8106ba81>] kthread+0x82/0x8a
>>  [<ffffffff8100aae4>] kernel_thread_helper+0x4/0x10
>>  [<ffffffff8106b9ff>] ? kthread+0x0/0x8a
>>  [<ffffffff8100aae0>] ? kernel_thread_helper+0x0/0x10
>> ---[ end trace 756b0818a6415dca ]---
>>
>> That was followed by a number of task blocked for more than 120 seconds
>> messages, all due to waiting for pty input or output.  An example trace:
> 
> This is triggered by an internal check in the workqueue handling that
> Tejun introduced. I guess it might be possible that this is triggered by
> a worker thread being blocked on a mutex, but I don't understand
> exactly what it is checking for. 

Hmmm... that's a condition which shouldn't happen regardless of being
blocked on mutex or whatever.  It means that internal book keeping
used to manage concurrency went out of sync somehow.  I've re-read the
code managing nr_running but couldn't spot where the problem could be.
Is there any way to reproduce the problem?

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab0JaMHN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 08:07:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60652 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab0JaMHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 08:07:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: James Cloos <cloos@jhcloos.com>
Subject: Re: open() on /dev/tty takes 30 seconds on 2.6.36
Date: Sun, 31 Oct 2010 12:36:38 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Eli Billauer <eli@billauer.co.il>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
References: <4CCBCD8E.1020601@billauer.co.il> <201010310436.18613.arnd@arndb.de> <m31v766fax.fsf@jhcloos.com>
In-Reply-To: <m31v766fax.fsf@jhcloos.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010311236.38844.arnd@arndb.de>
X-Provags-ID: V02:K0:0WXP+g/YZd+ZgDIH/luquCBbHDey6gYaopSRuMlKPtN
 wLEvlT5p2T7p9yFGls0idzCq7cs5Pc+LaqsVz/Bp9MkEWYigMH
 2vL4mfs4lbjTUgcXCDhqPIPjakwZbRfDjOtVwSnbzQ2UqVtbNm
 iYPNNwZ4Lo0wbE6/oNs61lM3VtUWrqA7+u4q27zjuij0Dz40gd
 Wq2w7lnOHFO1Rm1t6m8VQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 31 October 2010, James Cloos wrote:
> WARNING: at kernel/workqueue.c:1180 worker_enter_idle+0xd6/0xe2()
> Hardware name: MS-7642
> Modules linked in: tcp_diag inet_diag ipt_addrtype xt_dscp xt_string xt_owner xt_multiport xt_iprange xt_hashlimit xt_DSCP xt_NFQUEUE xt_mark xt_connmark tun snd_pcm_oss snd_mixer_oss snd_usb_audio snd_usbmidi_lib snd_rawmidi tpm_tis tpm ppdev parport_pc tpm_bios parport serio_raw edac_core k10temp pcspkr i2c_piix4 shpchp
> Pid: 8061, comm: kworker/0:1 Not tainted 2.6.36-carbon1 #18
> Call Trace:
>  [<ffffffff81050c60>] warn_slowpath_common+0x85/0x9d
>  [<ffffffff81050c92>] warn_slowpath_null+0x1a/0x1c
>  [<ffffffff81066861>] worker_enter_idle+0xd6/0xe2
>  [<ffffffff81068453>] worker_thread+0x182/0x19b
>  [<ffffffff810682d1>] ? worker_thread+0x0/0x19b
>  [<ffffffff8106ba81>] kthread+0x82/0x8a
>  [<ffffffff8100aae4>] kernel_thread_helper+0x4/0x10
>  [<ffffffff8106b9ff>] ? kthread+0x0/0x8a
>  [<ffffffff8100aae0>] ? kernel_thread_helper+0x0/0x10
> ---[ end trace 756b0818a6415dca ]---
> 
> That was followed by a number of task blocked for more than 120 seconds
> messages, all due to waiting for pty input or output.  An example trace:

This is triggered by an internal check in the workqueue handling that
Tejun introduced. I guess it might be possible that this is triggered by
a worker thread being blocked on a mutex, but I don't understand
exactly what it is checking for. 

	Arnd


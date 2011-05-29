Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253Ab1E2INI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 04:13:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37323 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab1E2INF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 04:13:05 -0400
Date: Sun, 29 May 2011 10:13:00 +0200
From: Borislav Petkov <bp@alien8.de>
To: Niels <zorglub_olsen@hotmail.com>
Cc: linux-kernel@vger.kernel.org, Serge Hallyn <serge@hallyn.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Trace during boot
Message-ID: <20110529081300.GB3762@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Niels <zorglub_olsen@hotmail.com>, linux-kernel@vger.kernel.org,
	Serge Hallyn <serge@hallyn.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <irsuji$6h8$1@dough.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <irsuji$6h8$1@dough.gmane.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 10:02:59AM +0200, Niels wrote:
> Hi list, I got the below trace during boot (got it from dmesg). I don't know
> if it's anything serious, just thought I'd pass it on.

No, nothing serious, just a warning about syslog-ng using a deprecated
syslog access method.

According to

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ce6ada35bdf7
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ee24aebffb75

syslog-ng is using CAP_SYS_ADMIN to access syslog, although it should
use CAP_SYSLOG now.

> 
> //Niels
> 
> ------------[ cut here ]------------
> WARNING: at kernel/printk.c:288 do_syslog+0x83/0x40a()
> Hardware name: P5Q SE
> Attempt to access syslog with CAP_SYS_ADMIN but no CAP_SYSLOG (deprecated).
> Modules linked in: snd_seq_midi snd_seq_midi_event snd_seq vboxnetadp
> vboxnetflt vboxdrv nvidia(P) snd_ice1712 snd_ice17xx_ak4xxx snd_ak4xxx_adda
> snd_cs8427 snd_ac97_codec snd_pcm snd_timer pcspkr snd_page_alloc ac97_bus
> snd_i2c snd_mpu401_uart snd_rawmidi snd_seq_device snd
> Pid: 2482, comm: syslog-ng Tainted: P            2.6.38-gentoo-r6 #2
> Call Trace:
>  [<ffffffff81030f8e>] ? warn_slowpath_common+0x78/0x8c
>  [<ffffffff81031041>] ? warn_slowpath_fmt+0x45/0x4a
>  [<ffffffff81031f61>] ? do_syslog+0x83/0x40a
>  [<ffffffff810b37dd>] ? do_lookup+0x1c5/0x27b
>  [<ffffffff810f11f0>] ? kmsg_release+0x0/0x18
>  [<ffffffff810e8e48>] ? proc_reg_open+0x8d/0x121
>  [<ffffffff810e8dbb>] ? proc_reg_open+0x0/0x121
>  [<ffffffff810a9d00>] ? __dentry_open+0x112/0x21a
>  [<ffffffff810b4932>] ? finish_open+0x97/0x14d
>  [<ffffffff810b6721>] ? do_filp_open+0x161/0x573
>  [<ffffffff810d4275>] ? fsnotify_clear_marks_by_inode+0x20/0xbd
>  [<ffffffff810bf4bc>] ? alloc_fd+0x69/0x10a
>  [<ffffffff810a9b26>] ? do_sys_open+0x56/0xe1
>  [<ffffffff81001efb>] ? system_call_fastpath+0x16/0x1b
> ---[ end trace dc3209c35a681fed ]---
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Regards/Gruss,
    Boris.

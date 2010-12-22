Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab0LVOLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 09:11:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:38341 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab0LVOLt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 09:11:49 -0500
Subject: Re: [PATCH] avoid race condition in pick_next_task_fair in
 kernel/sched_fair.c
From: Peter Zijlstra <peterz@infradead.org>
To: Miklos Vajna <vmiklos@frugalware.org>
Cc: Mike Galbraith <efault@gmx.de>, shenghui <crosslonelyover@gmail.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, Greg KH <greg@kroah.com>
In-Reply-To: <1293026422.2170.136.camel@laptop>
References: <AANLkTin49UHeVhfS-iFwWvPIg29HPhXaP3DorBAa-a0I@mail.gmail.com>
	 <1277808215.1868.5.camel@laptop>
	 <20101219020313.GJ31750@genesis.frugalware.org>
	 <20101222002248.GP10557@genesis.frugalware.org>
	 <1293006589.2170.41.camel@laptop>
	 <1293007311.11370.172.camel@marge.simson.net>
	 <1293008842.2170.70.camel@laptop>
	 <20101222133154.GS10557@genesis.frugalware.org>
	 <1293026422.2170.136.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 22 Dec 2010 15:11:52 +0100
Message-ID: <1293027112.2170.140.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-22 at 15:00 +0100, Peter Zijlstra wrote:
> On Wed, 2010-12-22 at 14:31 +0100, Miklos Vajna wrote:
> > 
> > http://frugalware.org/~vmiklos/files/systemd.img
> > 
> > Here is how I started it:
> > 
> > qemu-kvm -vnc :0 -m 1G -hda systemd.img 
> 
> awesome, thanks!
> 
> I started it with something like: 
>  qemu -kernel foo-build/arch/x86/boot/bzImage -append "root=/dev/sda1
> debug sched_debug ignore_loglevel sysrq_always_enabled console=ttyS0"
> -hda systemd.img -serial stdio -m 1G
> 
> Where foo-build/ contains a kernel build using your .config.
> 
> I'll have a poke at it..

Hrm,. its not really wanting to start properly..

---
EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
Freeing unused kernel memory: 520k freed
EXT4-fs (sda1): re-mounted. Opts: (null)
md: stopping all md devices.
Restarting system.
machine restart
---

Does it _require_ initrd like muck? Or are there some modules that need
to get built-in in order for the thing to boot?

This is an utter lack of error reporting here, no idea what's wrong.

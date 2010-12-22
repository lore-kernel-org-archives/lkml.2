Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab0LVPZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 10:25:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:60802 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab0LVPZj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 10:25:39 -0500
Subject: Re: [PATCH] avoid race condition in pick_next_task_fair in
 kernel/sched_fair.c
From: Peter Zijlstra <peterz@infradead.org>
To: Miklos Vajna <vmiklos@frugalware.org>
Cc: Mike Galbraith <efault@gmx.de>, shenghui <crosslonelyover@gmail.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, Greg KH <greg@kroah.com>
In-Reply-To: <20101222151434.GW10557@genesis.frugalware.org>
References: <AANLkTin49UHeVhfS-iFwWvPIg29HPhXaP3DorBAa-a0I@mail.gmail.com>
	 <1277808215.1868.5.camel@laptop>
	 <20101219020313.GJ31750@genesis.frugalware.org>
	 <20101222002248.GP10557@genesis.frugalware.org>
	 <1293006589.2170.41.camel@laptop>
	 <1293007311.11370.172.camel@marge.simson.net>
	 <1293008842.2170.70.camel@laptop>
	 <20101222133154.GS10557@genesis.frugalware.org>
	 <1293026422.2170.136.camel@laptop> <1293027112.2170.140.camel@laptop>
	 <20101222151434.GW10557@genesis.frugalware.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 22 Dec 2010 16:25:30 +0100
Message-ID: <1293031530.2170.150.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-22 at 16:14 +0100, Miklos Vajna wrote:
> 
> qemu -enable-kvm -kernel kernel-build/arch/x86/boot/bzImage -append
> "root=/dev/sda1 debug sched_debug ignore_loglevel sysrq_always_enabled
> console=ttyS0 init=/bin/systemd" -hda systemd.img -serial stdio -m 1G
> -vnc :0
> 
> ^ Only init=/bin/systemd added, and this results in a panic in most
> cases. I'm attaching the stdout of qemu, showing the fail in
> put_prev_task_fair. 

OK, that does seem to work, maybe it really wants the vnc thing, dunno.

Anyway, it looks like I need to go build a kernel with kvm in for that
machine ;-) Thanks for the effort so far.

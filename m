Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab1J1Gf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 02:35:59 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:48955 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750730Ab1J1Gf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 02:35:58 -0400
X-Sasl-enc: HmFppIbU1Zw/Q391fpm0AAaIpMXm4LGJNI8g8p5iYzzM 1319783756
Subject: Re: INFO: possible recursive locking detected:
 autofs4_expire_indirect()
From: Ian Kent <raven@themaw.net>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Pawel Sikora <pluto@agmk.net>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        arekm@pld-linux.org, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20111027133118.GA17916@elliptictech.com>
References: <3620801.NcMcO2jnH8@pawels>
	 <20111027133118.GA17916@elliptictech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Oct 2011 14:35:51 +0800
Message-ID: <1319783751.3214.9.camel@perseus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-27 at 09:31 -0400, Nick Bowler wrote:
> On 2011-10-25 14:48 +0200, Pawel Sikora wrote:
> > the nfs client/server with fresh 3.0.8 + vserver + enabled debug options reports attached info.
> > afaics, the vserver doesn't change autofs code, so it looks like a pure vanilla problem.
> 
> I reported this issue a long time ago, and a patch[1] was provided
> quickly, but it seems that for some reason it never made it to mainline.
> 
> Adding Steven to CC.
> 
> [1] http://permalink.gmane.org/gmane.linux.kernel/1129741

And when nothing happened I forwarded the patch to Al Viro.
Sounds like it's time to re-post this one, and I'll ack it.

> 
> > [ 3708.715749] =============================================
> > [ 3708.715940] [ INFO: possible recursive locking detected ]
> > [ 3708.716040] 3.0.8-vs2.3.1-dirty #6
> > [ 3708.716131] ---------------------------------------------
> > [ 3708.716230] automount/29215 is trying to acquire lock:
> > [ 3708.716301]  (&(&dentry->d_lock)->rlock/1){+.+...}, at: [<ffffffffa0214fb0>] autofs4_expire_indirect+0xe0/0x4e0 [autofs4]
> > [ 3708.716301]
> > [ 3708.716301] but task is already holding lock:
> > [ 3708.716301]  (&(&dentry->d_lock)->rlock/1){+.+...}, at: [<ffffffffa0214fb0>] autofs4_expire_indirect+0xe0/0x4e0 [autofs4]
> > [ 3708.716301]
> > [ 3708.716301] other info that might help us debug this:
> > [ 3708.716301]  Possible unsafe locking scenario:
> > [ 3708.716301]
> > [ 3708.716301]        CPU0
> > [ 3708.716301]        ----
> > [ 3708.716301]   lock(&(&dentry->d_lock)->rlock);
> > [ 3708.716301]   lock(&(&dentry->d_lock)->rlock);
> > [ 3708.716301]
> > [ 3708.716301]  *** DEADLOCK ***
> > [ 3708.716301]
> > [ 3708.716301]  May be due to missing lock nesting notation
> > [ 3708.716301]
> > [ 3708.716301] 2 locks held by automount/29215:
> > [ 3708.716301]  #0:  (&(&sbi->lookup_lock)->rlock){+.+...}, at: [<ffffffffa0214f61>] autofs4_expire_indirect+0x91/0x4e0 [autofs4]
> > [ 3708.716301]  #1:  (&(&dentry->d_lock)->rlock/1){+.+...}, at: [<ffffffffa0214fb0>] autofs4_expire_indirect+0xe0/0x4e0 [autofs4]
> > [ 3708.716301]
> > [ 3708.716301] stack backtrace:
> > [ 3708.716301] Pid: 29215, comm: automount Not tainted 3.0.8-vs2.3.1-dirty #6
> > [ 3708.716301] Call Trace:
> > [ 3708.716301]  [<ffffffff810925d6>] __lock_acquire+0x1606/0x1b50
> > [ 3708.716301]  [<ffffffffa0214fb0>] ? autofs4_expire_indirect+0xe0/0x4e0 [autofs4]
> > [ 3708.716301]  [<ffffffff81092c6a>] ? lock_release_non_nested+0x14a/0x310
> > [ 3708.716301]  [<ffffffffa0214fb0>] ? autofs4_expire_indirect+0xe0/0x4e0 [autofs4]
> > [ 3708.716301]  [<ffffffffa0214fb0>] ? autofs4_expire_indirect+0xe0/0x4e0 [autofs4]
> > [ 3708.716301]  [<ffffffff810930c5>] lock_acquire+0x85/0x110
> > [ 3708.716301]  [<ffffffffa0214fb0>] ? autofs4_expire_indirect+0xe0/0x4e0 [autofs4]
> > [ 3708.716301]  [<ffffffffa02151bd>] ? autofs4_expire_indirect+0x2ed/0x4e0 [autofs4]
> > [ 3708.716301]  [<ffffffff81453c1a>] _raw_spin_lock_nested+0x2a/0x40
> > [ 3708.716301]  [<ffffffffa0214fb0>] ? autofs4_expire_indirect+0xe0/0x4e0 [autofs4]
> > [ 3708.716301]  [<ffffffff81454386>] ? _raw_spin_unlock+0x26/0x30
> > [ 3708.716301]  [<ffffffff8110f830>] ? might_fault+0x40/0x90
> > [ 3708.716301]  [<ffffffffa0214fb0>] autofs4_expire_indirect+0xe0/0x4e0 [autofs4]
> > [ 3708.716301]  [<ffffffffa021568d>] autofs4_do_expire_multi+0xed/0x130 [autofs4]
> > [ 3708.716301]  [<ffffffffa0215a70>] ? autofs_dev_ioctl_askumount+0x30/0x30 [autofs4]
> > [ 3708.716301]  [<ffffffffa0215a8a>] autofs_dev_ioctl_expire+0x1a/0x20 [autofs4]
> > [ 3708.716301]  [<ffffffffa0216063>] _autofs_dev_ioctl+0x273/0x360 [autofs4]
> > [ 3708.716301]  [<ffffffffa021615e>] autofs_dev_ioctl+0xe/0x20 [autofs4]
> > [ 3708.716301]  [<ffffffff8115dc56>] do_vfs_ioctl+0x96/0x560
> > [ 3708.716301]  [<ffffffff8114c289>] ? fget_light+0x99/0x130
> > [ 3708.716301]  [<ffffffff8114c227>] ? fget_light+0x37/0x130
> > [ 3708.716301]  [<ffffffff8115e1b1>] sys_ioctl+0x91/0xa0
> > [ 3708.716301]  [<ffffffff8145bdbb>] system_call_fastpath+0x16/0x1b
> 
> Cheers,



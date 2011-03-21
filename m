Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab1CUDj2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 23:39:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39218 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab1CUDj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 23:39:27 -0400
Date: Mon, 21 Mar 2011 03:39:26 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39-rc0: umount tmpfs hangs
Message-ID: <20110321033926.GP22723@ZenIV.linux.org.uk>
References: <AANLkTi=5pSyJVqOQUJ8wXbNpXogWcRdavswx9my0OzEX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=5pSyJVqOQUJ8wXbNpXogWcRdavswx9my0OzEX@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 05:24:08AM +0300, Alexander Beregalov wrote:
> Hi
> 
> kernel is 2.6.38-06507-ga952baa
> 
> /etc/init.d/swap stop
> runs
> umount -a -t tmpfs
> 
> which is hangs at
> 
> $cat /proc/4453/stack
> [<c1066332>] rcu_barrier_sched+0x32/0x40
> [<c109fdca>] deactivate_locked_super+0x3a/0x60
> [<c10a05f6>] deactivate_super+0x46/0x60
> [<c10b6f2a>] mntput_no_expire+0x5a/0x90
> [<c10b7a6d>] sys_umount+0x5d/0x300
> [<c10b7d29>] sys_oldumount+0x19/0x20
> [<c136eb50>] sysenter_do_call+0x12/0x36
> [<ffffffff>] 0xffffffff

rcu_barrier() hanging for some reason...  I really wonder what's going
on there - missing rcu_read_unlock()?  Could you try to reproduce that
sucker and, if possible, bisect it?

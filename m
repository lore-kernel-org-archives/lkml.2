Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab1DMT0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 15:26:49 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34320 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758188Ab1DMT0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 15:26:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=nugP6X9ISDzmVJeIHan95yaT1n0m6XRAquar1V8XmGPJmMm1fdALXXfOgo/zQWJpO5
         3SIG5+uMbRdeLlm3ppm9A/v8v85nYj1NpEhb2n8+28HmZOUz/SGjxz9dO3J4GeJYeEu5
         jDYkijbEJ8iZw4gr23tm0Lq7j+IxJoH9KgvEM=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Nick Bowler <nbowler@elliptictech.com>
Subject: Re: Lockdep splat in autofs with 2.6.39-rc2
Date: Wed, 13 Apr 2011 21:26:41 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, autofs@linux.kernel.org,
        Ian Kent <raven@themaw.net>
References: <20110407194403.GA29404@elliptictech.com>
In-Reply-To: <20110407194403.GA29404@elliptictech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104132126.42050.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=33242
for your bug report, please add your address to the CC list in there, thanks!


On czwartek, 7 kwietnia 2011 o 21:44:03 Nick Bowler wrote:
> Just saw this on 2.6.39-rc2 after half a day or so of uptime.  I've
> never seen it before today so it may be a regression from 2.6.38.
> Nothing seems have failed as a result.  Please let me know if you
> need any more info.
> 
>   =============================================
>   [ INFO: possible recursive locking detected ]
>   2.6.39-rc2 #177
>   ---------------------------------------------
>   automount/23324 is trying to acquire lock:
>    (&(&dentry->d_lock)->rlock/1){+.+...}, at: [<ffffffffa034ea28>]
> autofs4_expire_indirect+0x307/0x484 [autofs4]
> 
>   but task is already holding lock:
>    (&(&dentry->d_lock)->rlock/1){+.+...}, at: [<ffffffffa034ea28>]
> autofs4_expire_indirect+0x307/0x484 [autofs4]
> 
>   other info that might help us debug this:
>   2 locks held by automount/23324:
>    #0:  (&(&sbi->lookup_lock)->rlock){+.+...}, at: [<ffffffffa034e9aa>]
> autofs4_expire_indirect+0x289/0x484 [autofs4] #1: 
> (&(&dentry->d_lock)->rlock/1){+.+...}, at: [<ffffffffa034ea28>]
> autofs4_expire_indirect+0x307/0x484 [autofs4]
> 
>   stack backtrace:
>   Pid: 23324, comm: automount Not tainted 2.6.39-rc2 #177
>   Call Trace:
>    [<ffffffff81061dc7>] __lock_acquire+0xc83/0xcfa
>    [<ffffffff8105f200>] ? static_obj+0x3d/0x4d
>    [<ffffffff81062073>] ? lock_release_non_nested+0x1c8/0x227
>    [<ffffffffa034ea28>] ? autofs4_expire_indirect+0x307/0x484 [autofs4]
>    [<ffffffffa034ea28>] ? autofs4_expire_indirect+0x307/0x484 [autofs4]
>    [<ffffffff81061e95>] lock_acquire+0x57/0x6d
>    [<ffffffffa034ea28>] ? autofs4_expire_indirect+0x307/0x484 [autofs4]
>    [<ffffffff8131f4e3>] _raw_spin_lock_nested+0x39/0x48
>    [<ffffffffa034ea28>] ? autofs4_expire_indirect+0x307/0x484 [autofs4]
>    [<ffffffff8131fb10>] ? _raw_spin_unlock+0x3e/0x4b
>    [<ffffffffa034ea28>] autofs4_expire_indirect+0x307/0x484 [autofs4]
>    [<ffffffffa034f184>] ? autofs_dev_ioctl_askumount+0x2d/0x2d [autofs4]
>    [<ffffffffa034edbd>] autofs4_do_expire_multi+0x30/0xe9 [autofs4]
>    [<ffffffffa034f184>] ? autofs_dev_ioctl_askumount+0x2d/0x2d [autofs4]
>    [<ffffffffa034f184>] ? autofs_dev_ioctl_askumount+0x2d/0x2d [autofs4]
>    [<ffffffffa034f19e>] autofs_dev_ioctl_expire+0x1a/0x1c [autofs4]
>    [<ffffffffa034f738>] _autofs_dev_ioctl+0x2a3/0x348 [autofs4]
>    [<ffffffffa034f7eb>] autofs_dev_ioctl+0xe/0x12 [autofs4]
>    [<ffffffff810c750d>] do_vfs_ioctl+0x45f/0x4ae
>    [<ffffffff810bab4e>] ? rcu_read_unlock+0x21/0x23
>    [<ffffffff810c759e>] sys_ioctl+0x42/0x65
>    [<ffffffff8132463b>] system_call_fastpath+0x16/0x1b

-- 
Maciej Rutecki
http://www.maciek.unixy.pl

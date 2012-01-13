Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652Ab2AMS1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 13:27:18 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:49488 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab2AMS1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 13:27:16 -0500
Date: Fri, 13 Jan 2012 10:27:12 -0800 (PST)
Message-Id: <20120113.102712.600185688659703015.davem@davemloft.net>
To: davej@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        glommer@parallels.com
Subject: Re: recvmsg sleeping from invalid context
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120113182401.GA25885@redhat.com>
References: <20120113182401.GA25885@redhat.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 13 Jan 2012 10:27:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Jones <davej@redhat.com>
Date: Fri, 13 Jan 2012 13:24:01 -0500

> getting a ton of these on the latest head (099469502f62fbe0d7e4f0b83a2f22538367f734)
> 
> BUG: sleeping function called from invalid context at mm/memory.c:3905
> in_atomic(): 0, irqs_disabled(): 0, pid: 1067, name: NetworkManager
> INFO: lockdep is turned off.
> Pid: 1067, comm: NetworkManager Not tainted 3.2.0+ #22
> Call Trace:
>  [<ffffffff81099415>] __might_sleep+0x145/0x200
>  [<ffffffff811752a4>] might_fault+0x34/0xb0
>  [<ffffffff81551555>] ? sock_def_readable+0x25/0x1a0
>  [<ffffffff8155c387>] put_cmsg+0x77/0x120
>  [<ffffffff8159379c>] netlink_recvmsg+0x35c/0x480
>  [<ffffffff8155201a>] ? sock_update_classid+0x9a/0x260
>  [<ffffffff81552052>] ? sock_update_classid+0xd2/0x260
>  [<ffffffff81549fbd>] sock_recvmsg+0x11d/0x140
>  [<ffffffff811752c3>] ? might_fault+0x53/0xb0
>  [<ffffffff8117530c>] ? might_fault+0x9c/0xb0
>  [<ffffffff811752c3>] ? might_fault+0x53/0xb0
>  [<ffffffff8154b1b3>] __sys_recvmsg+0x153/0x2d0
>  [<ffffffff811bc39a>] ? fget_light+0x5a/0x470
>  [<ffffffff8109fd11>] ? get_parent_ip+0x11/0x50
>  [<ffffffff816ac23d>] ? sub_preempt_count+0x9d/0xd0
>  [<ffffffff811bc43b>] ? fget_light+0xfb/0x470
>  [<ffffffff811bc39a>] ? fget_light+0x5a/0x470
>  [<ffffffff8154e2e9>] sys_recvmsg+0x49/0x90
>  [<ffffffff816b00e9>] system_call_fastpath+0x16/0x1b

Sigh, I suspect the new socket memcg code, which I didn't want to
even apply in the first place. :-/

Glauber, please fix this.

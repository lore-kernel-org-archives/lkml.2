Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282Ab0GGEeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 00:34:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60098 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab0GGEeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 00:34:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SQfliftKBTBIlx8Iah7G0kiAGTJlqmAOC4GlbrtKWAB2dhSyYVnCr0PiuwRnrfUth3
         4EYpgtXVNKGzzLPb0jzxSpslnZkczyF3jQCnBSdlzDKrFA4MQjclKhb6KjX0Pebp4kNE
         HnGy1yZts7JHKfFfdg/vtaTa5/0ChEWczfoUU=
Subject: Re: 2.6.35-rc4 - include/linux/fdtable.h:85 invoked
 rcu_dereference_check()  without protection!
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTinDWl1qJzK-H9Qw3jjKs9zdUYE1Hh3hTaDw8asd@mail.gmail.com>
References: <AANLkTinDWl1qJzK-H9Qw3jjKs9zdUYE1Hh3hTaDw8asd@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Jul 2010 06:34:17 +0200
Message-ID: <1278477257.2445.2.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 06 juillet 2010 à 20:25 -0400, Miles Lane a écrit :
> [ INFO: suspicious rcu_dereference_check() usage. ]
>  ---------------------------------------------------
>  include/linux/fdtable.h:85 invoked rcu_dereference_check() without protection!
> 
>  other info that might help us debug this:
> 
>  rcu_scheduler_active = 1, debug_locks = 1
>  no locks held by compiz/4286.
> 
>  stack backtrace:
>  Pid: 4286, comm: compiz Not tainted 2.6.35-rc4 #6
>  Call Trace:
>   [<ffffffff8106714e>] lockdep_rcu_dereference+0x9d/0xa6
>   [<ffffffff810d3bdd>] fcheck_files+0x5c/0xca
>   [<ffffffff810d3ca3>] fget_light+0x35/0x96
>   [<ffffffff810e1b02>] do_sys_poll+0x1ff/0x3e5
>   [<ffffffff810e1316>] ? __pollwait+0x0/0xc7
>   [<ffffffff810e13dd>] ? pollwake+0x0/0x4f
>   [<ffffffff8125b785>] ? __sock_sendmsg+0x66/0x72
>   [<ffffffff8125da9e>] ? sock_aio_write+0x0/0xf6
>   [<ffffffff8125db7f>] ? sock_aio_write+0xe1/0xf6
>   [<ffffffff810d295f>] ? do_sync_readv_writev+0xbc/0xfb
>   [<ffffffff810d284f>] ? fsnotify_modify+0x67/0x6f
>   [<ffffffff810d35eb>] ? do_readv_writev+0x109/0x122
>   [<ffffffff81009cba>] ? sysret_check+0x2e/0x69
>   [<ffffffff810e1e7c>] sys_poll+0x50/0xba
>   [<ffffffff81009c82>] system_call_fastpath+0x16/0x1b
> 
> ===============================================================================
> 
>  [ INFO: suspicious rcu_dereference_check() usage. ]
>  ---------------------------------------------------
>  include/linux/fdtable.h:88 invoked rcu_dereference_check() without protection!
> 
>  other info that might help us debug this:
> 
>  rcu_scheduler_active = 1, debug_locks = 1
>  no locks held by gnome-panel/4293.
> 
>  stack backtrace:
>  Pid: 4293, comm: gnome-panel Not tainted 2.6.35-rc4 #6
>  Call Trace:
>   [<ffffffff8106714e>] lockdep_rcu_dereference+0x9d/0xa6
>   [<ffffffff810d3c32>] fcheck_files+0xb1/0xca
>   [<ffffffff810ab263>] ? might_fault+0x63/0xb3
>   [<ffffffff810d3ca3>] fget_light+0x35/0x96
>   [<ffffffff810e1b02>] do_sys_poll+0x1ff/0x3e5
>   [<ffffffff810e1316>] ? __pollwait+0x0/0xc7
>   [<ffffffff8125a2ae>] ? __sock_recvmsg_nosec+0x65/0x6e
>   [<ffffffff8125b7da>] ? __sock_recvmsg+0x49/0x54
>   [<ffffffff8125da8a>] ? sock_aio_read+0xe8/0xfc
>   [<ffffffff810d2b67>] ? do_sync_read+0xc6/0x103
>   [<ffffffff81009cba>] ? sysret_check+0x2e/0x69
>   [<ffffffff810e1e7c>] sys_poll+0x50/0xba
>   [<ffffffff81009c82>] system_call_fastpath+0x16/0x1b
> --

Miles, you already posted this three times, and a fix is known.

BTW, I dont know why it's not already in, Paul submitted it several
times, but nobody cares.

http://kerneltrap.org/mailarchive/linux-kernel/2010/6/17/4584014

I am going to Ack it, maybe some other guys can help to.



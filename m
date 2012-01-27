Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab2A0SPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:15:32 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38465 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab2A0SPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:15:30 -0500
Date: Fri, 27 Jan 2012 19:15:25 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC c/r 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
Message-ID: <20120127181525.GD11715@one.firstfloor.org>
References: <20120127175342.273260614@openvz.org> <20120127175939.795551339@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120127175939.795551339@openvz.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It takes up to 5 agruments - the pids of the two tasks (which
> characteristics should be compared), the comparision type and
> (in case of comparision of files) two file descriptors.

Can you please write a manpage for it? That's really required
to evaluate the interface properly.

As I understand it every time the kernel adds some new kind of state
this would need to be extended too? This would seem like a lot of work,
especially since you always need to synchronize kernel/user space.
How would the user space break if it doesn't know about some newly
added state?

Maybe it would be better to put more of the relevant code into the
kernel to encapsulate this better.


> +	case KCMP_SYSVSEM:
> +#ifdef CONFIG_SYSVIPC
> +		ret = kcmp_ptr((long)task1->sysvsem.undo_list,
> +			       (long)task2->sysvsem.undo_list,
> +			       KCMP_SYSVSEM);

I assume that's normally NULL.

> +#ifdef CONFIG_X86_64
> +static long syscall5(int nr, unsigned long arg0, unsigned long arg1,
> +		unsigned long arg2, unsigned long arg3,
> +		unsigned long arg4)

Why not just use syscall() in glibc?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

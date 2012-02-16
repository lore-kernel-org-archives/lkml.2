Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab2BPS0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 13:26:00 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61548 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab2BPSZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 13:25:58 -0500
Date: Thu, 16 Feb 2012 22:21:06 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu,
        Michal Marek <mmarek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: + syscalls-x86-add-__nr_kcmp-syscall-v8.patch added to -mm tree
Message-ID: <20120216182106.GA17020@albatros>
References: <20120215184336.GA24182@redhat.com>
 <20120215195610.GJ4533@moon>
 <20120215195733.GA8021@albatros>
 <20120215200533.GQ1894@moon>
 <20120215202538.GK4533@moon>
 <20120215210934.GL4533@moon>
 <20120215215807.GM4533@moon>
 <20120216144954.GA11953@redhat.com>
 <20120216151340.GI1905@moon>
 <20120216164901.GD3849@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120216164901.GD3849@moon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 20:49 +0400, Cyrill Gorcunov wrote:
> +	err = mutex_lock_killable(m1);
> +	if (!err && likely(m1 != m2)) {
> +		err = mutex_lock_killable_nested(m2, SINGLE_DEPTH_NESTING);

Doesn't it lead to a deadlock?

mutex_lock_killable(task1)
|					mutex_lock_killable(task2)
mutex_lock_killable_nested(task2)	|
(locked)				|
					mutex_lock_killable_nested(task1)
					(locked)

I suppose you should use some global lock (kcmp_lock) before both locks.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments

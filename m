Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab2BOQNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 11:13:37 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42549 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab2BOQNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 11:13:35 -0500
Date: Wed, 15 Feb 2012 20:13:29 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
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
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu,
        Michal Marek <mmarek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + syscalls-x86-add-__nr_kcmp-syscall-v8.patch added to -mm tree
Message-ID: <20120215161329.GM1894@moon>
References: <20120215143606.GA14037@redhat.com>
 <20120215151008.GL1894@moon>
 <20120215153816.GA15988@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120215153816.GA15988@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 04:38:16PM +0100, Oleg Nesterov wrote:
...
> >
> > Wait, how it's differ from other ptrace_may_access calls all over
> > the kernel? I suppose I'm missing something obvious?
> 
> For example? Say, mm_access() is fine because it returns ->mm
> which we are going to play with.

So, say we have

environ_read
  mm_for_maps
   mm_access
    success, and first reader continue here

then say task change own credentials and all
this sequence fails because access is not granted
anymore (say for second reader), but first reader
still able to continue reading because access was
graned earlier.

So I don't understand how it's different from what
is provided in this patch. What I'm missing?

> Once again, I am not saying that this code really has the security
> problems. I simply do not know. But it looks wrong without the
> comment. I do not really understand why do we need ptrace_may_access(),
> but whatever reason we have how we can trust it? Say, when KCMP_VM
> checks ->mm, all we know is that PTRACE_MODE_READ succeed in the
> past. This looks confusing, imho.

Adding the comment is not a problem. The problem is that I
dont understand if there error in patch or not, can we stick
with ptrace_may_access or need something different here?
The idea was exactly like -- if you have enough rights to
proceed ptrace_may_access then syscall should continue
executing and return comparision result.

	Cyrill

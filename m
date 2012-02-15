Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab2BOUFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:05:39 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34205 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658Ab2BOUFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:05:38 -0500
Date: Thu, 16 Feb 2012 00:05:33 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
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
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + syscalls-x86-add-__nr_kcmp-syscall-v8.patch added to -mm tree
Message-ID: <20120215200533.GQ1894@moon>
References: <20120215143606.GA14037@redhat.com>
 <20120215151008.GL1894@moon>
 <20120215153816.GA15988@redhat.com>
 <20120215161329.GM1894@moon>
 <20120215162222.GA18266@redhat.com>
 <20120215175319.GG4533@moon>
 <20120215184336.GA24182@redhat.com>
 <20120215195610.GJ4533@moon>
 <20120215195733.GA8021@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120215195733.GA8021@albatros>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 11:57:33PM +0400, Vasiliy Kulikov wrote:
> > 
> > This makes me scratch the head ;) I think ptrace_may_access (or
> > some other security test) should remain since it's somehow weird
> > if non-root task will be able to find objects order from privileged
> > task. Thus I need to find a way how to handle execve(setuid_app).
> > Need to think...
> 
> Look at fs/proc/base.c:lock_trace() - it locks ->cred_guard_mutex
> for the whole period of time when it uses a resource.

Yup, thanks Vasiliy! I've just found cred_guard_mutex in
install_exec_creds. Now I'm thinking if this is what we
need here ;)

	Cyrill

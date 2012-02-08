Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab2BHNlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 08:41:52 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:38574 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756163Ab2BHNlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 08:41:51 -0500
Message-ID: <4F327B99.7020602@gmail.com>
Date: Wed, 08 Feb 2012 17:41:45 +0400
From: Andrew Vagin <avagin@gmail.com>
Reply-To: avagin@gmail.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Pedro Alves <palves@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH] ptrace: add ability to get clear_tid_address
References: <1328267483-3225342-1-git-send-email-avagin@openvz.org> <20120203162519.GB805@google.com> <4F2C0F13.70709@parallels.com> <20120203165132.GA5636@redhat.com> <4F31848A.9070406@redhat.com>
In-Reply-To: <4F31848A.9070406@redhat.com>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
> Off hand, I'm not picturing a use.  But that may well just mean I'm lacking
> imagination.  Andrew, Pavel, did you have a particular idea in mind when you
> said it may be useful for debugging a multithreading program / gdb?
For example:

pthread_join() waits on a futex (child_tid_address), but a thread is 
dead already.

Where is the problem? At first I would want to check, that 
pthread_join() uses the correct address of the futex. The simple way is 
to connect to this process via gdb
and get it.

I want to say, that when you have trouble with child_tid_address, you 
may want to get it.
If the code is your, you may get it via prctl, but if it's not, what 
will you do?

Yes, we have lived without this for a long time, so I can assume that 
all what I tell is useless.

But one more reason why I want to add this in ptrace.
I want use this functionality to dump a process state.
Now we do a few actions in a context of the process which we want to 
dump. A parasite code is injected for that. This way is dangerous, 
because it may affect a target process (It may occur due to a bug in 
parasite). We use this way, because we want to add minimum functionality 
in the kernel. Our current goal is to make a full functional prototype 
and when everyone will understand that this project works and it's 
usefull, we will do improvements. And I hope in future we will save 
state of processes without parasite.

For this reason I avoid adding new actions in a parasite code, but 
prctl() can be executed only from parasite code.

If after all you are not sure that this functionality should be in 
ptrace, I will add it in prctl, it's not a problem.

Thanks.

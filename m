Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab1JTRcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 13:32:23 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:3263 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024Ab1JTRcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 13:32:22 -0400
Message-ID: <4EA05AC4.5060706@parallels.com>
Date: Thu, 20 Oct 2011 21:30:44 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrey Vagin <avagin@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [patch 5/5] elf: Add support for loading ET_CKPT files
References: <20111014110416.552685686@openvz.org> <20111014110511.670174429@openvz.org> <20111014171033.GC4294@google.com> <20111014173304.GD4294@google.com> <4E9E9255.7090601@parallels.com> <20111019182228.GJ25124@google.com> <4E9FDCEF.5050008@parallels.com> <20111020155645.GV25124@google.com>
In-Reply-To: <20111020155645.GV25124@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2011 07:56 PM, Tejun Heo wrote:
> Hello,
> 
> On Thu, Oct 20, 2011 at 12:33:51PM +0400, Pavel Emelyanov wrote:
>>> To shared kernel data structures.
>>
>> Yet again - keeping shared stuctres self-consistent from which point of view? From
>> the kernel's one - already handled with in-kernel locks. From the userspace one -
>> every single kernel API provides a *way* to do things right, but doesn't provide
>> the fool protection.
> 
> Sigh, no, in exec and related paths, the fact that all other threads
> have been zapped are depended upon and the exec'ing task assumes
> exclusive access to resources which in usual cases would require other
> forms of exclusion.  Maybe there are not too many of them and things
> can definitely be audited and updated but it is pretty intricate down
> there and I just don't see good enough justification here.

The amount of new kernel API is good justification. I've sent the list of what
should we allow to change from user-space for the sake of restore only.

Anyway - let's wait for Cyrill's work done in this area.

>>> IMHO, this is a fundamentally broken approach which isn't even
>>> necessary.  So, FWIW, NACK.
>>
>> It's a pity :( Anyway, as I stated above, we'll try to compare two
>> real implementations, not abstract assumptions.
> 
> Given the state of this thread, I'm pretty skeptical this one can
> survive but, hey, who knows?

That's good to hear that you're still open for discussion.

> Thank you.

Thanks,
Pavel

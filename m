Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab1JVGe6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 02:34:58 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:24453 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010Ab1JVGe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 02:34:57 -0400
Message-ID: <4EA263E0.5050800@parallels.com>
Date: Sat, 22 Oct 2011 10:34:08 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Cyrill Gorcunov <gorcunov@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
References: <20111014110416.552685686@openvz.org> <20111014110511.670174429@openvz.org> <20111014171033.GC4294@google.com> <20111014173304.GD4294@google.com> <4E9E9255.7090601@parallels.com> <20111019182228.GJ25124@google.com> <20111019195632.GB14464@moon> <20111021182610.GB28670@google.com> <20111021183628.GH31508@moon> <20111021184239.GI31508@moon> <20111021184817.GC28670@google.com>
In-Reply-To: <20111021184817.GC28670@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2011 10:48 PM, Tejun Heo wrote:
> Hello,
> 
> On Fri, Oct 21, 2011 at 10:42:39PM +0400, Cyrill Gorcunov wrote:
>> On Fri, Oct 21, 2011 at 10:36:28PM +0400, Cyrill Gorcunov wrote:
>>>> I think this comes back to why one-stop-solution-in-kernel is a bad
>>>> idea for CR.  My impression is that when people say "that would
>>>> require too many small API updatesa", it usually means that they
>>>> haven't really thought about each necessary piece enough and just
>>
>> Don't claim such things, Tejun. Yes, I'm missing a number of things
>> (the same applies to you as well), but this patch was not 'just a
>> fast way to achieve what we need'. It's rather an attempt to gather
>> all things I've missed and provide more robust/solid version at the
>> next iteration (regargless which form this patch appeared, complete
>> user-space solution, some kernel api extension of whatever).
> 
> Hmmm... my point was that single lumpy implementation allows for such
> mistakes to go unnoticed && makes it difficult to recover and thus is
> a bad approach to the problem.  For example, unlikely but, let's say
> we missed this vdso thing and it went into upstream, now what would we
> do?  We'll need to somehow allow userland supply vdso symtab to kernel
> and let the kernel do the bridging and then probably bump the version
> number for elf format and so on.  IMHO, that just isn't a good way to
> approach the problem, so let's please do it piece by piece.

What mistakes are we talking about?

With the seized restore we prepare the VDSO thing in the userspace and
then push this in to the kernel (let alone the question how we make the
kernel know this page IS VDSO), with the exec-ed restore we also prepare 
this VDSO in the userspace and then push this into the kernel as well, but
via the binary handler. This handler is extremely simple thing and not
supposed to do complex logic - just call do_mmap_pgoff() and write pages 
in there in cycle, which is generic enough even for VDSO, no?

What am I missing here, where is the difference? Don't get me wrong, I'm
not mocking, just assume that we can all miss smth from each other.

> Thanks.
> 


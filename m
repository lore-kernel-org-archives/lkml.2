Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab2BXQPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:15:00 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37089 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab2BXQO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:14:57 -0500
Message-ID: <4F47B781.2050300@gmail.com>
Date: Fri, 24 Feb 2012 11:14:57 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.1) Gecko/20120208 Thunderbird/10.0.1
MIME-Version: 1.0
To: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Jamie Lokier <jamie@shareable.org>,
        vapier@gentoo.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Mark thread stack correctly in proc/<pid>/maps
References: <4F32B776.6070007@gmail.com> <1328972596-4142-1-git-send-email-siddhesh.poyarekar@gmail.com> <CAHGf_=oi8_s0Bxn4qSD7S_FBSgp29BPXor4hCf5-kekGnf3qEw@mail.gmail.com> <CAAHN_R2Awa5X3B09541grAPLkm9RzL9DnixUKFJXpz=1ZkPTFg@mail.gmail.com>
In-Reply-To: <CAAHN_R2Awa5X3B09541grAPLkm9RzL9DnixUKFJXpz=1ZkPTFg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Sigh. No, I missed one thing. If application use
>> makecontext()/swapcontext() pair,
>> ESP is not reliable way to detect pthread stack. At that time the
>> stack is still marked
>> as anonymous memory.
>
> This is not wrong, because it essentially gives the correct picture of
> the state of that task -- the task is using another vma as a stack
> during that point and not the one it was allotted by pthreads during
> thread creation.
>
> I don't think we can successfully stick to the idea of trying to mark
> stack space allocated by pthreads but not used by any task *currently*
> as stack as long as the allocation happens outside the kernel space.
> The only way to mark this is either by marking the stack as
> VM_GROWSDOWN (which will make the stack grow and break some pthreads
> functions) or create a new flag, which a simple display such as this
> does not deserve. So it's best that this sticks to what the kernel
> *knows* is being used as stack.

Oh, maybe generically you are right. but you missed one thing. Before
your patch, stack or not stack are address space property. thus, using
/proc/pid/maps makes sense. but after your patch, it's no longer memory
property. applications can use heap or mapped file as a stack. then, at
least, current your code is wrong. the code assume each memory property
are exclusive.

Moreover, if pthread stack is unimportant, I wonder why we need this patch
at all. Which application does need it? and When?


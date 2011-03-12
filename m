Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab1CLVU4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 16:20:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004Ab1CLVUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 16:20:55 -0500
Date: Sat, 12 Mar 2011 22:11:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Vagin <avagin@gmail.com>
Cc: Pavel Emelyanov <xemul@openvz.org>, Andrey Vagin <avagin@openvz.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: + x86-mm-handle-mm_fault_error-in-kernel-space.patch added to
	-mm tree
Message-ID: <20110312211143.GA27460@redhat.com>
References: <20110310142812.GA25224@redhat.com> <4D7926C9.9070206@parallels.com> <20110311111931.GA16052@redhat.com> <4D7A2FED.3060200@gmail.com> <20110311165700.GA30929@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110311165700.GA30929@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11, Oleg Nesterov wrote:
>
> On 03/11, Andrew Vagin wrote:
> >
> >
> The point is, if current was _NOT_ killed we should follow the current
> pagefault_out_of_memory() logic or remove pagefault_out_of_memory()
> completely.

Yes, and I still think this is valid. And thus I still think the patch
should be changed (btw, this problem is not x86 specific).

However,

> >> Why do you think the current task should be killed? In this case we
> >> do not need oom-killer at all, we could always kill the caller of
> >> alloc_page/etc.
> >
> > You don't understand. alloc_page calls oom-killer himself, then try
> > allocate memory again. Pls look at __alloc_pages_slowpath().
> > __alloc_pages_slowpat may fail if order > 3 || gfp_mask & __GFP_NOFAIL
> > || test_thread_flag(TIF_MEMDIE)
>
> Andrew, please, I know this.

Hmm. It turns out I do not ;)

I thought I can find the case when handle_mm_fault() returns VM_FAULT_OOM
and the caller is not killed, but I can't. I do not really understand
mem_cgroup_handle_oom/etc, but it seems we always retry indefinitely even
with mem_cgroup's. mm/hugetlb.c looks fine too...

So, I have to apologize, I am starting to think you are right.



Maybe someone could explain why pagefault_out_of_memory() is still
needed?

Oleg.


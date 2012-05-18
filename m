Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966310Ab2ERLyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 07:54:00 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:33911 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558Ab2ERLx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 07:53:58 -0400
Message-ID: <4FB6384D.7090906@parallels.com>
Date: Fri, 18 May 2012 15:53:49 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [rfc 0/4] procfs fdinfo extension
References: <20120517160738.116113099@openvz.org> <20120517120541.f2dbdee9.akpm@linux-foundation.org>
In-Reply-To: <20120517120541.f2dbdee9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 11:05 PM, Andrew Morton wrote:
> On Thu, 17 May 2012 20:07:38 +0400
> Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
>> when we do restore files such as eventfd/eventpoll we need to pass
>> appropriate parameters to system calls.
> 
> What does "such as" mean?  Provide the whole list, please.

As far as this particular set is concerned -- we'll add inotify stuff
there and the signalfd info a bit later (no apps we test use it by now).
That's it. But once there will appear more fd-s based on anon_inode
and that are configured using custom syscalls, we'll have to implement
the "get info" API for them too.

> I assume we're going to have to add ~100 lines of stuff to each and 
> every one? Stuff which, according to this patchset, is needed even when
> CONFIG_CHECKPOINT_RESTORE=n?

Generally speaking -- yes. It can be useful to check e.g. what the event
counter is on some eventfd for debugging purposes. Right now there's no
way for getting this info.

> My reason for disliking our whole approach to integration of c/r is
> that it exposes us to an ongoing trickle of nasty surprises.  This
> patchset is one such nasty surprise, and we don't even know how
> extensive this particular surprise will be.

Well, I wouldn't say it's nasty. The problem with evetpoll, eventfd and
inotifies, is that each of them is a set-only API unlike most of the other
APIs for working with fds. I.e. -- you can configure your fd, it will work,
yes. But you have NO MEANS for finding out what you have configured 
previously. What we do is just make the API complete.

If you believe that using fdinfo file in proc for that is nasty, then we're
OK to rework this. But this approach was discussed on LSF this year, that's
why we've implemented it this way.

> And how many more surprises are we going to get?
> 
> 
> I'm quite apprehensive about this, largely because it has so many
> unknowns.  How much work would it be to prepare a full list of
> everything that still needs to be done to fully implement c/r in Linux?

I'd say, that the whole c/r project is being done to determine how much
information the kernel does NOT provide yet. And we really appreciate that
this happens on the mainstream kernel, rather than in a separate branch.

> .
> 

Thanks,
Pavel

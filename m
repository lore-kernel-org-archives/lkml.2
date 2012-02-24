Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab2BXSVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 13:21:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481Ab2BXSVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 13:21:19 -0500
Date: Fri, 24 Feb 2012 16:21:09 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Jidong Xiao <jidong.xiao@gmail.com>
Cc: david@lang.hm, Cong Wang <xiyou.wangcong@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
Message-ID: <20120224162109.1bbf157b@redhat.com>
In-Reply-To: <CAG4AFWbfrTtq2OCrkrXfF-VV1+80oUE1Nfaxg5US3hNX3AiQ6A@mail.gmail.com>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
	<4F4661D6.7030809@gmail.com>
	<CAG4AFWa3cs-V+wfL8o6PauTAOtvj8t1E_iSN5r0A8z=Aqzg0tg@mail.gmail.com>
	<alpine.DEB.2.02.1202231247550.1803@asgard.lang.hm>
	<CAG4AFWbfrTtq2OCrkrXfF-VV1+80oUE1Nfaxg5US3hNX3AiQ6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 23 Feb 2012 16:01:56 -0500
Jidong Xiao <jidong.xiao@gmail.com> escreveu:

> On Thu, Feb 23, 2012 at 3:48 PM,  <david@lang.hm> wrote:
> > On Thu, 23 Feb 2012, Jidong Xiao wrote:
> >
> >>>
> >>> At least UIO drivers are already in Linux kernel, see drivers/uio/.
> >>>
> >>
> >> Oh, so does it make sense to move existing device drivers into user
> >> space? For example, move most of the stuff located under drivers/usb
> >> into user-space?
> >
> >
> > Why would you want to? What advantage are you looking to gain from all the
> > effort?
> >
> Since device drivers are a significant source of bugs in OS. Moving
> them to user space can reduce the impact of these bugs. Otherwise, why
> UIO, or drivers/uio, is accepted by mainstream Linux kernel.

Moving a buggy driver to userspace won't fix the bug. You're just moving
it from one place to another place. Also, the code will likely require changes
to work on userspace, so, the chances are that you're actually introducing more
bugs.

The impact of the bug won't also reduce, on most cases, as the userspace driver
will very likely require root capabilities.

Also, as driver talks directly with the hardware, an userspace block driver
would have access to the raw disk data. So, even if you find a way for it to
run unprivileged, it can still mangle the data written on the disk, and
even have a malicious code there that adds or allows to add a malware at the
disk partitions.

That's said, there are much more eyes inspecting the kernel sources than on any 
other userspace project. So, the risk of a bad code to be inserted unnoticed at
the Linux kernel is degrees of magnitude lower than on an userspace driver.

So, I can't see any advantage on doing something like that.

> 
> -Jidong
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Cheers,
Mauro

---

Delivering value year after year.
Red Hat ranks #1 in value among software vendors.
http://www.redhat.com/promo/vendor/

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108Ab1KBPbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 11:31:37 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41800 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374Ab1KBPbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 11:31:35 -0400
Date: Wed, 2 Nov 2011 08:31:46 -0700
From: Tejun Heo <htejun@gmail.com>
To: trisha yad <trisha1march@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-mm <linux-mm@kvack.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Issue with core dump
Message-ID: <20111102153146.GC12543@dhcp-172-17-108-109.mtv.corp.google.com>
References: <CAGr+u+zkPiZpGefstcbJv_cj929icWKXbqFy1uR22Hns1hzFeQ@mail.gmail.com>
 <20111101152320.GA30466@redhat.com>
 <CAGr+u+wgAYVWgdcG6o+6F0mDzuyNzoOxvsFwq0dMsR3JNnZ-cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGr+u+wgAYVWgdcG6o+6F0mDzuyNzoOxvsFwq0dMsR3JNnZ-cA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Nov 02, 2011 at 12:03:39PM +0530, trisha yad wrote:
> In loaded embedded system the time at with code hit do_user_fault()
> and core_dump_wait() is bit
> high, I check on my  system it took 2.7 sec. so it is very much
> possible that core dump is not correct.

This may sound like arguing over semantics but it doesn't matter how
long it takes, it's still correct.  You're arguing that it's not
immediate enough.  IOW, no matter how fast you make it, you cannot
guarantee that results from slow operation wouldn't appear.

Also, the time between do_user_fault() and actual core dumping isn't
the important factor here.  do_user_fault() directly triggers delivery
of SIGSEGV (or BUS) and signal delivery will immediately deliver
SIGKILL to all other threads in the process, so it should be immediate
enough, or, rather, we don't have any way to make it any more
immediate.  It's basically direct call + IPI (if some threads are
running on other cpus).

Are you actually seeing artifacts from delayed core dump?  Given the
code path, I'm highly skeptical that would be the actual case.  If
you're using shared memory between different processes, then that
delay would matter but for such cases there's nothing much to do.

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964837Ab2LFSWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 13:22:47 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:59782 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab2LFSWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 13:22:45 -0500
Date: Thu, 6 Dec 2012 10:22:39 -0800
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Jeff Moyer <jmoyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, Zach Brown <zab@redhat.com>,
        Peter Zijlstra <pzijlstr@redhat.com>, Ingo <mingo@redhat.com>
Subject: Re: [patch,v2] bdi: add a user-tunable cpu_list for the bdi flusher
 threads
Message-ID: <20121206182239.GS19802@htj.dyndns.org>
References: <x49lidfnf0s.fsf@segfault.boston.devel.redhat.com>
 <50BE5988.3050501@fusionio.com>
 <x498v9dpnwu.fsf@segfault.boston.devel.redhat.com>
 <50BE5C99.6070703@fusionio.com>
 <x494nk1pi7h.fsf@segfault.boston.devel.redhat.com>
 <20121206180150.GQ19802@htj.dyndns.org>
 <50C0E1B6.5060602@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C0E1B6.5060602@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens.

On Thu, Dec 06, 2012 at 07:19:34PM +0100, Jens Axboe wrote:
> We need to expose it. Once the binding is set from the kernel side on a
> kernel thread, it can't be modified.

That's only if kthread_bind() is used.  Caling set_cpus_allowed_ptr()
doesn't set PF_THREAD_BOUND and userland can adjust affinity like any
other tasks.

> Binding either for performance reasons or for ensuring that we
> explicitly don't run in some places is a very useful feature.

Sure, but I think this is too specific.  Something more generic would
be much better.  It can be as simple as generating a uevent.

Thanks.

-- 
tejun

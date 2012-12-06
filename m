Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946688Ab2LFSeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 13:34:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946675Ab2LFSeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 13:34:06 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        Zach Brown <zab@redhat.com>, Peter Zijlstra <pzijlstr@redhat.com>,
        Ingo <mingo@redhat.com>
Subject: Re: [patch,v2] bdi: add a user-tunable cpu_list for the bdi flusher threads
References: <x49lidfnf0s.fsf@segfault.boston.devel.redhat.com>
	<50BE5988.3050501@fusionio.com>
	<x498v9dpnwu.fsf@segfault.boston.devel.redhat.com>
	<50BE5C99.6070703@fusionio.com>
	<x494nk1pi7h.fsf@segfault.boston.devel.redhat.com>
	<20121206180150.GQ19802@htj.dyndns.org>
	<50C0E1B6.5060602@fusionio.com>
	<20121206182239.GS19802@htj.dyndns.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 06 Dec 2012 13:33:57 -0500
In-Reply-To: <20121206182239.GS19802@htj.dyndns.org> (Tejun Heo's message of
	"Thu, 6 Dec 2012 10:22:39 -0800")
Message-ID: <x49zk1rvxm2.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello, Jens.
>
> On Thu, Dec 06, 2012 at 07:19:34PM +0100, Jens Axboe wrote:
>> We need to expose it. Once the binding is set from the kernel side on a
>> kernel thread, it can't be modified.
>
> That's only if kthread_bind() is used.  Caling set_cpus_allowed_ptr()
> doesn't set PF_THREAD_BOUND and userland can adjust affinity like any
> other tasks.
>
>> Binding either for performance reasons or for ensuring that we
>> explicitly don't run in some places is a very useful feature.
>
> Sure, but I think this is too specific.  Something more generic would
> be much better.  It can be as simple as generating a uevent.

I'm in favor of a more general approach.  For now, I'm still going to
push a patch that at least binds to the proper numa node.  I'll post
that after I've tested it.

Cheers,
Jeff

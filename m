Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab0KDEjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 00:39:06 -0400
Received: from brinza.cc.columbia.edu ([128.59.29.8]:56024 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab0KDEjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 00:39:03 -0400
Message-ID: <4CD237EB.6090907@cs.columbia.edu>
Date: Thu, 04 Nov 2010 00:34:51 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Lightning/1.0b1 Thunderbird/3.0.8
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Tejun Heo <tj@kernel.org>, ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu> <4CD08419.5050803@kernel.org> <20101102214706.GA28593@lst.de>
In-Reply-To: <20101102214706.GA28593@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

I really wish you would have raised these concerns during the
ksummit or thereafter. I'm here (LPC) until Friday, and would be
happy to discuss any aspect of the linux-cr while at it (and if
needed can post a summary to the list).

On 11/02/2010 05:47 PM, Christoph Hellwig wrote:
> Thanks Tejun,
> 
> your writeup brought up a lot of the same issues that I see with
> the in-kernel C/R.  Various C/R implementations that are entirely
> in userspace or with limited kernel assistance have been in production
> in HPC environments for years.  I think especially for these workloads
> C/R is an extremly useful feature, and a standard implementation would
> do Linux well.
> 
> But I think the "transparent" in-kernel one is the wrong approach.  It
> tries to give the illusion that C/R will just work, while a lot of
> things are simply not support.  

The fact is that an in-kernel implementation can and does support
a significantly larger feature-set.

Linux-cr does not and will not support everything. Nearly all driver
devices won't be supported in the near future (but interested vendors
could builds such functionality into their drivers!). Also, pseudo
file systems like sysfs, procfs, debugfs will at most get partial
support.

But apart for that, it really covers (or will soon) nearly everything.
So I do wonder what concretely is "a lot of things" ?

> In this case whitelisting the allowed
> state by requiring special APIs for all I/O (or even just standard
> APIs as long as they are supposed by the C/R lib you're linked against)
> is the more pragmatic, and I think faithful aproach.  In addition to
> the amount of state not supported despite looking transparant the

"Transparent" means that applications don't know that they are
being checkpointed, nor do they need to cooperate. So linux-cr
is *completely* transparent to applications that are checkpointable.

Perhaps you can elaborate on the "state not supported despite
looking transparent" - beyond what I mentioned above ?

> other big problem with the patchset is that it saves the kernel internal
> state which changes all the time from one release to another.  

It is our experience that the format is pretty immune to changes
that occur to in-kernel (and not user/ABI visible) structures.
It mainly changes when we add new features - and I expect that
to happen less frequently once the patchset finds its way to the
mainline.

> The
> handwaiving is that a userspace tool will solve it.  I'm pretty sure
> that's not the case; it might solve a few cases but the general
> version n to version m conversion is impossible to maintain.  Just look
> at the problem qemu has migration between just a handfull of version
> of the relatively well (compared to random kernel state) defined vmstate
> format.

The problem space is smaller, because we are aiming at a simpler
goal. We need to always know how to convert from version N to
version N+1. Then conversion from N to N+k is a series of these
conversions.

QEMU has a broader goal: IIUC, both QEMU and KVM versions may
change, they are not tied to each other. So the problem is harder.

In linux-cr, the format is tied to the version of objects that
the kernel that outputs/inputs the data knows. That makes things
much simpler.

Oren.

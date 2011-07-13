Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab1GMMeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 08:34:07 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50468 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab1GMMeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 08:34:06 -0400
Date: Wed, 13 Jul 2011 14:34:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Menage <menage@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH 2/7] cgroups: New resource counter inheritance API
Message-ID: <20110713123357.GE9201@somewhere>
References: <1310393706-321-1-git-send-email-fweisbec@gmail.com>
 <1310393706-321-3-git-send-email-fweisbec@gmail.com>
 <CAJniumXEPUkRpLdfnu3g-NPBH_mEKYmov1P6+6m3+SXh9sZCvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJniumXEPUkRpLdfnu3g-NPBH_mEKYmov1P6+6m3+SXh9sZCvA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 01:41:31PM -0700, Paul Menage wrote:
> On Mon, Jul 11, 2011 at 7:15 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > Provide an API to inherit a counter value from a parent.
> > This can be useful to implement cgroup.clone_children on
> > a resource counter.
> >
> > Still the resources of the children are limited by those
> > of the parent, so this is only to provide a default setting
> > behaviour when clone_children is set.
> >
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Can't this be just:
> 
> void res_counter_inherit(struct res_counter *counter, int member) {
>   struct res_counter *parent;
>   parent = counter->parent;
>   if (parent)
>     res_counter_write_u64(counter, member,
> res_counter_read_u64(parent, member));
> }
> 
> This is just used at cgroup creation time, right? So the performance
> impact of an extra cli/sti shouldn't matter.

Yeah indeed.
 
> Also, looking at the code res_counter_read_u64() appears to not do any
> locking. I don't recall why I added it like that, but it probably
> ought to do at least an atomic64_read().

It does in 32 bits, using the res counter spinlock.

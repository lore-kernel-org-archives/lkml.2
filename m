Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab0GAOz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 10:55:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55555 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab0GAOz5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 10:55:57 -0400
Subject: Re: [PATCH repost] sched: export sched_set/getaffinity to modules
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Sridhar Samudrala <sri@us.ibm.com>,
       netdev <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitri Vorobiev <dmitri.vorobiev@movial.com>,
       Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@linux.intel.com>
In-Reply-To: <4C2CABF2.2020801@kernel.org>
References: <1277983179.1917.10.camel@laptop>
	 <1277984603.1917.15.camel@laptop> <20100701115507.GA31333@redhat.com>
	 <20100701122340.GB31333@redhat.com> <1277987657.1917.32.camel@laptop>
	 <1277988395.1917.47.camel@laptop> <20100701130816.GB32223@redhat.com>
	 <1277991024.1917.108.camel@laptop> <20100701133956.GD32223@redhat.com>
	 <4C2CA5C5.4040402@kernel.org> <20100701144624.GA11171@redhat.com>
	 <4C2CABF2.2020801@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 01 Jul 2010 16:55:35 +0200
Message-ID: <1277996135.1917.198.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-01 at 16:53 +0200, Tejun Heo wrote:
> Hello,
> 
> On 07/01/2010 04:46 PM, Oleg Nesterov wrote:
> >> It might be a good idea to make the function take extra clone flags
> >> but anyways once created cloned task can be treated the same way as
> >> other kthreads, so nothing else needs to be changed.
> > 
> > This makes kthread_stop() work. Otherwise the new thread is just
> > the CLONE_VM child of the caller, and the caller is the user-mode
> > task doing ioctl() ?
> 
> Hmmm, indeed.  It makes the attribute inheritance work but circumvents
> the whole reason there is kthreadd.

I thought the whole reason there was threadd was to avoid the
inheritance? So avoiding the avoiding of inheritance seems like the goal
here, no?

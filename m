Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab2EXHks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 03:40:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33537 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab2EXHkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 03:40:47 -0400
Subject: Re: [PATCH v7 8/8] x86/tlb: just do tlb flush on one of siblings
 of SMT
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Jan Beulich <JBeulich@suse.com>, Alex Shi <alex.shi@intel.com>,
        borislav.petkov@amd.com, arnd@arndb.de, akinobu.mita@gmail.com,
        eric.dumazet@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
        hughd@google.com, jeremy@goop.org, len.brown@intel.com,
        tony.luck@intel.com, yongjie.ren@intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, seto.hidetoshi@jp.fujitsu.com,
        penberg@kernel.org, yinghai@kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, ak@linux.intel.com, avi@redhat.com,
        dhowells@redhat.com, mingo@redhat.com, riel@redhat.com, cpw@sgi.com,
        steiner@sgi.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        hpa@zytor.com
In-Reply-To: <CAObL_7GEzHYV9RbinPmK5D3DkZLiV0Wbz6j8x-Agbi21BM_OgA@mail.gmail.com>
References: <1337782555-8088-1-git-send-email-alex.shi@intel.com>
	 <1337782555-8088-9-git-send-email-alex.shi@intel.com>
	 <4FBD18D20200007800085951@nat28.tlf.novell.com>
	 <1337792984.9783.37.camel@laptop> <1337793338.9783.38.camel@laptop>
	 <CAObL_7GEzHYV9RbinPmK5D3DkZLiV0Wbz6j8x-Agbi21BM_OgA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 May 2012 09:40:30 +0200
Message-ID: <1337845230.9783.51.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 18:46 -0700, Andrew Lutomirski wrote:
> On Wed, May 23, 2012 at 10:15 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, 2012-05-23 at 19:09 +0200, Peter Zijlstra wrote:
> >> > There is no comment or anything else indicating that this is
> >> > suitable for dual-thread CPUs only - when there are more than
> >> > 2 threads per core, the intended effect won't be achieved.
> >>
> >> Why would that be? Won't higher thread count still share the same
> >> resources just more so?
> >
> > Ah, I see, you're saying his code is buggy for >2 threads. Agreed.
> >
> 
> An evil knob to statically choose which SMT sibling gets the interrupt
> would be nice.  Then my compute-intensive thread could be (mostly)
> unaffected by the other thread on a different core that calls munmap
> frequently.

Just make sure the two workloads never share a core and this should
already happen since TLB invalidates are only broadcast to the mm
cpumask.


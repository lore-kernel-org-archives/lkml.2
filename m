Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab0IMUvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:51:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42181 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab0IMUvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:51:40 -0400
Date: Mon, 13 Sep 2010 22:51:37 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com,
        markus.t.metzger@intel.com
Subject: Re: [PATCH] perf_events: improve DS/BTS/PEBS buffer allocation
Message-ID: <20100913225137.042ff889@basil.nowhere.org>
In-Reply-To: <1284407360.2275.431.camel@laptop>
References: <4c8e3c0c.12d1d80a.73d9.ffffcf21@mx.google.com>
	<877hip4et0.fsf@basil.nowhere.org>
	<1284407360.2275.431.camel@laptop>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010 21:49:20 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2010-09-13 at 21:35 +0200, Andi Kleen wrote:
> > Stephane Eranian <eranian@google.com> writes:
> > 
> > > The DS, BTS, and PEBS memory regions were allocated using
> > > kzalloc(), i.e., requesting contiguous physical memory. There is
> > > no such restriction on DS, PEBS and BTS buffers. Using kzalloc()
> > > could lead to error in case no contiguous physical memory is
> > > available. BTS is requesting 64KB, thus it can cause issues. PEBS
> > > is currently only requesting one page. Both PEBS and BTS are
> > > static buffers allocated for each CPU at the first user. When the
> > > last user exists, the buffers are released.
> > 
> > DS supports page tables, but I have some doubts it really 
> > supports page faults. vmalloc today does page faults. 
> > 
> > I think the change is a good idea, but it will need
> > vmalloc_sync_all() everywhere.
> 
> Right, I seem to remember from that last discussion on vmalloc vs NMI
> that vmalloc_sync_all() had some issues, or am I totally
> mis-remembering that?

Linus thought it was ugly, but he never explained why and it was
not obvious to me. 

His proposed replacement wouldn't work for this case.

I am not aware of any real technical issues, except that
it needs to be done for both 32bit and 64bit.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

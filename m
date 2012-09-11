Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759763Ab2IKTba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 15:31:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33774 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab2IKTb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 15:31:28 -0400
Date: Tue, 11 Sep 2012 12:31:24 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Muthu Kumar <muthu.lkml@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk,
        Vivek Goyal <vgoyal@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
        bharrosh@panasas.com, david@fromorbit.com
Subject: Re: [PATCH 2/2] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120911193124.GI19739@google.com>
References: <20120910002810.GA23241@moria.home.lan>
 <20120910172210.GC14103@google.com>
 <20120910202435.GG16360@google.com>
 <20120910204010.GA32310@google.com>
 <20120910213349.GH16360@google.com>
 <20120910213710.GA7677@google.com>
 <20120910215633.GA19739@google.com>
 <CAFR8ued=Le4B4i_Rf4eECXsVgKvce9J7bO9sDSS91PFzBZ6j5w@mail.gmail.com>
 <20120911184553.GT7677@google.com>
 <CAFR8uefj7kxNUHLeppsH8THPzM7XCzT3tOxtuZ0qr4XUe7Bbmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFR8uefj7kxNUHLeppsH8THPzM7XCzT3tOxtuZ0qr4XUe7Bbmw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 11:58:05AM -0700, Muthu Kumar wrote:
> On Tue, Sep 11, 2012 at 11:45 AM, Tejun Heo <tj@kernel.org> wrote:
> > Hello,
> >
> > On Tue, Sep 11, 2012 at 11:36:28AM -0700, Muthu Kumar wrote:
> >> Does this preserve the CPU from which the bio was submitted
> >> originally. Not familiar with cmwq, may be Tejun can clarify.
> >>
> >> Tejun - the question is, do we honor the rq_affinity with the above
> >> rescue worker implementation?
> >
> > The work item would run from the same CPU but there isn't any
> > mechanism to keep track of the issuing CPU if there are multiple bios
> > to be rescued.  Isn't rq_affinity an optimization hint?  If so, I
> > don't think it matters here.
> >
> 
> Thanks... Just worried about performance impact.
> 
> Kent - Anything to validate that the performance is not impacted would
> be really good. Otherwise, the patch looks great.

Well - there'll only be any performance impact at all when we're memory
constrained enough that GFP_NOWAIT allocations fail, which for these
size allocations definitely isn't normal.

I did test it with forcing everything to use the rescuer, and I also
benchmarked Vivek's version - in any sane configuration, the impact of
punting everything to workqueue is not very noticable (the AHCI
interrupt handler uses more cpu).

> 
> Feel free to add:
> 
> Reviewed-by: Muthukumar Ratty <muthur@gmail.com>

Thanks!

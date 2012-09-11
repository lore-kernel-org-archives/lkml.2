Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab2IKUAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 16:00:35 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:54827 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750935Ab2IKUAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 16:00:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120911193124.GI19739@google.com>
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
	<20120911193124.GI19739@google.com>
Date: Tue, 11 Sep 2012 13:00:31 -0700
Message-ID: <CAFR8uedk3KpqhJuMn5rVuDbbWz=VOqt=O7ssFqugHTcw=EZsFw@mail.gmail.com>
Subject: Re: [PATCH 2/2] block: Avoid deadlocks with bio allocation by
 stacking drivers
From: Muthu Kumar <muthu.lkml@gmail.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: Tejun Heo <tj@kernel.org>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk,
        Vivek Goyal <vgoyal@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
        bharrosh@panasas.com, david@fromorbit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kent,

On Tue, Sep 11, 2012 at 12:31 PM, Kent Overstreet
<koverstreet@google.com> wrote:
> On Tue, Sep 11, 2012 at 11:58:05AM -0700, Muthu Kumar wrote:
>> On Tue, Sep 11, 2012 at 11:45 AM, Tejun Heo <tj@kernel.org> wrote:
>> > Hello,
>> >
>> > On Tue, Sep 11, 2012 at 11:36:28AM -0700, Muthu Kumar wrote:
>> >> Does this preserve the CPU from which the bio was submitted
>> >> originally. Not familiar with cmwq, may be Tejun can clarify.
>> >>
>> >> Tejun - the question is, do we honor the rq_affinity with the above
>> >> rescue worker implementation?
>> >
>> > The work item would run from the same CPU but there isn't any
>> > mechanism to keep track of the issuing CPU if there are multiple bios
>> > to be rescued.  Isn't rq_affinity an optimization hint?  If so, I
>> > don't think it matters here.
>> >
>>
>> Thanks... Just worried about performance impact.
>>
>> Kent - Anything to validate that the performance is not impacted would
>> be really good. Otherwise, the patch looks great.
>
> Well - there'll only be any performance impact at all when we're memory
> constrained enough that GFP_NOWAIT allocations fail, which for these
> size allocations definitely isn't normal.


Agreed. If we are in this situation, we are already running in
degraded mode. So performance is not in question.

Regards,
Muthu

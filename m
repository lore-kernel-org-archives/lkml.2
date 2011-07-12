Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab1GLJsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 05:48:24 -0400
Received: from 8bytes.org ([88.198.83.132]:38675 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808Ab1GLJsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 05:48:23 -0400
Date: Tue, 12 Jul 2011 11:48:22 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Will Deacon <will.deacon@arm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 1/3] perf: add context field to perf_event
Message-ID: <20110712094822.GB29812@8bytes.org>
References: <4E1BF5A1.5070301@redhat.com> <1310459898.18678.108.camel@twins> <4E1C0F02.9040906@redhat.com> <1310462046.14978.11.camel@twins> <4E1C10F8.6010300@redhat.com> <1310462335.14978.12.camel@twins> <4E1C1373.5080500@redhat.com> <1310463060.14978.17.camel@twins> <20110712094131.GA29812@8bytes.org> <4E1C1771.9010300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1C1771.9010300@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 12:44:17PM +0300, Avi Kivity wrote:
> On 07/12/2011 12:41 PM, Joerg Roedel wrote:
>> >  Using TIF_bits sounds like a much better solution for this, wakeups are
>> >  really rather expensive and its best to avoid extra if at all possible.
>>
>> I would rather vote for Avi's solution too. Such a functionality is very
>> helpful for LWP-perf integration as well (because we need a way to call
>> do_mmap for a task != current).
>>
>
> It's not needed for that.  See use_mm() (caller must be a kernel thread).

But in our case the caller would be the process that wants to count, not
a kernel thread.

	Joerg


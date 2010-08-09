Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141Ab0HIQeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 12:34:37 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59394 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597Ab0HIQef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 12:34:35 -0400
Subject: Re: [PATCH] kvm: make mmu_shrink() fit shrinker's requirement
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
In-Reply-To: <4C5A844C.60105@redhat.com>
References: <4C591313.50402@cn.fujitsu.com>  <4C5A844C.60105@redhat.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Mon, 09 Aug 2010 09:34:30 -0700
Message-ID: <1281371670.9442.16947.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 12:28 +0300, Avi Kivity wrote:
> On 08/04/2010 10:13 AM, Lai Jiangshan wrote:
> > mmu_shrink() should attempt to free @nr_to_scan entries.
> >
> 
> This conflicts with Dave's patchset.
> 
> Dave, what's going on with those patches?  They're starting to smell.

The hardware and test rig that actually found the original scalability
problem is a bit contended with issues at the moment, so I've been
unable to get the original issue reproduced.

But, I think the patches should be able to stand on their own.  Even in
my testing, it's obvious that the shrinker code gets queries (via
nr_to_shrink=0) *way* more often than it's actually called upon to
shrink things.

Even if we have to come back with some more patches than this in the
future for the original problem that was found, we should feel confident
that this patch set is worthwhile and does some real, quantifiable good
on its own.

I'll go and immediately test that the first four patches in the series
are still behaving themselves in the way that I expect.

-- Dave


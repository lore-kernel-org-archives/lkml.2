Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab1CQQri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 12:47:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867Ab1CQQrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 12:47:36 -0400
Date: Thu, 17 Mar 2011 17:47:26 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Check whether pages are poisoned before copying
Message-ID: <20110317164726.GA10696@random.random>
References: <4D817234.9070106@jp.fujitsu.com>
 <4D8172D7.3040201@jp.fujitsu.com>
 <20110317041424.GD11094@one.firstfloor.org>
 <4D819A2A.8050606@jp.fujitsu.com>
 <20110317062612.GE11094@one.firstfloor.org>
 <4D81BB87.10803@jp.fujitsu.com>
 <20110317140401.GX10696@random.random>
 <20110317152559.GG11094@one.firstfloor.org>
 <20110317161219.GZ10696@random.random>
 <20110317162710.GH11094@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317162710.GH11094@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 05:27:10PM +0100, Andi Kleen wrote:
> > What I can tell is with the default khugepaged scan rate, the
> > collapse_huge_page will have an impact much smaller than KSM. It could
> > have more impact than KSM if you increase khugepaged load to 100% with
> > sysfs (because of the more memory that is covered by khugepaged
> > compared to only the shared portion of KSM). Then the window gets much
> > bigger, but still minor, if you can't trigger it with the testsuite
> > it's even less likely to ever happen in practice.
> 
> You mean randomly injecting errors?
> That tends to be hard and unreliable -- usually we try to have a 
> specific tester that is not random.

I meant the testsuite using MCE injection, called mce-test. I've run
it a couple of times for some hugetlbfs collision with THP (solved
some time ago).

> The measurement is simple: run the workloads and do some dumps
> with pagetypes and check if the memory with lots of pages 
> has a state that can be handled by memory_failure()
> 
> AFAIK  this hasn't been done so far with THP.

I'm unsure if there's already coverage for it in mce-test yet, the
biggest test I run was hugetlbfs related (MAP_ANONYMOUS|MAP_HUGETLB or
filebacked or still shm). Surely it'd be good idea to add THP
coverage.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab2AHCdK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 21:33:10 -0500
Received: from mga14.intel.com ([143.182.124.37]:38189 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab2AHCdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 21:33:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="93506946"
Date: Sun, 8 Jan 2012 10:33:05 +0800
From: Wu Fengguang <wfg@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: =?utf-8?B?0JjQu9GM0Y8g0KLRg9C80LDQudC60LjQvQ==?= 
	<librarian_rus@yahoo.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: A regression in recent 3.2 kernel: bdi_dirty_limit() divide
 error
Message-ID: <20120108023305.GA5074@localhost>
References: <1325884395.57034.YahooMailClassic@web161605.mail.bf1.yahoo.com>
 <20120107145645.GA4997@localhost>
 <1325954125.2442.27.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325954125.2442.27.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 07, 2012 at 05:35:25PM +0100, Peter Zijlstra wrote:
> On Sat, 2012-01-07 at 22:56 +0800, Wu Fengguang wrote:
> > Subject: 
> > Date: Sat Jan 07 22:50:45 CST 2012
> > 
> > The uninitilized shift may lead to denominator=0 in
> > prop_fraction_percpu() and divide error in bdi_dirty_limit().
> 
> I'm not seeing how, only proc_change_shift() can change ->index, and it
> does that after it writes ->pg[index]->shift.

Then I lose the clue why bdi_dirty_limit() will divide error at all.

prop_change_shift() does

        change ->pg[index]->shift
        smp_wmb()
        change ->index

Will the read side prop_fraction_percpu() need some read memory barrier?

Thanks,
Fengguang

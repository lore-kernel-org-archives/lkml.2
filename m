Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab1DZRvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 13:51:40 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:36408 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757538Ab1DZRvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 13:51:39 -0400
Subject: Re: [PATCH] mm: Check if any page in a pageblock is reserved
 before marking it MIGRATE_RESERVE
From: John Stultz <john.stultz@linaro.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        Arve Hj?nnev?g <arve@android.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110426185114.F3A4.A69D9226@jp.fujitsu.com>
References: <1303436043-26644-1-git-send-email-john.stultz@linaro.org>
	 <20110426073410.GA4658@suse.de>
	 <20110426185114.F3A4.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Apr 2011 10:51:20 -0700
Message-ID: <1303840280.2816.71.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-26 at 18:49 +0900, KOSAKI Motohiro wrote:
> > On Thu, Apr 21, 2011 at 06:34:03PM -0700, John Stultz wrote:
> > > From: Arve Hjønnevåg <arve@android.com>
> > > 
> > > This fixes a problem where the first pageblock got marked MIGRATE_RESERVE even
> > > though it only had a few free pages. This in turn caused no contiguous memory
> > > to be reserved and frequent kswapd wakeups that emptied the caches to get more
> > > contiguous memory.
> > > 
> > > CC: Dave Hansen <dave@linux.vnet.ibm.com>
> > > CC: Mel Gorman <mgorman@suse.de>
> > > CC: Andrew Morton <akpm@linux-foundation.org>
> > > Signed-off-by: Arve Hjønnevåg <arve@android.com>
> > > Acked-by: Mel Gorman <mel@csn.ul.ie>
> > > 
> > > [This patch was submitted and acked a little over a year ago
> > > (see: http://lkml.org/lkml/2010/4/6/172 ), but never seemingly
> > > made it upstream. Resending for comments. -jstultz]
> > > 
> > > Signed-off-by: John Stultz <john.stultz@linaro.org>
> > 
> > Whoops, should have spotted it slipped through. FWIW, I'm still happy
> > with my Ack being stuck onto it.
> 
> Hehe, No.
> 
> You acked another patch at last year and John taked up old one. Sigh.
> Look,  correct one has pfn_valid_within(). 
> 	http://lkml.org/lkml/2010/4/6/172

Oh yikes! Many thanks for noticing that detail! Indeed, I started with
the patch in the Android tree, and didn't notice the difference in the
discussion I linked to. My apologies.

> And, Minchan suggested to add more explanation to the description. Then, I think
> following is desiable one.

Thanks so much again!
-john



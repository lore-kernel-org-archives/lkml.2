Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759136Ab1DNPKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 11:10:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759081Ab1DNPKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 11:10:23 -0400
Date: Thu, 14 Apr 2011 17:09:26 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: raz ben yehuda <raziebe@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, riel@redhat.com,
        kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: 2.6.38 sbrk regression
Message-ID: <20110414150925.GD15707@random.random>
References: <1302692638.15225.14.camel@raz.scalemp.com>
 <20110413125146.GR29444@random.random>
 <1302703579.17536.1.camel@raz.scalemp.com>
 <20110413172127.GB5734@random.random>
 <1302781754.5098.13.camel@raz.scalemp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302781754.5098.13.camel@raz.scalemp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 02:49:14PM +0300, raz ben yehuda wrote:
> Hey Andrea
> Me again. I managed to ftrace ( function graph ) the two kernels. I used
> 2.6.37 and 2.6.39-rc3. The bellow is example for sys_brk calls traces
> from each kernel. As you can see, there is no "single smoking gun"
> here. 
> 
> The vm functions durations increased as a whole.
> I repeated the tests from sha1 4e9f64c42d0ba5eb0c78569435ada4c224332ce4
> compared to sha1 152c9ccb75548c027fa3103efa4fa4e19a345449  and it is
> consistent. ~13% performance decrease.
> 

> Can you see any relation to thp that might causes this degradation ?

With compaction and THP off I don't see how it could change
anything.

But can you try the THP-33 tag of my aa.git tree, that was based on
2.3.37-rc5 so it'll rule out the whole THP patchset if it doesn't
regress compared to 2.6.37-rc5 vanilla.

git clone --reference linux-2.6 git://git.kernel.org/pub/scm/linux/kernel/git/andrea/aa.git
git checkout THP-33

Thanks,
Andrea

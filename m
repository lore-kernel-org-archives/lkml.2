Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626Ab1DNUIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 16:08:21 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38993 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab1DNUIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 16:08:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WRA1ShTu8pofl1q+YOGITfihZ2I7kld3t70/RhQDTtg30Vo9A4IimuUA4YrSuj0w3U
         E719RRlSIvc5v4LKpicXvCCkBrErVuFJ5N2VKbh1WUOjWY4XQq0wmItaUpTh3Ly+25gh
         Jb1QLM9Tpq3moLUENESmESWNCMulLXEJVbNdU=
Subject: Re: 2.6.38 page_test regression
From: raz ben yehuda <raziebe@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, riel@redhat.com,
        kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20110414150925.GD15707@random.random>
References: <1302692638.15225.14.camel@raz.scalemp.com>
	 <20110413125146.GR29444@random.random>
	 <1302703579.17536.1.camel@raz.scalemp.com>
	 <20110413172127.GB5734@random.random>
	 <1302781754.5098.13.camel@raz.scalemp.com>
	 <20110414150925.GD15707@random.random>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 23:07:23 +0300
Message-ID: <1302811643.10051.8.camel@raz.scalemp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bah. Mel is correct. I did mean page_test  ( in my defense it is in the
msg ).
Here some more information:
1. I manage to lower the regression to 2 sha1's:
    	32dba98e085f8b2b4345887df9abf5e0e93bfc12 to
71e3aac0724ffe8918992d76acfe3aad7d8724a5. 
	though I had to remark wait_split_huge_page for the sake of
compilation. up to 32dba98e085f8b2b4345887df9abf5e0e93bfc12 there is no
regression.

2. I booted 2.6.37-rc5 you gave me. same regression is there. 

raz


On Thu, 2011-04-14 at 17:09 +0200, Andrea Arcangeli wrote:
> On Thu, Apr 14, 2011 at 02:49:14PM +0300, raz ben yehuda wrote:
> > Hey Andrea
> > Me again. I managed to ftrace ( function graph ) the two kernels. I used
> > 2.6.37 and 2.6.39-rc3. The bellow is example for sys_brk calls traces
> > from each kernel. As you can see, there is no "single smoking gun"
> > here. 
> > 
> > The vm functions durations increased as a whole.
> > I repeated the tests from sha1 4e9f64c42d0ba5eb0c78569435ada4c224332ce4
> > compared to sha1 152c9ccb75548c027fa3103efa4fa4e19a345449  and it is
> > consistent. ~13% performance decrease.
> > 
> 
> > Can you see any relation to thp that might causes this degradation ?
> 
> With compaction and THP off I don't see how it could change
> anything.
> 
> But can you try the THP-33 tag of my aa.git tree, that was based on
> 2.3.37-rc5 so it'll rule out the whole THP patchset if it doesn't
> regress compared to 2.6.37-rc5 vanilla.
> 
> git clone --reference linux-2.6 git://git.kernel.org/pub/scm/linux/kernel/git/andrea/aa.git
> git checkout THP-33
> 
> Thanks,
> Andrea



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab2AGO4y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 09:56:54 -0500
Received: from mga03.intel.com ([143.182.124.21]:15601 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab2AGO4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 09:56:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="93416404"
Date: Sat, 7 Jan 2012 22:56:45 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: =?utf-8?B?0JjQu9GM0Y8g0KLRg9C80LDQudC60LjQvQ==?= 
	<librarian_rus@yahoo.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: A regression in recent 3.2 kernel: bdi_dirty_limit() divide
 error
Message-ID: <20120107145645.GA4997@localhost>
References: <1325884395.57034.YahooMailClassic@web161605.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1325884395.57034.YahooMailClassic@web161605.mail.bf1.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Ilya,

Thanks for the report!
Would you try if the attached patch can fix it?

Thanks,
Fengguang

On Fri, Jan 06, 2012 at 01:13:15PM -0800, Илья Тумайкин wrote:
> Hello, Mr. Fengguang.
> 
> As you know the 3.2 version of Linux kernel was just released, so I decided to try it out. After I sucessfully compiled it with the  previously used configuration file a bug appeared: as soon as I try to log into X, the kernel crashes producing the trace which you can see in the attachements. In terminal or when just running kdm everything is ok, also everything is completely stable with 3.1.7, so I've guessed it is kernel regression. After some playing with 'git bisect' it has pinpointed me to this commit:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7381131cbcf7e15d201a0ffd782a4698efe4e740
> 
> That's why I've sent you this mail. I've attached several photos of different traces which I got during bisecting (nothing hit the log or very small pieces of info). If any addtional info is needed I am ready to provide it to you.
> 
> OS: Gentoo amd64 with vanilla 3.2 kernel.
> 
> Best regards.
> Ilya Tumaykin.







--IS0zKkzwUGydFO0o
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="proportion-init-shift.patch"

Subject: 
Date: Sat Jan 07 22:50:45 CST 2012

The uninitilized shift may lead to denominator=0 in
prop_fraction_percpu() and divide error in bdi_dirty_limit().

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 lib/proportions.c |    1 +
 1 file changed, 1 insertion(+)

--- linux.orig/lib/proportions.c	2012-01-07 22:50:29.000000000 +0800
+++ linux/lib/proportions.c	2012-01-07 22:50:37.000000000 +0800
@@ -82,6 +82,7 @@ int prop_descriptor_init(struct prop_des
 
 	pd->index = 0;
 	pd->pg[0].shift = shift;
+	pd->pg[1].shift = shift;
 	mutex_init(&pd->mutex);
 	err = percpu_counter_init(&pd->pg[0].events, 0);
 	if (err)

--IS0zKkzwUGydFO0o--

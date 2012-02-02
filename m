Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab2BBUTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:19:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab2BBUTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:19:14 -0500
Date: Thu, 2 Feb 2012 12:19:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Venkatesh Pallipadi <venki@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Avoid mask based num_possible_cpus and num_online_cpus
 -v5
Message-Id: <20120202121912.c82a185e.akpm@linux-foundation.org>
In-Reply-To: <87d39xj955.fsf@rustcorp.com.au>
References: <CABeCy1aPp4=v90v_wAsw-KWDwNs59CwwYSJ-36+4t8kMuCaK0w@mail.gmail.com>
	<1328055439-9441-1-git-send-email-venki@google.com>
	<20120201140125.c656df41.akpm@linux-foundation.org>
	<87d39xj955.fsf@rustcorp.com.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Feb 2012 06:33:02 +1030
Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Wed, 1 Feb 2012 14:01:25 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > Though most of the callers of these two routines are init time (with few
> > > exceptions of runtime calls), it is cleaner to use variables
> > > and not go through this repeated mask based calculation.
> > 
> > Looks good to me.
> 
> But, I wonder who's asking num_possible_cpus().  It's not a very useful
> thing to know, though some arch's "know" it's contiguous, so can cheat.
> 
> Optimizing it seems particularly foolish.

We're fools for optimisations!

> We either audit and wean
> everyone off who's using it incorrectly, or insist on contiguous CPU
> numbers and drop the mask altogether.

drivers/block/nvme.c looks like it's assuming a contiguous map.  Maybe
also drivers/scsi/bnx2fc (wtf?).  I didn't see anything else outside
arch code.


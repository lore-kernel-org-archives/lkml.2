Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119Ab2HQWWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 18:22:11 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:28527 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757158Ab2HQWWD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 18:22:03 -0400
MIME-Version: 1.0
Message-ID: <8fa37327-17ff-4734-9007-40412b18d0fb@default>
Date: Fri, 17 Aug 2012 15:21:22 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Kurt Hackel <kurt.hackel@oracle.com>
Subject: RE: [PATCH 0/4] promote zcache from staging
References: <1343413117-1989-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <5021795A.5000509@linux.vnet.ibm.com> <5024067F.3010602@linux.vnet.ibm.com>
 <2e9ccb4f-1339-4c26-88dd-ea294b022127@default>
 <50254F69.2000409@linux.vnet.ibm.com>
In-Reply-To: <50254F69.2000409@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Subject: Re: [PATCH 0/4] promote zcache from staging
> 
> On 08/09/2012 03:20 PM, Dan Magenheimer wrote
> > I also wonder if you have anything else unusual in your
> > test setup, such as a fast swap disk (mine is a partition
> > on the same rotating disk as source and target of the kernel build,
> > the default install for a RHEL6 system)?
> 
> I'm using a normal SATA HDD with two partitions, one for
> swap and the other an ext3 filesystem with the kernel source.
> 
> > Or have you disabled cleancache?
> 
> Yes, I _did_ disable cleancache.  I could see where having
> cleancache enabled could explain the difference in results.

Sorry to beat a dead horse, but I meant to report this
earlier in the week and got tied up by other things.

I finally got my test scaffold set up earlier this week
to try to reproduce my "bad" numbers with the RHEL6-ish
config file.

I found that with "make -j28" and "make -j32" I experienced
__DATA CORRUPTION__.  This was repeatable.

The type of error led me to believe that the problem was
due to concurrency of cleancache reclaim.  I did not try
with cleancache disabled to prove/support this theory
but it is consistent with the fact that you (Seth) have not
seen a similar problem and has disabled cleancache.

While this problem is most likely in my code and I am
suitably chagrined, it re-emphasizes the fact that
the current zcache in staging is 20-month old "demo"
code.  The proposed new zcache codebase handles concurrency
much more effectively.

I'll be away from email for a few days now.

Dan

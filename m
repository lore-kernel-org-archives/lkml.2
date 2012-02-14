Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761387Ab2BNXns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 18:43:48 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:18550 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340Ab2BNXnq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 18:43:46 -0500
MIME-Version: 1.0
Message-ID: <443c718c-643b-4b48-9dd8-e0424fc0afa9@default>
Date: Tue, 14 Feb 2012 15:43:31 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>, Konrad Wilk <konrad.wilk@oracle.com>
Subject: RE: linux-next: build failure after merge of the staging tree
References: <20120210155800.ccef418fd5c2f2b87a5d6315@canb.auug.org.au>
 <20120210052947.GA2068@kroah.com>
 <80f07411-179e-4fe9-b591-32fbcaac414b@default>
 <20120210174359.GB5128@kroah.com>
In-Reply-To: <20120210174359.GB5128@kroah.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090206.4F3AF1AA.003F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Subject: Re: linux-next: build failure after merge of the staging tree
> 
> On Fri, Feb 10, 2012 at 09:21:46AM -0800, Dan Magenheimer wrote:
> > > From: Greg KH [mailto:greg@kroah.com]
> > > Subject: Re: linux-next: build failure after merge of the staging tree
> > >
> > > On Fri, Feb 10, 2012 at 03:58:00PM +1100, Stephen Rothwell wrote:
> > > > Hi Greg,
> > > >
> > > > After merging the staging tree, today's linux-next build (x86_64
> > > > allmodconfig) failed like this:
> > > >
> > > > drivers/staging/ramster/ramster_o2net.c: In function 'ramster_remote_async_get_request_handler':
> > > > drivers/staging/ramster/ramster_o2net.c:91:2: error: implicit declaration of function
> > > 'o2net_force_data_magic' [-Werror=implicit-function-declaration]
> > > > drivers/staging/ramster/ramster_o2net.c: In function 'ramster_remote_put':
> > > > drivers/staging/ramster/ramster_o2net.c:250:2: error: implicit declaration of function
> > > 'o2net_nn_from_num' [-Werror=implicit-function-declaration]
> > > > drivers/staging/ramster/zcache-main.c:40:64: fatal error: ../zram/xvmalloc.h: No such file or
> > > directory
> > > >
> > > > Caused by commits ba351b02ab11 ("staging: ramster: local compression +
> > > > tmem") and 14a3cd58dd4f ("staging: ramster: ramster-specific new files").
> > > >
> > > > I have used the version of the staging tree from next-20120209 for today.
> > >
> > > Ugh, I wonder why it builds here, very odd.
> > >
> > > Dan, care to send me a patch to fix this?
> >
> > > > drivers/staging/ramster/zcache-main.c:40:64: fatal error: ../zram/xvmalloc.h: No such
> >
> > Hmmm... it appears that Seth's zsmalloc patch for drivers/staging/zcache
> > removed xvmalloc.[ch] from drivers/staging/zram while drivers/staging/ramster
> > is still depending on it. :-(  I hadn't planned for both ramster
> > and zsmalloc-replacing-xvmalloc to be merged at the same time... I guess
> > this is exactly the kind of problem linux-next is designed to wring out!
> >
> > Greg, FOR NOW, PLEASE JUST REVERT the ramster patchset from staging-next.
> > I am working on a v5 anyway and will roll in a copy of the xvmalloc.[ch]
> > code into it for now and, since Seth's patch should be in linux-next
> > by the time I am done (hopefully next week), I can test build ramster v5
> > with linux-next to ensure all the above problems are resolved before
> > resubmitting.
> >
> > (Seth, I could also switch ramster v5 to depend on zsmalloc instead of
> > xvmalloc, but since I've done all my ramster testing on xvmalloc,
> > I think I would prefer to make that transition later.)
> >
> > Sorry, Stephen and Greg, for the hassle!
> 
> Ok, now reverted, what a mess...
> 
> greg k-h

OK, I have just posted the ramster v5 patchset which applies against
linux-3.2.  I've test-built it against linux-next... it only gets
the normal minor merge conflicts for adding a line to
drivers/staging/Makefile and Kconfig.

Sorry again for the inconvenience.  At least V5 has some nice
improvements over V4, see: https://lkml.org/lkml/2012/2/14/396 

Thanks,
Dan

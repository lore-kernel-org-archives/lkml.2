Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab0IOTZC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 15:25:02 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:54487 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab0IOTZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 15:25:01 -0400
From: "Tim Pepper" <lnxninja@linux.vnet.ibm.com>
Date: Wed, 15 Sep 2010 12:24:55 -0700
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, lnxninja@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH] update /proc/sys/vm/drop_caches documentation
Message-ID: <20100915192454.GD5585@tpepper-t61p.dolavim.us>
References: <20100914234714.8AF506EA@kernel.beaverton.ibm.com>
 <20100915133303.0b232671.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100915133303.0b232671.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 15 Sep at 13:33:03 +0900 kamezawa.hiroyu@jp.fujitsu.com said:
> >  
> > diff -puN fs/drop_caches.c~update-drop_caches-documentation fs/drop_caches.c
> > --- linux-2.6.git/fs/drop_caches.c~update-drop_caches-documentation	2010-09-14 15:44:29.000000000 -0700
> > +++ linux-2.6.git-dave/fs/drop_caches.c	2010-09-14 15:58:31.000000000 -0700
> > @@ -47,6 +47,8 @@ int drop_caches_sysctl_handler(ctl_table
> >  {
> >  	proc_dointvec_minmax(table, write, buffer, length, ppos);
> >  	if (write) {
> > +		WARN_ONCE(1, "kernel caches forcefully dropped, "
> > +			     "see Documentation/sysctl/vm.txt\n");
> 
> Documentation updeta seems good but showing warning seems to be meddling to me.

We already have examples of things where we warn in order to turn up
"interesting" userspace code, in the hope of starting dialog and getting
things fixed for the future.  I don't see this so much as meddling as
one of the fundamental aspects of open source.

drop_caches probably originally should have gone in under a CONFIG_DEBUG
(even if all the distros would have turned it on), and had a WARN_ON
(personally I'd argue for this compared to WARN_ONCE()), and even have
been exposed in debugfs not procfs...but it's part of the "the interface"
at this point.

Somebody doing debug and testing which leverages drop_caches should not
be bothered by a WARN_ON().  Somebody using it to "fix" the kernel with
repeated/regular calls to drop_caches should get called out for fixing
themselves and the WARN_*()'s noting the comm could help that, unless
somebody has a use case where repeated/regular calls to drop_caches
is valid and not connected to buggy usage or explicit performance
debug/testing?

-- 
Tim Pepper  <lnxninja@linux.vnet.ibm.com>
IBM Linux Technology Center

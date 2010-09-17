Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab0IQPyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:54:10 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43307 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755419Ab0IQPyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:54:06 -0400
Subject: Re: [RFCv2][PATCH] add some drop_caches documentation and info
 messsge
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lnxninja@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
        ebiederm@xmission.com
In-Reply-To: <20100917092603.3BD5.A69D9226@jp.fujitsu.com>
References: <20100916165047.DAD42998@kernel.beaverton.ibm.com>
	 <20100917092603.3BD5.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Fri, 17 Sep 2010 08:54:01 -0700
Message-ID: <1284738841.25231.4387.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-17 at 09:26 +0900, KOSAKI Motohiro wrote:
> > diff -puN fs/drop_caches.c~update-drop_caches-documentation fs/drop_caches.c
> > --- linux-2.6.git/fs/drop_caches.c~update-drop_caches-documentation	2010-09-16 09:43:52.000000000 -0700
> > +++ linux-2.6.git-dave/fs/drop_caches.c	2010-09-16 09:43:52.000000000 -0700
> > @@ -47,6 +47,8 @@ int drop_caches_sysctl_handler(ctl_table
> >  {
> >  	proc_dointvec_minmax(table, write, buffer, length, ppos);
> >  	if (write) {
> > +		printk(KERN_NOTICE "%s (%d): dropped kernel caches: %d\n",
> > +			current->comm, task_pid_nr(current), sysctl_drop_caches);
> >  		if (sysctl_drop_caches & 1)
> >  			iterate_supers(drop_pagecache_sb, NULL);
> >  		if (sysctl_drop_caches & 2)
> 
> Can't you print it only once?

Sure.  But, I also figured that somebody calling it every minute is
going to be much more interesting than something just on startup.
Should we printk_ratelimit() it, perhaps?

-- Dave


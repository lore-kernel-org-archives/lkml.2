Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab0IOGO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 02:14:28 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60384 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab0IOGO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 02:14:27 -0400
Subject: Re: [RFC][PATCH] update /proc/sys/vm/drop_caches documentation
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lnxninja@linux.vnet.ibm.com
In-Reply-To: <20100915135016.C9F1.A69D9226@jp.fujitsu.com>
References: <20100914234714.8AF506EA@kernel.beaverton.ibm.com>
	 <20100915133303.0b232671.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100915135016.C9F1.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Tue, 14 Sep 2010 23:14:22 -0700
Message-ID: <1284531262.27089.15725.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-15 at 13:53 +0900, KOSAKI Motohiro wrote:
> > >  ==============================================================
> > >  
> > > diff -puN fs/drop_caches.c~update-drop_caches-documentation fs/drop_caches.c
> > > --- linux-2.6.git/fs/drop_caches.c~update-drop_caches-documentation	2010-09-14 15:44:29.000000000 -0700
> > > +++ linux-2.6.git-dave/fs/drop_caches.c	2010-09-14 15:58:31.000000000 -0700
> > > @@ -47,6 +47,8 @@ int drop_caches_sysctl_handler(ctl_table
> > >  {
> > >  	proc_dointvec_minmax(table, write, buffer, length, ppos);
> > >  	if (write) {
> > > +		WARN_ONCE(1, "kernel caches forcefully dropped, "
> > > +			     "see Documentation/sysctl/vm.txt\n");
> > 
> > Documentation updeta seems good but showing warning seems to be meddling to me.
> 
> Agreed.
> 
> If the motivation is blog's bogus rumor, this is no effective. I easily
> imazine they will write "Hey, drop_caches may output strange message, 
> but please ignore it!".

Fair enough.  But, is there a point that we _should_ be warning?  If
someone is doing this every minute, or every hour, something is pretty
broken.  Should we at least be doing a WARN_ON() so that the TAINT_WARN
is set?

I'm worried that there are users out there experiencing real problems
that aren't reporting it because "workarounds" like this just paper over
the issue.

-- Dave


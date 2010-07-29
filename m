Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158Ab0G2XVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 19:21:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61600 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab0G2XVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 19:21:34 -0400
X-Authority-Analysis: v=1.1 cv=rsPCLZWyMDYHS6UYEmJ4E6URGqccNA0A37lrbq4bmic= c=1 sm=0 a=BtHjyF6zVRsA:10 a=kj9zAlcOel0A:10 a=Nqdp4+S2FArj7gZzHVn+tA==:17 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=QmGmV2LSw2OV1NK-1mwA:9 a=k1OY8TEASf_YsEAof-4A:7 a=MK5ZSFKKvayEB0D_C6OqdYF150EA:4 a=CjuIK1q_8ugA:10 a=Nqdp4+S2FArj7gZzHVn+tA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.120.198.24
Date: Thu, 29 Jul 2010 18:23:52 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <dlezcano@free.fr>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Paul Menage <menage@google.com>
Subject: Re: Remaining work for userns (WAS Re: [PATCH 3/3] cgroup : remove
 the ns_cgroup)
Message-ID: <20100729232352.GC13902@hallyn.com>
References: <20100729195629.GA13378@hallyn.com>
 <20100729195812.GB19015@hallyn.com>
 <20100729214008.GA2785@count0.beaverton.ibm.com>
 <20100729223957.GA12387@hallyn.com>
 <20100729230052.GB2785@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100729230052.GB2785@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Matt Helsley (matthltc@us.ibm.com):
> On Thu, Jul 29, 2010 at 05:39:57PM -0500, Serge E. Hallyn wrote:
> > Quoting Matt Helsley (matthltc@us.ibm.com):
> > > On Thu, Jul 29, 2010 at 02:58:12PM -0500, Serge E. Hallyn wrote:
> 
> <snip>
> 
> > 
> > BTW in the past the only reason I saw for keeping ns cgroup was
> > to lock tasks into a devices cgroup.  Until that lazy guy who was
> > going to do it gets off his butt and implements user namespaces,
> > you'll just have to use LSMs, which is the right way.
> 
> And the only missing piece of userns is replacing the cred checks
> right? If so, it might be possible to come up with a coccinelle semantic
> patch which would do all/most of the hard work -- depends on whether the
> all the checks fit a small number of semantic patterns.

I think the thing that always puts the brakes on when I get started
is siginfo_t.  We need some way to reference user namespaces in there,
without enforcing lifetime rules on siginfo.

What you mention is definately a chunk as well, so if you are interested
in pursuing that that'd be great.

Also, reviewing the patches at the top of
http://git.kernel.org/?p=linux/kernel/git/sergeh/linux-cr.git;a=shortlog;h=refs/heads/userns.feb16.1
to give us some fresh feedback on the general approach is
valuable.

And from there, the whole discussion (which we've had several times
in the past) about how to have the VFS map userids should probably be
had again.  (I believe august 2008 was the last time we really got
into that)

thanks,
-serge

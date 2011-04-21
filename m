Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab1DUGKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 02:10:42 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41672 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab1DUGKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 02:10:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [Stable-review] [48/70] vmscan: all_unreclaimable() use zone->all_unreclaimable as a name
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, Nick Piggin <npiggin@kernel.dk>,
        David Rientjes <rientjes@google.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <gregkh@suse.de>
In-Reply-To: <1303361579.3464.168.camel@localhost>
References: <20110421132442.7327.A69D9226@jp.fujitsu.com> <1303361579.3464.168.camel@localhost>
Message-Id: <20110421151117.733D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Thu, 21 Apr 2011 15:10:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 2011-04-21 at 13:24 +0900, KOSAKI Motohiro wrote:
> > > On Tue, 2011-04-19 at 13:08 -0700, Greg KH wrote:
> > > > 2.6.38-stable review patch.  If anyone has any objections, please let us know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > > 
> > > > commit 929bea7c714220fc76ce3f75bef9056477c28e74 upstream.
> > > > 
> > > > all_unreclaimable check in direct reclaim has been introduced at 2.6.19
> > > > by following commit.
> > > > 
> > > > 	2006 Sep 25; commit 408d8544; oom: use unreclaimable info
> > > > 
> > > > And it went through strange history. firstly, following commit broke
> > > > the logic unintentionally.
> > > > 
> > > > 	2008 Apr 29; commit a41f24ea; page allocator: smarter retry of
> > > > 				      costly-order allocations
> > > [...]
> > > 
> > > So presumably this needs to be fixed in 2.6.32.y and other longterm
> > > series as well.  Though there seems to be a whole series of fixes
> > > required in 2.6.32.y!
> > > 
> > > Are you going to look after that, or should someone else prepare
> > > backports?  (I'm certainly not volunteering - I don't have the VM
> > > knowledge to work out what needs doing.)
> > 
> > Hi Ben
> > 
> > Honestly, I didn't prepare. If my remember is correct, you are debian 
> > guy. So, Can I think the backport 2.6.32.y help debian people? If so,
> > it's good thing to increase my priority to do this.
> 
> Most of the 'enterprise' and long-term supported distributions (Debian,
> Ubuntu, SLE, OEL and RHEL) have kernels based on 2.6.32.  RH seem to be
> doing their own thing but the rest of us are using 2.6.32.y as a basis.

I've finished see current head of longterm-2.6.32. It has

        2006 Sep 25; commit 408d8544; oom: use unreclaimable info
        2008 Apr 29; commit a41f24ea; page allocator: smarter retry of
                                      costly-order allocations

and, doesn't have

        2010 Jun 04; commit bb21c7ce; vmscan: fix do_try_to_free_pages()
                                      return value when priority==0
        2010 Sep 22: commit d1908362: vmscan: check all_unreclaimable
                                      in direct reclaim path
        2011 Apr 14 commit 929bea7c7: vmscan: all_unreclaimable() use 
                                      zone->all_unreclaimable as a name

Then, the code mean
 1) commit 408d8544 doesn't works as well.
 2) But, there is no hangup risk as commit 929bea7c7 described.

So, I think there is no worth to backport. Two years no bug report mean
it's no big matter. And we can't make a patch which include the above
three patch and its dependencies smaller than 100 lines.

Thanks.



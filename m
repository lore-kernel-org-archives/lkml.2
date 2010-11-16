Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933948Ab0KPHE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 02:04:58 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:54591 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933886Ab0KPHE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 02:04:57 -0500
Date: Tue, 16 Nov 2010 16:04:21 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "shaohui.zheng@linux.intel.com" <shaohui.zheng@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [v2,5/8] NUMA Hotplug emulator
Message-ID: <20101116070421.GB1330@linux-sh.org>
References: <20101116041330.GA20694@shaohui> <20101116054747.GA1064@linux-sh.org> <A24AE1FFE7AEC5489F83450EE98351BF27D53BCC36@shsmsx502.ccr.corp.intel.com> <20101116050507.GA21317@shaohui>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116050507.GA21317@shaohui>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 01:05:07PM +0800, Shaohui Zheng wrote:
> > 
> > On Tue, Nov 16, 2010 at 12:13:30PM +0800, Shaohui Zheng wrote:
> > > >This looks like an incredibly painful interface. How about scrapping all
> > > >of this _emu() mess and just reworking the register_cpu() interface?
> > > > Something like:
> > > 
> > > hi, Paul
> > > 	I saw your reply on patchwork.kernel.org, but I did not find your email 
> > > in my mailbox, you might forget to cc to me.
> > > 
> > Then fix your mailer. You are presently forcing Mail-Followup-To to the
> > list, which in turn is dropping you from the cc on a group reply.
> 
> My mailer is mutt, and I did not configure "Mail-Follow-To", it should use the
> default value. I add "set followup_to=no" to my ~/muttrc file now.
> 
> Hope it is got fixed, thanks you for your remind.
> 
Yes, it's fixed now!

> > > 	I think that your register_cpu_node interface seems good, but this will 
> > > remove the interface register_cpu. it is not the original purpose of the 
> > > emulator, we want to emulate the oringal process, but we did not want to change
> > > the old interface, that is a rule.
> > > 
> > Wait, what? How does my patch remove register_cpu()? It does no such
> > thing, all it does is add a supplemental register_cpu_node() for you to
> > call in to, without needing to carry any of the _emu() damage around. The
> > old interface has not been modified in any way whatsoever.
> 
> I recheck your patch, It seems that I misunderstand it. with your function
> register_cpu_node, we can call it in arch_cpu_probe, and then we need not the _emu()
> any more. Our _emu() functions work, but it get thing complicated. :)
> 
> I will rework patch 4 and patch 5 with your suggestion, thanks.
> 
Perhaps the easiest is just to insert my patch in to your series as a
standalone thing and then build on top of it for your patches 4 and 5. If
you wish to do this, then you can of course add my Signed-off-by for
that.

Also, are you doing this development in a git tree somewhere? I'd like to
get it going on top of SH also, so it would be nice to have a point of
reference for keeping things in sync (otherwise I'll just make a topic
branch with your newest version and send you updates incrementally). 

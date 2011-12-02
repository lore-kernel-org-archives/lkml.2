Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab1LBFtG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 00:49:06 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46134 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab1LBFtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 00:49:04 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 2 Dec 2011 14:47:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Jason Baron <jbaron@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        rostedt@goodmis.org
Subject: Re: [PATCH] jump_label: jump_label for boot options.
Message-Id: <20111202144748.7fa32a57.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1322804045.4755.13.camel@marge.simson.net>
References: <20111201115353.563f79fc.kamezawa.hiroyu@jp.fujitsu.com>
	<20111201154036.GA2443@redhat.com>
	<20111202092837.58e11827.kamezawa.hiroyu@jp.fujitsu.com>
	<1322804045.4755.13.camel@marge.simson.net>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Dec 2011 06:34:05 +0100
Mike Galbraith <efault@gmx.de> wrote:

> On Fri, 2011-12-02 at 09:28 +0900, KAMEZAWA Hiroyuki wrote:
> > On Thu, 1 Dec 2011 10:40:36 -0500
> > Jason Baron <jbaron@redhat.com> wrote:
> > 
> > > On Thu, Dec 01, 2011 at 11:53:53AM +0900, KAMEZAWA Hiroyuki wrote:
> > > > I tried to use jump_label for handling memcg's boot options which sets
> > > > global variable true/false and never changes after boot. And found jump_table
> > > > is larger than expected. This patch is a trial to allow to place jump_table
> > > > in .init section. How do you think ?
> > > > 
> > > 
> > > Remeber too, that 'static_branch()' is inherently biased. That is, the
> > > 'false' path is assumed to be the the most likely path. Thus, the 'true'
> > > path is move out-of-line. Thus, if the 'true' branch is potentially
> > > used all the time, we would want to make sure that the savings of not
> > > having to check a variable is still worth it. I should probably rename
> > > static_branch() -> 'static_branch_default_false()' to make that clear.
> > > 
> > Thank you for pointing out.
> > 
> > My assumption is that it's disabled at boot by few people because sane
> > people will not config memcg if they don't want. Most of distro users
> > will not turn off it...
> 
> I think that's a bad assumption.  I see a lot of cgroup_disable=memory
> command lines, and _always_ add it to grub when installing "everything
> plus the kitchen sink" distro kernels on my boxen. 
> 
Ok, I stop this work.

Thanks,
-Kame


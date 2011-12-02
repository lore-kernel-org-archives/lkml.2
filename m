Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab1LBFeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 00:34:17 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:57227 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751602Ab1LBFeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 00:34:13 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX196intZjlV6Tk4ZDM0js0AoYLT71TjGSIbX3eai4r
	ATrsoO4I8NJi2p
Subject: Re: [PATCH] jump_label: jump_label for boot options.
From: Mike Galbraith <efault@gmx.de>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jason Baron <jbaron@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        rostedt@goodmis.org
In-Reply-To: <20111202092837.58e11827.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111201115353.563f79fc.kamezawa.hiroyu@jp.fujitsu.com>
	 <20111201154036.GA2443@redhat.com>
	 <20111202092837.58e11827.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Dec 2011 06:34:05 +0100
Message-ID: <1322804045.4755.13.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-02 at 09:28 +0900, KAMEZAWA Hiroyuki wrote:
> On Thu, 1 Dec 2011 10:40:36 -0500
> Jason Baron <jbaron@redhat.com> wrote:
> 
> > On Thu, Dec 01, 2011 at 11:53:53AM +0900, KAMEZAWA Hiroyuki wrote:
> > > I tried to use jump_label for handling memcg's boot options which sets
> > > global variable true/false and never changes after boot. And found jump_table
> > > is larger than expected. This patch is a trial to allow to place jump_table
> > > in .init section. How do you think ?
> > > 
> > 
> > Remeber too, that 'static_branch()' is inherently biased. That is, the
> > 'false' path is assumed to be the the most likely path. Thus, the 'true'
> > path is move out-of-line. Thus, if the 'true' branch is potentially
> > used all the time, we would want to make sure that the savings of not
> > having to check a variable is still worth it. I should probably rename
> > static_branch() -> 'static_branch_default_false()' to make that clear.
> > 
> Thank you for pointing out.
> 
> My assumption is that it's disabled at boot by few people because sane
> people will not config memcg if they don't want. Most of distro users
> will not turn off it...

I think that's a bad assumption.  I see a lot of cgroup_disable=memory
command lines, and _always_ add it to grub when installing "everything
plus the kitchen sink" distro kernels on my boxen. 

	-Mike


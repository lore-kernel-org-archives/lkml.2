Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab1LBA3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 19:29:49 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54670 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935Ab1LBA3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 19:29:48 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 2 Dec 2011 09:28:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Jason Baron <jbaron@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        rostedt@goodmis.org
Subject: Re: [PATCH] jump_label: jump_label for boot options.
Message-Id: <20111202092837.58e11827.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111201154036.GA2443@redhat.com>
References: <20111201115353.563f79fc.kamezawa.hiroyu@jp.fujitsu.com>
	<20111201154036.GA2443@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Dec 2011 10:40:36 -0500
Jason Baron <jbaron@redhat.com> wrote:

> On Thu, Dec 01, 2011 at 11:53:53AM +0900, KAMEZAWA Hiroyuki wrote:
> > I tried to use jump_label for handling memcg's boot options which sets
> > global variable true/false and never changes after boot. And found jump_table
> > is larger than expected. This patch is a trial to allow to place jump_table
> > in .init section. How do you think ?
> > 
> 
> Remeber too, that 'static_branch()' is inherently biased. That is, the
> 'false' path is assumed to be the the most likely path. Thus, the 'true'
> path is move out-of-line. Thus, if the 'true' branch is potentially
> used all the time, we would want to make sure that the savings of not
> having to check a variable is still worth it. I should probably rename
> static_branch() -> 'static_branch_default_false()' to make that clear.
> 
Thank you for pointing out.

My assumption is that it's disabled at boot by few people because sane
people will not config memcg if they don't want. Most of distro users
will not turn off it...



Thanks,
-Kame


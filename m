Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab0JVV5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 17:57:15 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49976 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929Ab0JVV5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 17:57:14 -0400
Date: Fri, 22 Oct 2010 14:57:08 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        "akpm >> Andrew Morton" <akpm@linux-foundation.org>,
        Paul Menage <menage@google.com>
Subject: Re: [PATCH 5/7] cgroups: Make freezer subsystem bindable
Message-ID: <20101022215708.GM10119@count0.beaverton.ibm.com>
References: <4CC146A4.9090505@cn.fujitsu.com>
 <4CC1473D.9070201@cn.fujitsu.com>
 <20101022205755.GJ10119@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101022205755.GJ10119@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 01:57:55PM -0700, Matt Helsley wrote:
> On Fri, Oct 22, 2010 at 04:11:41PM +0800, Li Zefan wrote:
> > To make it bindable, we need to thaw all processes when unbinding
> > the freezer subsystem from a cgroup hierarchy.
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Based on experience using cgroups and questions we've fielded in the
> past on IRC I'd say users will really appreciate this.
> 
> We're planning to use the freezer in checkpoint/restart. Since
> checkpoint requires the tasks to remain frozen for the duration of
> the syscall we add a kernel-internal freezer subsystem interface
> which prevents the cgroup from thawing. So we'll need some way to
> "block" unbinding for that as well.

And in case you're curious here are the portions of the checkpoint/restart
tree which implement the above:

http://www.linux-cr.org/git/?p=linux-cr.git;a=commitdiff;h=a584c1c6b729a544c76cbb173ce62ffb6575b1d3
http://www.linux-cr.org/git/?p=linux-cr.git;a=commitdiff;h=34869146ecd662352c0024e0769ec77e643fb1e1

Cheers,
	-Matt Helsley

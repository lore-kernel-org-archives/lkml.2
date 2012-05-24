Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933978Ab2EXSXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 14:23:53 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36029 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757651Ab2EXSXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 14:23:52 -0400
Date: Thu, 24 May 2012 22:23:47 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>, ebiederm@xmission.com,
        tj@kernel.org, skinsbursky@openvz.org
Subject: Re: [rfc v2 0/7] procfs fdinfo extension v2
Message-ID: <20120524182347.GE23326@moon>
References: <20120523102541.382837149@openvz.org>
 <20120524180121.GK798@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120524180121.GK798@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 11:01:21AM -0700, Matt Helsley wrote:
> On Wed, May 23, 2012 at 02:25:41PM +0400, Cyrill Gorcunov wrote:
> 
> <snip>
> 
> >  - finally it would be great to have ability to attach tasks to
> >    frozen tasks cgroup to thaw them at one moment (the preliminary
> >    patch I've proposed pretty long ago, but Tejun was modifying cgroups
> >    code and asked to wait until 3.4 is release, so I didn't check
> >    the current status of task cgroups at moment, I've it in my todo list)
> 
> This still strikes me as the wrong way to go about freezing for c/r.
> You never explained why you had to do it this way. Why can't you inject
> the parasite thread, move that thread out of the cgroup-to-be-frozen,
> then freeze?

Hi Matt,

last time I checked the code, the ptrace has been able to work with
frozen groups (!), that's the main problem and moving thread out of
frozen cgroup will not help. The same applies to restore time, we
want to create frozen cgroup, restore everything up to original IP
via ptrace (or parasite restorer) and thaw the cgroup. Or you asking
something else?

> 
> As best I can tell your reply last time only fleshed out the details
> of *how* you would like it to work, not *why it needs to* work that way:
> 
> 	http://lkml.org/lkml/2011/11/30/27

	Cyrill

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab2IKRzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 13:55:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36060 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab2IKRzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 13:55:20 -0400
Date: Tue, 11 Sep 2012 10:55:15 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Li Zefan <lizf@cn.fujitsu.com>, Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC cgroup/for-3.7] cgroup: mark subsystems with broken
 hierarchy support and whine if cgroups are nested for them
Message-ID: <20120911175515.GP7677@google.com>
References: <20120910223125.GC7677@google.com>
 <20120911145106.GG12039@redhat.com>
 <20120911171601.GN7677@google.com>
 <20120911173524.GJ12039@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120911173524.GJ12039@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Tue, Sep 11, 2012 at 01:35:25PM -0400, Vivek Goyal wrote:
> It is kind of strange. First kernel allows creation of hiearchy for
> non-hierarchical controllers and it also gives warning for user space to
> not do that.
> 
> If creating hiearchy for flat controllers is wrong then kernel should
> not allow it in first place and enforce it, instead of just giving a
> warning to user space to not create the hierarchy.
> 
> Initially I had blocked the creation of hierarchy deeper than 1 level
> but later had to remove it as people wanted libvirt to use blkio
> controller and seemed to be fine with flat support. In fact there
> were people who insisted on flat support as they thought that made
> more sense.

Yes, it is an ugly situation and we'll have to drag ourselves out of
this mess gradually.  I hope it hadn't happened like this but what
happened already happened and I can't see a better way out.  If you
can, please share.

> Sure. Just that CFQ code now has become really complicated and messy
> (especially with that 3 service trees per group) so making it hierarchical
> is significant amount of effort.

I think the wording for the warning wasn't entirely accurate.  The
thing that we wanna warn about is that the hierarchy behavior isn't
complete yet and it may change in the future.  If we can absolutely
declare that cfq is and will stay broken in terms of hierarchy
support, that could work too but I don't really think that's a good
idea.  It's something we need to do one way or the other.

> And regarding change of behavior, we can always intoduce a .hierarchy
> file like cgroup which needs to be explicitly set to make controller
> truly hiearchical. That way behavior does not change in a subtle manner
> in future kernel releases. (Not that I am a fan of hierarchy file, just
> that it is cost we pay for not implementing hierarchical controller to
> begin with).

I think that way of thinking is what led to this horrible mess in the
first place.  More flexibility doesn't equal better.  We can't keep
piling things on top.  I'd like to at least have an exit strategy.
use_hierarchy drives us further away from where we wanna be.

Thanks.

-- 
tejun

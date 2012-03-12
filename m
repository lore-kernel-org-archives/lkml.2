Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835Ab2CLWhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 18:37:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39953 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab2CLWhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 18:37:21 -0400
Date: Mon, 12 Mar 2012 17:37:07 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Michal Schmidt <mschmidt@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        Lennart Poettering <lennart@poettering.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120312223707.GA8272@peqn>
References: <20120221211938.GE12236@google.com>
 <20120312221050.GG23255@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312221050.GG23255@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tejun Heo (tj@kernel.org):
> Hello, guys.
> 
> Thanks a lot for the discussion and here are my take aways:
> 
> * At least to me, nobody seems to have strong enough justification for
>   orthogonal multiple hierarchies, so, yeah, unless something else

First off, can you (sorry) show an example of exactly what would no
longer be supported?  Is this the ability to not separately mount
freezer and cpusets (for instance)?

I've submitted a topic for the upcoming linux foundation end user summit
in new york, to get feedback from end users.  (Frankly I don't want to go
so would love if someone else wanted to do this :).  I think it'd be nice
to wait and see if this gets accepted, and see whether any end users are
relying on this.

(IMO it's wrong to say that "if you are using a current feature, you'd
better be reading lkml so you can speak up lest that feature might get
removed.")

>   happens, I'm scheduling multiple hierarchy support for the chopping
>   block.  This is a long term thing (think years), so no need to panic
>   right now and as is life plans may change and fail to materialize,
>   but I intend to at least move away from it.
> 
> * Several people pointed out that it would be inconvenient to require
>   cgroup hierarchy to be a strict super-imposed tree on top of process
>   tree and that program groups / sessions aren't like that either.  I
>   agree, so it will hopefully be single hierarchy which more or less
>   behaves the same as the current hierarchy.
> 
> * How to map controllers which aren't aware of full hierarchy is still
>   an open question but I'm still standing by one active node on any
>   root-to-leaf path w/ root group serving as the special rest group.
> 
>   This should happen first for the long migration to begin.  I might
>   get to it someday but if anyone can beat me to it, please go ahead.
>   I'll be ecstatic to review and merge the patches.
> 
> Also, I'll slowly be marking features which don't seem essential,
> especially the convenience features for multiple hierarchies, as
> deprecated and eventually chop them.
> 
> Thank you.
> 
> -- 
> tejun
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers

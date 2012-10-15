Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415Ab2JOIRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 04:17:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53147 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab2JOIRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 04:17:19 -0400
Date: Mon, 15 Oct 2012 10:17:15 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Alex Bligh <alex@alex.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Local DoS through write heavy I/O on CFQ & Deadline
Message-ID: <20121015081715.GC29069@dhcp22.suse.cz>
References: <0B138F62-16BF-4295-9AD9-64C0BB39FCE2@alex.org.uk>
 <20121012133044.GA10115@dhcp22.suse.cz>
 <E6EF14955C67D6CA58918872@nimrod.local>
 <20121012145838.GD22083@dhcp22.suse.cz>
 <3D1C85A52BB960B79E37AC30@nimrod.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3D1C85A52BB960B79E37AC30@nimrod.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 12-10-12 17:29:50, Alex Bligh wrote:
> Michael,
> 
> --On 12 October 2012 16:58:39 +0200 Michal Hocko <mhocko@suse.cz> wrote:
> 
> >Once dirty_ratio (resp. dirty_bytes) limit is hit then the process which
> >writes gets throttled. If this is not the case then there is a bug in
> >the throttling code.
> 
> I believe that is the problem.
> 
> >>Isn't the only thing that is going to change that it ends up
> >>triggering the writeback earlier?
> >
> >Set the limit lowe?
> 
> I think you mean 'lower'. If I do that, what I think will happen
> is that it will start the write-back earlier, 

Yes this is primarily controlled by dirty_background_{bytes|ratio}.

> but the writeback once started will not keep up with the generation of
> data, possibly because the throttling isn't going to work.

This would be good to confirm.

> Note that for instance using ionice to set priority or class to 'idle'
> has no effect. So, to test my hypothesis ...

This has been tested with the original dirty_ratio configuration, right?

> >>Happy to test etc - what would you suggest, dirty_ratio=5,
> >>dirty_background_ratio=2 ?
> >
> >These are measured in percentage. On the other hand if you use
> >dirty_bytes resp. dirty_background_bytes then you get absolute numbers
> >independent on the amount of memory.
> 
> ... what would you suggest I set any of these to in order to test
> (assuming the same box) so that it's 'low enough' that if it still
> hangs, it's a bug, rather than it's simply 'not low enough'. It's
> an 8G box and clearly I'm happy to set either the _ratio or _bytes
> entries.

I would use _ratio variants as you have a better control over the amount
of dirty data that can accumulate. You will need to experiment a bit to
tune this up. Maybe somebody with more IO experiences can help you more
with this.
I think what you see is related to your filesystem as well. Other
processes probably wait for fsync but the amount of dirty data is so big
it takes really long to finish it.
-- 
Michal Hocko
SUSE Labs

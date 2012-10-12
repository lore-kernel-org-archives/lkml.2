Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759673Ab2JLO6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 10:58:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48966 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757497Ab2JLO6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 10:58:40 -0400
Date: Fri, 12 Oct 2012 16:58:39 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Alex Bligh <alex@alex.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Local DoS through write heavy I/O on CFQ & Deadline
Message-ID: <20121012145838.GD22083@dhcp22.suse.cz>
References: <0B138F62-16BF-4295-9AD9-64C0BB39FCE2@alex.org.uk>
 <20121012133044.GA10115@dhcp22.suse.cz>
 <E6EF14955C67D6CA58918872@nimrod.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E6EF14955C67D6CA58918872@nimrod.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 12-10-12 15:48:34, Alex Bligh wrote:
> 
> 
> --On 12 October 2012 15:30:45 +0200 Michal Hocko <mhocko@suse.cz> wrote:
> 
> >>Full info, including logs and scripts can be found at:
> >>  https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1064521
> >
> >You seem to have 8G of RAM and dirty_ratio=20 resp.
> >dirty_background_ratio=10 which means that 1.5G worth of dirty data
> >until writer gets throttled which is a lot. Background writeback starts
> >at 800M which is probably not sufficient as well. Have you tried to set
> >dirty_bytes at a reasonable value (wrt. to your storage)?
> 
> This is for an appliance install where we have no idea how much
> memory the box has in advance other than 'at least 4G' so it
> is difficult to tune by default.
> 
> However, I don't think that would solve the problem as the zcat/dd
> can always generate data faster than it can be written to disk unless
> or until it is throttled, which it never is. 

Once dirty_ratio (resp. dirty_bytes) limit is hit then the process which
writes gets throttled. If this is not the case then there is a bug in
the throttling code.

> Isn't the only thing that is going to change that it ends up
> triggering the writeback earlier?

Set the limit lowe?
 
> Happy to test etc - what would you suggest, dirty_ratio=5,
> dirty_background_ratio=2 ?

These are measured in percentage. On the other hand if you use
dirty_bytes resp. dirty_background_bytes then you get absolute numbers
independent on the amount of memory.

-- 
Michal Hocko
SUSE Labs

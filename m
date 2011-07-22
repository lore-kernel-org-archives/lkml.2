Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab1GVRbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 13:31:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543Ab1GVRbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 13:31:05 -0400
Date: Fri, 22 Jul 2011 19:31:02 +0200
From: Michal Hocko <mhocko@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86, PAT: honor CONFIG_STRICT_DEVMEM if pat is disable]
Message-ID: <20110722173102.GA26935@tiehlicka.suse.cz>
References: <20110722091151.GA4004@tiehlicka.suse.cz>
 <4E29A20C.70402@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E29A20C.70402@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 22-07-11 09:15:08, H. Peter Anvin wrote:
> On 07/22/2011 02:11 AM, Michal Hocko wrote:
> > Hi,
> > I have just come across a strange behavior of /dev/[k]mem when PAT is
> > configured while STRICT_DEVMEM is disabled. 
> > One would expect that /dev/kmem would allow to access also the
> > system RAM in that configuration but that is not obviously true as pat
> > code defines range_is_allowed to protect from accessing that memory.
> > 
> > AFAICS this behavior was introduced in 0124cecf (x86, PAT: disable
> > /dev/mem mmap RAM with PAT) which says that it disables [k]mem with PAT
> > because it is safer. There is no explanation why it allows to access
> > that memory if CONFIG_NONPROMISC_DEVMEM (CONFIG_STRICT_DEVMEM now).
> > 
> > The thing is even more complicated by the fact that the access is
> > allowed when nopat kernel parameter is specified because
> > range_is_allowed just does't call devmem_is_allowed in that case.
> > 
> > While I do agree that the feature is not safe in general we should honor
> > STRICT_DEVMEM setting in some way IMO.
> > 
> > What do you think about the following fix? I have tried to preserve
> > "disabled for PAT" by default behavior.
> 
> The reason it is disabled for PAT is that it is very hard to track maps
> of that memory that are created by mapping /dev/[k]mem, since those maps
> don't have a defined PAT type and really should be transparently
> tracking the consensus caching type; this is a facility that *could* be
> created but has no other user.

Thanks for the clarification!
What do you think about fixing the nopat with STRICT_DEVMEM like the
patch does?

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic

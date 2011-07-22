Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab1GVQQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 12:16:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51334 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578Ab1GVQQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 12:16:58 -0400
Message-ID: <4E29A20C.70402@zytor.com>
Date: Fri, 22 Jul 2011 09:15:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Venki Pallipadi <venkatesh.pallipadi@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86, PAT: honor CONFIG_STRICT_DEVMEM if pat is disable]
References: <20110722091151.GA4004@tiehlicka.suse.cz>
In-Reply-To: <20110722091151.GA4004@tiehlicka.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2011 02:11 AM, Michal Hocko wrote:
> Hi,
> I have just come across a strange behavior of /dev/[k]mem when PAT is
> configured while STRICT_DEVMEM is disabled. 
> One would expect that /dev/kmem would allow to access also the
> system RAM in that configuration but that is not obviously true as pat
> code defines range_is_allowed to protect from accessing that memory.
> 
> AFAICS this behavior was introduced in 0124cecf (x86, PAT: disable
> /dev/mem mmap RAM with PAT) which says that it disables [k]mem with PAT
> because it is safer. There is no explanation why it allows to access
> that memory if CONFIG_NONPROMISC_DEVMEM (CONFIG_STRICT_DEVMEM now).
> 
> The thing is even more complicated by the fact that the access is
> allowed when nopat kernel parameter is specified because
> range_is_allowed just does't call devmem_is_allowed in that case.
> 
> While I do agree that the feature is not safe in general we should honor
> STRICT_DEVMEM setting in some way IMO.
> 
> What do you think about the following fix? I have tried to preserve
> "disabled for PAT" by default behavior.

The reason it is disabled for PAT is that it is very hard to track maps
of that memory that are created by mapping /dev/[k]mem, since those maps
don't have a defined PAT type and really should be transparently
tracking the consensus caching type; this is a facility that *could* be
created but has no other user.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


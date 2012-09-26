Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab2IZT4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 15:56:54 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44672 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab2IZT4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 15:56:53 -0400
Date: Wed, 26 Sep 2012 12:56:48 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        devel@openvz.org, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Message-ID: <20120926195648.GA20342@google.com>
References: <1347977050-29476-5-git-send-email-glommer@parallels.com>
 <20120926140347.GD15801@dhcp22.suse.cz>
 <20120926163648.GO16296@google.com>
 <50633D24.6020002@parallels.com>
 <CAOS58YNj-L4ocwn-c27ho4WPW41MKOeJbnLZ8N8r4eUkoxC7GA@mail.gmail.com>
 <50634105.8060302@parallels.com>
 <20120926180124.GA12544@google.com>
 <50634FC9.4090609@parallels.com>
 <20120926193417.GJ12544@google.com>
 <50635B9D.8020205@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50635B9D.8020205@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Sep 26, 2012 at 11:46:37PM +0400, Glauber Costa wrote:
> Besides not being part of cgroup core, and respecting very much both
> cgroups' and basic sanity properties, kmem is an actual feature that
> some people want, and some people don't. There is no reason to believe
> that applications that want will live in the same environment with ones
> that don't want.

I don't know.  It definitely is less crazy than .use_hierarchy but I
wouldn't say it's an inherently different thing.  I mean, what does it
even mean to have u+k limit on one subtree and not on another branch?
And we worry about things like what if parent doesn't enable it but
its chlidren do.

This is a feature which adds complexity.  If the feature is necessary
and justified, sure.  If not, let's please not and let's err on the
side of conservativeness.  We can always add it later but the other
direction is much harder.

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab2IZTuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 15:50:10 -0400
Received: from mx2.parallels.com ([64.131.90.16]:49146 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897Ab2IZTuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 15:50:08 -0400
Message-ID: <50635B9D.8020205@parallels.com>
Date: Wed, 26 Sep 2012 23:46:37 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Michal Hocko <mhocko@suse.cz>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <devel@openvz.org>, <linux-mm@kvack.org>,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
References: <1347977050-29476-1-git-send-email-glommer@parallels.com> <1347977050-29476-5-git-send-email-glommer@parallels.com> <20120926140347.GD15801@dhcp22.suse.cz> <20120926163648.GO16296@google.com> <50633D24.6020002@parallels.com> <CAOS58YNj-L4ocwn-c27ho4WPW41MKOeJbnLZ8N8r4eUkoxC7GA@mail.gmail.com> <50634105.8060302@parallels.com> <20120926180124.GA12544@google.com> <50634FC9.4090609@parallels.com> <20120926193417.GJ12544@google.com>
In-Reply-To: <20120926193417.GJ12544@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [109.173.3.27]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2012 11:34 PM, Tejun Heo wrote:
> Hello,
> 
> On Wed, Sep 26, 2012 at 10:56:09PM +0400, Glauber Costa wrote:
>> For me, it is the other way around: it makes perfect sense to have a
>> per-subtree selection of features where it doesn't hurt us, provided it
>> is hierarchical. For the mere fact that not every application is
>> interested in this (Michal is the one that is being so far more vocal
>> about this not being needed in some use cases), and it is perfectly
>> valid to imagine such applications would coexist.
>>
>> So given the flexibility it brings, the real question is, as I said,
>> backwards: what is it necessary to make it a global switch ?
> 
> Because it hurts my head and it's better to keep things simple.  We're
> planning to retire .use_hierarhcy in sub hierarchies and I'd really
> like to prevent another fiasco like that unless there absolutely is no
> way around it.  Flexibility where necessary is fine but let's please
> try our best to avoid over-designing things.  We've been far too good
> at getting lost in flexbility maze.  Michal, care to chime in?
> 

I would very much like to hear Michal here as well, sure.

But as I said in this very beginning of this, you pretty much know that
I am heavily involved in trying to get rid of use_hierarchy, and by no
means I consider this en pair with that.

use_hierarchy is a hack around a core property of cgroups, the fact that
they are hierarchical. Its mere existence came to be to overcome a
performance limitation.

It puts you in contradictory situation where you have cgroups organized
as directories, and then not satisfied in making this hierarchical
representation be gravely ignored, forces you to use nonsensical terms
like "flat hierarchy", making us grasp at how it is to be a politician
once in our lifetimes.

Besides not being part of cgroup core, and respecting very much both
cgroups' and basic sanity properties, kmem is an actual feature that
some people want, and some people don't. There is no reason to believe
that applications that want will live in the same environment with ones
that don't want.




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274Ab2IZS7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 14:59:41 -0400
Received: from mx2.parallels.com ([64.131.90.16]:59980 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758068Ab2IZS7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 14:59:39 -0400
Message-ID: <50634FC9.4090609@parallels.com>
Date: Wed, 26 Sep 2012 22:56:09 +0400
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
References: <1347977050-29476-1-git-send-email-glommer@parallels.com> <1347977050-29476-5-git-send-email-glommer@parallels.com> <20120926140347.GD15801@dhcp22.suse.cz> <20120926163648.GO16296@google.com> <50633D24.6020002@parallels.com> <CAOS58YNj-L4ocwn-c27ho4WPW41MKOeJbnLZ8N8r4eUkoxC7GA@mail.gmail.com> <50634105.8060302@parallels.com> <20120926180124.GA12544@google.com>
In-Reply-To: <20120926180124.GA12544@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [109.173.3.27]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2012 10:01 PM, Tejun Heo wrote:
> Hello,
> 
> On Wed, Sep 26, 2012 at 09:53:09PM +0400, Glauber Costa wrote:
>> I understand your trauma about over flexibility, and you know I share of
>> it. But I don't think there is any need to cap it here. Given kmem
>> accounted is perfectly hierarchical, and there seem to be plenty of
>> people who only care about user memory, I see no reason to disallow a
>> mixed use case here.
>>
>> I must say that for my particular use case, enabling it unconditionally
>> would just work, so it is not that what I have in mind.
> 
> So, I'm not gonna go as far as pushing for enabling it unconditionally
> but would really like to hear why it's necessary to make it per node
> instead of one global switch.  Maybe it has already been discussed to
> hell and back.  Care to summarize / point me to it?
> 

For me, it is the other way around: it makes perfect sense to have a
per-subtree selection of features where it doesn't hurt us, provided it
is hierarchical. For the mere fact that not every application is
interested in this (Michal is the one that is being so far more vocal
about this not being needed in some use cases), and it is perfectly
valid to imagine such applications would coexist.

So given the flexibility it brings, the real question is, as I said,
backwards: what is it necessary to make it a global switch ?


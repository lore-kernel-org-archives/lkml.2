Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab2IZR4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:56:42 -0400
Received: from mx2.parallels.com ([64.131.90.16]:43594 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758016Ab2IZR4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:56:40 -0400
Message-ID: <50634105.8060302@parallels.com>
Date: Wed, 26 Sep 2012 21:53:09 +0400
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
References: <1347977050-29476-1-git-send-email-glommer@parallels.com> <1347977050-29476-5-git-send-email-glommer@parallels.com> <20120926140347.GD15801@dhcp22.suse.cz> <20120926163648.GO16296@google.com> <50633D24.6020002@parallels.com> <CAOS58YNj-L4ocwn-c27ho4WPW41MKOeJbnLZ8N8r4eUkoxC7GA@mail.gmail.com>
In-Reply-To: <CAOS58YNj-L4ocwn-c27ho4WPW41MKOeJbnLZ8N8r4eUkoxC7GA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [109.173.3.27]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2012 09:44 PM, Tejun Heo wrote:
> Hello, Glauber.
> 
> On Wed, Sep 26, 2012 at 10:36 AM, Glauber Costa <glommer@parallels.com> wrote:
>> This was discussed multiple times. Our interest is to preserve existing
>> deployed setup, that were tuned in a world where kmem didn't exist.
>> Because we also feed kmem to the user counter, this may very well
>> disrupt their setup.
> 
> So, that can be served by .kmem_accounted at root, no?
> 
>> User memory, unlike kernel memory, may very well be totally in control
>> of the userspace application, so it is not unreasonable to believe that
>> extra pages appearing in a new kernel version may break them.
>>
>> It is actually a much worse compatibility problem than flipping
>> hierarchy, in comparison
> 
> Again, what's wrong with one switch at the root?
> 

I understand your trauma about over flexibility, and you know I share of
it. But I don't think there is any need to cap it here. Given kmem
accounted is perfectly hierarchical, and there seem to be plenty of
people who only care about user memory, I see no reason to disallow a
mixed use case here.

I must say that for my particular use case, enabling it unconditionally
would just work, so it is not that what I have in mind.


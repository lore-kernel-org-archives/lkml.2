Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab2I0Mnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 08:43:35 -0400
Received: from mx2.parallels.com ([64.131.90.16]:36676 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab2I0Mne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 08:43:34 -0400
Message-ID: <50644923.2060008@parallels.com>
Date: Thu, 27 Sep 2012 16:40:03 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <devel@openvz.org>, <linux-mm@kvack.org>,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
References: <50637298.2090904@parallels.com> <20120926221046.GA10453@mtj.dyndns.org> <506381B2.2060806@parallels.com> <20120926224235.GB10453@mtj.dyndns.org> <50638793.7060806@parallels.com> <20120926230807.GC10453@mtj.dyndns.org> <50638DBB.4000002@parallels.com> <20120926233334.GD10453@mtj.dyndns.org> <20120927121558.GB29104@dhcp22.suse.cz> <506444A7.5060303@parallels.com> <20120927124031.GC29104@dhcp22.suse.cz>
In-Reply-To: <20120927124031.GC29104@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 04:40 PM, Michal Hocko wrote:
> On Thu 27-09-12 16:20:55, Glauber Costa wrote:
>> On 09/27/2012 04:15 PM, Michal Hocko wrote:
>>> On Wed 26-09-12 16:33:34, Tejun Heo wrote:
>>> [...]
>>>>>> So, this seems properly crazy to me at the similar level of
>>>>>> use_hierarchy fiasco.  I'm gonna NACK on this.
>>>>>
>>>>> As I said: all use cases I particularly care about are covered by a
>>>>> global switch.
>>>>>
>>>>> I am laying down my views because I really believe they make more sense.
>>>>> But at some point, of course, I'll shut up if I believe I am a lone voice.
>>>>>
>>>>> I believe it should still be good to hear from mhocko and kame, but from
>>>>> your point of view, would all the rest, plus the introduction of a
>>>>> global switch make it acceptable to you?
>>>>
>>>> The only thing I'm whining about is per-node switch + silently
>>>> ignoring past accounting, so if those two are solved, I think I'm
>>>> pretty happy with the rest.
>>>
>>> I think that per-group "switch" is not nice as well but if we make it
>>> hierarchy specific (which I am proposing for quite some time) and do not
>>> let enable accounting for a group with tasks then we get both
>>> flexibility and reasonable semantic. A global switch sounds too coars to
>>> me and it really not necessary.
>>>
>>> Would this work with you?
>>>
>>
>> How exactly would that work? AFAIK, we have a single memcg root, we
>> can't have multiple memcg hierarchies in a system. Am I missing something?
> 
> Well root is so different that we could consider the first level as the
> real roots for hierarchies.
> 
So let's favor clarity: What you are proposing is that the first level
can have a switch for that, and the first level only. Is that right ?

At first, I just want to understand what exactly is your proposal. This
is not an endorsement of lack thereof.



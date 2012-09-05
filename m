Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303Ab2IEJfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:35:16 -0400
Received: from mx2.parallels.com ([64.131.90.16]:53594 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758099Ab2IEJfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:35:14 -0400
Message-ID: <50471C0C.7050600@parallels.com>
Date: Wed, 5 Sep 2012 13:31:56 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <linux-mm@kvack.org>, <davej@redhat.com>,
        <ben@decadent.org.uk>, <pjt@google.com>, <lennart@poettering.net>,
        <kay.sievers@vrfy.org>
Subject: Re: [RFC 0/5] forced comounts for cgroups.
References: <1346768300-10282-1-git-send-email-glommer@parallels.com>  <20120904214602.GA9092@dhcp-172-17-108-109.mtv.corp.google.com>  <5047074D.1030104@parallels.com>  <20120905081439.GC3195@dhcp-172-17-108-109.mtv.corp.google.com>  <50470A87.1040701@parallels.com>  <20120905082947.GD3195@dhcp-172-17-108-109.mtv.corp.google.com>  <50470EBF.9070109@parallels.com>  <20120905084740.GE3195@dhcp-172-17-108-109.mtv.corp.google.com>  <1346835993.2600.9.camel@twins>  <20120905091140.GH3195@dhcp-172-17-108-109.mtv.corp.google.com>  <50471782.6060800@parallels.com> <1346837209.2600.14.camel@twins>
In-Reply-To: <1346837209.2600.14.camel@twins>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2012 01:26 PM, Peter Zijlstra wrote:
> On Wed, 2012-09-05 at 13:12 +0400, Glauber Costa wrote:
>> On 09/05/2012 01:11 PM, Tejun Heo wrote:
>>> Hello, Peter.
>>>
>>> On Wed, Sep 05, 2012 at 11:06:33AM +0200, Peter Zijlstra wrote:
>>>> *confused* I always thought that was exactly what you meant with unified
>>>> hierarchy.
>>>
>>> No, I never counted out differing granularity.
>>>
>>
>> Can you elaborate on which interface do you envision to make it work?
>> They will clearly be mounted in the same hierarchy, or as said
>> alternatively, comounted.
>>
>> If you can turn them on/off on a per-subtree basis, which interface
>> exactly do you propose for that?
> 
> I wouldn't, screw that. That would result in the exact same problem
> we're trying to fix. I want a single hierarchy walk, that's expensive
> enough.
> 
>> Would a pair of cgroup core files like available_controllers and
>> current_controllers are a lot of drivers do, suffice?
> 
> No.. its not a 'feature' I care to support for 'my' controllers.
> 
> I simply don't want to have to do two (or more) hierarchy walks for
> accounting on every schedule event, all that pointer chasing is stupidly
> expensive.
> 

You wouldn't have to do more than one hierarchy walks for that. What
Tejun seems to want, is the ability to not have a particular controller
at some point in the tree. But if they exist, they are always together.



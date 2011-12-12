Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab1LLJft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 04:35:49 -0500
Received: from mx2.parallels.com ([64.131.90.16]:50563 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab1LLJfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 04:35:47 -0500
Message-ID: <4EE5CACD.5080606@parallels.com>
Date: Mon, 12 Dec 2011 13:35:09 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Turner <pjt@google.com>, <cgroups@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, <devel@openvz.org>,
        Linux Containers <containers@lists.osdl.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: How to draw values for /proc/stat
References: <4EDC8FB1.60407@parallels.com> <1323439411.17673.65.camel@twins>  <4EE22179.5090106@parallels.com> <1323682413.16764.55.camel@twins>
In-Reply-To: <1323682413.16764.55.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2011 01:33 PM, Peter Zijlstra wrote:
> On Fri, 2011-12-09 at 12:55 -0200, Glauber Costa wrote:
>> On 12/09/2011 12:03 PM, Peter Zijlstra wrote:
>
>>> Namespaces seem to be about limiting visibility, cgroups about
>>> controlling resources.
>>>
>>> The two things are hopelessly disjoint atm, but I believe someone was
>>> looking at this mess.
>>
>> I did take a look at this (if anyone else was, I'd like to know so we
>> can share some ideas), but I am not convinced we should do anything to
>> join them anymore. We virtualization people are to the best of my
>> knowledge the only ones doing namespaces. Cgroups, OTOH, got a lot bigger.
>>
>> What I am mostly concerned about now, is how consistent they will be.
>> /proc always being always global indeed does make sense, but my question
>> still stands: if you live in a resource-controlled world, why should you
>> even see resources you will never own ?
>
> Since without namespaces you can still see the rest of the world. So it
> makes sense to me to still see all resources too.
>
> Also, proportional controllers might not see a consistent slice of the
> resource, making the stats rather awkward to interpret.
>
> Furthermore, not everybody might care about these statistics at all and
> I know pjt objected to being subjected to the extra accounting (pjt do
> speak up etc..).
>
>> If it is not co-mounted, we draw the global value. If you don't mount
>> it, I someone does not mount it, I can assure you he doesn't care about
>> it. We for sure will.
>
> Anyway, looking at the rest of the emails in this thread the current
> proposal is a cgroup mount option that indicates if you want these
> per-cgroup stats or not, right?

Well, it is something in this direction. I don't think it's entirely 
clear what exactly it will look like, but it seems we're making progress.


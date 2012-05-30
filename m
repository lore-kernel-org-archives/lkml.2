Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab2E3Mq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 08:46:57 -0400
Received: from mx2.parallels.com ([64.131.90.16]:57629 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712Ab2E3Mq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 08:46:56 -0400
Message-ID: <4FC61619.7000300@parallels.com>
Date: Wed, 30 May 2012 16:44:09 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Turner <pjt@google.com>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>,
        Tejun Heo <tj@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
        <handai.szj@gmail.com>, <Andrew.Phillips@lmax.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v3 5/6] Also record sleep start for a task group
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>  <1338371317-5980-6-git-send-email-glommer@parallels.com>  <CAPM31R+VXsffUOSOtMPG=g+G9OdzWMKQvx9usTFa3KBbrqPe6A@mail.gmail.com>  <4FC61188.8000908@parallels.com> <1338381877.26856.272.camel@twins>
In-Reply-To: <1338381877.26856.272.camel@twins>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 04:44 PM, Peter Zijlstra wrote:
> On Wed, 2012-05-30 at 16:24 +0400, Glauber Costa wrote:
>> sleep_start is not for iowait. This is for idle. And I know no other way
>> to collect idle time per cgroup, other than the time during which it was
>> out of the runqueue.
>>
>> Now what you say about the sleepers don't make that much sense for idle
>> because this information is per-cpu as well.
>>
>> When the se is being dequeued, it means none of its children is running
>> on that runqueue. That's idle.
>
> But does that mean the cgroup is idle? Its impossible to re-construct
> the machine state from this per-cpu data if your definition of
> cgroup-idle is the time when _all_ cpus are idle.
>
It is idle for that runqueue, aka cpu. The cgroup itself is idle when 
all cpus are idle. And yes, then you have 2s per sec of idle in a 2-way 
system.

That's pretty much how a physical box works as well.


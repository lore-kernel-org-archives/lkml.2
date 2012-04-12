Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761745Ab2DLCRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 22:17:37 -0400
Received: from mx2.parallels.com ([64.131.90.16]:53723 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947Ab2DLCRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 22:17:35 -0400
Message-ID: <4F863AD5.3010505@parallels.com>
Date: Wed, 11 Apr 2012 23:15:49 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Daniel Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFD] Merge task counter into memcg
References: <20120411185715.GA4317@somewhere.redhat.com> <20120412010745.GE1787@cmpxchg.org>
In-Reply-To: <20120412010745.GE1787@cmpxchg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.35.198.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 10:07 PM, Johannes Weiner wrote:
> You could also twist this around and argue the same for cpu usage and
> make it part of the cpu cgroup, but it doesn't really fit in either
> subsystem, IMO.
I myself really prefer this in the cpu controller.
Besides the bytes vs objects things, Whenever you create a process, at 
some point it will end up in the runqueues to be scheduled. It is a 
natural point of accounting.

Either that, or making it a core feature of cgroups, like limiting the 
number of processes in the tasks file (just have to find a natural way 
to make it hierarchical). It will make more and more sense as people 
seem to be favoring single hierarchies these days. (granted, not a 
settled discussion, so your views may vary)



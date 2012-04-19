Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab2DSDeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 23:34:23 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36734 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab2DSDeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 23:34:21 -0400
Date: Thu, 19 Apr 2012 07:34:15 +0400
From: Alexander Nikiforov <a.nikiforov@samsung.com>
Subject: Re: [RFD] Merge task counter into memcg
In-reply-to: <20120417152350.GC32402@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Glauber Costa <glommer@parallels.com>,
        Daniel Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        d.solodkiy@samsung.com
Message-id: <4F8F87B7.2000504@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329
 Thunderbird/11.0.1
References: <20120411185715.GA4317@somewhere.redhat.com>
 <4F86527C.2080507@samsung.com> <20120417010902.GA14646@somewhere.redhat.com>
 <4F8D1171.1090504@samsung.com> <20120417152350.GC32402@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2012 07:23 PM, Tejun Heo wrote:
> Hello,
>
> On Tue, Apr 17, 2012 at 10:45:05AM +0400, Alexander Nikiforov wrote:
>> between them. Now we have only 1 way to get notification about tasks
>> file - inotify(), but this approach works only if you work from
>> userspace with file (e.g. create struct file, for example with echo
>> $$ /sys/abc/tasks), but when something happens from kernel side
>> (do_fork()/do_exit) we cannot get any event about group of the
>> process (we can scan tasks file and count number of PID, or work
>> with
>> waitpid(), but IMHO this is ugly solutions)
> Wouldn't simply generating FS_MODIFY event on the tasks file do the
> trick?
>
> Thanks.
>
Maybe it will, but in my mind it should be with event. I thought about 
inotify before my RFD mail. Here we have file update, so FS_MODIFY very 
natural.
But on the other hand - we have event in memcg, so conventional approach 
is event.

If this functionality is acceptable in cgroup and FS_MODIFY better, 
we'll make new patch with this approach.

-- 
Best regards,
      Alex Nikiforov,
      Mobile SW, Advanced Software Group,
      Moscow R&D center, Samsung Electronics


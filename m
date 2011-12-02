Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab1LBMnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 07:43:16 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:35916 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755509Ab1LBMnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 07:43:15 -0500
Message-ID: <4ED8C7DE.4050107@parallels.com>
Date: Fri, 02 Dec 2011 16:43:10 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Pedro Alves <pedro@codesourcery.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [rfc 2/3] fs, proc: Introduce the Children: line in /proc/<pid>/status
References: <20111129191252.769160532@openvz.org> <20111201095434.GR14515@moon> <20111202094010.ca2dee4c.kamezawa.hiroyu@jp.fujitsu.com> <201112021241.04471.pedro@codesourcery.com>
In-Reply-To: <201112021241.04471.pedro@codesourcery.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2011 04:41 PM, Pedro Alves wrote:
> On Friday 02 December 2011 00:40:10, KAMEZAWA Hiroyuki wrote:
>>> What about this one?
>>> ---
>>> fs, proc: Introduce the /proc/<pid>/children entry
>>>
>>> There is no easy way to make a reverse parent->children chain
>>> from the task status, in turn children->parent provided with "PPid"
>>> field.
>>>
>>> So instead of walking over all pids in system to figure out what
>>> children the task have -- we add explicit /proc/<pid>/children entry,
>>> since kernel already knows this kind of information but it was not
>>> yet exported.
>>>
>>> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
>>> Cc: Pavel Emelyanov <xemul@parallels.com>
>>> Cc: Serge Hallyn <serge.hallyn@canonical.com>
>>> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>> Yes, I like /children file. other points seems to be pointed out by other
>> reviewers. 
> 
> Any reason this is a file instead of a directory like /proc/PID/task/ ?
> 
> $ sudo ls /proc/8167/task/
> 8167  854  855  856  857  858  859
> $ sudo ls /proc/8167/task/855/
> attr    clear_refs  cpuset   exe     io       loginuid  mountinfo  oom_adj        pagemap      sched      smaps  statm    wchan
> auxv    cmdline     cwd      fd      latency  maps      mounts     oom_score      personality  schedstat  stack  status
> cgroup  comm        environ  fdinfo  limits   mem       numa_maps  oom_score_adj  root         sessionid  stat   syscall
> 
> Much easier to follow the chain from the command line this way.

What do you propose to put into these directories? Another directories named with
children pid-s?

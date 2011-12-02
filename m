Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab1LBMlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 07:41:18 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:58955 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590Ab1LBMlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 07:41:16 -0500
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [rfc 2/3] fs, proc: Introduce the Children: line in /proc/<pid>/status
Date: Fri, 2 Dec 2011 12:41:04 +0000
User-Agent: KMail/1.13.6 (Linux/2.6.38-13-generic; KDE/4.7.2; x86_64; ; )
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>
References: <20111129191252.769160532@openvz.org> <20111201095434.GR14515@moon> <20111202094010.ca2dee4c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111202094010.ca2dee4c.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112021241.04471.pedro@codesourcery.com>
X-OriginalArrivalTime: 02 Dec 2011 12:41:06.0646 (UTC) FILETIME=[A9082F60:01CCB0EF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 December 2011 00:40:10, KAMEZAWA Hiroyuki wrote:
> > What about this one?
> > ---
> > fs, proc: Introduce the /proc/<pid>/children entry
> > 
> > There is no easy way to make a reverse parent->children chain
> > from the task status, in turn children->parent provided with "PPid"
> > field.
> > 
> > So instead of walking over all pids in system to figure out what
> > children the task have -- we add explicit /proc/<pid>/children entry,
> > since kernel already knows this kind of information but it was not
> > yet exported.
> > 
> > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> > Cc: Pavel Emelyanov <xemul@parallels.com>
> > Cc: Serge Hallyn <serge.hallyn@canonical.com>
> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Yes, I like /children file. other points seems to be pointed out by other
> reviewers. 

Any reason this is a file instead of a directory like /proc/PID/task/ ?

$ sudo ls /proc/8167/task/
8167  854  855  856  857  858  859
$ sudo ls /proc/8167/task/855/
attr    clear_refs  cpuset   exe     io       loginuid  mountinfo  oom_adj        pagemap      sched      smaps  statm    wchan
auxv    cmdline     cwd      fd      latency  maps      mounts     oom_score      personality  schedstat  stack  status
cgroup  comm        environ  fdinfo  limits   mem       numa_maps  oom_score_adj  root         sessionid  stat   syscall

Much easier to follow the chain from the command line this way.

-- 
Pedro Alves

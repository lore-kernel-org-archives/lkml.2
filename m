Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab1LBOAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 09:00:51 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:38203 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756596Ab1LBOAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 09:00:49 -0500
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [rfc 2/3] fs, proc: Introduce the Children: line in /proc/<pid>/status
Date: Fri, 2 Dec 2011 14:00:42 +0000
User-Agent: KMail/1.13.6 (Linux/2.6.38-13-generic; KDE/4.7.2; x86_64; ; )
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>
References: <20111129191252.769160532@openvz.org> <201112021344.40177.pedro@codesourcery.com> <4ED8D82B.9080408@parallels.com>
In-Reply-To: <4ED8D82B.9080408@parallels.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112021400.42762.pedro@codesourcery.com>
X-OriginalArrivalTime: 02 Dec 2011 14:00:45.0033 (UTC) FILETIME=[C92C2D90:01CCB0FA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 December 2011 13:52:43, Pavel Emelyanov wrote:
> On 12/02/2011 05:44 PM, Pedro Alves wrote:
> > On Friday 02 December 2011 13:16:52, Pavel Emelyanov wrote:
> >> On 12/02/2011 04:58 PM, Pedro Alves wrote:
> >>> On Friday 02 December 2011 12:43:10, Pavel Emelyanov wrote:
> >>>
> >>>>>> Yes, I like /children file. other points seems to be pointed out by other
> >>>>>> reviewers. 
> >>>>>
> >>>>> Any reason this is a file instead of a directory like /proc/PID/task/ ?
> >>>>>
> >>>>> $ sudo ls /proc/8167/task/
> >>>>> 8167  854  855  856  857  858  859
> >>>>> $ sudo ls /proc/8167/task/855/
> >>>>> attr    clear_refs  cpuset   exe     io       loginuid  mountinfo  oom_adj        pagemap      sched      smaps  statm    wchan
> >>>>> auxv    cmdline     cwd      fd      latency  maps      mounts     oom_score      personality  schedstat  stack  status
> >>>>> cgroup  comm        environ  fdinfo  limits   mem       numa_maps  oom_score_adj  root         sessionid  stat   syscall
> >>>>>
> >>>>> Much easier to follow the chain from the command line this way.
> >>>>
> >>>> What do you propose to put into these directories? Another directories named with
> >>>> children pid-s?
> >>>
> >>> Yes, just like the task/ dir gives you directories named with the
> >>> processes's thread ids.  Opening /proc/PID/children/PID-CHILD1/ would get
> >>> you the same as opening /proc/PID-CHILD1/.  Just like
> >>> opening /proc/PID/task/PID-CHILD1/ gets you (almost) the same as opening
> >>> /proc/PID-CHILD1/.
> >>
> >> You cannot make the dentry named /proc/<pid1>/children/<pid2> be a hardlink on
> >> the /proc/<pid2>. Thus you have to make arbitrary amount of inodes to point to
> >> a single task. This brings unnecessary complexity and memory usage (by dentries
> >> and proc inodes).
> > 
> > How is this different from the _already existing_ /proc/<pid1>/task/ directory?
> 
> Those living in /proc/<pid1>/task do not live in /proc. At all. This explains
> everything below.

Well, except they do, and it doesn't.  The're not visible when
listing /proc/, but they're there.  Try it.

$ls /proc/ | grep 854

(empty)

$ ls /proc/8167/task/854
attr    clear_refs  cpuset   exe     io       loginuid  mountinfo  oom_adj        pagemap      sched      smaps  statm    wchan
auxv    cmdline     cwd      fd      latency  maps      mounts     oom_score      personality  schedstat  stack  status
cgroup  comm        environ  fdinfo  limits   mem       numa_maps  oom_score_adj  root         sessionid  stat   syscall

$ls /proc/854/
attr       cgroup      comm             cwd      fd      latency   maps       mounts      numa_maps  oom_score_adj  root       sessionid  stat    syscall
autogroup  clear_refs  coredump_filter  environ  fdinfo  limits    mem        mountstats  oom_adj    pagemap        sched      smaps      statm   task
auxv       cmdline     cpuset           exe      io      loginuid  mountinfo  net         oom_score  personality    schedstat  stack      status  wchan

-- 
Pedro Alves

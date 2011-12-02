Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab1LBNoq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 08:44:46 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:36210 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618Ab1LBNop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 08:44:45 -0500
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [rfc 2/3] fs, proc: Introduce the Children: line in /proc/<pid>/status
Date: Fri, 2 Dec 2011 13:44:39 +0000
User-Agent: KMail/1.13.6 (Linux/2.6.38-13-generic; KDE/4.7.2; x86_64; ; )
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>
References: <20111129191252.769160532@openvz.org> <201112021258.04197.pedro@codesourcery.com> <4ED8CFC4.5010804@parallels.com>
In-Reply-To: <4ED8CFC4.5010804@parallels.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112021344.40177.pedro@codesourcery.com>
X-OriginalArrivalTime: 02 Dec 2011 13:44:43.0059 (UTC) FILETIME=[8BCA9830:01CCB0F8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 December 2011 13:16:52, Pavel Emelyanov wrote:
> On 12/02/2011 04:58 PM, Pedro Alves wrote:
> > On Friday 02 December 2011 12:43:10, Pavel Emelyanov wrote:
> > 
> >>>> Yes, I like /children file. other points seems to be pointed out by other
> >>>> reviewers. 
> >>>
> >>> Any reason this is a file instead of a directory like /proc/PID/task/ ?
> >>>
> >>> $ sudo ls /proc/8167/task/
> >>> 8167  854  855  856  857  858  859
> >>> $ sudo ls /proc/8167/task/855/
> >>> attr    clear_refs  cpuset   exe     io       loginuid  mountinfo  oom_adj        pagemap      sched      smaps  statm    wchan
> >>> auxv    cmdline     cwd      fd      latency  maps      mounts     oom_score      personality  schedstat  stack  status
> >>> cgroup  comm        environ  fdinfo  limits   mem       numa_maps  oom_score_adj  root         sessionid  stat   syscall
> >>>
> >>> Much easier to follow the chain from the command line this way.
> >>
> >> What do you propose to put into these directories? Another directories named with
> >> children pid-s?
> > 
> > Yes, just like the task/ dir gives you directories named with the
> > processes's thread ids.  Opening /proc/PID/children/PID-CHILD1/ would get
> > you the same as opening /proc/PID-CHILD1/.  Just like
> > opening /proc/PID/task/PID-CHILD1/ gets you (almost) the same as opening
> > /proc/PID-CHILD1/.
> 
> You cannot make the dentry named /proc/<pid1>/children/<pid2> be a hardlink on
> the /proc/<pid2>. Thus you have to make arbitrary amount of inodes to point to
> a single task. This brings unnecessary complexity and memory usage (by dentries
> and proc inodes).

How is this different from the _already existing_ /proc/<pid1>/task/ directory?
I can imagine that 98% of the code would be shared even?  It's "just" a matter of
listing thread group children (child/), instead of clone children (task/),
isn't it?

They are not symbolic links under task/.  /proc/<pid1>/task/<pid2>/ does not
have a task/ subdir, only /proc/<pid1>/ does, I guess to avoid the memory usage
issue you raise.

> I'd accept the symbolic links, but how would they look like? Like this:
>    # ls -l /proc/123/children
>             234 -> ../../234
> ?

That'd work for me...  but really, why not reuse tasks/'s code and
behave the same?

-- 
Pedro Alves

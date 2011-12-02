Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab1LBNLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 08:11:10 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:65211 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095Ab1LBNLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 08:11:08 -0500
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [rfc 2/3] fs, proc: Introduce the Children: line in /proc/<pid>/status
Date: Fri, 2 Dec 2011 13:10:59 +0000
User-Agent: KMail/1.13.6 (Linux/2.6.38-13-generic; KDE/4.7.2; x86_64; ; )
Cc: Pavel Emelyanov <xemul@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>
References: <20111129191252.769160532@openvz.org> <4ED8C7DE.4050107@parallels.com> <20111202124551.GD14515@moon>
In-Reply-To: <20111202124551.GD14515@moon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112021310.59972.pedro@codesourcery.com>
X-OriginalArrivalTime: 02 Dec 2011 13:11:02.0887 (UTC) FILETIME=[D7ACCF70:01CCB0F3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 December 2011 12:45:51, Cyrill Gorcunov wrote:
> On Fri, Dec 02, 2011 at 04:43:10PM +0400, Pavel Emelyanov wrote:
> ...
> > >>
> > >> Yes, I like /children file. other points seems to be pointed out by other
> > >> reviewers. 
> > > 
> > > Any reason this is a file instead of a directory like /proc/PID/task/ ?
> > > 
> > > $ sudo ls /proc/8167/task/
> > > 8167  854  855  856  857  858  859
> > > $ sudo ls /proc/8167/task/855/
> > > attr    clear_refs  cpuset   exe     io       loginuid  mountinfo  oom_adj        pagemap      sched      smaps  statm    wchan
> > > auxv    cmdline     cwd      fd      latency  maps      mounts     oom_score      personality  schedstat  stack  status
> > > cgroup  comm        environ  fdinfo  limits   mem       numa_maps  oom_score_adj  root         sessionid  stat   syscall
> > > 
> > > Much easier to follow the chain from the command line this way.
> > 
> > What do you propose to put into these directories? Another directories named with
> > children pid-s?
> > 
> 
> Yes, I suppose additional directory/links and whatever would be just
> noneeded overhead.

/proc/8167/task/ being a directory could also be claimed
"noneeded overhead", yet it exists, and is very useful (I use
it a lot).  Why diverge instead of being consistent?

(Note that listing /proc only shows thread group ids, but
you can still open /proc/THREAD-ID/, so a /proc/PID/task file
with lists of pids would have been "good enough".)

-- 
Pedro Alves

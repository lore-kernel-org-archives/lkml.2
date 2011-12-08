Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab1LHQur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 11:50:47 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61869 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab1LHQup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 11:50:45 -0500
Date: Thu, 8 Dec 2011 20:50:40 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Vagin <avagin@openvz.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs, proc: Introduce the /proc/<pid>/children entry v2
Message-ID: <20111208165040.GJ21678@moon>
References: <20111206181026.GO29781@moon>
 <20111207185343.GA3209@redhat.com>
 <20111207190340.GP21678@moon>
 <20111208163535.GA25023@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111208163535.GA25023@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 05:35:35PM +0100, Oleg Nesterov wrote:
> >
> > Wait, Oleg, I might be wrong as well, but it's now a
> >
> > children_seq_open
> >  get_proc_task (so ref to task increased)
> 
> Yes. task_struct itself can't go away.
> 
> > the children_seq_start/children_seq_stop work
> > in iteration and every new iteration seq_list_next
> > walks over the whole children list from the list
> > head under rcu lock,
> 
> Yep, I misread this code, I though it does _next.
> 
> However, ->children list is not rcu-safe, this means that even
> list_for_each() itself is not safe. Either you need tasklist or
> we can probably make it rcu-safe...
> 

Seems I'll have to use tasklist_lock read-lock (atually it was
there in previous versions of patch but patch was not implementing
start/stop concept so I've been advised to use rcu read locks
instead).

> As for /proc/pid/children, personally I think it is very useful.
> But note that it obviously reports the children per-thread, while
> in general this is the per-process thing. Not sure this really

Yeah, Kosaki pointed me that I missed children from another threads.

> makes sense, but perhaps /proc/pid/children and
> /proc/pid/task/tid/children should act differently. Like, say,
> proc_tid_stat/proc_tgid_stat. I won't insist.
> 

At moment I thought only about top level here, ie /proc/pid/children,
but I think once I finish we can extend the patch ;)

Thanks for comments!

	Cyrill

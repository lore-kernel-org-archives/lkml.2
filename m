Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab2ARJng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:43:36 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45386 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104Ab2ARJne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:43:34 -0500
Date: Wed, 18 Jan 2012 13:43:28 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [RFC] fs, proc: Introduce /proc/<pid>/task/<tid>/children entry
 v6
Message-ID: <20120118094328.GJ1968@moon>
References: <20120116153231.GF2998@moon>
 <4F15EA53.8030405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F15EA53.8030405@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 04:38:27PM -0500, KOSAKI Motohiro wrote:
> (1/16/12 10:32 AM), Cyrill Gorcunov wrote:
> >When we do checkpoint of a task we need to know the list of children
> >the task, has but there is no easy and fast way to generate reverse
> >parent->children chain from arbitrary<pid>  (while a parent pid is
> >provided in "PPid" field of /proc/<pid>/status).
> >
> >So instead of walking over all pids in the system (creating one big process
> >tree in memory, just to figure out which children a task has) -- we add
> >explicit /proc/<pid>/task/<tid>/children entry, because the kernel already has
> >this kind of information but it is not yet exported.
> 
> I doubt this is good idea. It move some complexity to userland, but not reduce.
> Again, if we add this interface, it should help pstree like process traversal
> tools. Bare task hierarchy shouldn't be exposed userland. I believe users need
> sub process, not sub threads.
>

Which exactly complexity it moves to user-space? You have some task, and now
you can find all children easily, what the complexity you're talking about?
pstree is building the whole process tree going through all entries in
/proc/<pid>, reading PPid field and then forming the topology. I would like
to be able to find children faster. So I readdir a /proc/<pid>/task/ and
the walk over every /proc/<pid>/task/<tid>/children. This helps alot.

	Cyrill

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab2AOSyq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 13:54:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911Ab2AOSyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 13:54:25 -0500
Date: Sun, 15 Jan 2012 19:48:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [RFC] fs, proc: Introduce /proc/<pid>/task/<tid>/children
	entry v5
Message-ID: <20120115184806.GA25928@redhat.com>
References: <20111228121407.GL27266@moon> <20120115180721.GA23810@redhat.com> <20120115183145.GH3186@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120115183145.GH3186@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15, Cyrill Gorcunov wrote:
>
> On Sun, Jan 15, 2012 at 07:07:21PM +0100, Oleg Nesterov wrote:
> >
> > Again. I simply can't understand what ptrace_may_access() actually
> > means. Why do we use the possible child, not parent?
> >
> > IOW. I have no idea if we really need any security check at all.
> > You can find the children pids without this patch anyway via.
> > grep PPid /proc/*/status.
> >
>
> OK, I see. I am actually not sure which behaviour should be there.
> What should we do if say we have a task with a number of children,
> which changed permissions of own and some of children. Look what I mean.
>
> We have say tid A, which has children B C D, and when we read
> /proc/pid/task/tid/children we should see "B C D" here. But
> what if say A started with roots rights, then changed own permission
> so everyone could read this /proc/pid/task/<A>/children, but
> left C with root permissions only. So should we list C here?

Why not? What is the problem to know the pid of this child? And once
again, you can list all children without this patch anyway.

Perhaps I missed something, but I simply don't understand the problem.

Oleg.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab2BNQTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 11:19:10 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61017 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab2BNQTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 11:19:07 -0500
Date: Tue, 14 Feb 2012 08:19:01 -0800
From: Tejun Heo <tj@kernel.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org, yong.zhang0@gmail.com
Subject: Re: [PATCH] percpu: use raw_local_irq_* in _this_cpu op
Message-ID: <20120214161901.GL12117@google.com>
References: <1329131018-19107-1-git-send-email-tom.leiming@gmail.com>
 <20120213172311.GB12117@google.com>
 <CACVXFVMyihmG3NexXOqTUoJb8UJFa7dJqYGOr6oC_y5heFSo1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACVXFVMyihmG3NexXOqTUoJb8UJFa7dJqYGOr6oC_y5heFSo1A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 11:30:06AM +0800, Ming Lei wrote:
> On Tue, Feb 14, 2012 at 1:23 AM, Tejun Heo <tj@kernel.org> wrote:
> > On Mon, Feb 13, 2012 at 07:03:38PM +0800, Ming Lei wrote:
> >> It doesn't make sense to trace irq off or do irq flags
> >> lock proving inside 'this_cpu' operations, so replace local_irq_*
> >> with raw_local_irq_* in 'this_cpu' op.
> >>
> >> Also the patch fixes one lockdep warning[1], which is caused
> >> by the added local_irq_save/restore(flags) in this_cpu_inc
> >> called by __debug_atomic_inc: kernel/lockdep.c
> >
> > I think this isn't gonna hurt anything but I don't understand why the
> > lockdep warning is triggering when using traced version.  Can you
> > please explain that in a bit more detail in the patch description?
> 
> In trace_hardirqs_on_caller:kernel/lockdep.c, __debug_atomic_inc
> will be called to add on 'this_cpu' variable, so may introduce recursive
> trace_hardirqs_on|off_caller called.

Ah, okay, so lockdep itself is using this_cpu ops.  Can you please
repost the patch with the above info in the description?

Thank you.

-- 
tejun

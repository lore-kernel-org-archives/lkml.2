Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760986Ab0FRLSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 07:18:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758357Ab0FRLSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 07:18:21 -0400
Date: Fri, 18 Jun 2010 13:15:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] procfs: Do not release pid_ns->proc_mnt too early
Message-ID: <20100618111554.GA3252@redhat.com>
References: <1276706068-18567-1-git-send-email-louis.rilling@kerlabs.com> <20100617212003.GA4182@redhat.com> <20100618082033.GD16877@hawkmoon.kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100618082033.GD16877@hawkmoon.kerlabs.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18, Louis Rilling wrote:
>
> On 17/06/10 23:20 +0200, Oleg Nesterov wrote:
> > On 06/16, Louis Rilling wrote:
> > >
> > > Detached tasks are not seen by zap_pid_ns_processes()->sys_wait4(), so
> > > that release_task()->proc_flush_task() of container init can be called
> > > before it is for some detached tasks in the namespace.
> > >
> > > Pin proc_mnt's in copy_process(), so that proc_flush_task() becomes safe
> > > whatever the ordering of tasks.
> >
> > I must have missed something, but can't we just move mntput() ?
>
> See the log of the commit introducing pid_ns_release_proc() (6f4e6433):
>
>     Sice the namespace holds the vfsmnt, vfsmnt holds the superblock and the
>     superblock holds the namespace we must explicitly break this circle to destroy
>     all the stuff.  This is done after the init of the namespace dies.

I see thanks.

Besides, put_pid_ns() can be called in any context...

Oleg.


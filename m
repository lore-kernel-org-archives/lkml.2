Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab0FTSHW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 14:07:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756137Ab0FTSHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 14:07:19 -0400
Date: Sun, 20 Jun 2010 20:05:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: [PATCH 0/2] pid_ns_release_proc() fixes
Message-ID: <20100620180530.GB17120@redhat.com>
References: <20100617212003.GA4182@redhat.com> <20100618082033.GD16877@hawkmoon.kerlabs.com> <20100618111554.GA3252@redhat.com> <20100618160849.GA7404@redhat.com> <20100618173320.GG16877@hawkmoon.kerlabs.com> <20100618175541.GA13680@redhat.com> <20100618212355.GA29478@redhat.com> <20100619190840.GA3424@redhat.com> <m1pqzmqema.fsf_-_@fess.ebiederm.org> <20100620180335.GA17120@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100620180335.GA17120@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20, Oleg Nesterov wrote:
>
> On 06/20, Eric W. Biederman wrote:
> >
> > Oleg Nesterov <oleg@redhat.com> writes:
> >
> > > I am going to simplify, test, and send the fix which moves mntput()
> > > into free_pid_ns() paths.
> >
> > free_pid_ns is comparatively late, to release the kern_mount.
>
> Why?
>
> Once again, it is very possible I am wrong. I forgot this code if ever
> knew. But could you please explain?

So. Please the the patches. On top of

	[PATCH 1/4] procfs: proc_get_sb: consolidate/cleanup root_inode->pid logic
	[PATCH 2/4] procfs: kill the global proc_mnt variable
	[PATCH 3/4] procfs: move pid_ns_prepare_proc() from copy_process() to create_pid_namespace()

Still untested, sorry. There was no electricity in office this weekend,
and I can hardly work from home ;) I am sending this fix for review.

And let me repeat, I do not think this approach is the best (even _if_
this change is correct), just my attempt to fix the bugs.

What do you think?

Oleg.


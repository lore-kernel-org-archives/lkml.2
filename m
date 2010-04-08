Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab0DHObf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 10:31:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758732Ab0DHObb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 10:31:31 -0400
Date: Thu, 8 Apr 2010 10:31:02 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch,rfc v2] ext3/4: enhance fsync performance when using cfq
Message-ID: <20100408143102.GE10879@redhat.com>
References: <x49ochv7yi3.fsf@segfault.boston.devel.redhat.com> <20100408110045.GJ10103@kernel.dk> <20100408135901.GA10879@redhat.com> <x49pr2a9h3n.fsf@segfault.boston.devel.redhat.com> <20100408141004.GC10879@redhat.com> <x49hbnm9g29.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49hbnm9g29.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 10:25:50AM -0400, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Thu, Apr 08, 2010 at 10:03:24AM -0400, Jeff Moyer wrote:
> >> Which actually brings up the question of whether this needs some
> >> knowledge of whether the journal is on the same device as the file
> >> system!  In such a case, we need not yield.  I think I'll stick my head
> >> in the sand for this one.  ;-)
> >
> > Jeff even if journal is not on same device, what harm yielding could do?
> > Anyway there is no IO on that queue and we are idling. Only side affect is
> > that yielding process could lose a bit if after fsync it immediately submits
> > more IO. Because this process has yielded it slice, it is back in the queue
> > instead of doing more IO in the current slice immediately.
> 
> What happens if the journal is on a super fast device, and finishes up
> very quickly allowing our process to initiate more I/O within the idle
> window?
> 

You lose. :-) But at the same time if journalling devices is not fast
enough, and you if can't submit next IO in idling window, then you are 
unnecessarily keeping the disk idle and preventing others from making
progress.

Vivek

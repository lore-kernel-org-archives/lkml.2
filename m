Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162909Ab2GLXJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:09:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45392 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964860Ab2GLXJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:09:52 -0400
Date: Thu, 12 Jul 2012 16:09:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 0/4] hfsplus: stop using write_supers and s_dirt
Message-Id: <20120712160951.74cbb3c1.akpm@linux-foundation.org>
In-Reply-To: <1342103191-17406-1-git-send-email-dedekind1@gmail.com>
References: <1342103191-17406-1-git-send-email-dedekind1@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2012 17:26:27 +0300
Artem Bityutskiy <dedekind1@gmail.com> wrote:

> Hi Andrew, here is v3 of the patches, could you please pick them instead of the
> ones you have in your tree?

I really do dislike dropping patches and replacing them.  For a whole
bunch of reasons.  One of which is that a wholesale replacement
requires a full re-review.  Another is that wholesale replacement makes
it hard to see what was changed.

> The differences to v2 are:
> 
> 1. checkpatch.pl warnings fixed
> 2. removed 'cancel_delayed_work()' from 'hfsplus_sync_fs()' because it is not
>    enough to just cancel the job, we need to set the work_queued flag to zero
>    as well. I could do this, but it is simpler to just remove this tiny
>    optimization - we do not gain much with it. I caught this bug while doing
>    some more testing.

And lo, when I look at "what was changed", I see that this patchset
actually does *not* remove the cancel_delayed_work() call.  What's up
with that?

This latest patchset is identical to the code which is presently in -mm.

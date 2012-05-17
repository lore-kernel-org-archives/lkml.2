Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967682Ab2EQT2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 15:28:39 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33008 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab2EQT2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 15:28:37 -0400
Date: Thu, 17 May 2012 23:28:32 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [rfc 0/4] procfs fdinfo extension
Message-ID: <20120517192832.GB10530@moon>
References: <20120517160738.116113099@openvz.org>
 <20120517120541.f2dbdee9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120517120541.f2dbdee9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 12:05:41PM -0700, Andrew Morton wrote:
> On Thu, 17 May 2012 20:07:38 +0400
> Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
> > when we do restore files such as eventfd/eventpoll we need to pass
> > appropriate parameters to system calls.
> 
> What does "such as" mean? Provide the whole list, please.  I assume
> we're going to have to add ~100 lines of stuff to each and every one? 
> Stuff which, according to this patchset, is needed even when
> CONFIG_CHECKPOINT_RESTORE=n?

By such as I meant eventfd/eventpoll and fsnotify. And Andrew, I don't
know the whole list yet, if I knew it I would definitely share it. But
as I said I'm trying really hard to minimize patch impact on mainline kernel.
With this particular set (well, inotify part needed, but I didn't send
it out yet simple because I find it not well done for mainline inclusion,
but its draft variant lives in our kernel repo on github and I'm using
it alot for testing c/r on various programs) we're able to c/r crond/httpd.

And I didn't wrap this code with CONFIG_CHECKPOINT_RESTORE yet to
simplify the patch and gather people opinion on design in general.
I'll add it later (don't worry I remember about it).

Still plain conversion of fdinfo to seq-files and move code to fd.c
I think is an improvement in readability (the proc/base.c is a _way_
big file and I think it should be splitted by small steps).

> My reason for disliking our whole approach to integration of c/r is
> that it exposes us to an ongoing trickle of nasty surprises.  This
> patchset is one such nasty surprise, and we don't even know how
> extensive this particular surprise will be.

Why it's nasty? We gather back information from kernel needed for
use with syscalls to restore kernel entities (in case of this patchset
we restore eventfd and eventpolls).

> And how many more surprises are we going to get?
> 
> I'm quite apprehensive about this, largely because it has so many
> unknowns.  How much work would it be to prepare a full list of
> everything that still needs to be done to fully implement c/r in Linux?

Well, to build the whole list... hmm, I think I need to talk to Pavel.

	Cyrill

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab1JWQRo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 12:17:44 -0400
Received: from netrider.rowland.org ([192.131.102.5]:50943 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751726Ab1JWQRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 12:17:43 -0400
Date: Sun, 23 Oct 2011 12:17:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: NeilBrown <neilb@suse.de>
cc: John Stultz <john.stultz@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        mark gross <markgross@thegnar.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: lsusd - The Linux SUSpend Daemon
In-Reply-To: <20111023192147.49413485@notabene.brown>
Message-ID: <Pine.LNX.4.44L0.1110231212480.5199-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Oct 2011, NeilBrown wrote:

> > There shouldn't be any trouble about making wakeup_count pollable.  It
> > also would need to respect nonblocking reads, which it currently does 
> > not do.
> 
> Hmm.. you are correct.  I wonder why I thought it did support non-blocking
> reads...
> I guess it was the code for handling an interrupted system call.
> 
> I feel a bit uncomfortable with the idea of sysfs files that block but I
> don't think I can convincingly argue against it.
> A non-blocking flag could be passed in, but it would be a very messy change -
> lots of function call signatures changing needlessly:  we would need a flag
> to the 'show' method ... or add a 'show_nonblock' method which would also be
> ugly.

Right.  Sysfs is pretty inflexible.

> But I think there is a need to block - if there is an in-progress event then
> it must be possible to wait for it to complete as it may not be visible to
> userspace until then.
> We could easily enable 'poll' for wakeup_count and then make it always
> non-blocking, but I'm not really sure I want to require programs to use poll,
> only to allow them.  And without using poll there is no way to wait.
> 
> As wakeup_count really has to be single-access we could possibly fudge
> something by remembering the last value read (like we remember the last value
> written).

A simpler approach would be to add a nonblocking variant:  
/sys/power/wakeup_count_nb.  It would make sense to support poll for 
this file; poll isn't very useful for the wakeup_count file.

Alan Stern


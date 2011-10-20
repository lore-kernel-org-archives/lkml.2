Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab1JTO4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 10:56:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950Ab1JTO4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 10:56:39 -0400
Date: Thu, 20 Oct 2011 16:47:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, Tejun Heo <htejun@gmail.com>,
        Luke Macken <lmacken@redhat.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable-3.0] ptrace: don't clear GROUP_STOP_SIGMASK on
	double-stop
Message-ID: <20111020144726.GB27610@redhat.com>
References: <20110926170632.GA16936@redhat.com> <20111019230027.GD32438@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019230027.GD32438@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19, Greg KH wrote:
>
> On Mon, Sep 26, 2011 at 07:06:32PM +0200, Oleg Nesterov wrote:
> > https://bugzilla.redhat.com/show_bug.cgi?id=740121
> >
> > 1. Luke Macken triggered WARN_ON(!(group_stop & GROUP_STOP_SIGMASK))
> >    in do_signal_stop().
> >
> >    This is because do_signal_stop() clears GROUP_STOP_SIGMASK part
> >    unconditionally but doesn't update it if task_is_stopped().
> >
> > 2. Looking at this problem I noticed that WARN_ON_ONCE(!ptrace) is
> >    not right, a stopped-but-resumed tracee can clone the untraced
> >    thread in the SIGNAL_STOP_STOPPED group, the new thread can start
> >    another group-stop.
> >
> >    Remove this warning, we need more fixes to make it true.
> >
> > Reported-by: Luke Macken <lmacken@redhat.com>
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> I still don't understand, did this fix ever get into Linus's tree?  If
> so, what is the git commit id.
>
> If not, why not?

I already explained:

	No. As I said, 3.1 has the similar problem. But not the same, and you
	need the quite different test-case to trigger the bug.

	We are discussing the possible fixes for 3.1, but this code was changed
	very much and it doesn't make sense to compare the fixes for 3.1 and 3.0.

IOW. This code was rewritten in 3.1, this particlular problem
was "fixed" by accident, but in fact the problem just mutated.

> I can't apply it to the 3.0-stable tree unless it is
> there, or there is a very good reason why it isn't.

OK, please ignore then.

Oleg.


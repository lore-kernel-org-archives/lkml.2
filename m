Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab1IZWPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 18:15:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43380 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab1IZWPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 18:15:33 -0400
Date: Mon, 26 Sep 2011 15:15:11 -0700
From: Greg KH <gregkh@suse.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <htejun@gmail.com>, Luke Macken <lmacken@redhat.com>,
        stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable-3.0] ptrace: don't clear GROUP_STOP_SIGMASK on
 double-stop
Message-ID: <20110926221511.GB19769@suse.de>
References: <20110926170632.GA16936@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110926170632.GA16936@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 07:06:32PM +0200, Oleg Nesterov wrote:
> https://bugzilla.redhat.com/show_bug.cgi?id=740121
> 
> 1. Luke Macken triggered WARN_ON(!(group_stop & GROUP_STOP_SIGMASK))
>    in do_signal_stop().
> 
>    This is because do_signal_stop() clears GROUP_STOP_SIGMASK part
>    unconditionally but doesn't update it if task_is_stopped().
> 
> 2. Looking at this problem I noticed that WARN_ON_ONCE(!ptrace) is
>    not right, a stopped-but-resumed tracee can clone the untraced
>    thread in the SIGNAL_STOP_STOPPED group, the new thread can start
>    another group-stop.
> 
>    Remove this warning, we need more fixes to make it true.
> 
> Reported-by: Luke Macken <lmacken@redhat.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Is this fix in Linus's tree already?  If so, what's the git commit id?

If not, please take a look at Documentation/stable_kernel_rules.txt for
how to properly submit a patch to the stable tree.

thanks,

greg k-h

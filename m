Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab1JSXDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 19:03:50 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:57577 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755406Ab1JSXDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 19:03:47 -0400
X-Sasl-enc: Bifw+XbWnxtnDEfwxRlDCmy6tosq430e7fmaRXL4Puw2 1319065426
Date: Wed, 19 Oct 2011 16:00:27 -0700
From: Greg KH <greg@kroah.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Greg KH <gregkh@suse.de>, Tejun Heo <htejun@gmail.com>,
        Luke Macken <lmacken@redhat.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable-3.0] ptrace: don't clear GROUP_STOP_SIGMASK on
 double-stop
Message-ID: <20111019230027.GD32438@kroah.com>
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

I still don't understand, did this fix ever get into Linus's tree?  If
so, what is the git commit id.

If not, why not?  I can't apply it to the 3.0-stable tree unless it is
there, or there is a very good reason why it isn't.

thanks,

greg k-h

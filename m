Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab2DPN7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 09:59:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38777 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab2DPN7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 09:59:40 -0400
Date: Mon, 16 Apr 2012 08:59:31 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Lezcano <daniel.lezcano@free.fr>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pidns: reboot_pid_ns: use SEND_SIG_FORCED instead of
 force_sig()
Message-ID: <20120416135931.GB4234@sergelap>
References: <20120413004446.GA8376@redhat.com>
 <20120413182051.GA11149@sergelap>
 <20120413192455.GA24464@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120413192455.GA24464@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> Hi Serge,
> 
> On 04/13, Serge Hallyn wrote:
> >
> > Quoting Oleg Nesterov (oleg@redhat.com):
> > > cf3f8921 "pidns: add reboot_pid_ns() to handle the reboot syscall"
> > > uses force_sig() to kill the SIGNAL_UNKILLABLE cinit, this was the
> > > only choice.
> > >
> > > After 629d362b we can use SEND_SIG_FORCED instead, force_sig() has
> > > the special semantics and should be avoided if possible.
> > >
> > > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> >
> > Hi Oleg,
> >
> > I like the patch in theory, however after applying it containers are
> > no longer able to shutdown/reboot.  I can externally kill them with
> > lxc-stop, but internal shutdown fails.
> 
> Oh, thanks a lot for testing.
> 
> Strange... I even tested this change, but only in the root namespace.
> OK, thanks, I'll investigate. I hope you verified your kernel has
> 629d362b commit ;)

I took friday's HEAD of Linus tree.  All went fine.  Added this patch.
The container can shutdown, but reboot causes shutdown.  Don't undersrtand
why.

-serge

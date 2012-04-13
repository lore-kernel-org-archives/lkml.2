Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab2DMTek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 15:34:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59769 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab2DMTei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 15:34:38 -0400
Date: Fri, 13 Apr 2012 14:34:30 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Lezcano <daniel.lezcano@free.fr>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pidns: reboot_pid_ns: use SEND_SIG_FORCED instead of
 force_sig()
Message-ID: <20120413193430.GA12147@sergelap>
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

You know, I did.  But in the wrong tree!

Sorry.  Will add that patch, re-build and re-test.

-serge

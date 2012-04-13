Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488Ab2DMTZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 15:25:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756421Ab2DMTZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 15:25:24 -0400
Date: Fri, 13 Apr 2012 21:24:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Lezcano <daniel.lezcano@free.fr>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pidns: reboot_pid_ns: use SEND_SIG_FORCED instead of
	force_sig()
Message-ID: <20120413192455.GA24464@redhat.com>
References: <20120413004446.GA8376@redhat.com> <20120413182051.GA11149@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120413182051.GA11149@sergelap>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Serge,

On 04/13, Serge Hallyn wrote:
>
> Quoting Oleg Nesterov (oleg@redhat.com):
> > cf3f8921 "pidns: add reboot_pid_ns() to handle the reboot syscall"
> > uses force_sig() to kill the SIGNAL_UNKILLABLE cinit, this was the
> > only choice.
> >
> > After 629d362b we can use SEND_SIG_FORCED instead, force_sig() has
> > the special semantics and should be avoided if possible.
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> Hi Oleg,
>
> I like the patch in theory, however after applying it containers are
> no longer able to shutdown/reboot.  I can externally kill them with
> lxc-stop, but internal shutdown fails.

Oh, thanks a lot for testing.

Strange... I even tested this change, but only in the root namespace.
OK, thanks, I'll investigate. I hope you verified your kernel has
629d362b commit ;)

Oleg.


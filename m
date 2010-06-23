Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab0FWOyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 10:54:49 -0400
Received: from smtp.outflux.net ([198.145.64.163]:55672 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab0FWOys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 10:54:48 -0400
Date: Wed, 23 Jun 2010 07:54:37 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] security: Yama LSM
Message-ID: <20100623145437.GJ5876@outflux.net>
References: <20100623065236.GH5876@outflux.net>
 <877hlqas9e.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877hlqas9e.fsf@basil.nowhere.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Wed, Jun 23, 2010 at 01:43:41PM +0200, Andi Kleen wrote:
> Kees Cook <kees.cook@canonical.com> writes:
> > +
> > +config SECURITY_YAMA_SYMLINKS
> > +	bool "Yama: protect symlink following in sticky world-writable
> > dirs"
> 
> IMHO it's bad style to have CONFIGs that just set defaults,
> if that can be done at runtime too. Especially as in your case if it's 
> a lot of settings. Is it that bad to have a init script and drop these 
> CONFIGs? 

Oh, er, I actually added these configs because Eric Paris recommended them
as handy for distributions.  I'm fine with dropping them, but will I be
asked to add them back later?  And what about the case of CONFIG_SYSCTL
being unset?

> However the help texts are useful,  these should be in the sysctl
> documentatin in Documentation instead.

I documented the sysctls in Documentation/Yama.txt (where SELinux.txt and
Smack.txt live) should I create an additional file in Documentation/sysctl/
with that information (moved from Yama.txt) or move Yama.txt there?

> > +	if (rc) {
> > +		printk_ratelimited(KERN_INFO "ptrace of non-child"
> > +			" pid %d was attempted by: %s (pid %d)\n",
> > +			child->pid, get_task_comm(name, current),
> > +			current->pid);
> 
> It's probably obscure and other kernel code has this too, but at some point
> there were attacks to use terminal ESC sequences to attack root's
> terminal when they dmesg. Couldn't that be done through "comm" here?

I actually think this is a flaw in get_task_comm.  (Though actually it's
the fault of terminals if they process dangerous escape sequences. Worst
case tends to just be confusing output, but that's not important --
nothing should spew non-printables regardless.)  Would a patch to
get_task_comm be accepted to replace non-printables with "?" or something
when filling the buffer?

Thanks,

-Kees

-- 
Kees Cook
Ubuntu Security Team

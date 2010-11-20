Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab0KTTr2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 14:47:28 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:53305 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754883Ab0KTTr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 14:47:27 -0500
X-Sasl-enc: sS1eUOT1iw54Mut5azJjAPoIqouq/FH44m28VXJER3p4 1290282446
Date: Sat, 20 Nov 2010 17:47:23 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Kees Cook <kees.cook@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Walls <andy@silverblocksystems.net>, linux-kernel@vger.kernel.org,
        sarah.a.sharp@linux.intel.com
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
Message-ID: <20101120194723.GH12640@khazad-dum.debian.net>
References: <1290201154.2116.29.camel@morgan.silverblock.net>
 <AANLkTi=fnFhznMz2bTRSJDrfeDwsVUTyqiKDATPzEjhq@mail.gmail.com>
 <20101120024034.GB4617@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101120024034.GB4617@outflux.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Nov 2010, Kees Cook wrote:
> On Fri, Nov 19, 2010 at 03:22:00PM -0800, Linus Torvalds wrote:
> > In this case, the upside just wasn't big enough to accept _any_
> > breakage, especially since people and distributions can just do the
> > "chmod" themselves if they want to. There was a lot of discussion
> > whether the patch should even go in in the first place. So this time,
> > the "let's just revert it" was a very easy decision for me.
> 
> The downside is that /proc can be remounted multiple times for different
> containers, etc. Having to patch everything that mounts /proc to do the
> chmod seems much more painful that fixing a simple userspace bug in an old
> klog daemon.
> 
> (For example, rsyslogd handles this fine since it's root to open it, and
> even if it fails, it doesn't do the broken fclose().)

If it is a pain only for buggy old/legacy userspace like klogd or a few
tools, it would still be very useful as a Kconfig option defaulting to
disabled.

As an user and sysadmin, I'd rather not have to find out every place that
mounts /proc in a chroot to chmod all relevant files :(  That's fighting a
loosing battle, unlike fixing broken tools (which at least will stay fixed).

Distros could get any fixing done they require, and then enable it for all
their users.  Ubuntu and Debian are likely to do it, and I'd guess so is
Fedora.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

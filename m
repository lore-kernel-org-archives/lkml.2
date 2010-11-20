Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab0KTClK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 21:41:10 -0500
Received: from smtp.outflux.net ([198.145.64.163]:38086 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756404Ab0KTClJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 21:41:09 -0500
Date: Fri, 19 Nov 2010 18:40:34 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Walls <andy@silverblocksystems.net>, linux-kernel@vger.kernel.org,
        sarah.a.sharp@linux.intel.com
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
Message-ID: <20101120024034.GB4617@outflux.net>
References: <1290201154.2116.29.camel@morgan.silverblock.net>
 <AANLkTi=fnFhznMz2bTRSJDrfeDwsVUTyqiKDATPzEjhq@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=fnFhznMz2bTRSJDrfeDwsVUTyqiKDATPzEjhq@mail.gmail.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 03:22:00PM -0800, Linus Torvalds wrote:
> In this case, the upside just wasn't big enough to accept _any_
> breakage, especially since people and distributions can just do the
> "chmod" themselves if they want to. There was a lot of discussion
> whether the patch should even go in in the first place. So this time,
> the "let's just revert it" was a very easy decision for me.

The downside is that /proc can be remounted multiple times for different
containers, etc. Having to patch everything that mounts /proc to do the
chmod seems much more painful that fixing a simple userspace bug in an old
klog daemon.

(For example, rsyslogd handles this fine since it's root to open it, and
even if it fails, it doesn't do the broken fclose().)

-Kees

-- 
Kees Cook
Ubuntu Security Team

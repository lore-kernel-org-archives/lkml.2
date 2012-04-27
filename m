Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984Ab2D0Jpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 05:45:34 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:55316 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759151Ab2D0Jpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 05:45:33 -0400
Message-ID: <4F9A6ABA.6050503@msgid.tls.msk.ru>
Date: Fri, 27 Apr 2012 13:45:30 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux-kernel <linux-kernel@vger.kernel.org>, autofs@vger.kernel.org,
        Ian Kent <raven@themaw.net>, Thomas Meyer <thomas@m3y3r.de>,
        stable@kernel.org
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix design
 error.
References: <1335447289-9909-1-git-send-email-mjt@msgid.tls.msk.ru> <CA+55aFxEP7-+N7vTPZ-4hD-UirZ=+YMJh2x3EjZvUmjjyOchtg@mail.gmail.com>
In-Reply-To: <CA+55aFxEP7-+N7vTPZ-4hD-UirZ=+YMJh2x3EjZvUmjjyOchtg@mail.gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.04.2012 04:37, Linus Torvalds wrote:
> None of this fixes the fact that current 'systemd' binaries just use
> 'union autofs_v5_packet_union' and do a sizeof on it.
> 
> We're not breaking systemd either. You seem to not care about that,
> but as long as you just blindly continue to not care, I'm going to
> continue to not care about the patches.

I posted an alternative patch that "fixes" this issue for both
old systemd and old autofs, by checking for current->comm being
"automount". Not nice solution but it should work in practice.

It is not that I don't _care_ about systemd, I just think that
_if_ I'd choose from two evils, I'd pick the one which is less --
note the _if_.

Please note: the talk is about 32bit userspace on 64bit kernel,
which should be quite rare these days, or something of less
priority.

And please note also that systemd developers are saying they're
fine with new interface and non-working old binaries of systemd,
as long as this new interface actually solves the problem.

> It's that simple.
> 
> It is unfortunate that we have this idiocy with different packages
> having different breakage due to the stupidity of the v5 packet, but
> it's REALITY. A simple revert won't fix it, and saying "and here is
> version 6" won't matter one whit to existing packages.

There are always tradeoffs, and we have to pick something.  _IF_
(again, note the if) we have to break Something because no other
solution to actual existing problem is found, this breaking have
to be done.

That's reality too, and _current_ reality we have _now_ is that
autofs package, which worked fine for many years before, is broken.
While systemd actually NEVER worked in this context so far, except
of 3.3 kernel which included the fix.

So this is not something about me caring or not, it is about the
situation we're in: we had working autofs and non-working systemd,
now it is the opposite.  I just propose to have a bit less ugly
fix in kernel and have working autofs as before and working NEW
systemd.  To me that's  the least of two evils.

Thanks,

/mjt

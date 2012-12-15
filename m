Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab2LOLda (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 06:33:30 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58482 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab2LOLd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 06:33:29 -0500
Date: Sat, 15 Dec 2012 12:33:18 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Linux 3.8-merge version information
Message-ID: <20121215113318.GA17019@amd.pavel.ucw.cz>
References: <50C72FCC.8010401@hartkopp.net>
 <CA+55aFyFfjAnD4hR2SpE2OK8_dtHPkt0sr4BKZPhp6P7NKpiwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyFfjAnD4hR2SpE2OK8_dtHPkt0sr4BKZPhp6P7NKpiwQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Tue 2012-12-11 10:57:21, Linus Torvalds wrote:
> On Tue, Dec 11, 2012 at 5:06 AM, Oliver Hartkopp <socketcan@hartkopp.net> wrote:
> > As the automatically generated git version information is misleading in the
> > merge window, name the kernel in the merge window as 3.8-merge .
> 
> This really doesn't help.

Well, I'd say it helps in the common case.

> 90% of the commits during the merge window wouldn't be based on that
> Makefile change anyway, but on some much older version. So when
> bisecting, for example, you'll see Makefiles with much older version
> numbers, even though the commits got merged into the 3.8 merge
> window.

No, it does not solve bisect, but at least you get something
reasonable in the boot menu...?

> Also, we have code to generate the version number automatically. In
> particular, I encourage people to use git trees and
> CONFIG_LOCALVERSION_AUTO=y, because then your /var/log/messages (and
> uname -r) will contain the exact git version of your kernel. So when
> you see something like
> 
>     Linux version 3.7.0-rc8-00041-gcaf491916b1c

Problem is that CONFIG_LOCALVERSION_AUTO adds a lot of time to
build. Like... making "empty" build twice as slow.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

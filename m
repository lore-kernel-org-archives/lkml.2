Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab2LKS5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 13:57:43 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:58172 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab2LKS5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 13:57:42 -0500
MIME-Version: 1.0
In-Reply-To: <50C72FCC.8010401@hartkopp.net>
References: <50C72FCC.8010401@hartkopp.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 11 Dec 2012 10:57:21 -0800
X-Google-Sender-Auth: wyXoT1qM-fyr096JNVcHQ1aPSMI
Message-ID: <CA+55aFyFfjAnD4hR2SpE2OK8_dtHPkt0sr4BKZPhp6P7NKpiwQ@mail.gmail.com>
Subject: Re: [PATCH] Linux 3.8-merge version information
To: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 5:06 AM, Oliver Hartkopp <socketcan@hartkopp.net> wrote:
> As the automatically generated git version information is misleading in the
> merge window, name the kernel in the merge window as 3.8-merge .

This really doesn't help.

90% of the commits during the merge window wouldn't be based on that
Makefile change anyway, but on some much older version. So when
bisecting, for example, you'll see Makefiles with much older version
numbers, even though the commits got merged into the 3.8 merge window.

Also, we have code to generate the version number automatically. In
particular, I encourage people to use git trees and
CONFIG_LOCALVERSION_AUTO=y, because then your /var/log/messages (and
uname -r) will contain the exact git version of your kernel. So when
you see something like

    Linux version 3.7.0-rc8-00041-gcaf491916b1c

in your message log, you'll know that the kernel you were running back
then was 41 commits past -rc8, and had git commit ID of caf491916b1c.
And that is really useful for things like bisections ("Ok, I know it
worked three days ago - what kernel was I running then?") much more so
than a Makefile change would be (never mind how unreliable the version
info in the makefile is).

So this is why we only change the version in the Makefile when we do a
new tagged release.

                    Linus

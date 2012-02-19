Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab2BSNmk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 08:42:40 -0500
Received: from www17.your-server.de ([213.133.104.17]:33446 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab2BSNmj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 08:42:39 -0500
References: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com>
In-Reply-To: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Message-Id: <FE1DCD87-0055-4C3E-B06A-251055E1492F@m3y3r.de>
Content-Transfer-Encoding: 8BIT
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: Linux 3.3-rc4
Date: Sun, 19 Feb 2012 14:42:33 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.1084)
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 19.02.2012 um 01:27 schrieb Linus Torvalds:

> 
> The workaround is either to just compile a 64-bit kernel (hey, you can
> leave your 32-bit userland alone if you are so emotionally attached to
> last century) or upgrade to 3.3-rc4.
> 

Theoretically yes, practically (at least with Fedora 15/16) no. I did hit these two bugs:

1.) autofs4 interface is broken between x86 and x86_64. as systemd uses autofs, this bug hangs the boot process as e.g. binfmt is mounted via autofs. see also http://lists.freedesktop.org/archives/systemd-devel/2011-September/003396.html
- autofs4 maintainer says that this minor kernel bug could be circumvented in user land.
- systemd developers says that this kernel bug should get fixed in the kernel

2.) while debugging above issue: I did find an minor bug in sys_poll() - nobody did take care of my proposed patch: https://lkml.org/lkml/2011/9/24/35

with kind regards
thomas


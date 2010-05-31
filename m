Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab0EaTwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 15:52:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58857 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757153Ab0EaTwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 15:52:34 -0400
Date: Mon, 31 May 2010 20:52:30 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Kees Cook <kees.cook@canonical.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@redhat.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH v2] fs: block cross-uid sticky symlinks
Message-ID: <20100531195230.GS31073@ZenIV.linux.org.uk>
References: <20100531030402.GQ6056@outflux.net>
 <20100531112314.373b0f26@lxorguk.ukuu.org.uk>
 <20100531175008.GC4098@outflux.net>
 <20100531190936.03076096@lxorguk.ukuu.org.uk>
 <20100531190754.GF4098@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100531190754.GF4098@outflux.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 12:07:54PM -0700, Kees Cook wrote:

> IIRC, screen, when setuid, allows users to share screen sessions (following
> some system-defined ACLs) but it does it via the /tmp directory trees it
> creates.  Per-user /tmp would break this (but yes, it's solvable using some
> kind of /var/lib/screen which maybe even already exists).

screen(1) does *not* put directories in /tmp these days, TYVM.

al@duke:~/linux/trees/vfs-next$ ls -l /var/run/screen/
total 1
drwx------ 2 al al 1024 May 20 21:50 S-al

That's lenny/x86_64; I can't be arsed to install ubuntu, but in case you
have a really ancient screen(1), pulling one from debian -stable would
suffice.  IIRC, -oldstable would work as well, actually, but I could be
wrong on that.

In any case, the suggested "improvement" breaks realistic use cases, AFAICS.
In particular,

cd /tmp
tar jxf foo-2.42.orig.tar.bz2
<...>
tar jxf foo-gtk-wank-wank-wank-2.69.orig.tar.bz2
<...>
ln -s foo-gtk-wank-wank-wank-2.69/docs/GNOME/design/ crap
<...>
lpr crap/taste-is-optional.ps
lpr crap/why-options-are-wrong.ps

is going to break with that, isn't it?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750878Ab1GZELp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 00:11:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34322 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab1GZELj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 00:11:39 -0400
Date: Tue, 26 Jul 2011 14:11:18 +1000
From: NeilBrown <neilb@suse.de>
To: Solar Designer <solar@openwall.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        kernel-hardening@lists.openwall.com, James Morris <jmorris@namei.org>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Eric Paris <eparis@redhat.com>, Willy Tarreau <w@1wt.eu>,
        Sebastian Krahmer <krahmer@suse.de>
Subject: Re: [kernel-hardening] [PATCH] move RLIMIT_NPROC check from
 set_user() to do_execve_common()
Message-ID: <20110726141118.32f948e0@notabene.brown>
In-Reply-To: <20110726011629.GA24610@openwall.com>
References: <1310738313.30257.27.camel@moss-pluto>
	<20110715152641.GA6286@albatros>
	<1310759683.30257.123.camel@moss-pluto>
	<20110721140936.632d2c8b@notabene.brown>
	<20110721124830.GA1325@openwall.com>
	<CA+55aFy4ybatb0McQr2f4A56ympZVLqK2sbp2=73idu58_4RxQ@mail.gmail.com>
	<20110721193939.GA3914@openwall.com>
	<20110725171423.GA3739@albatros>
	<20110725234013.GB24110@openwall.com>
	<20110726104713.37273143@notabene.brown>
	<20110726011629.GA24610@openwall.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jul 2011 05:16:29 +0400 Solar Designer <solar@openwall.com> wrote:


> > Let me try another suggestion.  Instead of catching the error in
> > do_execve_common, how about we catch it in do_mmap_pgoff.
> > i.e. if the flag is set and an attempt it made to create an executable
> > mapping, we check the user->processes against the limit then - either failing
> > or clearing the flag and succeeding.
> > 
> > This will stop an execve, and an attempt to load a shared library and call it.
> 
> This sounds too hackish to me, although if others are (unexpectedly) OK
> with it, I don't mind.

Thanks ... I think :-)

I don't really see that failing mmap is any more hackish than failing execve.

Both are certainly hacks.  It is setuid that should fail, but that is
problematic.

We seem to agree that it is acceptable to delay the failure until the process
actually tries to run some code for the user.  I just think that
mapping-a-file-for-exec is a more direct measure of "trying to run some code
for the user" than "execve" is.

So they are both hacks, but one it more thorough than the other.  In the
world of security I would hope that "thorough" would win.

NeilBrown


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964944Ab2JDA53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 20:57:29 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:45744 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964832Ab2JDA51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 20:57:27 -0400
From: Nix <nix@esperi.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ming Lei <ming.lei@canonical.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: udev breakages -
References: <4FE9169D.5020300@redhat.com> <20121002100319.59146693@redhat.com>
	<CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
	<20121002221239.GA30990@kroah.com> <20121002222333.GA32207@kroah.com>
	<CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com>
	<506C562E.5090909@redhat.com>
	<CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
	<20121003170907.GA23473@ZenIV.linux.org.uk>
	<CA+55aFw0pB99ztq5YUS56db-ijdxzevA=mvY3ce5O_yujVFOcA@mail.gmail.com>
	<20121003192636.GC23473@ZenIV.linux.org.uk>
Emacs: a learning curve that you can use as a plumb line.
Date: Thu, 04 Oct 2012 01:57:18 +0100
In-Reply-To: <20121003192636.GC23473@ZenIV.linux.org.uk> (Al Viro's message of
	"Wed, 3 Oct 2012 20:26:36 +0100")
Message-ID: <87pq4z12c1.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-INFN-TO-Metrics: spindle 1233; Body=8 Fuz1=8 Fuz2=8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 Oct 2012, Al Viro spake thusly:

> Looks sane.  TBH, I'd still prefer to see udev forcibly taken over and put into
> usr/udev in kernel tree - I don't trust that crowd at all and the fewer
> critical userland bits they can play leverage games with, the safer we are.  
>
> Al, that -><- close to volunteering for maintaining that FPOS kernel-side...

<flamebait type="heartfelt" subtype="fever-induced">

Please! It has already been forked at least once in userspace by people
who have the temerity to *not use systemd*, imagine that! and still want
a udev that is up-to-date in other ways. (We are now being told that,
contrary to what was said when udev was migrated into the systemd tree,
running udev without systemd is now deprecated and untested and might go
away completely. How surprising, nobody ever predicted that when it
migrated in, oh wait yes we did, and were assured that we were wrong,
that standalone udev would always be supported for those of us who
weren't using systemd. Way to destroy your userbase's trust in you...)

Possibly udev 175, the last standalone udev as far as I know, is a good
place to start from: but you might want to go back a release or two
before that, since 174 was where they started doing insane
backward-compatibility breaks. By 175 they were requiring devtmpfs, no
longer creating device nodes (which I thought was the original *point*
of udev), moving lots of install locations on the assumption that / and
/usr were on the same filesystem, and migrating udevd from /sbin into
/lib/udev without bothering to provide a backward-compatibility symlink.
Net benefit of all this thrashing about to udev users: nil. Net sysadmin
overhead on upgrade: substantial, oh and if you don't do it your system
won't boot.

By udev 175 I, and a lot of other people, had simply stopped upgrading
udev entirely on the grounds that we could no longer tolerate the
uncertainty over whether our systems would boot every time we upgraded
it, for no discernible benefit. Yes, all the incompatible changes are
(or were, as of udev 175) called out in the release notes -- but there
are so *many* of them, it's easy to miss one. And they all seem so
completely unnecessary, and their implications for your system
configuration grow more and more invasive all the time.

When gregkh was maintaining udev it was nicely robust and kept working
from release to release, and just did its job without requiring us to
change the way our system booted in backwardly-incompatible ways on
every release, merge filesystems together or mount /usr in early boot
(which is SSH-tunneled over a network in the case of one of my systems,
that was fun to do in the initramfs), or install invasive packages that
extend tentacles throughout the entire system, require a complete
rewriting of my boot process and require millions of kernel features
that may not always be turned on.

I'd like those days back. I can trust the kernel people to maintain some
semblance of userspace compatibility between releases, as is crucial for
boot-critical processes. It is now quite clear that I cannot trust the
present udev maintainers, or anyone else involved in the ongoing Linux
desktop trainwreck, to do any such thing.

</flamebait>

-- 
NULL && (void)

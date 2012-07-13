Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154Ab2GMVRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 17:17:53 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60417 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757827Ab2GMVRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 17:17:52 -0400
MIME-Version: 1.0
In-Reply-To: <20120713210240.GG1707@redhat.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
 <20120713210240.GG1707@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Jul 2012 14:17:30 -0700
X-Google-Sender-Auth: qWqpVWsIaw3y5LTiNBBZmcN6HZQ
Message-ID: <CA+55aFz_Vv899eXz6F0jtFH=hT4QpB0_2XuS8HySPjHC6s+L7Q@mail.gmail.com>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 2:02 PM, Dave Jones <davej@redhat.com> wrote:
>
> As long as you don't mind these being added after the fact, I suppose
> it would be workable.  The reason I say that is sometimes, it even catches *us*
> by surprise.  We recently found out our virtualisation guys started
> using sch_htb for example, and we inadvertantly broke it when we moved
> its module to a 'not always installed' kernel subpackage. (and before that, 9PFS..)
>
> People don't tell us anything, but somehow expect things to keep working.

I think even a "educated guess" config file is better than what we have now.

The *two* requirements (and they're really the same theme) I
personally think we should have for this are

 -  I think every single "select" for these things should come with a
comment about what it is about and why the distro needs it (to show
there was some thought involved and not just a blind "took it from the
distro config")

 - It should be about *minimal* settings. I'd rather have too few
things and the occasional complaint about "oh, it didn't work because
it missed XYZ" than have it grow to contain all the options just
because somebody decided to just add random things until things
worked.

Other than that, even if it only gets you *closer* to a kernel that
works with that distro, I think it doesn't have to be all that
perfect. Because the alternative is what we have now.

           Linus

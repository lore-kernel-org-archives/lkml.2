Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab2DWSiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 14:38:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579Ab2DWSiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 14:38:13 -0400
Date: Mon, 23 Apr 2012 20:37:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120423183734.GA1897@redhat.com>
References: <CA+55aFxQR8g3TycW7nOVjjnnsaWWW-Gh74-bV6rUm+7SRTm25g@mail.gmail.com> <20120420025438.GD6871@ZenIV.linux.org.uk> <CA+55aFzinX_6DVvDTyxrsP6VEHVY2Q+Y=e+qksnAjR+oT3GZew@mail.gmail.com> <20120420080914.GF6871@ZenIV.linux.org.uk> <CA+55aFxia+u3VAf0qN-2wv7DyAQZK-Z8=n=cqUvo--+C905aFg@mail.gmail.com> <20120420160848.GG6871@ZenIV.linux.org.uk> <20120420164239.GH6871@ZenIV.linux.org.uk> <CA+55aFzuTspDyyLaOA-g-dTWydaUeeWo9uVGR+rZ=ZJzPW_Ocw@mail.gmail.com> <20120420180748.GI6871@ZenIV.linux.org.uk> <20120423180150.GA6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120423180150.GA6871@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23, Al Viro wrote:
>
> On Fri, Apr 20, 2012 at 07:07:48PM +0100, Al Viro wrote:
> > On Fri, Apr 20, 2012 at 10:21:35AM -0700, Linus Torvalds wrote:
>
> > > This is why I suggested you look at Oleg's patches. If we guarantee
> > > that things won't be delayed past re-entering user mode, all those
> > > issues go away.
> >
> > I've looked at them.  One obvious problem is that it tracehook_notify_resume()
> > is not universally called.  AFAICS, hexagon, m68k, microblaze, score, um
> > and xtensa never call tracehook_notify_resume().

Yes,

> > Out of those, hexagon is
> > manually checking TIF_NOTIFY_RESUME and does key_replace_session_keyring(),
> > so the call could be easily added into the same place;

Yes, I sent the trivial patch.

> > the rest of those
> > guys don't even look at TIF_NOTIFY_RESUME anywhere near their signal*.c
> > and m68k/um/xtensa don't even have it defined, let alone handled.  So this
> > stuff depends on some amount of asm glue hacking on several architectures ;-/

which I don't understand even remotely :/ But I'll try to understand at
least something.

> Oleg, where does your tree live?

Cough. Nowhere. I still can't restore my korg account.

> I've walked through the signal handling
> on all targets over this weekend (and it's still not complete - there are
> fun bugs re multiple sigframes and restart handling on many of those) and
> my current queue is at git.kernel.org/pub/scm/linux/kernel/git/viro/signal;

Thanks. I don't think you need my help, but I'll certainly try to look this
week anyway.

Oleg.


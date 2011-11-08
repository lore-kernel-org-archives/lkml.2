Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab1KHQOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 11:14:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158Ab1KHQOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 11:14:35 -0500
Date: Tue, 8 Nov 2011 14:13:42 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@kernel.org>, Vince Weaver <vince@deater.net>,
        Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [F.A.Q.] the advantages of a shared tool/kernel Git
	repository, tools/perf/ and tools/kvm/
Message-ID: <20111108161342.GD14272@ghostprotocols.net>
References: <20111107203255.GF24234@thunk.org> <CAOJsxLEKx5M5L_N42pQpo2hcNhseQKhUo6CXAyQHesJRWFASKQ@mail.gmail.com> <4EB85969.2010108@codemonkey.ws> <12F471C8-2CF3-4CD7-B417-C8CC898669E6@mit.edu> <20111108093225.GB32533@elte.hu> <EDBAFB6F-4E3B-42B0-93E6-DF162B9859A6@mit.edu> <20111108125609.GA14272@ghostprotocols.net> <4EB9315A.10806@redhat.com> <20111108143228.GC14272@ghostprotocols.net> <4EB94D08.3010207@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB94D08.3010207@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 08, 2011 at 04:38:48PM +0100, Gerd Hoffmann escreveu:
> Seems to have no effect, guess the distro perf is too old (RHEL-6).

> > [tui]
> > 	report = off

> That works.  I don't want turn off the tui altogether though, I actually
> like the interactive expanding+collapsing of the call graphs.  I just
> want turn off the colors.

> perf_color_default_config() in util/color.c seems to lookup a "color.ui"
> config variable.  Can I set that somehow?  Tried ui= in a [color]
> section -- no effect.

Ouch, that came from the code initialy stolen^Wcopied from git :-\

I don't think that will have any effect :-\
 
> > Ah, if you still need to configure the colors, use "default" so that it
> > will use whatever is the color configured in your
> > xterm/gnome-terminal/whatever profile.

> > For reference, the default set of colors now is:

> >                 .colorset = HE_COLORSET_TOP,
> >                 .name     = "top",
> >                 .fg       = "red",
> >                 .bg       = "default",

> Bad idea IMO.  Setting only one of foreground+background gives pretty
> much unpredictable results.  My xterms have different background colors,
> the ones with a root shell happen to have a (dark) red background.
> Which results in red-on-dark-red text.  Not good.

> I'd strongly suggest to either set both background and foreground to
> default or to set both to a specific color.  When doing the latter make

That is the case for the normal one, two colorsets below the
HE_COLORSET_TOP one.

Humm, certainly there could be logic to figure it out if background ==
foreground and do something about it.

> sure the colors have enougth contrast so they are readable.

Problem is figuring out something that is considered a good default :-\
There will always be somebody that will complain.

When doing the coding to allow using the default xterm colors I tried
several of the gnome-terminal xterm profiles and all looked kinda sane
for the "top" (hottest functions, with most hits) and "medium" lines,
where we combine some chosen foreground color ("red" and "green").

Laziest solution would be: If the user customizes that much, could the
user please customize this as well? :-)

- Arnaldo

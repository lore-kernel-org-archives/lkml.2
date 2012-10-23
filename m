Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424Ab2JWAXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 20:23:15 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:59220 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044Ab2JWAXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 20:23:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bryan Wu <cooloney@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Miles Lane <miles.lane@gmail.com>, akpm <akpm@linux-foundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ledtrig-cpu: use spin_lock to replace mutex lock
Date: Tue, 23 Oct 2012 02:27:08 +0200
Message-ID: <3676680.un0SjMjRh0@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CAK5ve-L=sRNGYxsEjuJZrPYszLAgBXEfPfkLnLdHmxfnyCRnDA@mail.gmail.com>
References: <CAK5ve-JAc2Env1AyZMY178QobhqmAh4euHQdPS=UH3mGGeSgLA@mail.gmail.com> <2097144.LhjfvZ65DK@vostro.rjw.lan> <CAK5ve-L=sRNGYxsEjuJZrPYszLAgBXEfPfkLnLdHmxfnyCRnDA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 of October 2012 16:15:58 Bryan Wu wrote:
> On Mon, Oct 22, 2012 at 3:38 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Monday 22 of October 2012 11:59:19 Bryan Wu wrote:
> >> Hiya,
> >>
> >> Can I get some Acked or Tested-by from Rafael or Miles before I put it
> >> in my linux-leds tree?
> >
> > Well, I just explained why the current code didn't work. :-)
> >
> > Anyway, please feel free to add
> >
> > Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
> >
> 
> I was just reminded by Nathan Lynch <ntl@pobox.com> most of
> led-trigger API like register/unregister/event are potentially sleep.
> They should not be used in atomic context. Any suggestion to fix it?

Well, design ledtrig_cpu_syscore_suspend() so that it can be called from
atomic context?  You can use the observation that no locking is necessary
in that routine to simplify it, perhaps.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
